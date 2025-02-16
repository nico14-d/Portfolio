# Task 6: Create a Function - Get Sales Revenue by Category and Quarter  

### Approach  
This task defines a SQL function that retrieves the total sales revenue per film category for a specified quarter and year.  
Unlike a static view, this function allows users to query revenue from any quarter by providing a quarter-year parameter (QYYYY format).  

### How the function works  
1. The function accepts one parameter:  
   - `current_quarter` (INTEGER): Represents the quarter and year in the format QYYYY (e.g., 42024 for Q4 2024).  
2. Extracts the year and quarter from the provided parameter:  
   - `(current_quarter % 10000)` extracts the year (last four digits).  
   - `(current_quarter / 10000)` extracts the quarter (first digit).  
3. Joins necessary tables to associate rental payments with film categories.  
4. Filters payments to include only transactions from the specified quarter and year.  
5. Aggregates total revenue per category using `SUM(p.amount)`.  
6. Excludes categories with zero revenue using `HAVING SUM(p.amount) > 0`.  


[**See Code >**](https://github.com/nico14-d/Portfolio/blob/main/Projects/SQL/DVDRental%2C%20SalesHistory/DDL_Functions/task_6_script.sql) 
