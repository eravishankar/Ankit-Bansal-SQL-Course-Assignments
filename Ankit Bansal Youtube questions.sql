--Complex SQL Query 1 | Derive Points table for ICC tournament
--https://www.youtube.com/watch?v=qyAgWL066Vo&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=1

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

select * from icc_world_cup;

--Solution--

with all_matches as
(
select Team_1 as team_name,
case when Team_1=Winner then 1 else 0 end as win_flag
from icc_world_cup
union all
select Team_2 as team_name,
case when Team_2=Winner then 1 else 0 end as win_flag
from icc_world_cup
)
select team_name,count(win_flag) as matches_played,
sum(win_flag) as matches_won,count(win_flag)-sum(win_flag) as matches_lost
from all_matches
group by team_name

--Complex SQL 2 | find new and repeat customers | SQL Interview Questions
--https://www.youtube.com/watch?v=MpAMjtvarrc&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=2

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;
select * from customer_orders

--Solution---
with first_order_date_table as(
select customer_id,min(order_date) as first_order_date
from customer_orders
group by customer_id)


select order_date, 
sum(case when order_date=first_order_date then 1 else 0 end) as new_customer,
sum(case when order_date!=first_order_date then 1 else 0 end) as repeat_customer,
sum(case when order_date=first_order_date then order_amount else 0 end) as new_customer_amount,
sum(case when order_date!=first_order_date then order_amount else 0 end) as repeat_customer_amount
from customer_orders a
inner join first_order_date_table b on a.customer_id=b.customer_id
group by order_date

---Complex SQL 3 | Scenario based Interviews Question for Product companies---
--https://www.youtube.com/watch?v=P6kNMyqKD0A&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=3

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')

select * from entries

---Solution----

with floor_visit as (
select name,floor as max_floor_visited from (
select *,rank() over (partition by name order by floor_count desc) rn from (
select name,floor,count(floor) as floor_count from entries group by name,floor) a )b where rn=1),

resources as (
select name,count(name) as visit_count, STRING_AGG(resources ,',') as resource_count from entries
group by name),

agg_resources as ( select name, STRING_AGG(resources,',') as resources from ( select distinct name,resources from entries) a group by name )

select a.name,a.visit_count,b.max_floor_visited, c.resources from resources a inner join floor_visit b
on a.name=b.name inner join agg_resources c on c.name=a.name


---SQL Question Asked in a FAANG Interview | Complex SQL 4
--https://www.youtube.com/watch?v=6XQAokp4UCs&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=4

declare @today_date date;
declare @n int;
set @today_date= '2024-07-16';
set @n=3;

--Solution---
select dateadd(week,@n-1, dateadd(day,8-DATEPART(weekday,@today_date),@today_date))


--Complex SQL 5 | Pareto Principle (80/20 Rule) Implementation in SQL | PBC Interview Question
--https://www.youtube.com/watch?v=oGgE180oaTs&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=5

--Superstore Data-- 
with sales_table as (
select product_id,sum(sales) sales_
from Orders
group by product_id),

final_table as (
select *, sum(sales_) over (order by sales_ desc ) as running_sales,
sum(sales_) over () as total_sales
from sales_table)

select *,ROUND(running_sales*100.0/total_sales,2) as percent_
from final_table
order by sales_ desc

--Leetcode Hard Problem | Complex SQL 7 | Trips and Users
--https://www.youtube.com/watch?v=EjzhMv0E_FE&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=7


Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

select * from Trips;

Select * from Users;
--Solution-----
with joined_table as (
select t.* from Trips t
inner join Users cl on t.client_id=cl.users_id
inner join Users dr on t.driver_id=dr.users_id
where cl.banned='No' and dr.banned='No')



select request_at,
round((sum(case when status!='completed' then 1 else 0 end)*100.0/
sum(1)),2) as cancellation_rate
from joined_table
group by request_at

---Leetcode Hard problem 2| Tournament Winners | Complex SQL 8
---https://www.youtube.com/watch?v=IQ4n4n-Y9z8&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=8


create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from matches
select * from players

with combined_table as (
select first_player as player, first_score as score from matches
union all
select second_player as player, second_score as score from matches),

total_score_table as (
select player,group_id,sum(score) as total_score from combined_table a
inner join players b on a.player= b.player_id
group by player,group_id)

select * from (
select *, row_number() over (partition by group_id order by total_score desc ,player asc) as rn from total_score_table) a
where rn=1

