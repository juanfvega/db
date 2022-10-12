show databases;
create database world;
use world;
drop database world;

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
