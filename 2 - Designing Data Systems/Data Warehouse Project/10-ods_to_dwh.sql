-- Set up data warehouse schema
create or replace schema UDACITYPROJECT.DWH;

USE DATABASE UDACITYPROJECT;

USE SCHEMA DWH;

-- Create data warehouse tables

create or replace TABLE UDACITYPROJECT.DWH.DIM_BUSINESS (
	BUSINESS_ID VARCHAR(22) NOT NULL,
	NAME VARCHAR(16777216),
	primary key (BUSINESS_ID)
);

create or replace TABLE UDACITYPROJECT.DWH.DIM_CUSTOMER (
	USER_ID VARCHAR(22) NOT NULL,
	NAME VARCHAR(16777216),
	primary key (USER_ID)
);


-- I thought it was important to add at least the city data since the 
-- climate set is for Las Vegas
create or replace TABLE UDACITYPROJECT.DWH.DIM_LOCATION (
	LOCATION_ID NUMBER(38,0) NOT NULL,
	CITY_NAME VARCHAR(16777216),
	primary key (LOCATION_ID)
);

-- I collapsed the temperature and precipitation ods tables into a
-- single table since they have a one to one relationship based on the date
create or replace TABLE UDACITYPROJECT.DWH.DIM_CLIMATE (
	CLIM_DATE DATE NOT NULL,
	TEMPER_MAX FLOAT,
	TEMPER_MIN FLOAT,
	TEMPER_NORMAL_MAX FLOAT,
	TEMPER_NORMAL_MIN FLOAT,
	PRECIP_AMT FLOAT,
	PRECIP_NORMAL FLOAT,
	primary key (CLIM_DATE)
);

create or replace TABLE UDACITYPROJECT.DWH.FACT_REVIEW (
	USER_ID VARCHAR(22) NOT NULL,
	BUSINESS_ID VARCHAR(22) NOT NULL,
	CLIM_DATE DATE NOT NULL,
	LOCATION_ID NUMBER(38,0),
	STARS NUMBER(38,0),
	REVIEW_TEXT VARCHAR(16777216),
	primary key (USER_ID, BUSINESS_ID, CLIM_DATE),
	foreign key (LOCATION_ID) references UDACITYPROJECT.DWH.DIM_LOCATION(LOCATION_ID)
);



-- Load data into the dwh tables

insert into Dim_Business
select 
	business_id,
	name
FROM UDACITYPROJECT.ODS.BUSINESS;


insert into Dim_Customer
select 
	user_id,
	name
FROM UDACITYPROJECT.ODS.CUSTOMER;


insert into Dim_Location
select 
	city_id,
	city_name
FROM UDACITYPROJECT.ODS.CITY;


insert into Dim_Climate
select
	t.temper_date,
	t.max,
	t.min,
	t.normal_max,
	t.normal_min,
	p.precip_amt,
	p.precip_normal
from UDACITYPROJECT.ODS.TEMPERATURE as t
join UDACITYPROJECT.ODS.PRECIPITATION as p
on t.temper_date = p.precip_date;


insert into Fact_Review
select 
	r.user_id,
	r.business_id,
	r.review_date,
	b.city,
	r.stars,
	r.review_text
from UDACITYPROJECT.ODS.REVIEW as r
join UDACITYPROJECT.ODS.BUSINESS as b
on r.business_id = b.business_id;










