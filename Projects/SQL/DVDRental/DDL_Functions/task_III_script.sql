-- Task 3: Create a Function - Get Most Popular Films by Country

-- The function retrieves the most popular films in each country based on rental frequency.
-- It allows querying multiple countries at once using a text array parameter.

CREATE OR REPLACE FUNCTION public.most_popular_films_by_countries(countries TEXT[])
RETURNS TABLE (
    country TEXT,
    title TEXT, 
    rating public."mpaa_rating",
    language BPCHAR(20),
    length INT2, 
    release_year public."year"
)
LANGUAGE plpgsql
AS $$
DECLARE
    valid_countries INT; -- Counter for valid countries found in the database
BEGIN

    -- Check if countries exist in the database (case-insensitive comparison)
    SELECT COUNT(*)
    INTO valid_countries
    FROM public.country
    WHERE LOWER(public.country.country) = ANY(SELECT LOWER(unnest(countries)));

    -- If no valid countries are found, return an empty result with a message
    IF valid_countries = 0 THEN
        RETURN QUERY
        SELECT 
            'No valid countries provided' AS country, 
            NULL::TEXT AS title, 
            NULL::public."mpaa_rating" AS rating, 
            NULL::BPCHAR(20) AS language, 
            NULL::INT2 AS length, 
            NULL::public."year" AS release_year;
        RETURN;
    END IF;

    -- Retrieve most popular films per country based on rental frequency
    RETURN QUERY
    SELECT 
        ctry.country AS country, 
        f.title AS title, 
        f.rating AS rating,
        l.name AS language, 
        f.length AS length,
        f.release_year AS release_year 
    FROM film f
    INNER JOIN public.inventory i ON f.film_id = i.film_id 
    INNER JOIN public.rental r ON i.inventory_id = r.inventory_id 
    INNER JOIN public.customer c ON r.customer_id = c.customer_id 
    INNER JOIN public.address a ON c.address_id = a.address_id 
    INNER JOIN public.city ct ON a.city_id = ct.city_id 
    INNER JOIN public.country ctry ON ct.country_id = ctry.country_id 
    INNER JOIN public."language" l ON f.language_id = l.language_id 
    WHERE LOWER(ctry.country) = ANY(SELECT LOWER(UNNEST(countries))) -- Filter for provided country list
    GROUP BY ctry.country, f.title, f.rating, l.name, f.length, f.release_year 
    HAVING COUNT(r.rental_id) = ( -- Select films with the highest rental count in each country
        SELECT MAX(count_rentals)
        FROM (
            SELECT COUNT(r2.rental_id) AS count_rentals
            FROM public.film f2
            INNER JOIN public.inventory i2 ON f2.film_id = i2.film_id 
            INNER JOIN public.rental r2 ON i2.inventory_id = r2.inventory_id 
            INNER JOIN public.customer c2 ON r2.customer_id = c2.customer_id 
            INNER JOIN public.address a2 ON c2.address_id = a2.address_id 
            INNER JOIN public.city ct2 ON a2.city_id = ct2.city_id
            INNER JOIN public.country ctry2 ON ct2.country_id = ctry2.country_id 
            WHERE ctry2.country = ctry.country 
            GROUP BY f2.title
        ) AS subquery
    )
    ORDER BY country, title; -- Order results alphabetically by country and film title

END;
$$;
