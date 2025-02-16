# Task 3: Rent Favorite Movies and Process Payment

### Approach  
This task simulates renting specific movies from the store and processing the corresponding payments. The process involves multiple **inserts into the database** while ensuring data integrity.

### Solution using CTEs and Transactions  
- **Transaction Handling (`BEGIN; ... COMMIT;`)**  
  - Ensures data consistency by treating rental and payment inserts as a single atomic operation.
- **Using `me` CTE**  
  - Identifies the customer (`Nicola Dudziński`) using `first_name`, `last_name`, and `email` to ensure accuracy.
- **Using `rental_data` CTE**  
  - Retrieves required rental details, including `inventory_id`, `rental_date`, `return_date`, `staff_id`, and `amount`.
  - Calculates `return_date` dynamically based on the rental duration.
  - Ensures `staff_id` is dynamically retrieved instead of being hardcoded.
- **Inserting Rentals (`INSERT INTO rental`)**  
  - Prevents duplicate rentals using `WHERE NOT EXISTS`.
  - Returns `rental_id` and other relevant data for further processing.
- **Inserting Payments (`INSERT INTO payment`)**  
  - Uses `NOT EXISTS` to ensure payments are not duplicated.
  - Retrieves necessary fields from `rental_data` and previously inserted rentals.
  - Returns the generated `payment_id` for verification.
- **Final Verification (Optional Step)**  
  - A query is executed to check if the rental records were successfully inserted.

### Why this approach?  
- **Ensures data integrity**  
  - Transactions prevent incomplete operations in case of failures.
- **Avoids duplicate inserts**  
  - Uses `NOT EXISTS` to prevent redundant rental or payment records.
- **Dynamic data retrieval**  
  - No hardcoded values for `customer_id`, `staff_id`, or `inventory_id`.
- **CTEs improve readability**  
  - `me` and `rental_data` separate logic for better maintainability.


[**See Code >**](https://github.com/nico14-d/Portfolio/blob/main/Projects/SQL/DVDRental%2C%20SalesHistory/DML%2C%20TCL/task_3_script.sql) 
