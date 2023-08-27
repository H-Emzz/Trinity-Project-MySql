drop database project3a;
create database project3a;
use project3a;

create  table users (
users_id int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50));


load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from users;

# import the data type as string and convert or cast into datetime format
alter table users add column temp_created_at datetime;
update users set temp_created_at = str_to_date(created_at, '%d-%m-%Y %H:%i');
select * from users;
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;
select *from users;


# table 2 event
#user_id	occurred_at	event_type	event_name	location	device	user_type
# using load infile commends we can not import Null values that's the reason we have not used Null 

create table events (
users_id int,
occurred_at varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(50),
user_type int
);

## using load infile commends we can not import Null values 

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

describe events;
select * from events;

alter table events add column temp_occured datetime;
update events set temp_occured = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

alter table events drop column occurred_at;

alter table events change column temp_occured occurred_at datetime;
select *from events;


# Table 3 email_events
#user_id	occurred_at	action	user_type

create table email_events (
user_id int,
occurred_at varchar(100),
action varchar(50),
user_type int
);

# import load data infile does not import null values

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

desc email_events;
select * from email_events;

alter table email_events add column temp_occured datetime;
update email_events set temp_occured = str_to_date(occurred_at, '%d-%m-%Y %H:%i');

alter table email_events drop column occurred_at; 
alter table email_events change column temp_occured occurred_at datetime;

# Weekly User Engagement:Measure the activeness of users on a weekly basis.
select * from events;

SELECT
    YEAR(occurred_at) AS year, # YEAR() extracting year from occurred_at column 
    WEEK(occurred_at) AS week_number, # week() extracting week from occurred_at column calculates the week number  
    COUNT(*) AS engagement_count #  count(*) counts the number of rows in each group
FROM events
GROUP BY year, week_number
ORDER BY year, week_number
limit 5;

# 2 -- Calculate user growth for the product over time
SELECT
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(DISTINCT users_id) AS user_count
FROM users
GROUP BY year, month
ORDER BY year, month desc
limit 5;

# 3-- Calculate weekly retention of users based on sign-up cohort
SELECT
    YEAR(signup.created_at) AS signup_year,
    WEEK(signup.created_at) AS signup_week,
    YEAR(events.occurred_at) AS event_year,
    WEEK(events.occurred_at) AS event_week,
    COUNT(DISTINCT events.users_id) AS retained_users
FROM users signup
LEFT JOIN events ON signup.users_id = events.users_id
    AND events.occurred_at >= signup.created_at
    AND events.occurred_at <= DATE_ADD(signup.created_at, INTERVAL 7 DAY) -- Within the first week
GROUP BY signup_year, signup_week, event_year, event_week
ORDER BY signup_year, signup_week, event_year, event_week
limit 5;

# calculate weekly  engagement per device
select 
year (occurred_at) as year,
week (occurred_at ) as week,
device,
count(*) as engagement_count
from events
group by year, week, device
order by year, week, device
limit 5;

# -- Calculate email engagement metrics
select 
action,
count(*) as total_actions,
count(distinct user_id) as unique_users,
avg(user_type) as avg_user_type
from email_events
group by action
order by total_actions desc
limit 5;



	
