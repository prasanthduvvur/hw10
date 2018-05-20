use sakila;

#1a. Display the first and last names of all actors from the table actor. 
SELECT first_name,last_name
  FROM actor
 LIMIT 0,5;

/*
first_name,last_name
PENELOPE,GUINESS
NICK,WAHLBERG
ED,CHASE
JENNIFER,DAVIS
JOHNNY,LOLLOBRIGIDA
*/

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. 

SELECT UPPER(CONCAT(first_name,' ',last_name)) "Actor Name"
  FROM actor
 LIMIT 0,5;

/*
Actor Name
PENELOPE GUINESS
NICK WAHLBERG
ED CHASE
JENNIFER DAVIS
JOHNNY LOLLOBRIGIDA
*/

#2a. You need to find the ID number, first name, and last name of an actor, 
#of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id,first_name,last_name
  FROM actor
 WHERE first_name = 'Joe';
 
 /*
 actor_id first_name last_name
 9	JOE	SWANK
*/

#2b. Find all actors whose last name contain the letters GEN:
SELECT *
  FROM actor
 WHERE last_name LIKE '%GEN%';
 /*
 actor_id first_name last_name last_update
 14	VIVIEN	BERGEN	2006-02-15 04:34:33
41	JODIE	DEGENERES	2006-02-15 04:34:33
107	GINA	DEGENERES	2006-02-15 04:34:33
166	NICK	DEGENERES	2006-02-15 04:34:33
*/

#2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
SELECT *
  FROM actor
 WHERE last_name LIKE '%LI%'
 ORDER BY last_name,first_name;
 
 /*
actor_id first_name last_name last_update
86	GREG	CHAPLIN	2006-02-15 04:34:33
82	WOODY	JOLIE	2006-02-15 04:34:33
34	AUDREY	OLIVIER	2006-02-15 04:34:33
15	CUBA	OLIVIER	2006-02-15 04:34:33
172	GROUCHO	WILLIAMS	2006-02-15 04:34:33
137	MORGAN	WILLIAMS	2006-02-15 04:34:33
72	SEAN	WILLIAMS	2006-02-15 04:34:33
83	BEN	WILLIS	2006-02-15 04:34:33
96	GENE	WILLIS	2006-02-15 04:34:33
164	HUMPHREY	WILLIS	2006-02-15 04:34:33
*/

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
  FROM country
 WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
 
 /*
country_id, country
'1', 'Afghanistan'
'12', 'Bangladesh'
'23', 'China'
*/

#3a. Add a middle_name column to the table actor. 
#Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
  ADD COLUMN middle_name VARCHAR(1) AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. 
#Change the data type of the middle_name column to blobs.
DESC actor;
ALTER TABLE actor MODIFY middle_name BLOB;
DESC actor;

##3c. Now delete the middle_name column.
ALTER TABLE actor DROP middle_name;
DESC actor;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*)
  FROM actor
GROUP BY last_name
LIMIT 0,5;
# last_name, COUNT(*)
/*
'AKROYD', '3'
'ALLEN', '3'
'ASTAIRE', '1'
'BACALL', '1'
'BAILEY', '2'
*/
#4b. List last names of actors and the number of actors who have that last name,
#but only for names that are shared by at least two actors
SELECT last_name,COUNT(*)
  FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2
LIMIT 0,5;
/*
last_name, COUNT(*)
'AKROYD', '3'
'ALLEN', '3'
'BAILEY', '2'
'BENING', '2'
'BERRY', '3'
*/

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
#the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
SELECT *
  FROM actor
 WHERE last_name = 'WILLIAMS'
   AND first_name = 'GROUCHO';
/*
# actor_id, first_name, last_name, last_update
'172', 'GROUCHO', 'WILLIAMS', '2006-02-15 04:34:33'
*/
UPDATE actor
   SET first_name = 'HARPO'
 WHERE last_name = 'WILLIAMS'
   AND first_name = 'GROUCHO';

SELECT *
  FROM actor
 WHERE last_name = 'WILLIAMS'
   AND first_name = 'GROUCHO';   
/*
# actor_id, first_name, last_name, last_update
*/

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
(Hint: update the record using a unique identifier.)*/

SELECT *
  FROM actor
 WHERE first_name = 'HARPO';

UPDATE actor
   SET first_name = 'GROUCHO'
 WHERE first_name = 'HARPO'
   AND actor_id = 172;
   
