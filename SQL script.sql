/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


USE Covid_Project;


-- 1. SELECT THE DATA I AM GOING TO USE

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_project.covid_deaths
WHERE continent not like '0'
ORDER BY location, date
;

----------------------------------------------------------------------------------------------------------------------------

-- 2. LOOKING AT total_deaths PER total_cases RATIO WHICH SHOWS THE LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) *100 as death_ratio
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
ORDER BY location, date
;

----------------------------------------------------------------------------------------------------------------------------

-- 3. LOOKING AT TOTAL_CASES VS POPULATION WHICH SHOWS PERCENTAGE OF POPULATION WHO GOT INFECTED


SELECT location, date, population,total_cases, (total_cases / population) *100 as infection_rate
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
ORDER BY location, date
;

----------------------------------------------------------------------------------------------------------------------------

-- 4. LOOKING AT COUNTRIES WITH THE HIGHEST INFECTION RATE

SELECT location, population, max(total_cases) as highest_infection_count, max((total_cases/population)*100) as highest_infection_rate
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
GROUP BY location, population
ORDER BY highest_infection_rate desc
;

----------------------------------------------------------------------------------------------------------------------------

-- 5. LOOKING AT COUNTRIES WITH THE HIGHEST DEATH COUNT

SELECT location, population, max(total_deaths) as highest_death_count
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
GROUP BY location, population
ORDER BY highest_death_count desc
;

----------------------------------------------------------------------------------------------------------------------------

-- 6. LOOKING AT COUNTRIES WITH THE HIGHEST DEATH RATE

SELECT location, population, max(total_deaths) as highest_death_count, max((total_deaths / population)*100) as highest_death_rate
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
GROUP BY location, population
ORDER BY highest_death_rate desc
;

----------------------------------------------------------------------------------------------------------------------------

-- 7. LOOKING AT CONTINENTS WITHT THE HIGHEST DEATH COUNT

SELECT continent,max(total_deaths) as highest_death_count
FROM Covid_Project.covid_deaths
WHERE continent not like '0'
GROUP BY continent
ORDER BY highest_death_count desc
;

----------------------------------------------------------------------------------------------------------------------------

-- 8. LOOKING AT GLOBAL FIGURES

SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths/new_cases) as death_to_case_ratio
FROM Covid_Project.covid_deaths
;

----------------------------------------------------------------------------------------------------------------------------

-- 9. LOOKING AT NUMBER OF VACCINATIONS PER LOCATION AND PER DATE

SELECT death.continent, death.location, death.date,death.population, vac.new_vaccinations
FROM Covid_Project.covid_deaths as death
JOIN Covid_Project.covid_vaccinations as vac
    on death.location = vac.location
    and death.date = vac.date
WHERE death.continent not like '0'
ORDER BY location, date
;

----------------------------------------------------------------------------------------------------------------------------

-- 10. LOOKING AT INCREMENTAL NUMBER OF VACCINATIONS PER DAY　VS POPULATION USING A CTE

with pop_vac (continent, location, date, population, new_vaccinations, incremental_vaccinations)
as
(
SELECT death.continent, death.location, death.date,death.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) OVER (partition by death.location order by death.location, death.date) as incremental_vaccinations
FROM Covid_Project.covid_deaths as death
JOIN Covid_Project.covid_vaccinations as vac
    on death.location = vac.location
    and death.date = vac.date
WHERE death.continent not like '0'
ORDER BY location, date
)

SELECT * , (incremental_vaccinations / population)*100 as vacc_to_pop_ratio
FROM pop_vac
;

----------------------------------------------------------------------------------------------------------------------------

-- 11. LOOKING AT INCREMENTAL NUMBER OF VACCINATIONS PER DAY　VS POPULATION USING A TEMP TABLE

DROP TEMPORARY TABLE if exists percent_population_vaccinated;
CREATE TEMPORARY TABLE percent_population_vaccinated
(
continent varchar(255),
location varchar(255),
date date,
population bigint,
new_vaccinations int,
incremental_vaccinations decimal(10,0)
)
;

INSERT INTO percent_population_vaccinated
(
SELECT death.continent, death.location, death.date,death.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) OVER (partition by death.location order by death.location, death.date) as incremental_vaccinations
FROM Covid_Project.covid_deaths as death
JOIN Covid_Project.covid_vaccinations as vac
    on death.location = vac.location
    and death.date = vac.date
WHERE death.continent not like '0'
ORDER BY location, date
)
;

SELECT * , (incremental_vaccinations / population)*100 as vacc_to_pop_ratio
FROM percent_population_vaccinated
;

----------------------------------------------------------------------------------------------------------------------------

-- 12. CREATING A VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated

FROM Covid_Project.covid_deaths as death
JOIN Covid_Project.covid_vaccinations as vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent not like '0' 
;







