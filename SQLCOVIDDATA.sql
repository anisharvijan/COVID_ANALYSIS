/* 
COVID-19 DATA EXPLORATION
Skills Used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

-- Select data to be used 

Select location,date, total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

 -- Total Cases vs Total Deaths
 -- can predict ones likelihood of dying if u contract covid in the given country

 Select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
--where location like '%canada%'
order by 1,2

-- Total cases vs population 
-- what percentage of population got covid 

Select location,date,Population,total_cases ,(total_cases/population)*100 as PopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%canada%'
order by 1,2 

-- Countries with Highest Infection Rate compared to Population

Select location,Population,MAX(total_cases) AS HighestinfectionCount ,MAX((total_cases/population)*100) as PopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%canada%'
group by location,population
order by 4 desc

-- Showing Countries with Highest Death count per population 

Select location,Population,MAX(cast(total_deaths as bigint)) AS TotalDeathCount 
From PortfolioProject..CovidDeaths
--where location like '%canada%'
where continent is not null
group by location,population
order by 3 desc 

-- BY CONTINENT 
-- continents with highest death count

Select continent, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%canada%'
Where continent is not null 
Group by continent
order by 2 desc

--Total Covid cases by Countries (America) Highest to Lowest

SELECT location, population, SUM(total_cases)  TotalCasepercountry
FROM PortfolioProject..CovidDeaths
WHERE continent like '%states%'
AND continent IS NOT NULL
GROUP BY location, population
order by TotalCasepercountry DESC



--SHOWS TOP 10 Asia countries with Highest Number of Covid Cases

SELECT TOP 10 location, population, SUM(total_cases)  TotalCasepercountry
FROM PortfolioProject..CovidDeaths
WHERE continent like '%asia%'
AND continent IS NOT NULL
GROUP BY location, population
order by TotalCasepercountry DESC



--SHOWS COUNTRIES WITH THE HIGHEST INFECTION RATE Vs POPULATION IN Asia

SELECT location, population, MAX(total_cases)  HighestInfectioncount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent like '%Asia%'
AND continent IS NOT NULL
GROUP BY location, population
order by PercPopulationInfected DESC



--SHOWS TOP 10 COUNTRIES WITH THE HIGHEST INFECTION RATE Vs POPULATION IN Asia

SELECT TOP 10 location, population, MAX(total_cases)  HighestInfectioncount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent like '%Asia%'
AND continent IS NOT NULL
GROUP BY location, population
order by PercPopulationInfected DESC

-SHOWS COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION (GLOBAL)

SELECT location, MAX(cast(total_deaths as int)) as HighestDeathCount, ROUND(MAX(total_deaths/population)* 100,3) AS PercPopulationDeath
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
Group by location
ORDER BY PercPopulationDeath DESC



--SHOWS COUNTRIES WITH HIGHEST DEATH COUNT IN Asia

SELECT location, MAX(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent = '%Asia%'
AND continent IS NOT NULL
Group by location
ORDER BY HighestDeathCount DESC



--SHOWS COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION IN Asia

SELECT location, MAX(cast(total_deaths as int)) as HighestDeathCount, ROUND(MAX(total_deaths/population)* 100,3) AS PercPopulationDeath
FROM PortfolioProject..CovidDeaths
WHERE continent = '%Asia%'
AND continent IS NOT NULL
Group by location
ORDER BY PercPopulationDeath DESC



--LET'S BREAK THINGS DOWN BY CONTINENT

--Shows highest death counts by continent

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCountbyContinent                
From Project..CovidDeath$
Where continent is not null 
Group by continent
order by TotalDeathCountbyContinent desc



--Shows Highest Infection Count By Continent      

Select continent, MAX(total_cases) as TotalInfectionCountbyContinent
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalInfectionCountbyContinent desc




--Global Numbers
 Select date,SUM(new_cases) as total_newcases, SUM(cast(new_deaths as bigint)) as total_newdeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentageglobal
From PortfolioProject..CovidDeaths
--Where location like '%canda%'
where continent is not null 
Group By date
order by 1,2 
 
 -- total 
 Select SUM(new_cases) as total_newcases, SUM(cast(new_deaths as bigint)) as total_newdeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentageglobal
From PortfolioProject..CovidDeaths
--Where location like '%canda%'
where continent is not null 
order by 1,2 

--LOOKING AT TOTAL POPPULATION VS VACINATION


SELECT DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
SUM(cast(VAC.new_vaccinations as bigint))over (Partition by DEA.location Order by DEA.location, DEA.date) as Rollingpeoplevaciinated
FROM PortfolioProject..CovidDeaths DEA
JOIN  PortfolioProject..CovidVaccinations VAC
 ON DEA.location = VAC.location
 AND DEA.date= VAC.date
 where DEA.continent IS NOT NULL
 ORDER BY 2,3

 --CTE 
 With POPvsVAC (Continent,location,date,population,new_vaccinations,Rollingpeoplevacinated) 
 as( 
  SELECT DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
SUM(cast(VAC.new_vaccinations as bigint))over (Partition by DEA.location Order by DEA.location, DEA.date) as Rollingpeoplevacinated
FROM PortfolioProject..CovidDeaths DEA
JOIN  PortfolioProject..CovidVaccinations VAC
 ON DEA.location = VAC.location
 AND DEA.date= VAC.date
 where DEA.continent IS NOT NULL
 
 )
 Select * , (Rollingpeoplevacinated/population)*100 AS POPVSVACC
 from POPvsVAC

 --Temp Table
 DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATEDS
 CREATE TABLE #PERECENTPOPPULATIONVACCINATEDS
 (continent nvarchar(255), location nvarchar (255), date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)

 INSERT INTO #PERECENTPOPPULATIONVACCINATEDS
 SELECT DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
SUM(cast(VAC.new_vaccinations as bigint))over (Partition by DEA.location Order by DEA.location, DEA.date) as Rollingpeoplevacinated
FROM PortfolioProject..CovidDeaths DEA
JOIN  PortfolioProject..CovidVaccinations VAC
 ON DEA.location = VAC.location
 AND DEA.date= VAC.date
 where DEA.continent IS NOT NULL
 Select *, (RollingPeopleVaccinated/population)*100 as percentage_populationvaccinated
 From #PERECENTPOPPULATIONVACCINATEDS


 --Creating View to Store data for Visualization 

 Create View PERCENTPOPULATIONVACCINATED AS 
 SELECT DEA.continent,DEA.location,DEA.date,DEA.population,VAC.new_vaccinations,
SUM(cast(VAC.new_vaccinations as bigint))over (Partition by DEA.location Order by DEA.location, DEA.date) as Rollingpeoplevacinated
FROM PortfolioProject..CovidDeaths DEA
JOIN  PortfolioProject..CovidVaccinations VAC
 ON DEA.location = VAC.location
 AND DEA.date= VAC.date 

 --COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION (GLOBAL)
CREATE VIEW GlobalInfectionCountVsPopulationRate AS
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
Group by location,population
--ORDER BY PercPopulationInfected DESC


--TOP 50 COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION (GLOBAL)
CREATE VIEW Top50GlobalInfectionCountVsPopulationRate AS
SELECT TOP 50 location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 AS PercPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'Canada'
WHERE continent IS NOT NULL
Group by location,population
ORDER BY PercPopulationInfected DESC

--Shows highest death counts by continent
CREATE VIEW DeathCountsbyContinent AS
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCountbyContinent                
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
--order by TotalDeathCountbyContinent desc


--Shows Highest Infection Count By Continent 
CREATE VIEW InfectionCountsByContinent AS
Select continent, MAX(total_cases) as TotalInfectionCountbyContinent
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
--order by TotalInfectionCountbyContinent desc



--SHOWS GLOBAL OVERALL TOTAL COVID CASES, TOTAL COVID DEATHS, and DEATH PERCENTAGES
CREATE VIEW GlobalTotal AS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
--order by 1,2