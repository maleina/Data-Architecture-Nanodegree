# Project: Design a Data Warehouse for Reporting and OLAP

*Note: This project description text is from Udacity.com.*

## Description

In this project scenario, students will use actual YELP and climate datasets in order to analyze the effects the weather has on customer reviews of restaurants. The data for temperature and precipitation observations are from the Global Historical Climatology Network-Daily (GHCN-D) database. Students will use a leading industry cloud-native data warehouse system called Snowflake for all aspects of the project.

Students will then apply the skills they have acquired in the preceding Designing Data Systems Course to architect and design a Data Warehouse DWH for the purpose of reporting and online analytical processing (OLAP).

## Downloading the Data

In this project, you will merge two massive, real-world datasets in order to draw conclusions about how weather affects Yelp reviews.

The first step is to obtain the data we will use for the project.

Make sure you have around 10 GB free disk space.

### Yelp Data
Navigate to the [Yelp Dataset](https://www.yelp.com/dataset/download), then enter your details and click Download

On this page download 2 files “Download JSON” and “COVID-19 Data”

*Note: The COVID-19 Data is currently not available for download on Yelp dataset page. You can download the COVID-19 dataset from [this Kaggle page](https://www.kaggle.com/claudiadodge/yelp-academic-data-set-covid-features?select=yelp_academic_dataset_covid_features.json).*

If you get an error code, go back to the page where you entered your details, click on download again try again

*Note: Use single word filenames when you save. This will make it easier when loading into the database in later steps.*

These are compressed files that will need to be uncompressed with the tool of your choice

### Climate Data
We also need climate data, which is provided as two CSV files in the Resources tab in the classroom.

Precipitation Data - USW00023169-LAS VEGAS MCCARRAN INTL AP-PRECIPITATION-INCH
Temperature Data - USW00023169-TEMPERATURE-DEGREEF
The above data files contain historical weather data for the city of Las Vegas (Nevada) (Weather Station - USW00023169), and were obtained from [Climate Explorer](https://crt-climate-explorer.nemac.org/).

If you have already setup your SNOWFLAKE account, you can skip the next step

### Snowflake account setup
NOTE You will use the same Snowflake account that you used in your Exercises

Create a snowflake account here: [Snowflake: Your Cloud Data Platform](https://www.snowflake.com/)

New Acccount if needed:

- Select Start for free on top right
- Enter your details and click continue
- Select Enterprise and any cloud provider of your choice, enter any other details required and click Get Started
- Activate your account and log in to your account.
- Save the link given in the email for future use.
*NOTE Free trial gives credits worth $400, enough to complete this project. You don’t have to give credit card unless you ran out of credits.*

### SnowSQL client
You also need to install the [SnowSQL client](https://docs.snowflake.com/en/user-guide/snowsql-install-config.html) ( the direct link to the repository to download the installer is at Snowflake Repository)

Mac OS users: In case of an error, check for help [HERE](https://support.snowflake.net/s/question/0D50Z000084fjR3SAI/snowsql-cli-for-mac-isnt-installing-correctly) and resolve using “alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql”

Snowflake is a professional tool widely used in industry and does have a learning curve. It is highly recommended that you do the hands-on lab to get familiar with [Snowflake HANDS-ON LAB GUIDE FOR SNOWFLAKE FREE TRIAL](https://s3.amazonaws.com/snowflake-workshop-lab/Snowflake_free_trial_LabGuide.pdf)

Take some time to Explore the data you have uploaded

## Project Steps

- Create a data architecture diagram to visualize how you will ingest and migrate the data into Staging, Operational Data Store (ODS), and Data Warehouse environments, so as to ultimately query the data for relationships between weather and Yelp reviews. Save this so it can be included in your final submission.
- Create a staging environment(schema) in Snowflake.
- Upload all Yelp and Climate data to the staging environment. (Screenshots 1,2) (see Screenshot description below)

*NOTE: You may need to SPLIT these datasets into several smaller files (< 3 million records per file in YELP).
You can use PineTools online tool or download the 7zip tool to split large json files. After you split the large file into multiple files, please check the split data in the individual files to avoid parsing errors when you upload the files to Snowflake.*

- Create an ODS environment(aka schema).
- Draw an entity-relationship (ER) diagram to visualize the data structure. Save this so it can be included in your final submission.
- Migrate the data into the ODS environment. (Screenshots 3,4,5,6)
- Draw a STAR schema for the Data Warehouse environment. Save this so it can be included in your final submission.
- Migrate the data to the Data Warehouse. (Screenshot 7)
- Query the Data Warehouse to determine how weather affects Yelp reviews. ( Screenshot 8)

## Description of screenshots needed for submission

Note to students: You can either use SQL directly, or you can use Snowflake GUI interface to accomplish many of the tasks below. Snowflake can provide the SQL for any actions you take in the GUI. That is the SQL you would provide below.

- Screenshot of 6 tables created upon upload of YELP data
- Screenshot of 2 tables created upon upload of climate data
- SQL queries code that transforms staging to ODS. (include all queries)
- SQL queries code that specifically uses JSON functions to transform data from a single JSON structure of staging to multiple columns of ODS. (can be similar to #3, but must include JSON functions)
- Screenshot of the table with three columns: raw files, staging, and ODS. (and sizes)
- SQL queries code to integrate climate and Yelp data
- SQL queries code necessary to move the data from ODS to DWH.
- SQL queries code that reports the business name, temperature, precipitation, and ratings.