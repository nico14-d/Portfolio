# SQL DDL & Functions for Data Management and Analysis  

## **Project Overview**  
This project includes **DDL (Data Definition Language) operations and SQL functions** designed for the **DVDRental database**. The goal is to demonstrate expertise in **creating views, functions, and stored procedures** that enhance database efficiency, ensure data integrity, and optimize querying for analytical and transactional use cases.  

## **Key Features & Technologies**  

- **PostgreSQL DDL & Functions** – Implementation of `VIEWS`, `FUNCTIONS`, and `STORED PROCEDURES` for structured database management.  
- **Dynamic Sales Reporting** – A view and function to calculate sales revenue per film category for **any quarter**, enabling **real-time and historical reporting**.  
- **Custom Query Functions** – Functions that allow retrieving **the most popular films by country, available films based on partial title searches, and audience preferences**.  
- **Procedural Data Handling** – A procedure for dynamically inserting new films while ensuring **data consistency and avoiding duplicates**.  
- **Optimization with Joins & Aggregation** – Efficiently structured queries using `INNER JOIN`, `GROUP BY`, `HAVING`, `EXTRACT()`, and window functions like `ROW_NUMBER()`.  
- **Error Handling & Case Sensitivity** – Ensuring robustness through **`CASE` statements, `COALESCE()`, and case-insensitive string matching**.  

## **Core Implementations**  

- **Sales Revenue View (`sales_revenue_by_category_qtr`)**: A **dynamic view** that calculates total rental revenue by film category in the **current quarter**.  
- **Revenue Function (`get_sales_revenue_by_category_qtr`)**: A **parameterized function** that allows retrieving sales revenue for any **quarter and year**.  
- **Popular Movies by Country (`most_popular_films_by_countries`)**: A **flexible query function** that retrieves the most rented films in **specified countries**, supporting **multiple country inputs**.  
- **Movie Search Function (`films_in_stock_by_title`)**: A function that returns **available movies based on a title pattern**, leveraging `ILIKE` for case-insensitive searches and `ROW_NUMBER()` for ranking recent rentals.  
- **New Movie Procedure (`new_movie`)**: A procedure to **insert a new movie dynamically**, ensuring it has a **unique ID, default values, and a valid language**, with case-insensitive duplicate prevention.  

## **How to Use?**  

### **Executing the View & Functions**  
1. Ensure the **dvdrental database** is available in **PostgreSQL**.  
2. Execute the DDL script (`create_sales_revenue_by_category_qtr.sql`) to create the **view**.  
3. Run the function scripts (`functions.sql`) to enable **custom data queries**.  
