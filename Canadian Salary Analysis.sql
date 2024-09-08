
------------------------------------Data Collection & Exploration

select * from canada_data;


--------How many survey responses are available for analysis?

select count(*) from canada_data; --7038 response


--------What are the job titles and industries ratios represented in the dataset?


select title ,
	round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2) 
from canada_data
group by title
order by round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2)  desc;
-- We have variety of resposes but the most ratios is full stack, backend and fronted with 31.44%,19.54% and 10.26%

select industry ,
	round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2) 
from canada_data
group by industry
order by round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2)  desc;
-- the dominant industry is  "Information Services, IT, Software Development, or other Technology" with 57.37%



----------checking cities ratios

select city ,
	round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2) 
from canada_data
group by city
order by round((count(*)::float /(select count(*) from canada_data)*100 )::numeric , 2)  desc;


-- as we see the top 3 is Montreal, Hamilton–Niagara Peninsula and Toronto with 22.35% , 17.59% and 10.34%


-----------------------------Data Cleaning & Preparation

--checking for nulls

select * from canada_data
where 
	survay_year = null or
	company_size = null or
	industry = null or
	exp = null or
	title = null or
	country = null or
	salary = null ;-- there is no missing values



-------------------------Salary Trends Over Time

--How have salaries evolved in Canada from 2011 to 2023?
select survay_year , round(avg(salary)::numeric,2) as avg_salary
from canada_data
group by survay_year
order by survay_year Asc;

-- Most significant increase: From 2013 to 2014, the salary increased by $8,166.67 (from $79,333.33 to $87,500.00).
-- Most significant decrease: From 2014 to 2016, the salary decreased by $27,375.91 (from $87,500.00 to $60,124.09).



--Which years saw the most significant increase or decrease in salaries?

select survay_year ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by survay_year
order by round(avg(salary)::numeric,2) Asc;

-- the peak was in 2014 with avg salary 87.500 and the least salaries was in 2017 with avg salary 41.496



------------Salary by Industry

-- Which industry offers the highest average salary?
-- What is the salary distribution across different industries?

select 
	industry ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by industry
order by round(avg(salary)::numeric,2) desc; 
--This indicates a relatively small variation in average salaries across industries.

-- Oil & Gas offers the highest average salary at $68,851.56,
-- while Insurance offers the lowest average salary at $59,650.68


--------------Salary by Job Title

-- What are the top-paying job titles?
-- How do salaries vary between different job roles?

select 
	title ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by title
order by round(avg(salary)::numeric,2) desc; 

-- So the top-paying job titles is Experienced developers with avg salary 89222
-- There is relatively small variation in average salaries across titles 
-- but the Experienced developer and Engineering managers clearly are the top salary 



-------------Salary by Company Size

-- Do larger companies pay higher salaries on average?
-- Is there a noticeable salary difference between small, medium, and large companies?

select 
	company_size ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by company_size
order by round(avg(salary)::numeric,2) desc;


-- Larger companies do tend to pay higher salaries on average. 
-- Companies with 1,000 to 4,999 employees offer the highest average salary at $70,042.14, 
-- while smaller companies with 2 to 9 employees pay the lowest at $57,717.66.

-- Salary difference between small, medium, and large companies:
-- Small companies (2 to 99 employees) pay between $57,717.66 and $64,774.57.
-- Medium companies (100 to 4,999 employees) pay between $68,351.11 and $70,042.14.
-- Large companies (5,000+ employees) pay around $68,426.22 to $68,490.03.
-- There is a clear salary increase as company size grows, especially from small to medium companies.


-----------------------Salary by Experience Level

-- How does experience impact salary in the Canadian job market?
-- Is there a significant salary jump after a certain number of years of experience?

select 
	exp ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by exp
order by round(avg(salary)::numeric,2) desc;



-- Experience significantly impacts salary in the Canadian job market.
-- Individuals with 10 or more years of experience earn the highest average salary at $79,365.21, 
-- while those with 0 to 1 years earn the lowest at $38,156.98.

-- Significant salary jump: There is a major salary increase after 5 years of experience. 
-- The jump from 2 to 4 years ($51,588.93) to 5 to 9 years ($64,010.79) is around $12,421.86, 
-- and from 5 to 9 years to 10+ years ($79,365.21) is $15,354.42.
-- Thus, salary grows substantially with experience, particularly after 5 years.


-----------------City-Wise Salary Comparison

select 
	city ,
	round(avg(salary)::numeric,2) as avg_salary,
	PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY salary) AS median
from canada_data
group by city
order by round(avg(salary)::numeric,2) desc;



-- Cities with the highest and lowest average salaries:

-- Highest: Toronto offers the highest average salary at $82,676.04.
-- Lowest: Windsor-Sarnia offers the lowest average salary at $45,596.53.
-- Salary variation between urban and rural areas:

-- Urban areas like Toronto and London have significantly higher average salaries,
-- 	with Toronto leading at $82,676.04.
-- Rural areas or smaller regions like 
-- 	Regina–Moose Mountain and Windsor-Sarnia offer lower salaries, with Windsor-Sarnia at $45,596.53.
-- Salaries tend to be higher in larger urban centers.


