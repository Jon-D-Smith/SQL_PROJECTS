/*
Question: What are the top skills based on salary?
*/

SELECT 
    skills.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_job ON skills_job.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_job.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL 
    AND job_work_from_home = True
GROUP BY 
    skills.skills
ORDER BY
    avg_salary DESC
LIMIT 25