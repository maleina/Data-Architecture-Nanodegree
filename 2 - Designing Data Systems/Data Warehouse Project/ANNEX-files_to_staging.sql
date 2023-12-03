-- Initial setup of database and schema

create or replace database UDACITYEXERCISE;

create or replace schema UDACITYPROJECT.STAGING;

USE DATABASE UDACITYPROJECT;

USE SCHEMA STAGING;

-- Create the precipitation staging table
create or replace TABLE UDACITYPROJECT.STAGING.PRECIPITATION (
	PRECIPITATION_DATE INTEGER,
	PRECIPITATION_AMT VARCHAR(16777216),
	PRECIPITATION_NORMAL FLOAT
);

-- Load precipitation file data into snowflake precipitation staging table

COPY INTO "UDACITYPROJECT"."STAGING"."PRECIPITATION"
FROM '@"UDACITYPROJECT"."STAGING"."%PRECIPITATION"/__snowflake_temp_import_files__/'
FILES = ('usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv')
FILE_FORMAT = (
    TYPE=CSV,
    SKIP_HEADER=0,
    FIELD_DELIMITER=',',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
)
ON_ERROR=ABORT_STATEMENT
PURGE=TRUE


-- Create the temperature staging table.
-- I reversed min and max columns of file since it was obvious that the headings in the file were incorrect. 
-- This is as per the knowledge base answer (https://knowledge.udacity.com/questions/902247)
create or replace TABLE UDACITYPROJECT.STAGING.TEMPERATURE (
	TEMP_DATE INTEGER,
	MAX FLOAT,
	MIN FLOAT,
	NORMAL_MAX FLOAT,
	NORMAL_MIN FLOAT
);

-- Load temperature file data into snowflake temperature staging table

COPY INTO "UDACITYPROJECT"."STAGING"."TEMPERATURE"
FROM '@"UDACITYPROJECT"."STAGING"."%TEMPERATURE"/__snowflake_temp_import_files__/'
FILES = ('usw00023169-temperature-degreef.csv')
FILE_FORMAT = (
    TYPE=CSV,
    SKIP_HEADER=1,
    FIELD_DELIMITER=',',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
)
ON_ERROR=ABORT_STATEMENT
PURGE=TRUE


-- Create the staging tables for the Yelp data

create or replace TABLE UDACITYPROJECT.STAGING.COVID (
	JSONSTRING VARIANT
);


create or replace TABLE UDACITYPROJECT.STAGING.BUSINESS (
	JSONSTRING VARIANT
);


create or replace TABLE UDACITYPROJECT.STAGING.CHECK_IN (
	JSONSTRING VARIANT
);


create or replace TABLE UDACITYPROJECT.STAGING.REVIEW (
	JSONSTRING VARIANT
);


create or replace TABLE UDACITYPROJECT.STAGING.TIPS (
	JSONSTRING VARIANT
);


create or replace TABLE UDACITYPROJECT.STAGING.CUSTOMER (
	JSONSTRING VARIANT
);


-- Create  json file format
create or replace file format yelpjsonformat type='JSON' strip_outer_array=true;

-- Create stage for the yelp files
create or replace stage yelp_json_stage file_format = yelpjsonformat;


-- Each of the successive put statements loads a yelp file into the stage
-- Each of the successive copy statement loads the data from the staged file into the appropriate staging table

put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_academic_dataset_covid_features.json @yelp_json_stage auto_compress=true;


copy into covid from @yelp_json_stage/yelp_academic_dataset_covid_features.json.gz file_format=yelpjsonformat on_error='skip_file';



put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_dataset/yelp_academic_dataset_business.json @yelp_json_stage auto_compress=true;


copy into business from @yelp_json_stage/yelp_academic_dataset_business.json.gz file_format=yelpjsonformat on_error='skip_file';



put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_dataset/yelp_academic_dataset_checkin.json @yelp_json_stage auto_compress=true;


copy into check_in from @yelp_json_stage/yelp_academic_dataset_checkin.json.gz file_format=yelpjsonformat on_error='skip_file';



put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_dataset/yelp_academic_dataset_review.json @yelp_json_stage auto_compress=true;


copy into review from @yelp_json_stage/yelp_academic_dataset_review.json.gz file_format=yelpjsonformat on_error='skip_file';



put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_dataset/yelp_academic_dataset_tip.json @yelp_json_stage auto_compress=true;


copy into tips from @yelp_json_stage/yelp_academic_dataset_tip.json.gz file_format=yelpjsonformat on_error='skip_file';



put file:///Users/maleina/Development/Udacity/DArchND/DWH_Project/data/yelp_dataset/yelp_academic_dataset_user.json @yelp_json_stage auto_compress=true;


copy into customer from @yelp_json_stage/yelp_academic_dataset_user.json.gz file_format=yelpjsonformat on_error='skip_file';
