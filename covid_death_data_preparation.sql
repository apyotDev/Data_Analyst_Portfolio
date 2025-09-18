
select location,total_deaths from portfolio_projects..CovidDeaths
where continent is  null 
order by location desc



--Looking for how many percent of Death in Total of Cases (in each row):
--shows likelihood of dying if contract covid your country:
 Select location,new_cases,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_perecentage
,population from portfolio_projects..CovidDeaths
order by 1,2


--Looking at Total case vs Population:
--Shows what percentage of population got covid
Select location,new_cases,date,total_deaths,total_cases,
population,
(total_cases/population)*100 as total_case_population
from portfolio_projects..CovidDeaths
order by 1,2

--Looking at countries with highest infection rate campared to population:
Select location,population,MAX(total_cases) 
as Highestinfectioncount,
MAX((total_cases/population)*100) as percent_population_infected
from portfolio_projects..CovidDeaths
group by location,population
order by percent_population_infected desc

 --Showing Countries with highest Death Count per population:
 Select location, max(cast (total_deaths as int)) as Total_Death_Count
 from  portfolio_projects..CovidDeaths
 where location not in (continent)
 group by location
 order by Total_Death_Count desc


 --SHOWING THE CONTINENT	 WITH THE HIGHEST DEATH COUNT:
select location,max(cast(total_deaths as int)) as total_death_count
from portfolio_projects..CovidDeaths
where continent is  null 
group by location
order by total_death_count desc

--GLOBAL NUMBERS:

Select sum(new_cases) as 
total_cases,sum(cast(new_deaths as int)) as total_deaths,
case
when sum(new_cases)=0 then 0
else Sum(cast(new_deaths as int))/sum(new_cases)*100
end as total_death_percentage
from portfolio_projects..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total population vs Vaccinations:
--looking for total of people who are vaccinated in  the world:

--USING CTE:
with PopvsVacc(Continent,Location,Date,Population,new_vacc,rolling_people_vaccinated)  
as(
Select death.continent, death.location, death.date, death.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by death.location 
order by death.location,death.date) as rolling_people_vacinated 
from portfolio_projects..CovidDeaths death 
join portfolio_projects..CovidVaccinations vac
    on death.location=vac.location and death.date=vac.date
where death.continent is not null 
)
select *, 
case 
when Population=0 then 0
else (rolling_people_vaccinated/Population)*100
end as percentage_people_vaccinated
from PopvsVacc

--TEMP Table:

drop table if exists #percent_people_vaccination
create table #percent_people_vaccination
(Continent nvarchar(50)
,Location varchar(50)
,Date datetime
,Population numeric
,new_vacc numeric
,rolling_people_vaccinated numeric)

insert into #percent_people_vaccination
Select death.continent, death.location, death.date, death.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by death.location 
order by death.location,death.date) as rolling_people_vacinated 
from portfolio_projects..CovidDeaths death 
join portfolio_projects..CovidVaccinations vac
on death.location=vac.location and death.date=vac.date
where death.continent is not null 


select *, 
case 
when Population=0 then 0
else (rolling_people_vaccinated/Population)*100
end as percentage_people_vaccinated
from #percent_people_vaccination


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION:--

--PERCENT_PEOPLE_VACCINATION:
 use portfolio_projects
 go
Create View percent_people_vaccination  as
Select death.continent, death.location, death.date, death.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by death.location 
order by death.location,death.date) as rolling_people_vacinated 
from portfolio_projects..CovidDeaths death 
join portfolio_projects..CovidVaccinations vac
on death.location=vac.location and death.date=vac.date
where death.continent is not null 

--DEATH_PERCENTAGE:
use portfolio_projects
 go
Create View death_percentage  as
Select location,new_cases,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_perecentage
,population from portfolio_projects..CovidDeaths

--TOTAL_CASE_POPULATION(PERCENTAGE):
use portfolio_projects
 go
Create View total_case_population  as
Select location,new_cases,date,total_deaths,total_cases,
population,
(total_cases/population)*100 as total_case_population
from portfolio_projects..CovidDeaths

--COUNTRIES_INFECTION_RATE:
use portfolio_projects
 go
Create View countries_infection_rate as
Select location,population,MAX(total_cases) 
as Highestinfectioncount,
MAX((total_cases/population)*100) as percent_population_infected
from portfolio_projects..CovidDeaths
group by location,population

--COUNTRIES_DEATH_COUNT_PER_POPULATION:
 use portfolio_projects 
 go
 create view countries_death_count_per_population as 
 Select location, max(cast (total_deaths as int)) 
 as Total_Death_Count
 from  portfolio_projects..CovidDeaths
 where location not in (continent)
 group by location

--CONTINENTS_DEATH_COUNT:
use portfolio_projects 
go
Create View continents_case as
select location,max(cast(total_deaths as int))
as total_death_count,
max(total_cases) as total_case

from portfolio_projects..CovidDeaths
where continent is  null 
group by location
