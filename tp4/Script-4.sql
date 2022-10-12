use world;


-- 1 Listar el nombre de la ciudad y el nombre del país de todas las ciudades 
-- que pertenezcan a países con una población menor a 10000 habitantes.

SELECT c.Name, t.Name , t.Population 
FROM city AS c INNER JOIN country AS t ON c.CountryCode = t.Code 
WHERE t.Population < 10000


 
-- 2 Listar todas aquellas ciudades cuya población sea mayor que la
--  población promedio entre todas las ciudades.

SELECT c.Name , c.Population
FROM city AS c
WHERE c.Population > (
	SELECT AVG(t.Population) as avg_population
	FROM city AS t
)

-- 3 Listar todas aquellas ciudades no asiáticas cuya población
--   sea igual o mayor a la población total de algún país de Asia.

SELECT q1.Name, q2.Continent , q1.Population 
FROM city AS q1 INNER JOIN country AS q2 ON q1.CountryCode = q2.Code 
WHERE q2.Continent <> 'Asia' AND q1.Population > SOME 
	(
	SELECT c2.Population 
	FROM country AS c2 
	WHERE c2.Continent = 'Asia'
	)

-- 4 Listar aquellos países junto a sus idiomas no oficiales, 
--   que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.

/*
SELECT c1.Name , c2.`Language` , c2.Percentage , c2.IsOfficial 
FROM  country AS c1 INNER JOIN countrylanguage AS c2 ON c1.Code = c2.CountryCode
WHERE c2.IsOfficial = 'T' AND c2.Percentage
*/
SELECT c1.Name , c2.`Language` , c2.Percentage , c2.IsOfficial 
FROM  country AS c1 INNER JOIN countrylanguage AS c2 ON c1.Code = c2.CountryCode
WHERE c2.IsOfficial = 'F' AND c2.Percentage > ALL (
	SELECT q1.Percentage 
	FROM countrylanguage AS q1
	WHERE q1.CountryCode = c2.CountryCode AND q1.IsOfficial = 'T'
)
  


--  5 Listar (sin duplicados) aquellas regiones que tengan países con una 
--    superficie menor a 1000 km2 y exista (en el país) al menos una ciudad 
--    con más de 100000 habitantes. 
--   (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas).

SELECT DISTINCT c1.Region, c1.SurfaceArea  
FROM country  AS c1 INNER JOIN city AS c2 ON c1.Code = c2.CountryCode 
WHERE (c1.SurfaceArea  <= 1000) AND 
(c2.Population > 100000)

SELECT DISTINCT c.Region, c.SurfaceArea
FROM country AS c
WHERE c.SurfaceArea <= 1000 
AND EXISTS (
	SELECT *
	FROM city c2 
	WHERE c2.CountryCode = c.Code 
	AND c2.Population > 100000
)


 -- 6.Listar el nombre de cada país con la cantidad de habitantes 
 -- de su ciudad más poblada. (Hint: Hay dos maneras de llegar al mismo 
 -- resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).

SELECT country_name,  max_population_city
FROM (
	SELECT c1.name AS country_name, MAX(c2.Population) AS max_population_city
	FROM country AS c1 INNER JOIN city AS c2 ON c1.Code = c2.CountryCode
	GROUP BY c1.Name 
) AS t

SELECT c2.Name,
(
	SELECT MAX(c1.Population) 
	FROM city AS c1
	WHERE c1.CountryCode = c2.Code 
) AS max_population_city
FROM country AS c2


-- 7.Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje 
-- de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales.
SELECT c1.Name, c2.`Language` , c2.IsOfficial , c2.Percentage 
FROM country AS c1 INNER JOIN countrylanguage AS c2 ON c1.Code = c2.CountryCode 
WHERE c2.IsOfficial = 'F'
AND 
c2.Percentage > (
	SELECT AVG(l.Percentage)
	FROM countrylanguage AS l
	WHERE l.CountryCode = c2.CountryCode
	AND l.IsOfficial = 'T'
	GROUP BY l.CountryCode 
)
/* check */
SELECT c1.Name, c2.`Language` , c2.IsOfficial , c2.Percentage 
FROM country AS c1 INNER JOIN countrylanguage AS c2 ON c1.Code = c2.CountryCode 



-- 8.Listar la cantidad de habitantes por continente ordenado en forma descendiente.
SELECT c1.Name , SUM(c2.Population) AS total_person
FROM continent AS c1 INNER JOIN country c2 ON c1.Name = c2.Continent 
GROUP BY c1.Name 
ORDER BY total_person DESC 

-- 9.Listar el promedio de esperanza de vida (LifeExpectancy) 
-- por continente con una esperanza de vida entre 40 y 70 años.

SELECT c.Continent, AVG(c.LifeExpectancy) AS LifeExpectancy 
FROM country AS c 
WHERE LifeExpectancy BETWEEN 40 AND 70
GROUP BY c.Continent


-- 10.Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente

SELECT c.Continent, MAX(c.Population) AS max_pop,
					MIN(c.Population) AS min_pop,
					AVG(c.Population) AS avg_pop, 
					SUM(c.Population) AS sum_pop
FROM country AS c 
GROUP BY c.Continent
ORDER BY max_pop DESC 




