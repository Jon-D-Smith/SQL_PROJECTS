/*
Question: What are the top paying data-analyst jobs?
    - Identify the top 10 highest paying Data analyst roles that are available remotely
    - Focus on job postings with specified salaries (remove nulls)
    - Highlight the top paying opportunities for data analysts and get insight into the job market
*/

SELECT 
    postings.job_id,
    postings.job_title,
    company.name AS Company_name,
    postings.job_location,
    postings.job_schedule_type,
    postings.salary_year_avg,
    postings.job_posted_date
FROM 
    job_postings_fact AS postings
LEFT JOIN company_dim AS company ON company.company_id = postings.company_id
WHERE
    postings.job_title_short = 'Data Analyst' AND
    postings.job_location = 'Anywhere' AND
    postings.salary_year_avg IS NOT NULL
ORDER BY
    postings.salary_year_avg DESC
LIMIT 10

-- Check salary average 
WITH top_salaries AS (
SELECT 
    postings.job_id,
    postings.job_title,
    company.name AS Company_name,
    postings.job_location,
    postings.job_schedule_type,
    postings.salary_year_avg,
    postings.job_posted_date
FROM 
    job_postings_fact AS postings
LEFT JOIN company_dim AS company ON company.company_id = postings.company_id
WHERE
    postings.job_title_short = 'Data Analyst' AND
    postings.job_location = 'Anywhere' AND
    postings.salary_year_avg IS NOT NULL AND postings.salary_year_avg < 500000
ORDER BY
    postings.salary_year_avg DESC
LIMIT 10
) SELECT AVG(top_salaries.salary_year_avg) FROM top_salaries