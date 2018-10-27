USE sakila;

#1a
SELECT first_name, last_name
FROM actor;

#1b
SELECT CONCAT(first_name, last_name) As 'Actor Name'
FROM actor;actoractor

#2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='Joe';

#2b
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

#2c
SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

#2d

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
ADD COLUMN description BLOB;
SELECT *FROM actor;

#3b
ALTER TABLE actor
DROP COLUMN description;
SELECT *  FROM actor; 

#4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(last_name) as count 
FROM actor
GROUP BY last_name
HAVING count>=2;

#4c
UPDATE actor 
SET first_name='HARPO'
WHERE first_name = 'GROUCHO' and last_name ='WILLIAMS';

#4d
#Making sure there is only one actor whose first name is Harpo
select *
from actor
where first_name="HARPO";

UPDATE actor 
SET first_name = 'Groucho'
WHERE first_name = 'HARPO' and last_name="WILLIAMS";

#5a
DROP TABLE IF EXISTS address;
CREATE Table address;

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address 
ON staff.address_id = address.address_id;

#6b
select payment_date
from payment;

SELECT staff.first_name, staff.last_name, SUM(payment.amount) As 'total amount rung'
FROM payment 
INNER JOIN 
staff 
ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '%2005-08%'
GROUP BY payment.staff_id;

#6c
SELECT film.title AS 'Film tilte', COUNT(film_actor.actor_id) As 'Actor Count'
FROM film INNER JOIN film_actor 
ON film.film_id = film_actor.film_id;

#6d
SELECT COUNT(film_id) As 'Hunchback Impossible Inventory coount'
FROM inventory
WHERE film_id IN 
                 ( 
				 SELECT film_id FROM film
				 WHERE title = 'Hunchback Impossible');

#6e
SELECT customer.first_name, customer.last_name, SUM(payment.amount) As 'Total Amount Paid'
FROM payment INNER JOIN customer 
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name;

#7a
SELECT title FROM film WHERE language_id IN 
( 
 SELECT language_id FROM language
 WHERE name = 'English'
)
AND title LIKE 'K%' OR title LIKE 'Q%';

#7b
SELECT first_name, last_name FROM actor 
   WHERE actor_id IN 
		(SELECT actor_id FROM film_actor
		   WHERE film_id IN
						(SELECT film_id FROM film
						 WHERE title = 'Alone Trip'
						)
		)
;

#7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer INNER JOIN address ON customer.address_id = address.address_id
			  INNER JOIN city ON city.city_id = address.city_id
              INNER JOIN country ON country.country_id = city.country_id
WHERE country.country = 'Canada'
;

#7d
SELECT title As 'Family Movies' FROM film WHERE film_id IN 
															( 
															 SELECT film_id FROM film_category
															 WHERE category_id IN
						 (
						  SELECT category_id FROM category
						  WHERE name = 'Family'
						 )
)
;

#7e
SELECT film.title, COUNT(inventory.film_id) As 'Rented Times'
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
		  INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY COUNT(inventory.film_id) DESC;

#7f
SELECT staff.store_id, SUM(payment.amount) As 'Total Amount'
FROM payment INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY payment.staff_id;

#7g
SELECT store.store_id, city.city, country.country
FROM store INNER JOIN address ON store.address_id = address.address_id
		   INNER JOIN city ON city.city_id = address.city_id
		   INNER JOIN country ON country.country_id = city.country_id;

#7h
SELECT category.name As 'Top Five Genres', SUM(payment.amount) As 'Gross Revenue' 
FROM category INNER JOIN film_category ON category.category_id = film_category.category_id
		      INNER JOIN inventory ON inventory.film_id = film_category.film_id
		      INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
              INNER JOIN payment ON payment.rental_id = rental.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8a
CREATE VIEW top_five_genres AS
SELECT category.name As 'Top Five Genres', SUM(payment.amount) As 'Gross Revenue' 
FROM category INNER JOIN film_category ON category.category_id = film_category.category_id
		      INNER JOIN inventory ON inventory.film_id = film_category.film_id
		      INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
              INNER JOIN payment ON payment.rental_id = rental.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8b
SELECT* FROM top_five_genres;

#8c
DROP VIEW top_five_genres;