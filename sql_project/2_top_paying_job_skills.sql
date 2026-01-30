/*
Question: What skills are required for the top-paying data analyst jobs?
*/
-- Setting up the data to be exported for visualization or insights software
WITH top_paying_jobs AS (
SELECT 
    postings.job_id,
    postings.job_title,
    company.name AS Company_name,
    postings.salary_year_avg
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
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim AS skills_job ON skills_job.job_id = top_paying_jobs.job_id 
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_job.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;


-- Getting raw numbers for each skill
WITH top_paying_jobs AS (
SELECT 
    postings.job_id,
    postings.job_title,
    company.name AS Company_name,
    postings.salary_year_avg
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
)
SELECT
    skills,
    COUNT(skills) as skill_frequency
FROM top_paying_jobs
INNER JOIN skills_job_dim AS skills_job ON skills_job.job_id = top_paying_jobs.job_id 
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_job.skill_id
GROUP BY
    skills
HAVING 
    COUNT(skills) > 2
ORDER BY
    skill_frequency DESC;
