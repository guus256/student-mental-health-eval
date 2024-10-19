SELECT*
FROM mental_health;

# Tasks for this project 
# firstly, sprout out for some data cleaning. check for nulls, dupes, unecessary columns 
# do a bit of extra standardization; trim up columns if need be, create columns that need to be eg avg_mental_score, 

# checking for duplicates. 
WITH mental2 AS
(
SELECT *,
	   ROW_NUMBER() OVER(PARTITION BY gender, age, university, degree_major, academic_year, cgpa, residential_status, campus_discrimination, sports_engagement, average_sleep, study_satisfaction, academic_workload, academic_pressure, financial_concerns, social_relationships, depression, anxiety, isolation, future_insecurity, stress_relief_activities) row_num
FROM mental_health
)
SELECT *
FROM mental2
WHERE row_num > 1; 

# lets figure out which gender had the highest number of discrimination counts on campus. 
SELECT gender, 
	   COUNT(CASE WHEN campus_discrimination = "Yes" THEN 1 ELSE NULL END) AS Yes_Discriminated, 
       COUNT(CASE WHEN campus_discrimination = "No" THEN 1 ELSE NULL END) AS No_Discriminated
FROM mental_health
GROUP BY 1;

# lets create two columns; avg_mental_score and age_group to help do more aggregated analysis. 
SELECT MIN(age), MAX(age)
FROM mental_health;

SELECT CASE 
		WHEN age BETWEEN 17 AND 19 THEN '17-19'
        WHEN age BETWEEN 20 AND 22 THEN '20-22'
        WHEN age BETWEEN 23 AND 26 THEN '23-26'
        ELSE NULL
	   END AS age_group
FROM mental_health;

ALTER TABLE mental_health 
ADD COLUMN age_group VARCHAR(10); 

UPDATE mental_health 
SET age_group = CASE 
		WHEN age BETWEEN 17 AND 19 THEN '17-19'
        WHEN age BETWEEN 20 AND 22 THEN '20-22'
        WHEN age BETWEEN 23 AND 26 THEN '23-26'
        ELSE NULL
	   END; 

ALTER TABLE mental_health 
ADD COLUMN avg_mental_score VARCHAR(10);

SELECT ROUND(((academic_workload + academic_pressure + financial_concerns + depression + anxiety + isolation + future_insecurity - study_satisfaction - social_relationships)/ 9), 1) AS avg_mental_score
FROM mental_health; 

UPDATE mental_health
SET avg_mental_score = ROUND(((academic_workload + academic_pressure + financial_concerns + depression + anxiety + isolation + future_insecurity - study_satisfaction - social_relationships)/ 9), 1);

SELECT *
FROM mental_health;

SELECT degree_major, ROUND(SUM(avg_mental_score), 1) total_mental_score_by_avg
FROM mental_health
GROUP BY 1
ORDER BY 2 DESC;

SELECT gender, age_group, degree_level, degree_major, academic_year, cgpa, residential_status, campus_discrimination, sports_engagement, average_sleep, avg_mental_score
FROM mental_health; 

#I then uploaded this smaller dataset into Excel for further formatting and dashboard creation. 












