--SQL porfolio project.
--download credit card transactions dataset from below link :
--https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india
--import the dataset in sql server with table name : credit_card_transcations
--change the column names to lower case before importing data to sql server.Also replace space within column names with underscore.
--(alternatively you can use the dataset present in zip file)
--while importing make sure to change the data types of columns. by defualt it shows everything as varchar.

--write 4-6 queries to explore the dataset and solve below questions

--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

select city,sales,cast((sales*100.0/total_sales) as decimal(5,2)) as percentatge from (
SELECT top 5 city,sum(amount) as sales,(select sum(cast(amount as bigint))  from [dbo].[credit_card_transcations (2)]) as total_sales FROM [dbo].[credit_card_transcations (2)]
group by city
order by sales desc
) a;

--2- write a query to print highest spend month and amount spent in that month for each card type

WITH monthly_sales as (
select card_type,DATEPART(year,transaction_date) as year_,DATENAME(month,transaction_date) as month_,sum(amount) as sales

from [dbo].[credit_card_transcations (2)]
group by DATEPART(year,transaction_date),DATENAME(month,transaction_date),card_type
)

select * from (
select *, rank() over (partition by card_type order by sales desc) as rn
from monthly_sales) a
where rn=1;

--3- write a query to print the transaction details(all columns from the table) for each card type when
it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

with running_sum_table as (select *,
sum(amount) over (partition by card_type order by transaction_date,transaction_id asc rows between unbounded preceding and current row) as running_sum

from [dbo].[credit_card_transcations (2)])

select * from (
select *, rank() over (partition by card_type order by running_sum) as rn from running_sum_table
where running_sum>1000000) a
where rn=1;


--4- write a query to find city which had lowest percentage spend for gold card type- Question understood differently

with amount_city as (
select city,sum(amount) as amount_by_city
from [dbo].[credit_card_transcations (2)]
where card_type='Gold'
group by city)

select *,(amount_by_city*100.0)/sum(amount_by_city) over () as percentage_ from amount_city
order by percentage_ asc

with amount_city as (
select city,sum(amount) as amount_by_city,
sum(case when card_type='Gold' then amount else 0 end) as amount_by_city_gold
from [dbo].[credit_card_transcations (2)]
group by city)

select *,(amount_by_city_gold*100.0)/amount_by_city  as percentage_ from amount_city
where amount_by_city_gold>0
order by percentage_ asc

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

with ranking as (
select *,rank() over (partition by city order by sales asc) as least_exp_type,
rank() over (partition by city order by sales desc) as most_exp_type
from (
select city, exp_type, sum(amount) as sales from [dbo].[credit_card_transcations (2)]
group by city, exp_type) a)

select city, max(case when most_exp_type=1 then exp_type end) as highest_expense_type,
max(case when least_exp_type=1 then exp_type end) as lowest_expense_type
from ranking
where most_exp_type=1 or least_exp_type=1
group by city


--6- write a query to find percentage contribution of spends by females for each expense type

select exp_type,sum(amount) as total_sales,sum(case when gender='F' then amount else 0 end) as total_female_sales,
sum(case when gender='F' then amount else 0 end)*100.0/sum(amount) as percentage_spend
from [dbo].[credit_card_transcations (2)] 
group by exp_type
order by percentage_spend

--7- which card and expense type combination saw highest month over month growth in Jan-2014

with cat_sales as(
select card_type,exp_type,
datepart(year,transaction_date) as year_,datepart(month,transaction_date) as month_,
sum(amount) as sales from [dbo].[credit_card_transcations (2)]
group by card_type,exp_type,datepart(year,transaction_date),datepart(month,transaction_date)
),

prev_month_sales as(
select *, lag(sales) over (partition by card_type,exp_type order by year_,month_) as prev_month_sales from cat_sales
)

select top 1 *, (sales-prev_month_sales) as mom_growth from prev_month_sales
where year_=2014 and month_=1
order by mom_growth desc;

--8- during weekends which city has highest total spend to total no of transcations ratio 

select city,sum(amount) as sales,count(transaction_id) as no_of_transactions,
sum(amount)*1.0 /count(transaction_id) as sales_trans_ratio
from [dbo].[credit_card_transcations (2)]
where datepart(weekday,transaction_date) in (1,7)
group by city
order by sales_trans_ratio desc;

--9- which city took least number of days to reach its 500th transaction after the first transaction in that city

with row_n as(
select city,transaction_date,
ROW_NUMBER() over (partition by city order by transaction_date asc) as rn
from [dbo].[credit_card_transcations (2)])

select final_t.city as city, final_t.transaction_date as last_t, start_t.transaction_date as first_t, 
DATEDIFF(day,start_t.transaction_date,final_t.transaction_date) as days_500
from row_n as final_t
inner join  row_n as start_t on start_t.city=final_t.city
where final_t.rn=500 and start_t.rn=1
order by days_500;
