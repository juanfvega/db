show databases;
create database world;
use world;

CREATE TABLE `country`(
	`Code` CHAR(3),
	`Name` VARCHAR(255) NOT NULL,
	`Continent` VARCHAR(255) NOT NULL,
	`Region` VARCHAR(255) NOT NULL,
	`SurfaceArea` DECIMAL(10,2),
	`IndepYear` INT(4) UNSIGNED,
	`Population` INT UNSIGNED, 
	`LifeExpectancy` DECIMAL(4,1),
	`GNP` DECIMAL(12,2),
	`GNPOld` DECIMAL(12,2),
	`LocalName` VARCHAR(255),
	`GovernmentForm` VARCHAR(255),
	`HeadOfState` VARCHAR(255),
	`Capital` INT UNSIGNED,
	`Code2` VARCHAR(4),
	 PRIMARY KEY(`Code`)
);

CREATE TABLE `city`(
	`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(255),
	`CountryCode` VARCHAR(255),
	`District` VARCHAR(255),
	`Population` INT UNSIGNED,
	PRIMARY KEY(`ID`),
	FOREIGN KEY(`CountryCode`)
		REFERENCES `country`(`Code`)
		ON DELETE CASCADE
		ON UPDATE CASCADE 
);

CREATE TABLE `countrylanguage`(
	`CountryCode` CHAR(3),
	`Language` VARCHAR(255),
	`IsOfficial` ENUM('T','F'),
	`Percentage` DECIMAL(4,1),
	PRIMARY KEY(`CountryCode`, `Language`),
	FOREIGN KEY(`CountryCode`) 
		REFERENCES `country`(`Code`)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);

CREATE TABLE `continent`(
	`Name` VARCHAR(255) NOT NULL,
	`Area` INT NOT NULL, 
	`Percent_total_mass` DECIMAL(4,1),
	`Most_populous_city` VARCHAR(255),
	PRIMARY KEY(`Name`)
);


INSERT INTO `continent` VALUES('Africa', 30370000,20.4,'Cairo, Egypt');
INSERT INTO `continent` VALUES('Antartica', 14000000, 9.4,'mcMurdo, Station');
INSERT INTO `continent` VALUES('Asia',44579000, 29.5, 'Mumbai, India');
INSERT INTO `continent` VALUES('Europe',10180000,6.8,'Instanbul, Turquia');
INSERT INTO `continent` VALUES('North America', 24709000, 16.5, 'Ciudad de México, México');
INSERT INTO `continent` VALUES('Oceania', 8600000, 5.9, 'Syndey, Australia');
INSERT INTO `continent` VALUES('South America',17840000,12.0,'Sao Paulo, Brazil');

ALTER TABLE `country` ADD CONSTRAINT 
FOREIGN KEY (`Continent`) REFERENCES `continent`(`Name`)
	ON DELETE CASCADE 
	ON UPDATE CASCADE
	
drop table `continent`
-- SET FOREIGN_KEY_CHECKS=1;

-- 1)Devuelva una lista de los nombres y las regiones a las que pertenece cada país ordenada alfabéticamente.
	
	SELECT c.Name , c.Region 
	FROM country as c
	ORDER BY c.Name ASC 
	 
-- 2)Liste el nombre y la población de las 10 ciudades más pobladas del mundo.
	
	SELECT c.Name , c.Population 
	FROM city c 
	ORDER BY c.Population DESC
	LIMIT 10
	
-- 3)Liste el nombre, región, superficie y forma de gobierno de los 10 países con menor superficie.
	
	SELECT c2.Name , c2.Region , c2.SurfaceArea , c2.GovernmentForm 
	FROM country AS c2
	ORDER BY c2.SurfaceArea ASC
	LIMIT 10
	
-- 4)Liste todos los países que no tienen independencia (hint: ver que define la independencia de un país en la BD).
	SELECT c.Name, c.IndepYear 
	FROM country c 
	WHERE c.IndepYear IS NULL 
	
-- 5)Liste el nombre y el porcentaje de hablantes que tienen 
--   todos los idiomas declarados oficiales.
	SELECT c.`Language`, c.Percentage 
	FROM countrylanguage c
	WHERE IsOfficial = 'T'

-- Actualizar el valor de porcentaje del idioma inglés en el país con código 'AIA' a 100.0
	SELECT *
	FROM countrylanguage c 
	WHERE c.CountryCode = 'AIA'
	
	UPDATE countrylanguage AS c
	SET Percentage = 100
	WHERE c.CountryCode = 'AIA'

-- Listar las ciudades que pertenecen a Córdoba (District) dentro de Argentina.
	SELECT *
	FROM city c
	WHERE c.District  = 'Córdoba' AND c.CountryCode = 'ARG';

-- Eliminar todas las ciudades que pertenezcan a Córdoba fuera de Argentina.
	SELECT *
	FROM city c 
	WHERE c.District = 'Córdoba'
	
	DELETE FROM city 
	WHERE District = 'Córdoba' AND CountryCode <> 'ARG'

-- Listar los países cuyo Jefe de Estado se llame John.
	SELECT c.Name 
	FROM country c 
	WHERE c.HeadOfState LIKE '%John%'

-- Listar los países cuya población esté entre 35 M y 45 M ordenados por población de forma descendente.
	SELECT c.Name, c.Population 
	FROM country c 
	WHERE c.Population BETWEEN 35000000 AND 45000000
	ORDER BY c.Population DESC 
-- Identificar las redundancias en el esquema final.

	
