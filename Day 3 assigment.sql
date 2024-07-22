--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

--Super Store Data
--1- write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

select * from superstore_data
where customer_name like '_a_d%'

--2- write a sql to get all the orders placed in the month of dec 2020 (352 rows) 

select * from superstore_data
where year(order_date)=2020 and MONTH(order_date)=12

--3- write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

where ship_mode not in ('Standard Class','First Class')
and ship_date>='2020-12-01'

--4- write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

select * from superstore_data
where customer_name not like 'A%n'

--5- write a query to get all the orders where profit is negative (1871 rows)

select * from superstore_data
where profit<0


--6- write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

select * from superstore_data
where quantity<3 or profit=0

--7- your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

select * from superstore_data
where region='South' and discount>0

--8- write a query to find top 5 orders with highest sales in furniture category 

select top 5 * from superstore_data
where category='Furniture'
order by sales DESC

--9- write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

select * from superstore_data
where category in ('Furniture','Technology')
and year(order_date)=2020

--10-write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

select * from superstore_data
where year(ship_date)=2021
and year(order_date)=2020

--11- write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

update superstore_data set city = null
where order_id in ('CA-2020-161389' , 'US-2021-156909')

--12- write a query to find orders where city is null (2 rows)

select * from superstore_data
where city is null

--13- write a query to create new column to categories orders in 4 category :

sales < 100  -> low value orders
sales < 200 --> medium value orders
profit <400 --> high value orders
profit >= 400  --> very hIgh value orders

select *, 
case when sales<100 then 'Low Value Orders'
when sales<200 then 'Medium Value Orders'
when sales<400 then 'High Value Orders'
when sales>= 400 then 'Very High Value Orders'
end
from superstore_data
 