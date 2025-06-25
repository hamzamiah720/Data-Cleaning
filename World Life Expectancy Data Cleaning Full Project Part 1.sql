 
SELECT*
FROM world_life_expectancy;

SELECT Country, YEAR, CONCAT(Country, YEAR), COUNT(CONCAT(Country, YEAR)) as Counter
FROM world_life_expectancy
GROUP BY Country, YEAR, CONCAT(Country, YEAR)
HAVING Counter > 1;

SELECT*
FROM(
	SELECT Row_ID,
	CONCAT(Country, YEAR),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(COUNTRY, YEAR) ORDER BY CONCAT(Country, YEAR)) as Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1;






SET SQL_SAFE_UPDATES = 0; #Needed this to turn off safe mode








DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT ROW_ID
FROM(
	SELECT Row_ID,
	CONCAT(Country, YEAR),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(COUNTRY, YEAR) ORDER BY CONCAT(Country, YEAR)) as Row_Num
	FROM world_life_expectancy) AS Row_table
WHERE Row_Num > 1 
);
    
 
SELECT*
FROM world_life_expectancy
WHERE Status is NULL
;
 
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN(SELECT DISTINCT(Country)
		FROM world_life_expectancy
		WHERE Status = 'Developing');
        
UPDATE world_life_expectancy as t1
JOIN world_life_expectancy as t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.status <> ''
AND t2.Status = 'Developing'
 ;
        
        
        
UPDATE world_life_expectancy as t1
JOIN world_life_expectancy as t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.status <> ''
AND t2.Status = 'Developed'
 ;
  
SELECT*
FROM world_life_expectancy
WHERE 'Life expectancy' = ''
;



SELECT Country, YEAR, 'Life expectancy'
FROM world_life_expectancy
WHERE 'Life expectancy' = '';

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
       t2.Country, t2.Year, t2.`Life expectancy`, 
       t3.Country, t3.Year, t3.`Life expectancy`, 
       ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
 AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
  ON t1.Country = t3.Country
 AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
 AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
  ON t1.Country = t3.Country
 AND t1.Year = t3.Year + 1
 SET t1.`Life expectancy` =   ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` =  '';