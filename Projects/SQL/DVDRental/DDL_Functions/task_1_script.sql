-- Task 1: Create a View - Sales Revenue by Category and Quarter

-- Solution 1: Using a Standard Query
CREATE OR REPLACE VIEW public.sales_revenue_by_category_qtr AS
SELECT
    c.name AS category_name,
    SUM(p.amount) AS total_sales_revenue -- calculating total revenue by summing payment amounts
FROM public.payment p 
INNER JOIN public.rental r ON p.rental_id = r.rental_id 
INNER JOIN public.inventory i ON r.inventory_id = i.inventory_id 
INNER JOIN public.film_category fc ON i.film_id = fc.film_id 
INNER JOIN public.category c ON fc.category_id = c.category_id 
WHERE EXTRACT(YEAR FROM p.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE) -- filtering for the current year
    AND EXTRACT(QUARTER FROM p.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE) -- filtering for the current quarter
GROUP BY c.name, c.category_id -- grouping by category name and category_id to calculate total revenue per category
HAVING SUM(p.amount) > 0; -- including only categories with non-zero sales revenue in the current quarter


-- Solution 2: Using a CTE
WITH sales_data AS (
    SELECT 
        c.name AS category_name,
        SUM(p.amount) AS total_sales_revenue,
        EXTRACT(YEAR FROM p.payment_date) AS sales_year,
        EXTRACT(QUARTER FROM p.payment_date) AS sales_quarter
    FROM public.payment p 
    INNER JOIN public.rental r ON p.rental_id = r.rental_id 
    INNER JOIN public.inventory i ON r.inventory_id = i.inventory_id 
    INNER JOIN public.film_category fc ON i.film_id = fc.film_id 
    INNER JOIN public.category c ON fc.category_id = c.category_id 
    GROUP BY c.name, c.category_id, sales_year, sales_quarter
)
SELECT category_name, total_sales_revenue
FROM sales_data
WHERE sales_year = EXTRACT(YEAR FROM CURRENT_DATE)
  AND sales_quarter = EXTRACT(QUARTER FROM CURRENT_DATE)
  AND total_sales_revenue > 0;


-- Verification Query (Optional)
SELECT * FROM sales_revenue_by_category_qtr;
