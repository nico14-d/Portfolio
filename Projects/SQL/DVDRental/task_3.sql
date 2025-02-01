-- Task 3: Top 5 most rented movies and expected audience age

-- Solution 1: Using CTEs (Your Original Approach)
WITH ranked_movies AS (
    SELECT 
        f.film_id,
        f.title,
        f.rating,
        COUNT(r.rental_id) AS number_of_rentals -- counting the number of rentals per film_id
    FROM film f
    INNER JOIN inventory i ON f.film_id = i.film_id 
    INNER JOIN rental r ON i.inventory_id = r.inventory_id 
    GROUP BY f.film_id, f.title, f.rating -- grouping by film_id, title, and rating
    ORDER BY number_of_rentals DESC -- sorting by number of rentals in descending order
),
fifth_place AS (
    SELECT number_of_rentals
    FROM ranked_movies
    ORDER BY number_of_rentals DESC
    OFFSET 4 -- skipping the first four results to get the fifth most rented movie
    LIMIT 1 -- selecting exactly the fifth most rented movie
)

SELECT 
    rm.title,
    rm.rating, 
    rm.number_of_rentals, 
    CASE -- assigning expected audience age based on the movie's rating
        WHEN rm.rating = 'G' THEN 'All Ages'
        WHEN rm.rating = 'PG' THEN '8+'
        WHEN rm.rating = 'PG-13' THEN '13+'
        WHEN rm.rating = 'R' THEN '17+'
        WHEN rm.rating = 'NC-17' THEN '18+'
        ELSE 'Unknown Rating' -- handling cases where the movie doesn't have a rating
    END AS expected_audience_age
FROM ranked_movies rm
JOIN fifth_place fp ON rm.number_of_rentals >= fp.number_of_rentals -- returning movies with rentals >= fifth most rented movie
ORDER BY rm.number_of_rentals DESC; -- sorting the final results by the number of rentals


-- Solution 2: Using RANK() Window Function
WITH ranked_movies AS (
    SELECT 
        f.film_id,
        f.title,
        f.rating,
        COUNT(r.rental_id) AS number_of_rentals,
        RANK() OVER (ORDER BY COUNT(r.rental_id) DESC) AS rank -- assigning rank based on number of rentals
    FROM film f
    INNER JOIN inventory i ON f.film_id = i.film_id 
    INNER JOIN rental r ON i.inventory_id = r.inventory_id 
    GROUP BY f.film_id, f.title, f.rating
)

SELECT title, rating, number_of_rentals, 
       CASE 
           WHEN rating = 'G' THEN 'All Ages'
           WHEN rating = 'PG' THEN '8+'
           WHEN rating = 'PG-13' THEN '13+'
           WHEN rating = 'R' THEN '17+'
           WHEN rating = 'NC-17' THEN '18+'
           ELSE 'Unknown Rating' 
       END AS expected_audience_age
FROM ranked_movies
WHERE rank <= 5 -- selecting all movies that rank within top 5
ORDER BY number_of_rentals DESC;


-- Solution 3: Using FETCH FIRST 5 ROWS WITH TIES
SELECT 
    f.title,
    f.rating,
    COUNT(r.rental_id) AS number_of_rentals,
    CASE 
        WHEN f.rating = 'G' THEN 'All Ages'
        WHEN f.rating = 'PG' THEN '8+'
        WHEN f.rating = 'PG-13' THEN '13+'
        WHEN f.rating = 'R' THEN '17+'
        WHEN f.rating = 'NC-17' THEN '18+'
        ELSE 'Unknown Rating'
    END AS expected_audience_age
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id 
INNER JOIN rental r ON i.inventory_id = r.inventory_id 
GROUP BY f.film_id, f.title, f.rating
ORDER BY number_of_rentals DESC
FETCH FIRST 5 ROWS WITH TIES; -- ensuring all movies with the same rentals as 5th place are included
