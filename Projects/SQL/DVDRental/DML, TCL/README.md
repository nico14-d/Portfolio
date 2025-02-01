# DML & TCL Queries for Data Analysis and Transactions  

## **Project Overview**  
This section contains DML (Data Manipulation Language) queries and TCL (Transaction Control Language) operations designed for the DVDRental database.  
The goal is to analyze rental data, manage transactions, and ensure data consistency, showcasing expertise in data retrieval, filtering, aggregation, and transactional integrity.  

## **Key Features & Technologies**  

- **PostgreSQL DML & TCL Queries** – Structured queries utilizing `SELECT`, `INSERT`, `UPDATE`, `DELETE`, and transaction control (`BEGIN`, `COMMIT`, `ROLLBACK`).  
- **Movie & Rental Analysis** – Queries analyzing **rental revenue, movie popularity, and customer rental behavior**.  
- **Transaction Management** – Ensures **data integrity using transactions** for operations like renting movies and processing payments.  
- **Data Aggregation & Filtering** – Uses **`GROUP BY`, `HAVING`, `ORDER BY`** to summarize key insights.  
- **Handling NULL Values & Data Formatting** – Applies **`COALESCE()`, `STRING_AGG()`** for robust data processing.  
- **Optimized Queries** – Implements **CTEs (Common Table Expressions)** and **window functions** (`RANK()`, `ROW_NUMBER()`, `FETCH FIRST n ROWS WITH TIES`).  

## **Core SQL Queries & Transactions**  

### **Data Analysis (`DML`)**
- **Top 5 Most Rented Movies and Expected Audience Age**  
  - Identifies the **five most rented movies** and determines their expected audience age using **the Motion Picture Association film rating system**.  
  - Uses **CTEs**, `RANK()`, and `FETCH FIRST 5 ROWS WITH TIES` to handle ranking and ties efficiently.  

- **Revenue Earned by Each Rental Store Since March 2017**  
  - Calculates **total rental revenue per store** since **March 2017** using `SUM()`.  
  - Uses **joins between payment, rental, inventory, and store tables**.  
  - Applies `COALESCE()` to handle **NULL values** in addresses.  

- **Animation Movies (2017-2019) with a Rental Rate Greater than 1**  
  - Retrieves **all animation movies released between 2017-2019** with **a rental rate greater than 1**.  
  - Implements **two approaches**: using **JOINs** and **subqueries** to demonstrate different querying techniques.  

### **Transaction Management (`TCL`)**
- **Rent Favorite Movies and Process Payment**  
  - Simulates a **movie rental process** where a customer rents movies and makes a payment.  
  - Uses **a transaction (`BEGIN; COMMIT;`)** to ensure that **rentals and payments are processed together**.  
  - Dynamically retrieves **inventory, customer, and staff data** using **CTEs**.  
  - Uses **`WHERE NOT EXISTS`** to prevent duplicate records.  

## **How to Run the Scripts?**  

The queries are designed for **PostgreSQL** and can be executed in any SQL environment that supports PostgreSQL syntax.  

### **Step-by-Step Execution**
1. Ensure the **dvdrental database** is loaded in PostgreSQL.  
2. Use a database management tool such as **pgAdmin, DBeaver, or psql**.  
3. Run the relevant scripts depending on the use case:  
   - **For data analysis (`DML`)**:  
     ```sql
     SELECT * FROM top_5_most_rented_movies();
     ```
   - **For transactions (`TCL`)**:  
     ```sql
     BEGIN;
     -- Rental transaction script
     COMMIT;
     ```  
