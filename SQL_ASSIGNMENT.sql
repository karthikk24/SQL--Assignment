use sakila;
# 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
 select upper(concat(first_name ,' ', last_name)) as `Actor Name` from actor ;
 
 # 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
 Select actor_id,first_name, last_name from actor
 where first_name = 'Joe';
 
 # 2b. Find all actors whose last name contain the letters `GEN`:
 Select * from actor where last_name like  '%gen%';
 
# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
Select * from actor where last_name like  '%li%'
order by last_name desc, first_name ;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country 
where country in	 ('Afghanistan', 'Bangladesh','China');

# 3a. You want to keep a description of each actor. 
		# You don't think you will be performing queries on a description, 
		#so create a column in the table `actor` named `description` and use the data type `BLOB` 
		#(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
Alter table actor
add column description blob;
select * from actor limit 100;
#https://dev.mysql.com/doc/refman/5.7/en/blob.html


# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
alter table actor drop column description;
select * from actor limit 100;


# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name from actor where last_name !='';
select count(last_name) from actor where last_name != '';

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name , count(last_name) as count from actor group by last_name having count(*)>1;
#select count(last_name) from actor group by last_name having count(*)>1;

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor 
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

select * from actor where first_name = 'HARPO';

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

update actor 
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';

select * from actor where first_name = 'GROUCHO';
# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table address;
#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address 
from staff 
inner join address on 
staff.address_id = address.address_id;
# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select staff.first_name ,staff.last_name ,sum(payment.amount) as Total  , payment.payment_date
from staff
inner join payment on staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '%2005_08%' group by payment.amount ;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film.title,  COUNT(film_actor.actor_id) AS "Number of Actors" 
FROM film 
INNER JOIN film_actor ON 
film.film_id = film_actor.film_id GROUP BY film.title;

 #6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
 select count(*) as Count from inventory 
 where film_id IN( 
 SELECT film_id FROM film 
 WHERE title = "Hunchback Impossible");
 
 #6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
 SELECT customer.last_name, customer.first_name, SUM(payment.amount) 
 FROM customer 
 INNER JOIN payment ON 
 customer.customer_id = payment.customer_id GROUP BY customer.last_name;
 
 #7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
 SELECT * FROM film 
 WHERE language_id = 1 AND film.title 
 LIKE 'Q%' OR film.title LIKE 'K%';
 
# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT last_name, first_name FROM actor 
WHERE actor_id in (SELECT actor_id FROM film_actor WHERE film_id in (
SELECT film_id FROM film 
WHERE title = "Alone Trip"));

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT country, last_name, first_name, email 
FROM country c 
LEFT JOIN customer cu ON 
c.country_id = cu.customer_id 
WHERE country = 'Canada';

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title, category FROM 
film_list WHERE category = 'Family';

# 7e. Display the most frequently rented movies in descending order.
SELECT i.film_id, f.title, COUNT(r.inventory_id) 
FROM inventory i 
INNER JOIN rental r ON
i.inventory_id = r.inventory_id 
INNER JOIN film_text f ON
i.film_id = f.film_id 
GROUP BY r.inventory_id 
ORDER BY COUNT(r.inventory_id) DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount) 
FROM store INNER JOIN staff ON 
store.store_id = staff.store_id 
INNER JOIN payment p ON 
p.staff_id = staff.staff_id 
GROUP BY store.store_id ORDER BY SUM(amount);

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city, country 
FROM store s INNER JOIN customer cu ON 
s.store_id = cu.store_id 
INNER JOIN address a ON 
cu.address_id = a.address_id 
INNER JOIN city ci ON 
a.city_id = ci.city_id 
INNER JOIN country coun ON
ci.country_id = coun.country_id
WHERE country = 'CANADA' AND country = 'AUSTRAILA';

# 7h. List the top five genres in gross revenue in descending order. (##Hint##: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name, SUM(p.amount) FROM category c 
INNER JOIN film_category fc INNER JOIN inventory i ON 
i.film_id = fc.film_id 
INNER JOIN rental r ON 
r.inventory_id = i.inventory_id INNER JOIN payment p 
GROUP BY name LIMIT 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_five_genres AS
SELECT name, SUM(p.amount) FROM category c 
INNER JOIN film_category fc INNER JOIN inventory i ON 
i.film_id = fc.film_id 
INNER JOIN rental r ON 
r.inventory_id = i.inventory_id INNER JOIN payment p 
GROUP BY name LIMIT 5;

# 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_genres;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_grossing_genres;
 
 