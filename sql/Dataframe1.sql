SELECT 
	c.customer_id,
	LOWER(c.first_name) AS first_name,
	LOWER(c.last_name) AS last_name,
	LOWER(c.email) AS email,
	LOWER(ci.city) AS city,
	LOWER(co.country) AS country,
	r.rental_id,
	r.rental_date,
	r.return_date,
	DATEDIFF(r.return_date, r.rental_date) AS rental_duration_days,
	p.payment_id,
	p.amount,
	p.payment_date
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE 
	r.rental_id IS NOT NULL 
	AND p.payment_id IS NOT NULL
	AND p.amount > 0              
	AND r.return_date IS NOT NULL 
	AND r.rental_date < r.return_date;