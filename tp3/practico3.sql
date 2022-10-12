use world


-- 1 Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 10 ciudades más pobladas del mundo.
	SELECT c.Name , c2.Name , c2.Region , c2.GovernmentForm , c.Population 
	FROM city AS c INNER JOIN country c2 ON c.CountryCode = c2.Code 
	ORDER BY c.Population DESC LIMIT 10
	
-- 2 Listar los 10 países con menor población del mundo, junto a sus ciudades capitales 
-- (Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").
	SELECT c.Name , c.LocalName , c.Population 
	FROM country c 
	ORDER BY c.Population LIMIT 10
	
	SELECT c.Name , c.LocalName , c.Population 
	FROM country c 
	ORDER BY c.Population LIMIT 10
	
-- 3 Listar el nombre, continente y todos los lenguajes oficiales de cada país.
-- (Hint: habrá más de una fila por país si tiene varios idiomas oficiales).
	SELECT c.Name , c.Continent , c2.`Language` ,c2.IsOfficial 
	FROM country c INNER JOIN countrylanguage c2 ON c.Code = c2.CountryCode 
	WHERE c2.IsOfficial = 'T'

-- 4 Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.
	SELECT c.Name , c.SurfaceArea , c.LocalName 
	FROM country c 
	ORDER BY c.SurfaceArea DESC
	LIMIT 20
	
-- 5 Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) 
-- y el porcentaje de hablantes del idioma.
	SELECT c.Name , c2.`Language` , c2.Percentage 
	FROM city c INNER JOIN countrylanguage c2 ON c.CountryCode = c2.CountryCode
	WHERE c2.IsOfficial = 'T'
	ORDER BY c.Population DESC
	
-- 6 Listar los 10 países con mayor población y los 10 países con menor población 
-- (que tengan al menos 100 habitantes) en la misma consulta.
	(SELECT c.Name , c.Population 
	FROM country c 
	ORDER BY c.Population DESC 
	LIMIT 10)
	UNION 
	(SELECT c.Name , c.Population 
	FROM country c 
	WHERE c.Population > 100
	ORDER BY c.Population ASC
	LIMIT 10)
	
-- 7 Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés 
-- (hint: no debería haber filas duplicadas).
	
	SELECT c.Name 
	FROM country c INNER JOIN countrylanguage c2 ON c.Code = c2.CountryCode
	WHERE c2.IsOfficial  = 'T'
	AND c2.`Language` = 'English'
	INTERSECT(
 	SELECT c.Name  
	FROM country c INNER JOIN countrylanguage c2 ON c.Code = c2.CountryCode
	WHERE c2.IsOfficial  = 'T'
	AND c2.`Language` = 'French'
	
	
	select 2,3
-- 8 Listar aquellos países que tengan hablantes del Inglés 
--   pero no del Español en su población.
