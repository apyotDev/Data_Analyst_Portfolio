select * from portfolio_projects..bike_buyers


--looking Average Income based on gender:
--using CTE : 
WITH not_purchased_CTE AS (SELECT 
    Gender,AVG(Income) AS not_purchased_avg_income
    FROM portfolio_projects.dbo.bike_buyers 
    WHERE [Purchased Bike] = 'No'
    GROUP BY Gender 
),
purchased_CTE AS (SELECT 
        Gender,AVG(Income) AS purchased_avg_income
    FROM portfolio_projects.dbo.bike_buyers
    WHERE [Purchased Bike] = 'Yes'
    GROUP BY Gender 
)
SELECT 
    a.Gender,  
    b.purchased_avg_income,
    a.not_purchased_avg_income
FROM not_purchased_CTE a JOIN purchased_CTE b ON a.Gender = b.Gender;


--Looking for  buyer's commute distance :
Select * from portfolio_projects..bike_buyers

--Using CTE:
with  purchased_CTE as
( select [Commute Distance],count([Purchased Bike])
as purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='Yes'
group by [Commute Distance]),
not_purchased_CTE as
( select [Commute Distance],count([Purchased Bike])
as not_purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='No'
group by [Commute Distance])

select a.[Commute Distance],a.purchased_count,
b.not_purchased_count from purchased_CTE a
join not_purchased_CTE b on 
a.[Commute Distance]=b.[Commute Distance]
;

--looking for  Buyers Age Bracket:
--using CTE:
with purchased_CTE as
(  Select [Age Bracket],count([Purchased Bike])
as purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='Yes'
group by [Age Bracket]),
not_purchased_CTE as
(select [Age Bracket],count([Purchased Bike])
as not_purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='No'
group by [Age Bracket])

select b.[Age Bracket],a.purchased_count,
b.not_purchased_count from purchased_CTE a
join not_purchased_CTE b
on b.[Age Bracket]=a.[Age Bracket]

--looking at Highest buyer base on region:
select [Age Bracket],Region,count([Age Bracket]) as count_buyer
from portfolio_projects..bike_buyers
where [Purchased Bike]<>'No'
group by [Age Bracket],Region
order by count_buyer desc
--looking of  what age,region who buys the most:
select Age,Region,count(Age) as count_buyer
from portfolio_projects..bike_buyers
where [Purchased Bike]<>'No'
group by Age,Region
order by count_buyer desc


--Creating views:

-- average income based on Gender:
use portfolio_projects
go 
Create view avg_Income_gender_based as
WITH not_purchased_CTE AS (SELECT 
    Gender,AVG(Income) AS not_purchased_avg_income
    FROM portfolio_projects.dbo.bike_buyers 
    WHERE [Purchased Bike] = 'No'
    GROUP BY Gender 
),
purchased_CTE AS (SELECT 
        Gender,AVG(Income) AS purchased_avg_income
    FROM portfolio_projects.dbo.bike_buyers
    WHERE [Purchased Bike] = 'Yes'
    GROUP BY Gender 
)
SELECT 
    a.Gender,  
    b.purchased_avg_income,
    a.not_purchased_avg_income
FROM not_purchased_CTE a JOIN purchased_CTE b ON a.Gender = b.Gender;

--Commute Distance Buyer:
use portfolio_projects
go
create view commute_distance_buyer as
with  purchased_CTE as
( select [Commute Distance],count([Purchased Bike])
as purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='Yes'
group by [Commute Distance]),
not_purchased_CTE as
( select [Commute Distance],count([Purchased Bike])
as not_purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='No'
group by [Commute Distance])

select a.[Commute Distance],a.purchased_count,
b.not_purchased_count from purchased_CTE a
join not_purchased_CTE b on 
a.[Commute Distance]=b.[Commute Distance]
;

--Buyers Age brcaket:
use portfolio_projects
go
with purchased_CTE as
(  Select [Age Bracket],count([Purchased Bike])
as purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='Yes'
group by [Age Bracket]),
not_purchased_CTE as
(select [Age Bracket],count([Purchased Bike])
as not_purchased_count
from portfolio_projects.dbo.bike_buyers
where [Purchased Bike] ='No'
group by [Age Bracket])

select b.[Age Bracket],a.purchased_count,
b.not_purchased_count from purchased_CTE a
join not_purchased_CTE b
on b.[Age Bracket]=a.[Age Bracket]


--Most Buyer based on Region:
use portfolio_projects
go
create view regional_buyers as
Select Region,count(Region) as count_buyer from 
portfolio_projects..bike_buyers
where [Purchased Bike]='Yes'
group by Region

--Age group Buyers
use portfolio_projects
go
create view MostBuyerRegionAge as
select [Age Bracket],Region,count([Age Bracket]) as count_buyer
from portfolio_projects..bike_buyers
where [Purchased Bike]<>'No'
group by [Age Bracket],Region

