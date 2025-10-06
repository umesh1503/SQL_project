
Select *
From [PortFolio].[dbo].[CovidDeaths]

Select *
From [PortFolio].[dbo].[CovidVaccinations]

-- Looking into the data after importing

Select location , date,total_cases,new_cases,total_deaths,population
From [PortFolio].[dbo].[CovidDeaths]
order by 1,2

--Calculating Death percentage (Shows the probability of death)

Select location ,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [PortFolio].[dbo].[CovidDeaths]
Where location like '%India%'
order by 1,2 

--Calculating How the population got infected 

Select location ,date,total_cases,population,(total_cases/population)*100 as InfectedPercentage
From [PortFolio].[dbo].[CovidDeaths]
Where location like '%India%'
order by 1,2 


--Looking at the country with highest infection rate 

Select location,Max(total_cases) as HighestNumber,population , Max((total_cases/population)*100) as HighestInfected
From [PortFolio].[dbo].[CovidDeaths]
Group by location,population
order by HighestInfected  Desc


Select  continent ,Max(Cast(Total_deaths as int)) as TotalDeathCount 
From [PortFolio].[dbo].[CovidDeaths]
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--Global Numbers 

Select date , SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeath , (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage 
From [PortFolio].[dbo].[CovidDeaths]
Where continent is not null 
Group by date 
order by DeathPercentage

--Join the two tables 

Select *
From [PortFolio].[dbo].[CovidDeaths] as Death 
Join [PortFolio].[dbo].[CovidVaccinations] as Vaccination 
	on Death.location = Vaccination.location and Death.date = Vaccination.date

--Looking Total Population Vs Vaccination 

Select Death.continent,Death.location , Death.population,Vaccination.new_vaccinations,Death.date,
SUM(Convert(int,Vaccination.new_vaccinations)) Over (Partition by Death.location Order by Death.date)
From [PortFolio].[dbo].[CovidDeaths] as Death 
join [PortFolio].[dbo].[CovidVaccinations] as Vaccination 
	on Death.location = Vaccination.location and Death.date = Vaccination.date
Where Death.continent is not null 
Order by 2,3

--CTE Used for complex Query

with PopulationvsVaccination ( Continent, location , date , population , Newvaccination, Totalvaccination)
as
(
select Death.continent,Death.location,Death.date,Death.population,Vaccination.new_vaccinations,
SUM(convert(int,Vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location,death.date) as Totalvaccination
From [PortFolio].[dbo].[CovidDeaths] as Death 
join [PortFolio].[dbo].[CovidVaccinations] as Vaccination 
	on Death.location = Vaccination.location and Death.date = Vaccination.date
Where death.continent is not null
)

select *,(Totalvaccination/population)*100 
From PopulationvsVaccination


--Creating View 

Create View PercentagePopuVaccinated as 
select Death.continent,Death.location,Death.date,Death.population,Vaccination.new_vaccinations,
SUM(convert(int,Vaccination.new_vaccinations)) OVER (Partition by death.location Order by death.location,death.date) as Totalvaccination
From [PortFolio].[dbo].[CovidDeaths] as Death 
join [PortFolio].[dbo].[CovidVaccinations] as Vaccination 
	on Death.location = Vaccination.location and Death.date = Vaccination.date
Where death.continent is not null

Select *
From PercentagePopuVaccinated

