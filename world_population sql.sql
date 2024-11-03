# World Population Dataset SQL Project

# In this Case study, I will work with the  Kaggle dataset collection 
# https://www.kaggle.com/datasets/world-population?resource=download

#Why I choose this project, Since Population keeps increasing day by day and it's a concern for the society and environment
#As the world's population grows, so do its demands for water, land, trees, food,place, and soil, etc - all of which come at a 
#high price for already endangered plants and animals.

#In this article, They have mentioned 
#"India to overtake China as world's most populated country in 2023"

#https://www.business-standard.com/article/economy-policy/india-to-overtake-china-as-world-s-most-populated-country-in-2023-un-
#122071100983_1.html

# Why Population Control is necessary

#In Simple word, population control is necessary for a healthy and prosperous life, for Good Health and Education ,and for 
#the speedy development of a country.
#Population control is also necessary to reduce the burden on nature and 
#to tackle the environmental problem growing day by day.

#In this project, I analyzed the data based on the Population in 1970 to2023 Population data is also included in the file, etc

create database saugandh_project;

#Importing the data now,Creating Database SQL_Project

#Selecting the Sql_project database for table creation
use saugandh_project;

#Imported the data using Table Data Import Wizard option
SHOW TABLES;

#Querying all the data in the population table
SELECT 
    *
FROM
    world_population;

# 1st Analysis--  which COUNTRY  has the Highest Population in 2023?
SELECT 
    MAX(Population_2023)
FROM
    world_population;

# Method 2
SELECT 
    Country, continent, Population_2023
FROM
    world_Population
ORDER BY Population_2023 DESC
LIMIT 10;

# 2nd Analysis--  which COUNTRY  has the Least Population in 2023?
SELECT 
    Country, continent, Population_2023
FROM
    world_population
WHERE
    Population_2023 = (SELECT 
            MIN(population_2023)
        FROM
            world_population);
# Method 2 

SELECT 
    Country, continent, Population_2023
FROM
    world_Population
ORDER BY Population_2023
LIMIT 1;


# 3rd Analysis-- EXTRACT THE WORLD  POPULATION OF 2023

SELECT 
    SUM(POPULATION_2023) AS 'POPULATION_2023'
FROM
    WORLD_POPULATION;

# 4th Analysis--  EXTRACT THE WORLD POPULATION GROWTH FROM 2000 TILL  THE LATEST CENSUS(2023)

SELECT 
    SUM(POPULATION_2023) - SUM(POPULATION_2000) 'POPULATION GROWTH IN THE LAST 23 YEARS'
FROM
    WORLD_POPULATION;


#5th Analysis--Find the Population of India with all details.

SELECT 
    *
FROM
    World_population
WHERE
    country = 'India';

#6th Analysis--Which country are not too small and not too big in Population?

SELECT AVG(Population_2023) AS Average_population FROM world_population;

 #7th Analysis-- EXTRACT CONTINENT WISE POPULATION IN 2023

SELECT 
    CONTINENT, SUM(POPULATION_2023) AS 'Population_2023'
FROM
    WORLD_POPULATION
GROUP BY CONTINENT
ORDER BY CONTINENT ASC;


-- 8th Analysis EXTRACT THE  ASIA'S TOP 5 HIGHEST POPULATED COUNTRIES

SELECT 
    COUNTRY, SUM(POPULATION_2023) 'population_2023', CONTINENT
FROM
    WORLD_POPULATION
WHERE
    CONTINENT = 'Asia'
GROUP BY COUNTRY , CONTINENT
LIMIT 5;

-- -- 9th Analysis HOW HAS INDIA'S POPULATION GROWN SINCE 1970  BASED ON EVERY CENSUS

SELECT 
    country,
    (POPULATION_1980 - POPULATION_1970) '1970-1980 growth' ,
    (POPULATION_1990 - POPULATION_1980) '1980-1990 growth',
     (POPULATION_2000 - POPULATION_1990) '1990 -2000 growth',
     (population_2010 - population_2000) '2000-2010 growth',
    (population_2020 - population_2010) '2010-2020  growth'
