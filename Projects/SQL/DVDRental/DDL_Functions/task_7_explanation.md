# Task 7: Create a Function - Get Most Popular Films by Country  

### Approach  
This task defines a SQL function that retrieves the most popular films in a specified list of countries.  
A film's popularity is determined by the number of times it has been rented in each country.  

### How the function works  
1. The function accepts one parameter:  
   - `countries` (TEXT[]): An array of country names to filter results.  
2. Checks if provided country names exist in the database.  
   - If no valid countries are found, the function returns an empty result with a message.  
3. Joins necessary tables to link rentals with films and customers' country data.  
4. Counts rentals for each film in each country.  
5. Uses a subquery in `HAVING` to return only films with the highest rental count per country.  
6. Orders results alphabetically by country and film title.  
