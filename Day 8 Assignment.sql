--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.


--1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
--In case a department has less than 3 employees then print the details of highest salaried employee in that department.

with rnk as (
select *, dense_rank() over(partition by dept_id order by salary desc) as rn
from employee)
,cnt as (select dept_id,count(1) as no_of_emp from employee group by dept_id)
select
rnk.*
from 
rnk 
inner join cnt on rnk.dept_id=cnt.dept_id
where rn=3 or  (no_of_emp<3 and rn=1) 

--2- write a query to find top 3 and bottom 3 products by sales in each region.

with rank_product as (
select product_id,region,sum(sales) as sales,
rank() over (partition by region order by sum(sales) desc) as rn_desc,
rank() over (partition by region order by sum(sales) asc) as rn_asc

from Orders
group by product_id,region)

select product_id,region, sales from rank_product where rn_desc<=3 or rn_asc<=3

--3- Among all the sub categories. Which sub category had highest month over month growth by sales in Jan 2020 compare to dec 2019.

with sales_data as (
select sub_category,
DATEPART(month, order_date) as month_ ,
DATEPART(year, order_date) as year_ , 
sum(sales) as sales
from Orders
group by sub_category,DATEPART(month, order_date),DATEPART(year, order_date)
),
prev_sales_data as (
select *,
lag(sales) over (partition by sub_category order by year_,month_  asc) as prev_month_sales
from sales_data 

)

select top 1 *,(sales-prev_month_sales)*100.0/prev_month_sales mom_growth from prev_sales_data

where year_=2020 and month_=1

order by mom_growth desc;

--4- write a query to print top 3 products in each category by year over year sales growth in year 2020 compare to 2019.

with sales_data as (
select category,product_id,DATEPART(year,order_date) as year_, sum(sales) as sales_
from Orders
group by category,product_id,DATEPART(year,order_date)
--order by category,product_id,year_ asc
),

prev_year_data as(
select *,lag(sales_) over (partition by category order by year_ asc) as prev_year_sales
from sales_data ),

yoy as (
select *,(sales_-prev_year_sales)*100.0/prev_year_sales as yoy_growth
from prev_year_data
where year_=2020),

rank_no as(
select * 
,rank() over (partition by category order by yoy_growth desc) rn 
from yoy)

select * from rank_no where rn<=3;



--5- create below 2 tables 

create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;

--write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.Please do take into account that there will be
--multiple calls from one phone number and each entry in start table has a corresponding entry in end table.



--solve below questions. You can write SQLs and verify on the platform itself.

--Note : The platform supports only postgreSQL so there may be few diffrences in functions. Listing down some important diffrences:

--SQL server -> postgreSQL
--to extract a part of the date
--datepart(day,order_date) -> extract (day from order_date)

--to convert datetime/timestamp field to date or any other type of type casting 
--cast(order_date as date) -> order_date::date


--6-https://datalemur.com/questions/top-fans-rank

with top_10_cte as (SELECT a.artist_name,
DENSE_RANK() OVER (ORDER BY count(s.song_id) desc) as artist_rank
FROM artists a
inner join songs s 
on a.artist_id=s.artist_id
inner join global_song_rank gs
on s.song_id=gs.song_id
where gs.rank<=10
group by 1)

select * from top_10_cte where artist_rank<=5


--7-https://datalemur.com/questions/sql-highest-grossing

with rank_cte as 
(SELECT category, product,sum(spend) as total_spend,
rank() over (partition by category order by sum(spend) desc) as rank_items
FROM product_spend
where EXTRACT(year from transaction_date)=2022
group by category,product
order by category)

select category, product, total_spend FROM
rank_cte
where rank_items<=2
;

--8-https://datalemur.com/questions/top-drugs-sold

with cte_rank as (select manufacturer,drug,
rank() over (PARTITION BY manufacturer order by sum(units_sold) desc) as rn
from pharmacy_sales
group by 1,2)

select manufacturer,drug from cte_rank
where rn<=2


--9-https://datalemur.com/questions/yoy-growth-rate

with spends as (SELECT EXTRACT(year from transaction_date) as year,
product_id,
(spend) as curr_year_spend,
lag(spend) over( PARTITION BY product_id
order by EXTRACT(year from transaction_date) asc
) as prev_year_spend

FROM user_transactions
ORDER BY product_id,year)

select *,ROUND((curr_year_spend-prev_year_spend)*100.0/prev_year_spend,2)
from spends
;


--10-https://datalemur.com/questions/long-calls-growth

with counts as (select extract(year from call_date) as year,
extract(month from call_date) as month,
count(case_id) as curr_month_count
from callers
where call_duration_secs>300
group by 1,2
order by month asc),

prev_month_counts as(
select *, lag(curr_month_count) over (ORDER BY year) as last_month_count
from counts)

SELECT year,month,round(((curr_month_count-last_month_count)*100.0/last_month_count),1) as long_calls_growth_pct
from prev_month_counts

