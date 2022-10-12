use sakila
show tables


-- 1 Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas
CREATE TABLE `directors`(
	directors_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	films_number SMALLINT UNSIGNED NOT NULL,
	PRIMARY KEY(directors_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2 El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e.
-- el mayor número de películas filmadas) son también directores de las películas en
-- las que participaron. Basados en esta información, inserten, utilizando una subquery
-- los valores correspondientes en la tabla `directors`
 
INSERT INTO `directors`(first_name, last_name, films_number)
SELECT f1.first_name , f1.last_name,COUNT(f2.film_id) AS films_number 
FROM actor AS f1 INNER JOIN film_actor AS f2 ON f1.actor_id = f2.film_id 
GROUP BY f1.actor_id
ORDER BY films_number DESC
LIMIT 5

-- check 
SELECT *
FROM directors d 


-- 3. Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a
-- si el cliente es "premium" o no. Por defecto ningún cliente será premium.

DESCRIBE customer 

ALTER TABLE customer 
ADD COLUMN premium_customer ENUM('T','F') DEFAULT 'F'


-- Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` de
-- los 10 clientes con mayor dinero gastado en la plataforma.

UPDATE customer AS C, 
	(SELECT C1.customer_id AS customer_id  , SUM(C2.amount)  AS Total
	FROM customer AS C1 INNER JOIN payment AS C2 ON C1.customer_id = C2.customer_id 
	GROUP BY C1.customer_id 
	ORDER BY total DESC
	LIMIT 10) AS T
SET C.premium_customer = 'T'
WHERE C.customer_id = T.customer_id

SELECT C1.customer_id AS customer_id  , SUM(C2.amount)  AS Total , C1.premium_customer 
FROM customer AS C1 INNER JOIN payment AS C2 ON C1.customer_id = C2.customer_id 
GROUP BY C1.customer_id 
ORDER BY total DESC
LIMIT 10




-- 5.Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings
-- de las películas existentes (Hint: rating se refiere en este caso a la clasificación
-- según edad: G, PG, R, etc).
SELECT f.rating , COUNT(f.rating) AS cantidad  
FROM film AS f
GROUP BY f.rating
ORDER BY rating DESC 

-- 6. ¿Cuáles fueron la primera y última fecha donde hubo pagos?
SELECT MIN(p.payment_date) as first_pay , MAX(p.payment_date) AS last_pay  
FROM payment AS p 

-- 7. Calcule, por cada mes, el promedio de pagos (Hint: vea la manera de extraer el
-- nombre del mes de una fecha).
SELECT MONTH(p.payment_date) as mes, AVG(p.amount) AS avg_month 
FROM payment AS p
GROUP BY MONTH(p.payment_date)

-- 8. Listar los 10 distritos que tuvieron mayor cantidad de alquileres (con la cantidad total
-- de alquileres).
SELECT a.district AS district , SUM(r.rental_id) AS total_rental 
FROM address AS a INNER JOIN staff AS s ON a.address_id = s.address_id 
	INNER JOIN rental AS r ON r.staff_id = s.staff_id
GROUP BY a.district
ORDER BY total_rental DESC
LIMIT 10

-- 9. Modifique la table `inventory_id` agregando una columna `stock` que sea un número
-- entero y representa la cantidad de copias de una misma película que tiene
-- determinada tienda. El número por defecto debería ser 5 copias.
ALTER TABLE inventory 
ADD COLUMN `stock` SMALLINT UNSIGNED DEFAULT '5'


-- 10.Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la
-- tabla rental, haga un update en la tabla `inventory` restando una copia al stock de la
-- película rentada (Hint: revisar que el rental no tiene información directa sobre la
-- tienda, sino sobre el cliente, que está asociado a una tienda en particular).


CREATE TRIGGER `update_stock` AFTER INSERT 
ON rental FOR EACH ROW 

BEGIN 
	UPDATE inventory 
	SET inventory.stock = inventory.stock - 1
	WHERE inventory.store_id = (SELECT c.store_id 
						        FROM customer AS c
						        WHERE c.customer_id = NEW.customer_id);
END ; 

SHOW TRIGGERS;

DROP  trigger `update_stock`

SELECT COUNT(r.rental_id)  
FROM rental r 
-- 16044

SELECT *
FROM customer c 

SELECT *
FROM rental r2 

SELECT *
FROM customer AS c INNER JOIN inventory AS i ON c.store_id = i.store_id
	INNER JOIN rental AS r ON r.inventory_id = i.inventory_id 
WHERE c.customer_id = 130 AND r.rental_id = 16066


-- 11. Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es
-- una clave foránea a la tabla rental y el segundo es un valor numérico con dos
-- decimales.
CREATE TABLE `fines`( 
	rental_id INT NOT NULL AUTO_INCREMENT,
	amount DECIMAL(14,2) NOT NULL,
	CONSTRAINT `fines_fk` FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE 
)engine=INNODB;


-- 12. Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un
-- registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya
-- tardado más de 3 días (comparación con rental_date). El valor de la multa será el
-- número de días de retraso multiplicado por 1.5.
CREATE PROCEDURE `check_date_and_fine`()
BEGIN
	INSERT INTO fines(rental_id, amount)
	SELECT r.rental_id, DATEDIFF(r.rental_date, r.return_date)*3 AS total   
	FROM rental r
	WHERE DATEDIFF(r.rental_date, r.return_date) > 3;
END; 

SELECT *
FROM fines f 

-- 13. Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a
-- la tabla `rental`.
	CREATE ROLE `employee`;
	
	GRANT SELECT, UPDATE , DELETE 
	ON rental
	TO `employee`;

-- 14. Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que
-- tenga todos los privilegios sobre la BD `sakila`.
	REVOKE DELETE
	ON rental
	FROM `employee`;

	CREATE ROLE `administrator`;

	GRANT ALL 
	ON `sakila`
	TO `administrator`;

	SHOW DATABASES;

-- 15. Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro
-- de `administrator`
	CREATE ROLE `employeeA`;
	CREATE ROLE `employeeB`;
	
	GRANT `administrator` TO `employeeA`;
	GRANT `employee` TO `employeeB`;
