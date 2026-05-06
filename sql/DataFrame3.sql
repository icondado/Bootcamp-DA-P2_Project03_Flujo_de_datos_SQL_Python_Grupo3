 -- Autor: Irene Condado Alcantarilla
 --------------------------------------------------------------------------------------
 --  Dataframe 3: Elenco y popularidad
	-- Tablas: film, actor, film_actor
    -- Objetivo: analizar el elenco por película y frecuencia de aparición de actores.
--------------------------------------------------------------------------------------

USE sakila;

show tables;

SELECT *
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id;

-- Limpieza ----------------------------------
-- Estandarizar nombres de actores (LOWER(first_name) y LOWER(last_name)).
-- Eliminar actores duplicados (verificando combinaciones de nombre + apellido).
-- Asegurar que film.film_id y actor.actor_id existan (joins consistentes).
-- Filtrar películas sin actores asociados.
-- Sugerencias adicionales ----------------------------------
-- Generar tabla agregada con:
-- número de actores por película
-- número de películas por actor
-- Crear columna derivada: actor_full_name.

DROP TEMPORARY TABLE IF EXISTS tmp_elenco_enriquecido;

CREATE TEMPORARY TABLE tmp_elenco_enriquecido AS
SELECT 
    f.film_id,
    f.title,
    a.actor_id,
    CONCAT(LOWER(TRIM(a.first_name)), ' ', LOWER(TRIM(a.last_name))) AS actor_full_name,

    (
        SELECT COUNT(*) 
        FROM film_actor fa2
        WHERE fa2.film_id = f.film_id
    ) AS num_actors_per_film,

    (
        SELECT COUNT(*) 
        FROM film_actor fa3
        WHERE fa3.actor_id = a.actor_id
    ) AS num_films_per_actor

FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id;

select * from tmp_elenco_enriquecido;

select count(actor_id) From tmp_elenco_enriquecido;