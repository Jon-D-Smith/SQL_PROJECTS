# Job Listing Data Exploration

# Introduction
This is a showcase of an exploratory analysis in SQL where we break down a dataset for data oriented jobs. In this exploration we want to see the most desired skills for data analytics, the top salaries we can expect, and which skills can offer the highest salary. The dataset is based on the job market in 2023 so this is not a current look into the data analytics field and is only used for learning purposes. The version of SQL used for this project was Postgresql.

Check out the SQL queries here: [sql_project](/sql_project/)

# Questions explored
 1. What are the top paying data analyst job opportunities?
 2. What skills are required for these top paying jobs?
 3. What skills are most in demand for data analysis?
 4. Which of those skills are associated with higher paying jobs?
 5. What are the most optimal skills to learn?


# The Analysis
### Top Paying Jobs
The first task was to find the top 10 highest paying jobs for Data analyst roles. I am interested in remote positions which are labeled as 'Anywhere' in the job_postings_fact.job_location column.
```sql
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
```
Here's what I found from the top data analyst jobs in 2023:
- **Wide salary range:** The top 10 data analyst positions have a range of $184,000 to $650,000
- **Multiple Employers:** In these positions we only find one repeat company in our results showing a wide array of companies providing high paying data analyst roles
- **Large outlier:** Jobs 2-9 show a steady increase in pay, but the highest paying job appears to be a large outlier. The average salary for the top 10 jobs appears to be $264,506.15, but when we remove the role offered by Mantys the average for the next 10 companies is $216,506.15.

![Top paying roles](assets\1_top_paying_roles.JPG)
*Bar graph visualizing the salary for the top 10 highest paying data analysts positions. The graph was created in Tableau.*


### Top Paying Skills
The second task was to find which skills were mentioned in the job listings for the top 10 paying analyst roles.
```sql
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
```

**Results:**
I filtered the results to skills that were present in at least 3 of the top 10 job listings. The most common items were SQL, Python, and Tableau.
|Skills       |Frequency |
|-------------|----------|
|SQL          |8/10      |
|Python       |7/10      |
|Tableau      |6/10      |
|r            |4/10      |
|snowflake    |3/10      |
|Excel        |3/10      |
|pandas       |3/10      |


###In-Demand Skills for Data Analysis
Now that we know what the top jobs are looking for, let's broaden the scope into all job listings for Data Analyst roles. Here we look for the top 5 results.

```sql
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
LIMIT 5
```
**Results:**
From these results we find that SQL is still the highest skill in demand for data anlyst, but we see a large jump in importance for excel. Comparing the results to the skills in the top 10 listings we see Python and Tableau are still highly desired, and Power Bi is added to our list.
|Skills       |Frequency |
|-------------|----------|
|SQL          |92628     |
|excel        |67031     |
|python       |57326     |
|tableau      |46554     |
|power bi     |39468     |


### Top Paying Skills
Now we are looking at the skills with the highest average salary. The results show the specific software or tools that lead to the highest salary offerings. 

| skills          | avg_salary |
|-----------------|------------|
| pyspark         | 208172.25  |
| bitbucket       | 189154.50  |
| couchbase       | 160515.00  |
| watson          | 160515.00  |
| datarobot       | 155485.50  |
| gitlab          | 154500.00  |
| swift           | 153750.00  |
| jupyter         | 152776.50  |
| pandas          | 151821.33  |
| elasticsearch   | 145000.00  |
| golang          | 145000.00  |
| numpy           | 143512.50  |
| databricks      | 141906.60  |
| linux           | 136507.50  |
| kubernetes      | 132500.00  |
| atlassian       | 131161.80  |
| twilio          | 127000.00  |
| airflow         | 126103.00  |
| scikit-learn    | 125781.25  |
| jenkins         | 125436.33  |
| notion          | 125000.00  |
| scala           | 124903.00  |
| postgresql      | 123878.75  |
| gcp             | 122500.00  |
| microstrategy   | 121619.25  |

**RESULTS:**
With these results we go from broad categories like SQL and Python, to more specific tools and software like pyspark, pandas, etc.


### Optimal Skills
Now we combine salary and skill demand to find the most optimal skills for the 2023 job results.
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id 
INNER JOIN skills_dim  ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL 
    AND job_postings_fact.job_work_from_home = True
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 20
ORDER BY 
    avg_salary DESC,
    demand_count DESC 
LIMIT 25;
```


| skill_id | skills      | demand_count | avg_salary |
|----------|-------------|--------------|------------|
| 8        | go          | 27           | 115320     |
| 97       | hadoop      | 22           | 113193     |
| 80       | snowflake   | 37           | 112948     |
| 74       | azure       | 34           | 111225     |
| 76       | aws         | 32           | 108317     |
| 79       | oracle      | 37           | 104534     |
| 185      | looker      | 49           | 103795     |
| 1        | python      | 236          | 101397     |
| 5        | r           | 148          | 100499     |
| 182      | tableau     | 230          | 99288      |
| 186      | sas         | 63           | 98902      |
| 7        | sas         | 63           | 98902      |
| 61       | sql server  | 35           | 97786      |
| 183      | power bi    | 110          | 97431      |
| 0        | sql         | 398          | 97237      |
| 215      | flow        | 28           | 97200      |
| 199      | spss        | 24           | 92170      |
| 22       | vba         | 24           | 88783      |
| 196      | powerpoint  | 58           | 88701      |
| 181      | excel       | 256          | 87288      |
| 192      | sheets      | 32           | 86088      |
| 188      | word        | 48           | 82576      |

**Results:**
We see that knowing sql(sql and sql server), analytics languages (python, sas, r), web technologies (go, python), cloud technologies(Azure and AWS), spreadsheets (Excel and sheets), and visualization software (Tableau, power bi, and powerpoint) are all in demand skills for data analysts. Utilizing any combination of these technologies and skills should greatly increase our desirability in the data field.
