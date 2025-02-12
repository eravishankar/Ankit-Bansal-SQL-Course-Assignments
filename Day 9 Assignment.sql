--At this point you should be able to solve all the questions on https://datalemur.com/questions
--please try all of the free problems available .


--some more questions:

--1- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

with sales_table as (
SELECT category,product_id, DATEPART(year,order_date) as year_, DATEPART(month,order_date) as month_, sum(sales) as sales

 from orders
group by category,product_id,DATEPART(year,order_date),DATEPART(month,order_date)

),
rolling_sales as(
select *,sum(sales) over (partition by category,product_id order by year_  ,month_ rows between 2 preceding and current row) as rl_sales

 from sales_table
where year_=2020 and month_=1
),

rank_table as (
select *,rank() over (partition by category order by rl_sales desc) as rn from rolling_sales)

select * from rank_table where rn<=3;

--2- write a query to find products for which month over month sales has never declined.


with sales_table as (
select product_id, DATEPART(year,order_date) as year_,DATEPART(month,order_date) as month_, sum(sales) as sales_

from Orders
group by  product_id, DATEPART(year,order_date) ,DATEPART(month,order_date) ),

prev_sales as(
select *,
lag(sales_,1,0) over (partition by product_id order by year_, month_) as prev_month_sales
from sales_table)

select distinct product_id from prev_sales
where sales_>prev_month_sales

--3- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.

with xxx as (select category,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by category,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,sum(sales) over(partition by category order by yo,mo rows between 2 preceding and 1 preceding ) as prev2_sales
from xxx)
select * from yyyy where  sales>prev2_sales
