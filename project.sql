create database project3;
use project3;
select * from job_data;

# converting interger into time format 

alter table job_data add column overall_time time;
select* from job_data;
update job_data set overall_time = sec_to_time(time_spent);
select* from job_data;

#Jobs Reviewed Over Time:  Calculate the number of jobs reviewed per hour for each day in November 2020.

SELECT
    DATE(ds) AS date,
    HOUR(ds) AS hour,
    COUNT(*) AS jobs_reviewed
FROM job_data
WHERE
    ds >= '2020-11-01' AND ds < '2020-12-01'
GROUP BY date, hour
ORDER BY date, hour;

# Throughput Analysis:Calculate the 7-day rolling average of throughput (number of events per second).
select * from job_data;
alter table job_data drop column avg_rolling;

alter table job_data add avg_time_spent varchar(10);  
select * from job_data;

#3Language Share Analysis: Objective: Calculate the percentage share of each language in the last 30 days.. 
SELECT
    ds,
    SUM(time_spent) / (7 * 24 * 60 * 60) AS avg_time_spent
FROM (
    SELECT
        ds,
        time_spent,
        SUM(time_spent) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS sum_events
    FROM job_data
) AS t
GROUP BY ds
ORDER BY ds;


# 3. 
select * from job_data;
select language,
num_jobs,
100.0* num_jobs/total_jobs as pct_share_lang
from
(
select language, count(distinct job_id) as num_jobs
from job_data
group by language
)a
cross join
(
select count(distinct job_id) as total_jobs 
from job_data
)b;


#4.Duplicate Rows Detection: Objective: Identify duplicate rows in the data.
select * from
(
select *,
row_number()over(partition by job_id) as rownum 
from job_data
)a 
where rownum>1;




