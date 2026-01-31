/*
Question: What are the most in-demand skills for data analysts?
*/


SELECT 
    skills.skills,
    COUNT(skills_job.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_job ON skills_job.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_job.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    -- AND job_postings_fact.job_location IN ('Denton, TX', 'Lewisville, TX')
GROUP BY 
    skills.skills
ORDER BY
    demand_count DESC
LIMIT 20


-- Find location options near me
SELECT DISTINCT 
    job_location
from job_postings_fact AS j 
WHERE job_location LIKE '%TX%'
ORDER BY job_location