use role accountadmin;
use database common;
use schema utility;
use warehouse demo_wh;


--API integration to GitHub
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-jschembri')
  ENABLED = TRUE;

--new git repository similar to external stage
CREATE OR REPLACE GIT REPOSITORY common.utility.repo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/sfc-gh-jschembri/sfguide-getting-started-with-snowflake-devops';


-- To monitor data pipeline's completion
CREATE OR REPLACE NOTIFICATION INTEGRATION email_integration
  TYPE=EMAIL
  ENABLED=TRUE;


-- Database level objects
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;


-- Schema level objects
CREATE OR REPLACE FILE FORMAT bronze.json_format TYPE = 'json';
CREATE OR REPLACE STAGE bronze.raw;


-- Copy file from GitHub to internal stage
copy files into @bronze.raw from @common.utility.repo/branches/main/data/airport_list.json;
