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