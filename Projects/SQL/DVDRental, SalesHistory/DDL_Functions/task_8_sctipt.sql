-- Task 8: Create a Function - Get Movies in Stock by Title Pattern

-- The function retrieves a list of movies that are available in stock based on a partial title match.
-- It returns relevant details, including the last five rental records for each matching film.

CREATE OR REPLACE FUNCTION public.films_in_stock_by_title(pattern TEXT)
RETURNS TABLE (
    row_num INTEGER, 
    film_title TEXT, 
    "language" TEXT, 
    customer_name TEXT, 
    rental_date TIMESTAMP 
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH available_films AS (
        -- Identify films in stock that match the provided title pattern
        SELECT 
            f.title AS film_title, 
            l.name::TEXT AS language_name 
        FROM public.film f
        INNER JOIN public."language" l ON f.language_id = l.language_id 
        WHERE f.title ILIKE pattern -- Case-insensitive pattern match for titles
    ),
    last_rentals AS (
        -- Retrieve the last 5 rental records for each matching film
        SELECT 
            f.title AS film_title, 
            c.first_name || ' ' || c.last_name AS customer_name, -- Concatenates customer name
            r.rental_date::TIMESTAMP AS rental_date, -- Rental date of the movie
            ROW_NUMBER() OVER (PARTITION BY f.title ORDER BY r.rental_date DESC) AS rn -- Ranking rentals per movie
        FROM public.film f
        INNER JOIN public.inventory i ON f.film_id = i.film_id 
        INNER JOIN public.rental r ON i.inventory_id = r.inventory_id 
        INNER JOIN public.customer c ON r.customer_id = c.customer_id 
        WHERE f.title ILIKE pattern -- Case-insensitive pattern match for titles
    )
    -- Generate final result set with movie details and up to 5 recent rentals
    SELECT 
        ROW_NUMBER() OVER (ORDER BY af.film_title)::INTEGER AS row_num, -- Assign row numbers
        af.film_title, 
        af.language_name AS "language", 
        lr.customer_name,
        lr.rental_date 
    FROM available_films af
    LEFT JOIN last_rentals lr ON af.film_title = lr.film_title AND lr.rn <= 5 -- Include last 5 rentals for each film
    ORDER BY af.film_title, lr.rental_date DESC; -- Sort by movie title and most recent rental date

    -- Handle case where no films match the pattern
    IF NOT FOUND THEN
        RAISE NOTICE 'No films found for the given pattern: %', pattern; -- Notify if no films match the pattern
    END IF;
END;
$$;
