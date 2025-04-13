CREATE DATABASE IF NOT EXISTS db;
USE db;

CREATE TABLE case_study_1(
ds varchar(20),
job_id int,
actor_id int primary key,
event varchar(20),
language varchar(20),
time_spent int,
org varchar(10)
);

INSERT INTO case_study_1 (ds,job_id,actor_id,event,language,time_spent,org)
VALUES
("11/30/2020" ,21,	1001,	"skip",	"English",	15,	"A"),
("11/30/2020",	22,	1006,	"transfer"	,"Arabic"	,25,	"B"),
("11/29/2020"	,23,	1003,	"decision",	"Persian"	,20,	"C"),
("11/28/2020",	23,	1005,	"transfer"	,"Persian"	,22,	"D"),
("11/28/2020",	25,	1002,	"decision"	,"Hindi"	,11,	"B"),
("11/27/2020",	11,	1007	,"decision"	,"French"	,104,	"D"),
("11/26/2020",	23,	1004,	"skip",	"Persian",	56,	"A"),
("11/25/2020",	20,	1003,	"transfer",	"Italian",	45	,"C");

SELECT * FROM case_study_1;


/* Task A */

SELECT 
	ds AS date,
    COUNT(job_id) AS number_of_jobs,
    SUM(time_spent)/60 AS total_time_spent_in_hrs,
    COUNT(job_id)/(SUM(time_spent)/60) AS jobs_per_hour
FROM case_study_1
WHERE 
	ds BETWEEN "11/01/2020" AND "11/31/2020"
GROUP BY ds
ORDER BY ds ASC;

    
    
    
/*task - B*/


WITH daily_throughput AS (
    SELECT 
        STR_TO_DATE(ds, '%m/%d/%Y') AS date,    
        COUNT(event) AS total_events,            
        SUM(time_spent) AS total_time_spent,     
        COUNT(event) / SUM(time_spent) AS throughput  
    FROM case_study_1
    WHERE 
        STR_TO_DATE(ds, '%m/%d/%Y') BETWEEN '2020-11-01' AND '2020-11-30' 
    GROUP BY STR_TO_DATE(ds, '%m/%d/%Y')   ORDER BY STR_TO_DATE(ds, '%m/%d/%Y')   
)
SELECT 
    a.date,
    a.throughput,
    AVG(b.throughput) AS rolling_avg_throughput  
FROM daily_throughput a
JOIN daily_throughput b
    ON b.date BETWEEN DATE_SUB(a.date, INTERVAL 6 DAY) AND a.date  
GROUP BY a.date ORDER BY a.date;




/*Task - C*/


WITH recent_events AS (
    SELECT 
        STR_TO_DATE(ds, '%m/%d/%Y') AS date,
        language,
        COUNT(event) AS num_events
    FROM case_study_1
    WHERE STR_TO_DATE(ds, '%m/%d/%Y') >= '2020-11-01'
    GROUP BY STR_TO_DATE(ds, '%m/%d/%Y'), language
)
SELECT 
    language,
    SUM(num_events) AS events_per_language,  
    (SUM(num_events) / (SELECT COUNT(*) 
                        FROM case_study_1 
                        WHERE STR_TO_DATE(ds, '%m/%d/%Y') >= '2020-11-01')) * 100 AS percentage_share
FROM recent_events GROUP BY language ORDER BY percentage_share DESC;


/* Task - D */

SELECT 
    ds,job_id,actor_id,event,language,time_spent,org           
FROM 
    case_study_1
GROUP BY 
	 ds,job_id,actor_id,event,language,time_spent,org   
HAVING COUNT(*) > 1; 















