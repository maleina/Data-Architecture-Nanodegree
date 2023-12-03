-- Initial setup of ODS schema

create or replace schema UDACITYPROJECT.ODS;

USE DATABASE UDACITYPROJECT;

USE SCHEMA ODS;

-- Create the Yelp customer (user) ODS table

create or replace TABLE UDACITYPROJECT.ODS.CUSTOMER (
	USER_ID VARCHAR(22) NOT NULL,
	NAME VARCHAR(16777216),
	REVIEW_COUNT NUMBER(38,0),
	YELPING_SINCE VARCHAR(16777216),
	FRIENDS VARIANT,
	USEFUL NUMBER(38,0),
	FUNNY NUMBER(38,0),
	COOL NUMBER(38,0),
	FANS NUMBER(38,0),
	ELITE VARIANT,
	AVERAGE_STARS FLOAT,
	COMPLIMENT_HOT NUMBER(38,0),
	COMPLIMENT_MORE NUMBER(38,0),
	COMPLIMENT_PROFILE NUMBER(38,0),
	COMPLIMENT_CUTE NUMBER(38,0),
	COMPLIMENT_LIST NUMBER(38,0),
	COMPLIMENT_NOTE NUMBER(38,0),
	COMPLIMENT_PLAIN NUMBER(38,0),
	COMPLIMENT_COOL NUMBER(38,0),
	COMPLIMENT_FUNNY NUMBER(38,0),
	COMPLIMENT_WRITER NUMBER(38,0),
	COMPLIMENT_PHOTOS NUMBER(38,0),
	primary key (USER_ID)
);

-- Create the look up table for cities (for 3NF)

create or replace TABLE UDACITYPROJECT.ODS.CITY (
	CITY_ID NUMBER(38,0) NOT NULL autoincrement,
	CITY_NAME VARCHAR(16777216),
	primary key (CITY_ID)
);

-- Create the look up table for states (for 3NF)

create or replace TABLE UDACITYPROJECT.ODS.STATE (
	STATE_ID NUMBER(38,0) NOT NULL autoincrement,
	STATE_NAME VARCHAR(16777216),
	primary key (STATE_ID)
);

-- Create the look up table for postal codes (for 3NF)

create or replace TABLE UDACITYPROJECT.ODS.POSTAL_CODE (
	POSTAL_CODE_ID NUMBER(38,0) NOT NULL autoincrement,
	POSTAL_CODE VARCHAR(16777216),
	primary key (POSTAL_CODE_ID)
);

-- Create the Yelp business ODS table

create or replace TABLE UDACITYPROJECT.ODS.BUSINESS (
	BUSINESS_ID VARCHAR(22) NOT NULL,
	NAME VARCHAR(16777216),
	ADDRESS VARCHAR(16777216),
	CITY NUMBER(38,0),
	STATE NUMBER(38,0),
	POSTAL_CODE NUMBER(38,0),
	LATITUDE FLOAT,
	LONGITUDE FLOAT,
	STARS FLOAT,
	REVIEW_COUNT NUMBER(38,0),
	IS_OPEN INTEGER,
	ATTRIBUTES VARIANT,
	CATEGORIES VARIANT,
	HOURS VARIANT,
	primary key (BUSINESS_ID),
	foreign key (CITY) references UDACITYPROJECT.ODS.CITY(CITY_ID),
	foreign key (STATE) references UDACITYPROJECT.ODS.STATE(STATE_ID),
	foreign key (POSTAL_CODE) references UDACITYPROJECT.ODS.POSTAL_CODE(POSTAL_CODE_ID)
);


-- Create the Yelp covid ODS table

create or replace TABLE UDACITYPROJECT.ODS.COVID (
	BUSINESS_ID VARCHAR(22) NOT NULL,
	HIGHLIGHTS VARCHAR(16777216),
	DELIVERY_OR_TAKEOUT VARCHAR(16777216),
	GRUBHUB_ENABLED VARCHAR(16777216),
	CALL_TO_ACTION_ENABLED VARCHAR(16777216),
	REQUEST_A_QUOTE_ENABLED VARCHAR(16777216),
	COVID_BANNER VARCHAR(16777216),
	TEMPORARY_CLOSED_UNTIL VARCHAR(16777216),
	VIRTUAL_SERVICES_OFFERED VARCHAR(16777216),
	primary key (BUSINESS_ID),
	foreign key (BUSINESS_ID) references UDACITYPROJECT.ODS.BUSINESS(BUSINESS_ID)
);


