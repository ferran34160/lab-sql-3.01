USE sakila;
-- 1 / Drop column picture from staff.
ALTER TABLE sakila.staff
DROP picture;

-- 2 / A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. 
-- Update the database accordingly.
INSERT INTO sakila.staff (first_name, last_name, address_id, email, store_id, active, username)
SELECT first_name, last_name, address_id, email, 2, 1, 'tammy' FROM sakila.customer
WHERE first_name="TAMMY" AND last_name="SANDERS";

-- 3 / Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
-- You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. 
-- You can query those pieces of information. For eg., you would notice that you need customer_id information as well.
INSERT INTO sakila.rental (rental_date, inventory_id, customer_id, staff_id)
SELECT now(), 
	(SELECT MIN(inventory_id)
	FROM sakila.rental
	WHERE inventory_id IN 
		(SELECT inventory_id 
		FROM sakila.inventory
		JOIN sakila.film USING (film_id)
		WHERE title = "Academy Dinosaur")
	AND return_date IS NOT NULL)
	, 
	(SELECT customer_id 
    FROM sakila.customer
	WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER')
    ,
	(SELECT staff_id
	FROM sakila.staff
	WHERE first_name = "Mike" AND last_name	= "Hillyer")
;
