-- Task 1.1. All animation movies released between 2017 and 2019 with rate more than 1, alphabetical

-- Retrieve Animation movies (2017-2019) with rental_rate > 1
SELECT 
    f.film_id, 
    f.title,
    f.release_year,
    c.name AS category, -- retrieving category from the category table
	f.rental_rate 
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id -- joining film with film_category table
INNER JOIN category c ON fc.category_id = c.category_id -- joining film_category with category table
WHERE upper(c.name) = 'ANIMATION' -- filtering only Animation movies
	AND f.release_year BETWEEN 2017 AND 2019 -- filtering movies released between 2017 and 2019
	AND f.rental_rate > 1 -- filtering movies with rental_rate greater than 1
ORDER BY f.title ASC; -- sorting results alphabetically by title


-- Alternative approach: using subquery instead of JOINs
SELECT 
    f.film_id, 
    f.title,
    f.release_year,
    f.rental_rate 
FROM film f 
WHERE f.release_year BETWEEN 2017 AND 2019 -- filtering movies released between 2017 and 2019
AND f.rental_rate > 1 -- filtering movies with rental_rate greater than 1
AND f.film_id IN ( -- subquery to filter only movies in the 'Animation' category
    SELECT fl.fid
    FROM film_list fl
    WHERE upper(fl.category) = 'ANIMATION' -- filtering only Animation movies
    )
ORDER BY f.title ASC; -- sorting the result alphabetically by title in ascending order
