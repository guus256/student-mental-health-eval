### Students Mental Health Evaluation 

**Table of Contents**
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Exploratory Data Analysis and Methodology](#exploratory-data-analysis-and-methodology)
- [Insights](#insights)
- [Recommendations](#recommendations)

## Introduction
This project analyzes factors influencing mental health among university students, exploring how academic, social, and financial challenges impact their well-being. It aims to identify trends and insights to support strategies for improving student mental health.

## Project Overview
This analysis project aims to provide insights on three primary objectives among others, namely;
- Perform in-depth understanding, cleaning, filtering and sorting of the data set to ease task management.
- Data standardization and prepare data for data analysis and vizualisation in Microsoft Excel. 
- Assess the effectiveness of the different factors faced and create a visualization to present the insights and data outcomings. 

## Data Sources
The dataset was sourced from this [Kaggle](https://www.kaggle.com/datasets/abdullahashfaqvirk/student-mental-health-survey).

## Exploratory Data Analysis and Methodology
- Firstly, we check for duplicate data as we want to ensure integrity in our data and further analysis.
```sql
WITH mental2 AS
(
SELECT *,
	   ROW_NUMBER() OVER(PARTITION BY gender, age, university, degree_major, academic_year, cgpa, residential_status, campus_discrimination, sports_engagement, average_sleep, study_satisfaction, academic_workload, academic_pressure, financial_concerns, social_relationships, depression, anxiety, isolation, future_insecurity, stress_relief_activities) row_num
FROM mental_health
)
SELECT *
FROM mental2
WHERE row_num > 1; 
```

- Having discovered no duplicated data, we then proceed to find out the highest discrimination counts for the all universities. 
```sql
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
```
```sql
#Now for the average mental health score per student.

SELECT ROUND(((academic_workload + academic_pressure + financial_concerns + depression + anxiety + isolation + future_insecurity - study_satisfaction - social_relationships)/ 9), 1) AS avg_mental_score
FROM mental_health; 

UPDATE mental_health
SET avg_mental_score = ROUND(((academic_workload + academic_pressure + financial_concerns + depression + anxiety + isolation + future_insecurity - study_satisfaction - social_relationships)/ 9), 1);
```

- Last, but not least, we performed a simple aggregation to understand which degree major had the highest average mental score.
```sql
SELECT degree_major, ROUND(SUM(avg_mental_score), 1) total_mental_score_by_avg
FROM mental_health
GROUP BY 1
ORDER BY 2 DESC;
```

- We finalized with picking out a few columns that were necessary for the visualization and insights generation in Microsoft Excel.
 ```sql
SELECT gender, age_group, degree_level, degree_major, academic_year, cgpa, residential_status, campus_discrimination, sports_engagement, average_sleep, avg_mental_score
FROM mental_health; 

```
- In Excel, pivot tables were created, visualizations were put together to bring out a bigger picture, sliders were added for further filtration if needed and finally, a dashboard was created. (File added to repository above.)

## Insights
- **Discrimination**: Male and female students facing campus discrimination show increased mental health concerns, with a stronger effect among males.
- **Academic Performance & Residential Status**: Higher GPA students generally report better mental health, though on-campus students show slightly more concerns than their off-campus counterparts.
- **Degree Major**: Students in Data Science and Computer Science majors report higher mental health concerns compared to those in Software Engineering.
- **Sleep**: Students with 7-8 hours of sleep report the best mental health, while those with only 2-4 hours report the highest concerns.
- **Sports Participation**: Students engaging in sports 4+ times a week report better mental health than those who don’t participate in sports.

## Recommendations
- **Combat Discrimination**: Implement anti-discrimination policies and provide counseling support for affected students.
- **Enhance On-Campus Resources**: Improve mental health support and wellness programs for on-campus students.
- **Promote Sleep Hygiene**: Provide resources on sleep management to reduce mental health concerns linked to sleep deprivation.
- **Encourage Physical Activity**: Increase access to sports programs to support students' mental well-being.
- **Support High-Stress Majors**: Offer academic and mental health support for students in majors with higher reported stress, such as Data Science and Computer Science.