--Leetcode Hard Problem 3 | Market Analysis 2 | Complex SQL 9
--https://www.youtube.com/watch?v=1ias-sP_XAY&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=9
create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

 select * from users

 select * from items

 select * from orders

 select seller_id,(case when item_brand=favorite_brand then 'Yes' else 'No' end) as second_item_fav_brand from (

 --Solution--
 with rank_table as(
 select * from(
 select *, ROW_NUMBER() over (partition by seller_id order by order_date asc) rn
 from orders) a where rn=2)

 select 
 u.user_id,(case when item_brand=favorite_brand then 'Yes' else 'No' end) as second_item_fav_brand 
 from
 users u left join rank_table r on r.seller_id=u.user_id
 left join items i on i.item_id=r.item_id


 --An Awesome Tricky SQL Logic | Complex SQL 10--
 --https://www.youtube.com/watch?v=WrToXXN7Jb4&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=10

 create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

--Solution--
with rns as (
select *,DATEADD(DAY,-1* ROW_NUMBER() over (partition by state order by date_value asc),date_value) as rn
from tasks)

select min(date_value) as start_date, max(date_value) as end_date, state
from rns
group by rn,state
order by start_date

--Leetcode Hard Problem 4 | User Purchase Platform | Complex SQL 11
--https://www.youtube.com/watch?v=4MLVfsQEGl0&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=12

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);


--solution--
with all_spends as
(
select spend_date,user_id,max(platform) as platform,sum(amount) as amount from spending
group by user_id,spend_date
having count(distinct platform)=1
union all
select spend_date,user_id,'both' as platform,sum(amount) as amount from spending
group by user_id,spend_date
having count(distinct platform)=2
union all
select  distinct spend_date,null as user_id,'both' as platform, 0 as amount from spending
)

select spend_date,platform,sum(amount) as total_amount, count(distinct user_id) as total_users  from all_spends
group by spend_date,platform
order by spend_date,platform

--Amazon Prime Subscription Rate SQL Logic | Amazon Music | Complex SQL 14
--https://www.youtube.com/watch?v=i_ljK9gmstY&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=14

create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

select * from users

select * from events

--Part Solution---
with first_music_date as (
select user_id, min(access_date) as music_date
from events
where type='Music'
group by user_id ),

first_prime_date as (
select user_id, min(access_date) as prime_date
from events
where type='P'
group by user_id ),

required_users as
(select u.user_id,u.name,u.join_date,a.music_date,b.prime_date, DATEDIFF(day,join_date,prime_date) as date_diff from users u
left join first_music_date a on a.user_id=u.user_id
left join first_prime_date b on b.user_id=u.user_id
where DATEDIFF(day,join_date,prime_date)<30)


--Leetcode Hard SQL Problem - 6 | Second Most Recent Activity | SQL Window Analytical Functions
--https://www.youtube.com/watch?v=RljzVfz8vjk&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=17
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

select * from (
select *,
count(1) over (partition by username) as cnt,
ROW_NUMBER() over (partition by username order by startDate asc) as rn
from UserActivity) a
where cnt=1 or rn=2

--Data Analyst Spotify Case Study | SQL Interview Questions
--https://www.youtube.com/watch?v=-YdAIMjHZrM&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=19
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select * from activity

--1.Find total active users each day

select event_date,count(distinct user_id) as total_active_users from activity
group by event_date

--2.Find total active users each week

select DATEPART(week,event_date) as week_number,count(distinct user_id) as total_active_users from activity
group by DATEPART(week,event_date)

--3. Date wise total number of users who made the purchase the same day they installed the app

select * from activity

WITH count_table as (select event_date, count(distinct event_name) as cnt from activity
group by event_date,user_id)

select event_date, SUM(case when cnt=1 then 0 else 1 end ) as final_cnt from
count_table
group by event_date


--4. Percentage of paid users in India, USA and any other country should be tagged as others
with int_table as (
select case when country in ('India','USA') then country else 'Others' end as country_,user_id from activity
where event_name='app-purchase'
group by country,user_id),

total as ( select count(user_id) as total_users from int_table)


select country_, count(user_id)*100.0/total_users as count_
from int_table,total
group by country_,total_users

--5. Among all users who installed the app on a given day,how many did in app purchased on the very next day- day wise results

with init_table as (
select *,
lag(event_name) over (partition by user_id order by event_date) as prev_event_name,
lag(event_date) over (partition by user_id order by event_date) as prev_event_date
from activity)

select user_id,event_date from init_table
where DATEDIFF(day,prev_event_date,event_date)=1

--How to Write Advance SQL Queries | Consecutive Empty Seats | SQL Interview Questions
--https://www.youtube.com/watch?v=F9Otofceer0&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=20

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');


--Method 1--
select * from(
select *,
lag(is_empty,1) over ( order by seat_no) as prev_1,
lag(is_empty,2) over ( order by seat_no) as prev_2,
lead(is_empty,1) over ( order by seat_no) as next_1,
lead(is_empty,2) over ( order by seat_no) as next_2
from bms) a
where (is_empty='Y' and prev_1='Y' and prev_2='Y')
or (is_empty='Y' and next_1='Y' and next_2='Y')
or (is_empty='Y' and prev_1='Y' and next_1='Y')








