-- Task 2: Revenue earned by each rental store since March 2017

-- Solution 1: Using CTE
WITH store_sales AS (
    SELECT
        i.store_id,
        CONCAT(a.address, ' ', COALESCE(a.address2, '')) AS full_address, -- Handle NULL values in address2
        p.amount AS income
    FROM address a 
    INNER JOIN store s ON a.address_id = s.address_id 
    INNER JOIN inventory i ON s.store_id = i.store_id 
    INNER JOIN rental r ON i.inventory_id = r.inventory_id 
    INNER JOIN payment p ON r.rental_id = p.rental_id 
    WHERE p.payment_date >= '2017-03-01' -- Only payments since March 2017
)
SELECT 
    full_address,
    SUM(income) AS total_income -- Summing income for each store
FROM store_sales
GROUP BY full_address;

-- Solution 2: Using a standard query without CTE
SELECT 
    CONCAT(a.address, ' ', COALESCE(a.address2, '')) AS full_address, -- Handle NULL values in address2
    SUM(p.amount) AS total_income -- Summing income for each store
FROM address a 
INNER JOIN store s ON a.address_id = s.address_id 
INNER JOIN inventory i ON s.store_id = i.store_id 
INNER JOIN rental r ON i.inventory_id = r.inventory_id 
INNER JOIN payment p ON r.rental_id = p.rental_id 
WHERE p.payment_date >= '2017-03-01' -- Only payments since March 2017
GROUP BY full_address; -- Grouping by concatenated address
