# Task 5: Create a View - Sales Revenue by Category and Quarter  

### Approach  
This task involves creating a view that dynamically calculates total sales revenue for each film category in the current quarter.  
The view updates automatically with new data, ensuring real-time analytics for revenue tracking.  

### Solution using a Standard Query  
- Joins multiple tables to link payments with film categories.  
- Uses `SUM(p.amount)` to aggregate total revenue for each category.  
- Filters data using:  
  - `EXTRACT(YEAR FROM p.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)` (current year)  
  - `EXTRACT(QUARTER FROM p.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE)` (current quarter)  
- Ensures that only categories with at least one sale (`HAVING SUM(p.amount) > 0`) are included.  

### Solution using a CTE  
- The `sales_data` CTE calculates revenue per category, year, and quarter.  
- The main query filters data to show only revenue for the current quarter.  
- The advantage of using a CTE is improved readability and modular query structure.  

### Why two solutions?  
- The standard query approach is efficient and straightforward for generating a real-time view.  
- The CTE approach offers **better query organization** and allows **future modifications** (e.g., tracking past quarters).  


[**See Code >**](https://github.com/nico14-d/Portfolio/blob/main/Projects/SQL/DVDRental%2C%20SalesHistory/DDL_Functions/task_5_script.sql)  