-- Create the Yelp check-in ODS table

create or replace TABLE UDACITYPROJECT.ODS.CHECK_IN (
	CHECK_IN_ID NUMBER(38,0) NOT NULL autoincrement,
	BUSINESS_ID VARCHAR(22),
	CHECK_IN_DATE STRING,
	primary key (CHECK_IN_ID),
	foreign key (BUSINESS_ID) references UDACITYPROJECT.ODS.BUSINESS(BUSINESS_ID)
);

-- Create the Yelp tips ODS table

create or replace TABLE UDACITYPROJECT.ODS.TIPS (
	TIP_ID NUMBER(38,0) NOT NULL autoincrement,
	TIP_TEXT VARCHAR(16777216),
	TIP_DATE DATE,
	COMPLIMENT_COUNT NUMBER(38,0),
	BUSINESS_ID VARCHAR(22),
	USER_ID VARCHAR(22),
	primary key (TIP_ID),
	foreign key (BUSINESS_ID) references UDACITYPROJECT.ODS.BUSINESS(BUSINESS_ID),
	foreign key (USER_ID) references UDACITYPROJECT.ODS.CUSTOMER(USER_ID)
);

-- Create the temperature ODS table

create or replace TABLE UDACITYPROJECT.ODS.TEMPERATURE (
	TEMPER_DATE DATE NOT NULL,
	MAX FLOAT,
	MIN FLOAT,
	NORMAL_MAX FLOAT,
	NORMAL_MIN FLOAT,
	primary key (TEMPER_DATE)
);

-- Create the precipitation ODS table

create or replace TABLE UDACITYPROJECT.ODS.PRECIPITATION (
	PRECIP_DATE DATE NOT NULL,
	PRECIP_AMT FLOAT,
	PRECIP_NORMAL FLOAT,
	primary key (PRECIP_DATE)
);


-- Create the Yelp review ODS (has to be created last because of foreign key relationships to climate tables)
-- The date and time parts of the timestamp in the json string will be split into separate date and time fields.
-- This is to faciliate a foreign key relationship with the climate tables, which only have a date, without 
-- losing the time portion of the reivew timestamp.

create or replace TABLE UDACITYPROJECT.ODS.REVIEW (
	REVIEW_ID VARCHAR(22) NOT NULL,
	USER_ID VARCHAR(22),
	BUSINESS_ID VARCHAR(22),
	STARS NUMBER(38,0),
	REVIEW_DATE DATE,
	REVIEW_TIME TIME,
	REVIEW_TEXT VARCHAR(16777216),
	USEFUL NUMBER(38,0),
	FUNNY NUMBER(38,0),
	COOL NUMBER(38,0),
	primary key (REVIEW_ID),
	foreign key (USER_ID) references UDACITYPROJECT.ODS.CUSTOMER(USER_ID),
	foreign key (BUSINESS_ID) references UDACITYPROJECT.ODS.BUSINESS(BUSINESS_ID),
	foreign key (review_date) references UDACITYPROJECT.ODS.Temperature(temper_date),
	foreign key (review_date) references UDACITYPROJECT.ODS.Precipitation(precip_date)
);


-- The insert statements below use JSON functions in a select clause to 
-- easily populate the respective Yelp tables from their respective staging tables.
-- The staging tables each contain a single 'jsonstring' column which we are parsing below.


