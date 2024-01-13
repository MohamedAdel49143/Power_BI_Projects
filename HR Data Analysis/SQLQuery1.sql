
-- create database
CREATE DATABASE [HR Data]

use [HR Data]

SELECT *
FROM [dbo].[Hr_Data];



-- Update date/time to date
UPDATE [dbo].[Hr_Data]
SET termdate = FORMAT(CONVERT(DATETIME, LEFT(termdate, 19), 120), 'yyyy-MM-dd');

-- Update from nvachar to date
-- First, add a new date column
ALTER TABLE [dbo].[Hr_Data]
ADD new_termdate DATE;



-- Update the new date column with the converted values

UPDATE[dbo].[Hr_Data]
SET new_termdate = CASE
    WHEN termdate IS NOT NULL AND ISDATE(termdate) = 1
        THEN CAST(termdate AS DATETIME)
        ELSE NULL
    END;

select termdate,new_termdate
from [dbo].[Hr_Data]




--create a new column "age"

Alter table [dbo].[Hr_Data]
add age varchar(40);
--populate new column with age
update [dbo].[Hr_Data]
set age = DATEDIFF(YEAR,birthdate,GETDATE());

select age
from [dbo].[Hr_Data]

--Questions to answer from the data
--1) what's the age distribution in the company?
---Age distribution
	select
	MIN(age) as Youngest,
	Max(age) as Oldest
	from [dbo].[Hr_Data]
--age group
	select age_group,COUNT(*) as count
from(
	select case WHEN age <= 21 THEN '21 to 30'
				WHEN age <= 30 THEN '21 to 30'
				WHEN age <= 31 THEN '31 to 40'
				WHEN age <= 40 THEN '31 to 40'
				WHEN age <= 41 THEN '41 to 50'
				WHEN age <= 50 THEN '41 to 50'
				ELSE '50+'
	 end as age_group
	from [dbo].[Hr_Data]
	where New_termdate Is null
) as subquery
group by age_group
order by age_group;

--Age Group by Gender
select age_group,gender,COUNT(*) as count
from(
	select case WHEN age <= 21 THEN '21 to 30'
				WHEN age <= 30 THEN '21 to 30'
				WHEN age <= 31 THEN '31 to 40'
				WHEN age <= 40 THEN '31 to 40'
				WHEN age <= 41 THEN '41 to 50'
				WHEN age <= 50 THEN '41 to 50'
				ELSE '50+'
	 end as age_group,gender
	from [dbo].[Hr_Data]
	where New_termdate Is null
) as subquery
group by age_group,gender
order by age_group,gender;

--2) what's the gender breakdown in the company?
select gender,count(gender) as Count
from [Hr_Data]
where new_termdate is null
group by gender
order by gender asc;
--3) How does gender vary across departments and job titles?
select department,gender, count(gender) as Count
from [dbo].[Hr_Data]
where termdate is null
group by department,gender
order by  department,gender asc

--jobtitles
select department,jobtitle,gender, count(gender) as Count
from [dbo].[Hr_Data]
where termdate is null
group by department,jobtitle,gender
order by  department,jobtitle,gender asc

--4)what's the race distribution in the company?
select race,COUNT(*) as Count
from [dbo].[Hr_Data]
where new_termdate is null
group by race
order by count desc

--5)what's the average length of employment in the company?
select Avg(DATEDIFF( year,hire_date,new_termdate)) as tenure
from [dbo].[Hr_Data]
where new_termdate is not null and new_termdate <= getdate()

--6) which department has the highest turnover rate ?
--get total count 
--get terminated count
--terminated count/total count
select department,Total_employees,Terminated_count,round((cast(Terminated_count as float)/Total_employees),2) as Turnover_rate
from
	(
	select department,COUNT(*) as Total_employees,
			sum(case when new_termdate is not null and new_termdate <= GETDATE() then 1
				 else 0
			end) as Terminated_count
	from [dbo].[Hr_Data]
	group by department
	) as subquery
order by Turnover_rate desc;

--7)what is the tenure distribution for each department?
--ãÊæÓØ ãÏÉ ÇáÎÏãå áßá ÞÓã
--íÚäì ãÚÙã ÇáãæÙÝíä áÇ ÊÞá ÎÏãÊå ááÞÓã Úä ËãÇäíÉ Óäííä
select department,avg(DATEDIFF(year,hire_date,new_termdate)) as Tenure
from [dbo].[Hr_Data]
where new_termdate is not null and new_termdate <= getdate()
group by department

--min(hire_date)  Ãæá æÇÍÏ ÃäÖã ááÔÑßå
--max(new_termdate) ÇÎÑ æÇÍÏ ÇäÖã ááÔÑßå
--æÈÇáÊÇáì ÊÞÏÑ ÊÍÓÈ ÚãÑ ÇáÞÓã Çæ ÇáÔÑßå 

select department,DATEDIFF(year,min(hire_date),max(new_termdate)) as Tenure
from [dbo].[Hr_Data]
where new_termdate is not null and new_termdate <= getdate()
group by department
order by Tenure desc;




--8) how many employees work remotely for each department?
select department,count(location) as Total_employees
from [dbo].[Hr_Data]
where location = 'Remote' and new_termdate is null
group by department
order by Total_employees desc

select location,COUNT(location)
from [dbo].[Hr_Data]
where new_termdate is null
group by location

--9) what's the distribution of employees across different states?
select location_state,count(*) as Total_Employees
from [dbo].[Hr_Data]
where new_termdate is null
group by location_state
order by Total_Employees desc;

--10) How are jobtitles distributed in the company?ßíÝ ÊæÒÚÊ ÇáãÓãíÇÊ ÇáæÙíÝíå Ýì ÇáÔÑßå¿
select jobtitle, count(*) as Total_jobtitle
from [dbo].[Hr_Data]
where new_termdate is null
group by jobtitle
order by Total_jobtitle desc;

-- 11)How have employee hire counts varied over time?ßíÝ ßÇäÊ ÇÚÏÇÏ ÇáãæÙÝíä ãÚ ãÑæÑ ÇáæÞÊ¿
-- calculate hire
-- calculate terminations
-- (hires-terminations)/hires percent hire change
select Hire_year,
	   hires,
	   Terminations, 
	   hires - Terminations as net_change,
	   round(cast(hires - Terminations as float)/hires,2) as percent_hire_change
from(
		select year(hire_date) as Hire_year,COUNT(*) as hires,
			   sum(case when new_termdate is not null and new_termdate <= getdate() then 1 else 0 end) as Terminations
		from [dbo].[Hr_Data]
		GROUP By  year(hire_date)
) as Subquery
order by Hire_year asc























