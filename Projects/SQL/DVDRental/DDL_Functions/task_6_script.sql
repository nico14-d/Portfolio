-- Task 6: Create a Function - Get Sales Revenue by Category and Quarter

-- The function retrieves the total sales revenue per category for a specific quarter and year.
-- The parameter format is QYYYY (e.g., 42024 for Q4 2024, 12025 for Q1 2025).
-- The function dynamically filters data to ensure only relevant records are included.

CREATE OR REPLACE FUNCTION public.get_sales_revenue_by_category_qtr(current_quarter INT)
RETURNS TABLE (
    category_name TEXT, 
    total_sales_revenue NUMERIC
) 
AS $$
SELECT 
    c.name AS category_name,
    SUM(p.amount) AS total_sales_revenue
FROM payment p 
INNER JOIN public.rental r ON p.rental_id = r.rental_id -- linking payments to rental records
INNER JOIN public.inventory i ON r.inventory_id = i.inventory_id -- linking rentals to inventory
INNER JOIN public.film_category fc ON i.film_id = fc.film_id -- linking inventory to film categories
INNER JOIN public.category c ON fc.category_id = c.category_id -- retrieving category names
WHERE EXTRACT(YEAR FROM p.payment_date) = (current_quarter % 10000) -- extracting year from parameter
    AND EXTRACT(QUARTER FROM p.payment_date) = (current_quarter / 10000) -- extracting quarter from parameter
GROUP BY c.name, c.category_id -- grouping results by category
HAVING SUM(p.amount) > 0; -- ensuring only categories with revenue are included
$$
LANGUAGE SQL;
