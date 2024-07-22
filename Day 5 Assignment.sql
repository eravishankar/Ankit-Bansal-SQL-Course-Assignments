--Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

--1- write a query to get region wise count of return orders

select o.region,count(distinct(o.order_id)) from return_data r
left JOIN superstore_data o
on r.order_id=o.order_id
group by o.region

--2- write a query to get category wise sales of orders that were not returned

select
o.category,sum(sales) as total_sales 
from superstore_data o
left join return_data r 
on o.order_id = r.order_id
where r.order_id is null
group by o.category
	

--3- write a query to print dep name and average salary of employees in that dep .

select d.dep_name,AVG(e.salary) as avg_sal
from employee e
inner join dept d
on e.dept_id = d.dep_id
group by d.dep_name

--4- write a query to print dep names where none of the emplyees have same salary.

select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)

---5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

select (o.sub_category)
from superstore_data o
inner join return_data r
on o.order_id = r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3


--6- write a query to find cities where not even a single order was returned.

select city,count( distinct r.order_id) returned_orders
from superstore_data o
left join return_data r
on o.order_id = r.order_id
group by city
having count( distinct r.order_id)=0

--7- write a query to find top 3 subcategories by sales of returned orders in east region

select top 3 sub_category,sum(sales) as sales
from superstore_data o
inner join return_data r on o.order_id=r.order_id
where region='East'
group by sub_category
order by sales desc

--8- write a query to print dep name for which there is no employee

select dep_name
from employee e
full join dept d on e.dept_id=d.dep_id
where emp_id is null

--9- write a query to print employees name where dep id is not avaiable in dept table

select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
where e.dept_id is null


--10-write a query to print emp name , their manager name and diffrence in their age for employees whose age is less then their manager's age 

select e.emp_name as employee_name,
m.emp_name as manager_name,
m.emp_age-e.emp_age as age_diff
from employee e
join employee m on
e.manager_id=m.emp_id
where m.emp_age-e.emp_age>0

--11-write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

select e.emp_name as employee_name,
m.emp_name as manager_name,
sm.emp_name as senior_manager_name
from employee e
join employee m on
e.manager_id=m.emp_id
join employee sm on 
m.manager_id=sm.emp_id
