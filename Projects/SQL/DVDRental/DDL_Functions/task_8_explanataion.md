# Task 8: Create a Function - Get Movies in Stock by Title Pattern  

### Approach  
This task defines a SQL function that retrieves a list of movies available in stock based on a **partial title match**.  
The function allows querying **all movies containing a specified keyword** and returns rental details.  

### How the function works  
1. The function accepts one parameter:  
   - `pattern` (TEXT): A case-insensitive string used to filter movie titles (`ILIKE`).  
2. Uses two Common Table Expressions (CTEs):  
   - `available_films`: Retrieves films whose titles match the given pattern.  
   - `last_rentals`: Retrieves the **five most recent rentals** for each matching film.  
3. Uses the `ROW_NUMBER()` window function:  
   - Assigns a ranking to the last five rentals per movie.  
   - Generates row numbers in the final result.  
4. A `LEFT JOIN` ensures that all matching movies are returned even if they have no rental history.  
5. If no films match the pattern, the function raises a **notice message** informing the user.  
