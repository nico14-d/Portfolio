# Task 4: Animation Movies (2017-2019)

## Approach
This task retrieves all animation movies released between 2017 and 2019 with a rental rate greater than 1.

### Solution using JOINs
- Uses `INNER JOIN` to merge `film`, `film_category`, and `category` tables.
- Ensures films without a category are included.
- Filters based on `release_year` and `rental_rate`.

### Solution using a Subquery
- Retrieves films from `film_list` directly, avoiding explicit joins.
- Uses `IN` to filter only animation movies.

## Why two solutions?
- The **JOIN approach** is generally more **efficient**, as it directly connects tables.
- The **subquery approach** is easier to read but can be **less efficient** in large datasets.
