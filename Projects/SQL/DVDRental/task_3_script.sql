BEGIN;

-- Step 1: Identify the customer using name and email information
WITH me AS (
    SELECT customer_id
    FROM public.customer
    WHERE UPPER(first_name) = UPPER('Nicola')
      AND UPPER(last_name) = UPPER('Dudziński')
      AND UPPER(email) = UPPER('nicola.dudzinski@gmail.com')
    LIMIT 1
),

-- Step 2: Prepare rental data with calculated rental_date, return_date, and amount
rental_data AS (
    SELECT
        '2017-02-14'::timestamp AS rental_date,  -- Set rental_date to a fixed date in 2017
        i.inventory_id,
        me.customer_id,
        '2017-02-14'::timestamp + INTERVAL '1 day' * f.rental_duration AS return_date,  -- Calculate return_date based on rental_duration
        (SELECT staff_id FROM public.staff LIMIT 1) AS staff_id,  -- Retrieve an available staff_id
        f.rental_rate AS amount  -- Use the film's rental_rate as the amount to be charged
    FROM public.inventory i 
    INNER JOIN public.film f ON i.film_id = f.film_id
    CROSS JOIN me  -- Cross join with CTE me to access customer_id for each movie
    WHERE UPPER(f.title) IN (UPPER('Alien'), UPPER('Twelve Monkeys'), UPPER('The Big Lebowski'))
),

-- Step 3: Insert rental records into the rental table, only if they do not already exist
inserted_rentals AS (
    INSERT INTO public.rental (rental_date, inventory_id, customer_id, return_date, staff_id)
    SELECT
        rd.rental_date, 
        rd.inventory_id, 
        rd.customer_id, 
        rd.return_date, 
        rd.staff_id
    FROM rental_data AS rd
    WHERE NOT EXISTS (  -- Prevent inserting duplicates
        SELECT 1
        FROM public.rental r
        WHERE r.customer_id = rd.customer_id
          AND r.inventory_id = rd.inventory_id
          AND r.rental_date = rd.rental_date
    )
    RETURNING rental_id, customer_id, inventory_id, return_date AS payment_date  -- Return rental details including rental_id
)

-- Step 4: Insert payment records into the payment table, only if they do not already exist
INSERT INTO public.payment (customer_id, staff_id, rental_id, amount, payment_date)
SELECT 
    ir.customer_id, 
    rd.staff_id,
    ir.rental_id,
    rd.amount,  -- Use rental rate from rental_data as payment amount
    ir.payment_date  -- Set payment_date to the calculated return_date from rental_data
FROM inserted_rentals AS ir
INNER JOIN rental_data rd ON ir.inventory_id = rd.inventory_id AND ir.customer_id = rd.customer_id  -- Match inventory and customer IDs
WHERE NOT EXISTS (  -- Prevent inserting duplicate payments
    SELECT 1
    FROM public.payment p
    WHERE p.customer_id = ir.customer_id
      AND p.rental_id = ir.rental_id
      AND p.payment_date = ir.payment_date
)
RETURNING payment_id, rental_id;  -- Return generated payment_id for verification

-- Step 5 (Optional): Review inserted rental records to verify proper insertion of rentals
WITH me AS (
    SELECT customer_id
    FROM public.customer
    WHERE UPPER(first_name) = UPPER('Nicola')
      AND UPPER(last_name) = UPPER('Dudziński')
      AND UPPER(email) = UPPER('nicola.dudzinski@gmail.com')
    LIMIT 1
)

SELECT rental_id, customer_id, inventory_id, return_date AS payment_date
FROM public.rental
WHERE customer_id = (SELECT customer_id FROM me);  -- Retrieve records based on specific customer_id

COMMIT;