SELECT *
  FROM actor
 WHERE first_name = 'HARPO';
/*
# actor_id, first_name, last_name, last_update
*/

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
CREATE TABLE address (
  address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  address varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone varchar(20) NOT NULL,
  location geometry NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY idx_location (location),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

#6a. Use JOIN to display the first and last names, as well as the address, 
#of each staff member. Use the tables staff and address:
SELECT *
  FROM staff;
  
SELECT first_name,last_name,address
  FROM staff
  JOIN address ON staff.address_id = address.address_id;
/*
# first_name, last_name, address
'Mike', 'Hillyer', '23 Workhaven Lane'
'Jon', 'Stephens', '1411 Lillydale Drive'
*/

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment. 
SELECT *
  FROM payment
 WHERE payment_date BETWEEN '2005-08-01 00:00:00'
                        AND '2005-08-31 23:59:59';

SELECT first_name,last_name,SUM(AMOUNT)
  FROM staff
 JOIN payment ON staff.staff_id=payment.staff_id
 WHERE payment_date BETWEEN '2005-08-01 00:00:00'
                        AND '2005-08-31 23:59:59'
GROUP BY first_name,last_name;
/*
# first_name, last_name, SUM(AMOUNT)
'Mike', 'Hillyer', '11853.65'
'Jon', 'Stephens', '12218.48'
*/
SELECT * FROM payment;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
SELECT title,COUNT(*)
  FROM film_actor
INNER JOIN film ON film.film_id=film_actor.film_id
GROUP BY title
LIMIT 0,5;

/*
# title, COUNT(*)
'ACADEMY DINOSAUR', '10'
'ACE GOLDFINGER', '4'
'ADAPTATION HOLES', '5'
'AFFAIR PREJUDICE', '5'
'AFRICAN EGG', '5'
*/

SELECT title,COUNT(*)
  FROM film_actor,
       film
 WHERE film.film_id=film_actor.film_id
GROUP BY title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT *
  FROM film
 WHERE title = 'Hunchback Impossible';

SELECT COUNT(*)
  FROM inventory
JOIN film ON inventory.film_id = film.film_id
 WHERE title='Hunchback Impossible';
 
 /*
 # COUNT(*)
'6'
*/

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name:

SELECT first_name,last_name,SUM(amount)
  FROM payment
JOIN customer ON payment.customer_id=customer.customer_id
GROUP BY first_name,last_name
ORDER BY last_name ASC
LIMIT 0,5;

/*
# first_name, last_name, SUM(amount)
'RAFAEL', 'ABNEY', '97.79'
'NATHANIEL', 'ADAM', '133.72'
'KATHLEEN', 'ADAMS', '92.73'
'DIANA', 'ALEXANDER', '105.73'
'GORDON', 'ALLARD', '160.68'
*/

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 

SELECT title
  FROM film
JOIN language ON film.language_id=language.language_id
WHERE language.name = 'English'
  AND (film.title LIKE 'K%'
		OR
	   film.title LIKE 'Q%')
LIMIT 0,5;

/*
# title
'KANE EXORCIST'
'KARATE MOON'
'KENTUCKIAN GIANT'
'KICK SAVANNAH'
'KILL BROTHERHOOD'
*/
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name,last_name
  FROM film_actor
JOIN actor ON film_actor.actor_id=actor.actor_id
 WHERE film_id IN (SELECT film_id
                     FROM film
					WHERE title = 'Alone Trip');
/*
# first_name, last_name
'ED', 'CHASE'
'KARL', 'BERRY'
'UMA', 'WOOD'
'WOODY', 'JOLIE'
'SPENCER', 'DEPP'
'CHRIS', 'DEPP'
'LAURENCE', 'BULLOCK'
'RENEE', 'BALL'
*/

SELECT COUNT(*)
  FROM film_actor
 WHERE film_id IN (SELECT film_id
                     FROM film
					WHERE title='Alone Trip');

#7c. You want to run an email marketing campaign in Canada, 
#for which you will need the names and email addresses of all Canadian customers. 
#Use joins to retrieve this information.

SELECT first_name,last_name,email
  FROM country
JOIN city ON country.country_id=city.country_id
JOIN address ON city.city_id=address.city_id
JOIN customer ON address.address_id=customer.address_id
WHERE country='Canada';
/*
# first_name, last_name, email
'DERRICK', 'BOURQUE', 'DERRICK.BOURQUE@sakilacustomer.org'
'DARRELL', 'POWER', 'DARRELL.POWER@sakilacustomer.org'
'LORETTA', 'CARPENTER', 'LORETTA.CARPENTER@sakilacustomer.org'
'CURTIS', 'IRBY', 'CURTIS.IRBY@sakilacustomer.org'
'TROY', 'QUIGLEY', 'TROY.QUIGLEY@sakilacustomer.org'
*/
SELECT first_name,last_name,email
  FROM country,
       city,
       address,
       customer
 WHERE country.country_id=city.country_id
   AND city.city_id=address.city_id
   AND address.address_id=customer.address_id
   AND country='Canada';
/*
# first_name, last_name, email
'DERRICK', 'BOURQUE', 'DERRICK.BOURQUE@sakilacustomer.org'
'DARRELL', 'POWER', 'DARRELL.POWER@sakilacustomer.org'
'LORETTA', 'CARPENTER', 'LORETTA.CARPENTER@sakilacustomer.org'
'CURTIS', 'IRBY', 'CURTIS.IRBY@sakilacustomer.org'
'TROY', 'QUIGLEY', 'TROY.QUIGLEY@sakilacustomer.org'
*/

#7d. Sales have been lagging among young families, 
#and you wish to target all family movies for a promotion. 
#Identify all movies categorized as famiy films.

SELECT *
  FROM category;

SELECT title
  FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON film_category.category_id = category.category_id
 WHERE category.name = 'Family'
LIMIT 0,5; 

/*
# title
'AFRICAN EGG'
'APACHE DIVINE'
'ATLANTIS CAUSE'
'BAKED CLEOPATRA'
'BANG KWAI'
*/
SELECT title
  FROM film,film_category,category
 WHERE film_category.film_id = film.film_id
   AND film_category.category_id = category.category_id
   AND category.name = 'Family';

#7e. Display the most frequently rented movies in descending order.

SELECT title,COUNT(*)
  FROM rental
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film ON film.film_id=inventory.film_id
GROUP BY title
ORDER BY 2 DESC
LIMIT 0,5;
/*
# title, COUNT(*)
'BUCKET BROTHERHOOD', '34'
'ROCKETEER MOTHER', '33'
'FORWARD TEMPLE', '32'
'GRIT CLOCKWORK', '32'
'JUGGLER HARDLY', '32'
*/

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id,SUM(amount)
  FROM payment
JOIN store ON store.manager_staff_id=payment.staff_id
GROUP BY store_id;
/*
# store_id, SUM(amount)
'1', '33489.47'
'2', '33927.04'
*/

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id,city,country
  FROM store
JOIN address ON store.address_id=address.address_id
JOIN city ON city.city_id=address.city_id
JOIN country ON country.country_id=city.country_id;
/*
# store_id, city, country
'1', 'Lethbridge', 'Canada'
'2', 'Woodridge', 'Australia'
*/
#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name,SUM(amount)
  FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY 2 DESC
LIMIT 0,5;

/*
# name, SUM(amount)
'Sports', '5314.21'
'Sci-Fi', '4756.98'
'Animation', '4656.30'
'Drama', '4587.39'
'Comedy', '4383.58'
*/
SELECT category.name,SUM(amount)
  FROM category,film_category,inventory,rental,payment
 WHERE category.category_id = film_category.category_id
   AND inventory.film_id = film_category.film_id
   AND rental.inventory_id = inventory.inventory_id
   AND payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY 2 DESC
LIMIT 0,5;
/*
# name, SUM(amount)
'Sports', '5314.21'
'Sci-Fi', '4756.98'
'Animation', '4656.30'
'Drama', '4587.39'
'Comedy', '4383.58'
*/
#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_revenue
AS
SELECT category.name,SUM(amount)
  FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON inventory.film_id = film_category.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY 2 DESC
LIMIT 0,5;
#8b. How would you display the view that you created in 8a?
SELECT *
  FROM top_5_revenue;
/*
# name, SUM(amount)
'Sports', '5314.21'
'Sci-Fi', '4756.98'
'Animation', '4656.30'
'Drama', '4587.39'
'Comedy', '4383.58'
*/
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_5_revenue;