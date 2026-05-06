USE sakila;

select lower(TRIM(title)), lower(TRIM(description))
from film;

DELETE FROM film
WHERE film.length <= 0 or film.rating is null;

select lower(trim(f.title)), lower(trim(c.name)), lower(trim(l.name))
FROM film f
	 JOIN film_category fc on f.film_id = fc.film_id
     JOIN category c on fc.category_id = c.category_id
     JOIN language l on f.language_id = l.language_id;
     
SELECT lower(trim(f.title)), i.* FROM inventory i
		 JOIN film f on f.film_id = i.film_id
WHERE i.inventory_id is null;

SELECT *
FROM film_category
WHERE category_id IS NULL;

SELECT fc.*
FROM film_category fc
LEFT JOIN category c on fc.category_id = c.category_id
where c.category_id is null;

SELECT c.name, count(f.title)
FROM film f
	 JOIN film_category fc on f.film_id = fc.film_id
     JOIN category c on fc.category_id = c.category_id
group by name;

SELECT f.title, count(i.inventory_id)
		 FROM inventory i
		 JOIN film f on f.film_id = i.film_id
group by f.film_id;

ALTER TABLE film
ADD COLUMN is_long_film INT;
UPDATE film
SET is_long_film = CASE 
    WHEN length >= 120 THEN 1 
    ELSE 0 
END;
			  
			



