Task 2: Revenue Earned by Each Rental Store Since March 2017

## Approach
This task retrieves the total revenue earned by each rental store from March 2017 onwards.

### Solution using CTE

- Uses a Common Table Expression (CTE) named store_sales to improve readability.
- Joins address, store, inventory, rental, and payment tables.
- Applies COALESCE to handle NULL values in address2.
- Filters based on payment_date to include only payments from March 2017 onwards.
- Aggregates revenue per store.

### Solution using a Standard Query

- Uses direct joins between address, store, inventory, rental, and payment.
- Applies COALESCE to handle NULL values in address2.
- Filters based on payment_date to include only payments from March 2017 onwards.
- Aggregates revenue per store.

### Why two solutions?

- The CTE approach improves readability and allows easier modifications.
- The standard query is slightly more efficient for straightforward aggregations.
- Both approaches produce the same results, but CTE is preferable for complex queries requiring reuse of intermediate results.