INSERT INTO Customer   
SELECT 
  jsonstring:user_id, 
  jsonstring:name,
  jsonstring:review_count,
  jsonstring:yelping_since,
  jsonstring:friends,
  jsonstring:useful,
  jsonstring:funny,
  jsonstring:cool,
  jsonstring:fans,
  jsonstring:elite,
  jsonstring:average_stars,
  jsonstring:compliment_hot,
  jsonstring:compliment_more,
  jsonstring:compliment_profile,
  jsonstring:compliment_cute,
  jsonstring:compliment_list,
  jsonstring:compliment_note,
  jsonstring:compliment_plain,
  jsonstring:compliment_cool,
  jsonstring:compliment_funny,
  jsonstring:compliment_writer,
  jsonstring:compliment_photos   
FROM UDACITYPROJECT.STAGING.CUSTOMER;



INSERT INTO CITY (city_name)
SELECT DISTINCT jsonstring:city
FROM UDACITYPROJECT.STAGING.BUSINESS;


INSERT INTO STATE (state_name)
SELECT DISTINCT jsonstring:state
FROM UDACITYPROJECT.STAGING.BUSINESS;

INSERT INTO POSTAL_CODE (postal_code)
SELECT DISTINCT jsonstring:postal_code
FROM UDACITYPROJECT.STAGING.BUSINESS;


insert into BUSINESS
SELECT
	sb.jsonstring:business_id,
	sb.jsonstring:name,
	sb.jsonstring:address,
	c.city_id,
	s.state_id,
	p.postal_code_id,
	sb.jsonstring:latitude,
	sb.jsonstring:longitude,
	sb.jsonstring:stars,
	sb.jsonstring:review_count,
	sb.jsonstring:is_open,
	sb.jsonstring:attributes,
	sb.jsonstring:categories,
	sb.jsonstring:hours
FROM UDACITYPROJECT.STAGING.BUSINESS sb
JOIN city c
on c.cityname = sb.jsonstring:city
join state s
on s.state_name = sb.jsonstring:state
join postal_code p
on p.postal_code = sb.jsonstring:postal_code;


insert into COVID
SELECT 
	jsonstring:business_id,
	jsonstring:highlights,
	jsonstring:"delivery or takeout",
	jsonstring:"Grubhub enabled",
	jsonstring:"Call To Action enabled",
	jsonstring:"Request a Quote Enabled",
	jsonstring:"Covid Banner",
	jsonstring:"Temporary Closed Until",
	jsonstring:"Virtual Services Offered"
FROM UDACITYPROJECT.STAGING.COVID;


insert into check_in ( business_id, check_in_date)
select 
	jsonstring:business_id,
	jsonstring:date
FROM UDACITYPROJECT.STAGING.CHECK_IN;


insert into tips (tip_text, tip_date, compliment_count, business_id, user_id)
select
	jsonstring:text,
	jsonstring:date,
	jsonstring:compliment_count,
	jsonstring:business_id,
	jsonstring:user_id
FROM UDACITYPROJECT.STAGING.TIPS;


-- Insert into the temperature ODS table from the temperature staging table

insert into Temperature
select 
	date(temp_date,'yyyymmdd'),
	max,
	min,
	normal_max,
	normal_min
FROM UDACITYPROJECT.STAGING.TEMPERATURE;	


-- Insert into the precipitation ODS table from the precipitation staging table
-- Use 9999.0 for T values in precipitation_amt
-- So they can be easily filtered later
insert into Precipitation
select 
	date(precipitation_date, 'yyyymmdd'),
	CASE precipitation_amt
	WHEN 'T' THEN 9999.0
	ELSE cast(precipitation_amt as float)
	END,
	precipitation_normal
FROM UDACITYPROJECT.STAGING.PRECIPITATION;


-- The insert statements below use JSON functions in a select clause to 
-- easily populate the Yelp review table. Note how the split_part function
-- is used to split the data and time parts from the json date string.

insert into review
select 
	jsonstring:review_id,
	jsonstring:user_id,
	jsonstring:business_id,
	jsonstring:stars,
	split_part(jsonstring:date, ' ', 1),
	split_part(jsonstring:date, ' ', 2),
	jsonstring:text,
	jsonstring:useful,
	jsonstring:funny,
	jsonstring:cool
FROM UDACITYPROJECT.STAGING.REVIEW;
