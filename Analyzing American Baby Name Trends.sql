--Let's get oriented to American baby name tastes by looking at the names that have stood the test of time!
select first_name,sum(num)
from baby_names
group by first_name
having count(*)=101
order by sum(num) desc


-- Timeless or trendy?
select first_name,sum(num) ,
       (case when count(year)>80 then 'Classic'
             when count(year)>50 then 'Semi-classic'
             when count(year)>20 then 'Semi-trendy'
             when count(year)>0 then 'Trendy' end) as popularity_type
from baby_names
group by first_name
order by first_name;


-- Top-ranked female names since 1920
select RANK() over(order by sum(num) desc ) as name_rank,first_name,sum(num)
from baby_names
where sex='F'
group by first_name
limit 10;


-- Picking a baby name
select first_name
from baby_names
where sex='F' and year > 2015 and first_name like '%a'
group by first_name
order by sum(num) desc


-- The Olivia expansion
select year,first_name,num,sum(num) over (order by year) as cumulative_olivias
from baby_names
where first_name='Olivia'
order by year 


-- Many males with the same name
SELECT year,max(num) max_num
from baby_names
where sex ='M'
group by year


-- Top male names over the years
select b.year,b.first_name,b.num
from baby_names as b
inner join (SELECT year,max(num) as max_num
            from baby_names
            where sex ='M'
            group by year) as s
ON s.year=b.year and s.max_num=b.num
order by year desc


-- The most years at number one
with sub as (select b.year,b.first_name,b.num
from baby_names as b
inner join (SELECT year,max(num) as max_num
            from baby_names
            where sex ='M'
            group by year) as s
ON s.year=b.year and s.max_num=b.num
order by year desc)

select first_name,count(first_name) as count_top_name
from sub 
group by first_name
order by count(first_name) desc 


