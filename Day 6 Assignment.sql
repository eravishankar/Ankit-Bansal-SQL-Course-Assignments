--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

--1- Run below table script to create icc_world_cup table:

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

 --write a query to produce below output from icc_world_cup table.
--team_name, no_of_matches_played , no_of_wins , no_of_losses
--India, 2, 2, 0

with all_matches as (
select Team_1 as team_name
, case when Team_1=winner then 1 else 0 end as win_flag
from icc_world_cup 
union all
select Team_2
, case when Team_2=winner then 1 else 0 end as win_flag
from icc_world_cup)
select team_name, count(*) as no_of_matches_played, sum(win_flag) as no_of_wins
, count(*) - sum(win_flag) as no_of_losses
from all_matches
group by team_name;


--2- Run below script to create drivers table:

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

--write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver

--id, total_rides , profit_rides
--dri_1,5,1
--dri_2,2,0

select --d1.*, d2.* 
d1.id , count(*) as total_rides , count(d2.id) as profit_ride
from drivers d1
left join drivers d2 on d1.start_loc=d2.end_loc and d1.start_time=d2.end_time
group by d1.id

--3-write a query to print below output from orders data. example output
--hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
--category , Technology, ,
--category, Furniture, ,
--category, Office Supplies, ,
--sub_category, Art , ,
--sub_category, Furnishings, ,
--and so on all the category ,subcategory and ship_mode hierarchies 

select 'category' as hierarchy_type, category as hierarchy_name , sum(case when region='West' then sales end) as total_sales_in_west_region
,sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by category
union all
select 'sub_category' as hierarchy_type, sub_category as hierarchy_name , sum(case when region='West' then sales end) as total_sales_in_west_region
,sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by sub_category


--4-write a query to print customer name and no of occurence of character 'n' in the customer name.
--customer_name , count_of_occurence_of_n


SELECT customer_name, LENGTH(customer_name) - LENGTH(REPLACE(customer_name, 'n', '')) AS count_of_occurrence_of_n
FROM orders;

--5- Run the following command to add and update dob column in employee table
alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate())

--write a query to print emp name , their manager name and diffrence in their age (in days) 
--for employees whose year of birth is before their managers year of birth

SELECT e1.emp_name AS emp_name,
       e1.year_of_birth AS emp_birth_year,
       e2.emp_name AS manager_name,
       e2.year_of_birth AS manager_birth_year,
       ,e1.emp_age=e2.emp_age AS age_difference_in_days
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.year_of_birth < e2.year_of_birth;

--6- write a query to find premium customers from orders data. Premium customers are those who have done more no of orders than average no of orders per customer.

with cte as (
select customer_name , count(distinct order_id) as no_of_orders
from orders
group by customer_name)
select * from cte where no_of_orders > (select avg(no_of_orders) from cte)
order by no_of_orders;


--7- write a query to print emp name, salary and dep id of highest salaried employee in each department 

SELECT e1.emp_name, e1.salary, e1.dept_id
FROM employee e1
JOIN (
    SELECT dep_id, MAX(salary) AS max_salary
    FROM employee
    GROUP BY dept_id
) e2 ON e1.dept_id = e2.dept_id AND e1.salary = e2.max_salary;

--8- write a query to print product id and total sales of highest selling product (by no of units sold) in each category

with cte as (
select category, product_id , sum(quantity) as no_of_units, sum(sales) as total_sales
from orders
group by category, product_id )
, cte1 as (select category, max(no_of_units) as max_units
from cte
group by category)
select cte.*
from cte 
inner join cte1 on cte.category=cte1.category and cte.no_of_units=cte1.max_units


--9- write a query to find employees whose salary is more than average salary of employees in their department

select e.*,d.*
from
employee e
inner join (select dept_id,avg(salary) as avg_salary
from employee
group by dept_id) d on e.dept_id=d.dept_id 
where e.salary>d.avg_salary


--10- Script:
create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

--write a sql to find company id who have atleast 2 users speaks English and German both 


select company_id from 
(
SELECT company_id,user_id
FROM company_users
WHERE language IN ('English', 'German')
GROUP BY company_id,user_id
HAVING COUNT(DISTINCT language) = 2
) A
having count(distinct user_id)>=2;



============================================================================

--login on https://datalemur.com/questions 

--username : sql.namaste@gmail.com
--password : Namastesql22

--solve below questions. You can write SQLs and verify on the platform itself.

--Since these are common credentials . If you already see any solution written, please remove it and try to write your query.

--Note : The platform supports only postgreSQL so there may be few diffrences in functions. Listing down some important diffrences:

--SQL server -> postgreSQL
--to extract a part of the date
--datepart(day,order_date) -> extract (day from order_date)

--to convert datetime/timestamp field to date or any other type of type casting 
--cast(order_date as date) -> order_date::date

--1- https://datalemur.com/questions/matching-skills

SELECT candidate_id FROM candidates
where skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
having count(candidate_id)=3

--2- https://datalemur.com/questions/sql-page-with-no-likes

SELECT p.page_id FROM pages p
left join page_likes pl
on p.page_id=pl.page_id
where liked_date is null
ORDER BY p.page_id asc;

--3- https://datalemur.com/questions/tesla-unfinished-parts

SELECT part, assembly_step FROM parts_assembly
where finish_date is null
;

--4- https://datalemur.com/questions/laptop-mobile-viewership

SELECT 
sum(case when device_type ='laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type in ('tablet','phone') then 1 else 0 end) as mobile_views
FROM viewership;

--5- https://datalemur.com/questions/sql-average-post-hiatus-1

SELECT user_id, extract(days from max( post_date) -
min( post_date)) as date_diff
FROM posts
WHERE EXTRACT(year from post_date)=2021
group by user_id
having count(user_id)>1
;

--6- https://datalemur.com/questions/teams-power-users

SELECT sender_id, count(sender_id)
FROM messages
where EXTRACT(year from sent_date)=2022 and EXTRACT(month from sent_date)=8
group by sender_id
order by count DESC
limit 2
;

--7- https://datalemur.com/questions/completed-trades

SELECT u.city,count(t.order_id) counts FROM trades t
inner join users u on 
t.user_id=u.user_id
where t.status='Completed'
group by u.city
order by counts desc
limit 3
;

--8- https://datalemur.com/questions/sql-avg-review-ratings

SELECT extract(month from submit_date) as month,
product_id,ROUND(avg(stars),2)
FROM reviews
group by 1,2
order by 1,2
;

--9- https://datalemur.com/questions/click-through-rate

with metrics as 
(select app_id,
SUM(case when event_type = 'impression' then 1 else 0 end) as impressions,
SUM(case when event_type = 'click' then 1 else 0 end) as clicks
from events
where extract(year from timestamp)=2022
GROUP BY app_id

)
select app_id, round(((100.0*clicks)/impressions),2) as ctr from metrics

--10-https://datalemur.com/questions/second-day-confirmation

SELECT user_id FROM emails e
inner join texts t ON
e.email_id=t.email_id
where signup_action='Confirmed'
and EXTRACT(days from action_date-signup_date)=1
;