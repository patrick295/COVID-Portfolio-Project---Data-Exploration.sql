
--- Queries used for Power BI Project

-- 1. 

SELECT
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    CASE
        WHEN SUM(new_cases) > 0 THEN
            (SUM(new_deaths) / SUM(new_cases)) * 100
        ELSE
            0  -- or any default value you prefer when total_cases is zero
    END as DeathPercentage
FROM
    plogdb.`covid death`
-- WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1, 2;



-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


SELECT
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    CASE
        WHEN SUM(new_cases) > 0 THEN
            (SUM(new_deaths) / SUM(new_cases)) * 100
        ELSE
            0  -- or any default value you prefer when total_cases is zero
    END as DeathPercentage
FROM
    plogdb.`covid death`
-- WHERE location LIKE '%states%'
WHERE location = 'World'
-- GROUP BY date
ORDER BY 1, 2;




-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent

SELECT
    continent,
    SUM(new_deaths) as TotalDeathCount
FROM
    plogdb.`covid death`
-- WHERE location LIKE '%Nigeria%'
WHERE
    continent IS not  NULL
GROUP BY
    continent
ORDER BY
    TotalDeathCount DESC;




-- 3.

SELECT
    Location,
    Population,
     continent,
    MAX(total_cases) as HighestInfectionCount,
    MAX(total_cases) / max(population) * 100 as PercentPopulationInfected
FROM
    plogdb.`covid death`

GROUP BY
    Location, Population, continent
ORDER BY
    PercentPopulationInfected DESC;



-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From plogdb.covid death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From plogdb.'covid death'
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population
SELECT Location,date,population,total_cases,total_deaths
FROM plogdb.`covid death`
-- WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
ORDER BY Location, date;



WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated 
FROM plogdb.`covid death` AS dea
    JOIN plogdb.`covid vacinations` AS vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL 
    -- ORDER BY 2,3 -- You can uncomment this line if needed
)
SELECT
    PopvsVac.*,
    (PopvsVac.RollingPeopleVaccinated / PopvsVac.Population) * 100 as PercentPeopleVaccinated
FROM
    PopvsVac;



Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM plogdb.`covid death`
-- Where location like '%Nigeria%'
Group by Location, Population, date
order by PercentPopulationInfected desc










