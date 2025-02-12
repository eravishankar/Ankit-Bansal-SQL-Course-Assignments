There are 2 csv files present in this zip file. The data contains 120 years of olympics history. There are 2 daatsets 
1- athletes : it has information about all the players participated in olympics
2- athlete_events : it has information about all the events happened over the year.(athlete id refers to the id column in athlete table)

--import these datasets in sql server and solve below problems:

--1 which team has won the maximum gold medals over the years.

with joined_table as (
select  * from [dbo].[athlete_events]
inner join athletes on athlete_events.athlete_id=athletes.id)

select top 1 team,count(distinct event) as gold_medals from joined_table
where medal='Gold'
group by team
order by gold_medals desc

--2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver- Answer mismatch

with joined_table as (
select  * from [dbo].[athlete_events]
inner join athletes on athlete_events.athlete_id=athletes.id),

silver_medals as(
select team,count(distinct event) as silver_medals
from joined_table
where medal='Silver'
group by team),

max_silver_medals as(
select team,year, row_number() over (partition by team order by silver_medals desc) as rank_ from (
select team,year,count(distinct event) as silver_medals  from joined_table
where medal='Silver'
group by team,year) a)

select max_sil.team,max_sil.year,sil.silver_medals from max_silver_medals max_sil
inner join silver_medals sil on max_sil.team=sil.team
where max_sil.rank_=1;

with cte as(select a.team,ae.year , count(distinct event) as silver_medals
,rank() over(partition by team order by count(distinct event) desc) as rn
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal='Silver'
group by a.team,ae.year)
select team,sum(silver_medals) as total_silver_medals, max(case when rn=1 then year end) as  year_of_max_silver
from cte
group by team;

--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years

with gold_only as(
select * from [dbo].[athlete_events]
where medal not in ('NA') and medal = 'Gold'),

count_gsb as(
select athlete_id,count(distinct medal) as count_gsb from dbo.athlete_events
where medal not in ('NA') 
group by athlete_id)

select athletes.name from (
select top 1 gold_only.athlete_id,count(gold_only.athlete_id) as no_of_gold_medals from count_gsb
inner join gold_only on gold_only.athlete_id=count_gsb.athlete_id
where count_gsb.count_gsb=1
group by gold_only.athlete_id
order by no_of_gold_medals desc) a
inner join [dbo].[athletes] on a.athlete_id=athletes.id

--4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.

with gold_medals as (select year,athlete_id,count(distinct event) gold_medals from [dbo].[athlete_events]
where medal='Gold'
group by year,athlete_id),

rank_ as (
select *, dense_rank() over (partition by year order by gold_medals desc) rn from 
gold_medals) 

select year,gold_medals, STRING_AGG(name,',') from rank_ 
inner join [dbo].[athletes] on rank_.athlete_id=athletes.id
where rn=1
group by year,gold_medals
order by year;

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport

select distinct * from (
select medal,event,year,sport,RANK() over (partition by medal order by year asc) rn
from [dbo].[athlete_events] a
inner join [dbo].[athletes] b on a.athlete_id=b.id
where b.team='India' and medal not in ('NA')) a
where rn=1


--6 find players who won gold medal in summer and winter olympics both.

select a.name  
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal='Gold'
group by a.name having count(distinct season)=2

--My first attempt

with medals as (
select athlete_id,season, count(distinct event) medals from [dbo].[athlete_events]
where medal not in ('NA') and medal ='Gold'
group by athlete_id,season)

select athletes.name from (
select athlete_id, count(distinct season) count_sw from medals
group by athlete_id 
having count(distinct season)>1) a
inner join [dbo].[athletes] on a.athlete_id=athletes.id

--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.

select a.name,year
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where medal not in ('NA') 
group by a.name ,year
having count(distinct medal)=3

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.

with cte as (
select name,year,event
from athlete_events ae
inner join athletes a on ae.athlete_id=a.id
where year >=2000 and season='Summer'and medal = 'Gold'
group by name,year,event)
select * from
(select *, lag(year,1) over(partition by name,event order by year ) as prev_year
, lead(year,1) over(partition by name,event order by year ) as next_year
from cte) A
where year=prev_year+4 and year=next_year-4






