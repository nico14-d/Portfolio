# Task 3: Top 5 Most Rented Movies and Expected Audience Age

### Approach  
This task identifies the five most rented movies and determines their expected audience age based on the **Motion Picture Association film rating system**.

### Solution using CTE (Common Table Expressions)  
- Uses **two CTEs** to improve readability:
  1. **`ranked_movies`**: Joins `film`, `inventory`, and `rental` tables to count rentals per movie.
  2. **`fifth_place`**: Identifies the number of rentals of the fifth most rented movie using `OFFSET 4 LIMIT 1`.
- The final query retrieves all movies with rentals **greater than or equal** to the fifth most rented movie.
- A **CASE statement** assigns the expected audience age based on movie ratings.

### Solution using RANK()  
- Uses **the `RANK()` window function** to rank movies based on rental count.
- Ensures that **all movies tied at the fifth position are included**.
- The final query filters all movies where `rank <= 5`.

### Solution using FETCH FIRST 5 ROWS WITH TIES  
- Uses **`FETCH FIRST 5 ROWS WITH TIES`**, the simplest method to include tied movies.
- Eliminates the need for subqueries or window functions.
- Orders movies by the number of rentals and selects the top **5 movies plus any ties**.

### Why three solutions?  
- The **CTE approach** is structured and provides flexibility when dealing with large datasets.
- The **`RANK()` function** ensures that **all movies tied at the fifth position are included**, making it more accurate for handling ties.
- The **`FETCH FIRST 5 ROWS WITH TIES`** method is the simplest and most efficient when **only retrieving top-ranked records**.

All three approaches produce the same results but differ in complexity and use case. The choice depends on **performance needs** and **query readability**.
