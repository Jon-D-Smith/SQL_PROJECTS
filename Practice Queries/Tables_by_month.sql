CREATE TABLE january_jobs AS
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
    ;


CREATE TABLE february_jobs AS
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2
    ;

CREATE TABLE march_jobs AS
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3
    ;


SELECT MIN(job_posted_date) AS start_date, MAX(job_posted_date) AS end_date
FROM march_jobs;