--1- write a query to get number of business days between order_date and ship_date (exclude weekends). 
--Assume that all order date and ship date are on weekdays only

select *,DATEDIFF(day,[order_date],[ship_date]) -
(2*DATEDIFF(WEEK,order_date,ship_date)) as business_days
 from [dbo].[superstore_data]

--2- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
--write a query to find order ids where there is only 1 product bought by the customer.
select order_id,count(product_id) as product_count from superstore_data
group by order_id
having count(product_id)=1

--3- write a query to get total profit, first order date and latest order date for each category
select category,sum(profit) as  total_profit
,min(order_date) as  min_order_date
,max(order_date) as latest_order_date
from superstore_data
GROUP by category

select * from superstore_data

--4- write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category
select sub_category, sum(profit) as total_profit, avg(profit) as avg_profit from superstore_data
group by sub_category
having avg(profit)>0.5*sum(profit)

--5- create the exams table with below script;
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

--write a query to find students who have got same marks in Physics and Chemistry.
select student_id,marks from exams
where subject in ('Physics','Chemistry')
group by student_id,marks
having count(student_id)=2

--6- write a query to find total number of products in each category.
select category,count(distinct product_id) number_of_products from superstore_data
group by category

--7- write a query to find top 5 sub categories in west region by total quantity sold
select top 5 sub_category,sum(quantity) as qty from superstore_data
where region='West'
group by sub_category
order by qty desc

--8- write a query to find total sales for each region and ship mode combination for orders in year 2020
select region,ship_mode,sum(sales) sum_sales from superstore_data
where year(order_date)='2020'
group by region,ship_mode
order by region,ship_mode


--9- write a query to print below 3 columns
--category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)
SELECT category,
sum(case when year(order_date)='2019' then sales end) as  sales_in_year_2019,
sum(case when year(order_date)='2020' then sales end) as  sales_in_year_2020
from superstore_data
group by category

--10- write a query to return first name and last name of a customer in 2 separate columns. Assume everything before first space is first name and rest is second name.
select customer_name, SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name)) as first_name,
trim(SUBSTRING(customer_name,CHARINDEX(' ',customer_name),len(customer_name))) as last_name
 from superstore_data

--11- the order_id column has made up of  following information : county-year-tranid,  eg:US-2021-152898 
--write a query to get total sales by each county
 select SUBSTRING(order_id,1,CHARINDEX('-',order_id)-1) as country,sum(sales) as sales
 from superstore_data
 group by SUBSTRING(order_id,1,CHARINDEX('-',order_id)-1)

--12- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
--write a query to find order ids where there is more than 1 product bought by the customer. 
 select order_id,count(product_id) as product_count from superstore_data
group by order_id
having count(product_id)>1


--13-
--Script:
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
select company_id,count(user_id) from company_users
where language in ('German','English')
group by company_id,user_id,language