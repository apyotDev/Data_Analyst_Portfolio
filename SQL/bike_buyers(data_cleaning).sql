

select * from portfolio_projects..bike_buyers


--Finding Duplicate Data and Deleting Duplicate Data:
SELECT ID,[Marital Status],Gender,Income,Children,
Occupation,[Home Owner],Cars,[Commute Distance],
Region,Age,[Purchased Bike], COUNT(*) AS DuplicateCount
FROM portfolio_projects..bike_buyers
GROUP BY [Marital Status], Gender,Income,Children,Occupation,[Home Owner],
Cars,[Commute Distance],Region,Age,[Purchased Bike],ID
HAVING COUNT(*) > 1;

--Deleting Data :

--Using CTE:
with bike_buyers_cte as(
Select ID,[Marital Status],Gender,Income,Children,
Occupation,[Home Owner],Cars,[Commute Distance],
Region,Age,[Purchased Bike], ROW_NUMBER() over(partition by
ID,[Marital Status],Gender,Income,Children,
Occupation,[Home Owner],Cars,[Commute Distance],
Region,Age,[Purchased Bike] order by (select null)) as row_num
from portfolio_projects..bike_buyers)

delete from bike_buyers_cte where row_num>1

--Standardizing Data(Marital Status,Gender):
select[Marital Status],Gender from 
portfolio_projects..bike_buyers

--looking In Gender column 
--if there any other value aside from 'F' and 'M'
select Gender ,Count(Gender)as gender_count
from portfolio_projects..bike_buyers
group by Gender

--looking In Marital Status column 
--if there any other value aside from 'S' and 'M':
select [Marital Status] ,Count([Marital Status])
as marital_status_count
from portfolio_projects..bike_buyers
group by [Marital Status] 

--change 'F' and 'M' into 'Female' and 'Male'
--in Gender Column update statement:

update portfolio_projects..bike_buyers
set Gender='Female'
where Gender='F'

update portfolio_projects..bike_buyers
set Gender='Male'
where Gender='M'

select Gender from portfolio_projects..bike_buyers


--change 'S' and 'M' into 'Single' and 'Married'
--in Gender Column update statement:

update portfolio_projects..bike_buyers
set [Marital Status]='Single'
where [Marital Status]='S'

update portfolio_projects..bike_buyers
set [Marital Status]='Married'
where [Marital Status]='M'

select [Marital Status]
from portfolio_projects..bike_buyers



--Setting Age into Age brackets:
--using case statement:


--Looking at minimum and Minimum value:
select  min(Age) as minimum,max(Age) as maximum
from portfolio_projects..bike_buyers

--creating new column for Age bracket and inserting data using case statement 
--and update statement:
alter table portfolio_projects..bike_buyers
add  [Age Bracket] nvarchar(255)



update portfolio_projects..bike_buyers
set [Age Bracket]=case 
when Age<31 then 'Adolescent(0-30 years old)'
when Age>=31 and Age<55 then 'Middle Age(31-54 years old)'
when Age>=55 then 'old(55+ years old)'
else 'Invalid'
end

select * from portfolio_projects..bike_buyers