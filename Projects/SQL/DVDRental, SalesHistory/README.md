# DVDRental & SalesHistory Exercises

This folder contains various SQL exercises performed on the publicly available DVDRental and SalesHistory databases. These exercises showcase my skills in data manipulation, transaction management, DDL, and custom function creation.

## DML & TCL Queries for Data Analysis and Transactions (DVDRental)

This section contains DML (Data Manipulation Language) queries and TCL (Transaction Control Language) operations designed for the DVDRental database. The goal is to analyze rental data, manage transactions, and ensure data consistency, showcasing expertise in data retrieval, filtering, aggregation, and transactional integrity.

**Key Features & Technologies:**

*   PostgreSQL DML & TCL Queries – Structured queries utilizing SELECT, INSERT, UPDATE, DELETE, and transaction control (BEGIN, COMMIT, ROLLBACK).
*   Movie & Rental Analysis – Queries analyzing rental revenue, movie popularity, and customer rental behavior.
*   Transaction Management – Ensures data integrity using transactions for operations like renting movies and processing payments.
*   Data Aggregation & Filtering – Uses GROUP BY, HAVING, ORDER BY to summarize key insights.
*   Handling NULL Values & Data Formatting – Applies COALESCE(), STRING_AGG() for robust data processing.
*   Optimized Queries – Implements CTEs (Common Table Expressions) and window functions (RANK(), ROW_NUMBER(), FETCH FIRST n ROWS WITH TIES).

**Core SQL Queries & Transactions:**

*   **Data Analysis (DML)**
    *   [Top 5 Most Rented Movies and Expected Audience Age]([https://github.com/nico14-d/Portfolio/blob/main/Projects/SQL/DVDRental,%20SalesHistory/DML,%20TCL/Task%201:%20Top%205%20Most%20Rented%20Movies%20and%20Expected%20Audience%20Age](https://github.com/nico14-d/Portfolio/blob/main/Projects/SQL/DVDRental%2C%20SalesHistory/DML%2C%20TCL/Task%201%3A%20Top%205%20Most%20Rented%20Movies%20and%20Expected%20Audience%20Age.md))
    *   [Revenue Earned by Each Rental Store Since March 2017](DML_TCL/Revenue_Earned_by_Each_Rental_Store_Since_March_2017.sql)
    *   [Animation Movies (2017-2019) with a Rental Rate Greater than 1](DML_TCL/Animation_Movies_2017_2019_with_a_Rental_Rate_Greater_than_1.sql)
*   **Transaction Management (TCL)**
    *   [Rent Favorite Movies and Process Payment](DML_TCL/Rent_Favorite_Movies_and_Process_Payment.sql)

**How to Run the Scripts?**
The queries are designed for PostgreSQL and can be executed in any SQL environment that supports PostgreSQL syntax.

[**See DML & TCL Code >**](DML_TCL)  

---

## SQL DDL & Functions for Data Management and Analysis (DVDRental)

This project includes DDL (Data Definition Language) operations and SQL functions designed for the DVDRental database. The goal is to demonstrate expertise in creating views, functions, and stored procedures that enhance database efficiency, ensure data integrity, and optimize querying for analytical and transactional use cases.

**Key Features & Technologies:**

*   PostgreSQL DDL & Functions – Implementation of VIEWS, FUNCTIONS, and STORED PROCEDURES for structured database management.
*   Dynamic Sales Reporting – A view and function to calculate sales revenue per film category for any quarter, enabling real-time and historical reporting.
*   Custom Query Functions – Functions that allow retrieving the most popular films by country, available films based on partial title searches, and audience preferences.
*   Procedural Data Handling – A procedure for dynamically inserting new films while ensuring data consistency and avoiding duplicates.
*   Optimization with Joins & Aggregation – Efficiently structured queries using INNER JOIN, GROUP BY, HAVING, EXTRACT(), and window functions like ROW_NUMBER().
*   Error Handling & Case Sensitivity – Ensuring robustness through CASE statements, COALESCE(), and case-insensitive string matching.

**Core Implementations:**

*   Sales Revenue View (sales_revenue_by_category_qtr)
*   Revenue Function (get_sales_revenue_by_category_qtr)
*   Popular Movies by Country (most_popular_films_by_countries)
*   Movie Search Function (films_in_stock_by_title)
*   New Movie Procedure (new_movie)

**How to Use?**

*   Ensure the dvdrental database is available in PostgreSQL.
*   Execute the DDL script (create_sales_revenue_by_category_qtr.sql) to create the view.
*   Run the function scripts (functions.sql) to enable custom data queries.

[**See DDL & Functions Code >**](DDL_Functions)