FROM
    world_population
WHERE
    COUNTRY = 'India';




#10 th Analysis  --  PROVIDE THE 5 HIGHEST POPULATED COUNTRIES IN EACH CONTINENT

SELECT 
    *
FROM
    world_Population
GROUP BY Continent
HAVING MAX(population_2023)
ORDER BY population_2023 DESC
LIMIT 5;

# 11th Analysis --10 COUINTRIES WITH LEAST POPULATION IN 2023 YEAR

 select  
 dense_rank() over
 (order by Population_2023 asc) as rank_ ,  
 continent , country, population_2023  , AreaPerKM  
 from world_population 
 order by Population_2023 asc limit 10;
 
 
 
# 12th Analysis PROVIDE THE GROWTH RATE OF COUNTRIES  FROM 1970 TO 2023 IN MILLIONS

SELECT 
    Continent,
    Country,
    CONCAT(ROUND((Population_2020 - Population_1970) / 1000000,
                    2),
            '   Millions ') AS growth_50years
FROM
    world_population;


 # 13th Analysis Find countries whose area is more than 10 lakh areaperkm

SELECT COUNT(country) from world_population WHERE areaperkm > 1000000;

 
# 14th Analysis Top 10 Most Densely Populated Countries in 2023 ?

SELECT Country, Population_2023, AreaPerKM, 
       ROUND(Population_2023 / AreaPerKM, 2) AS Density 
FROM world_population 
ORDER BY Density DESC 
LIMIT 10;
 


# 15th Analysis Population Growth Rate for Each Continent from 2000 to 2023

SELECT Continent, 
       ROUND((SUM(Population_2023) - SUM(Population_2000)) / SUM(Population_2000) * 100, 2) AS GrowthRate_2000_2023 
FROM world_population 
GROUP BY Continent;
 
 
 # 16th Analysis Countries With Population Growth Greater Than 50% Since 2000

SELECT Country, Population_2000, Population_2023, 
       ROUND((Population_2023 - Population_2000) / Population_2000 * 100, 2) AS GrowthRate 
FROM world_population 
WHERE ROUND((Population_2023 - Population_2000) / Population_2000 * 100, 2) > 50 
ORDER BY GrowthRate DESC;
 
 
# 17th Analysis  Annual Average Population Growth (in Millions) for India

SELECT Country, 
       ROUND((Population_2023 - Population_1970) / 53, 2) AS AnnualGrowthInMillions 
FROM world_population 
WHERE Country = 'India';
 
 
 # 18th Analysis Top 5 Countries by Population Decrease from 2010 to 2023

SELECT Country, Population_2010, Population_2023, 
       Population_2010 - Population_2023 AS PopulationDecrease 
FROM world_population 
WHERE Population_2010 > Population_2023 
ORDER BY PopulationDecrease DESC 
LIMIT 5;


# 19th Analysis Countries with Populations Less Than the Average Population in 2023

SELECT Country, Population_2023 
FROM world_population 
WHERE Population_2023 < (SELECT AVG(Population_2023) FROM world_population) 
ORDER BY Population_2023 ASC;


# 20th Analysis Population Contribution by Top 3 Countries in Each Continent in 2023

WITH ContinentTop3 AS (
    SELECT Continent, Country, Population_2023, 
           ROW_NUMBER() OVER(PARTITION BY Continent ORDER BY Population_2023 DESC) AS RowNum 
    FROM world_population
) 
SELECT Continent, Country, Population_2023 
FROM ContinentTop3 
WHERE RowNum <= 3;


# 21th Analysis Yearly Average Population Growth Rate Across All Continents from 1970 to 2023

SELECT Continent, 
       ROUND((SUM(Population_2023) - SUM(Population_1970)) / SUM(Population_1970) * 100 / 53, 2) AS AvgAnnualGrowthRate 
FROM world_population 
GROUP BY Continent;