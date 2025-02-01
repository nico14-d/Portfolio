# DVDRental: DML & TCL Queries for Data Analysis and Transactions  

## **Project Overview**  
This project contains **DML (Data Manipulation Language)** queries and **TCL (Transaction Control Language)** operations designed for the **DVDRental** database.  
The goal is to **analyze rental data, manage transactions, and ensure data consistency**, showcasing expertise in **data retrieval, filtering, aggregation, and transactional integrity**.  

## **Key Features & Technologies**  

- **PostgreSQL DML & TCL Queries** – Structured queries utilizing `SELECT`, `INSERT`, `UPDATE`, `DELETE`, and transaction control (`BEGIN`, `COMMIT`, `ROLLBACK`).  
- **Movie & Rental Analysis** – Queries analyzing **rental revenue, movie popularity, and customer rental behavior**.  
- **Transaction Management** – Ensures **data integrity using transactions** for operations like renting movies and processing payments.  
- **Data Aggregation & Filtering** – Uses **`GROUP BY`, `HAVING`, `ORDER BY`** to summarize key insights.  
- **Handling NULL Values & Data Formatting** – Applies **`COALESCE()`, `STRING_AGG()`** for robust data processing.  
- **Optimized Queries** – Implements **CTEs (Common Table Expressions)** and **window functions** (`RANK()`, `ROW_NUMBER()`, `FETCH FIRST n ROWS WITH TIES`).  

## **Core SQL Queries & Transactions**  

### **Data Analysis (`DML`)**
- **Movie Analysis**: Retrieves **animated movies from 2017-2019** with high ratings.  
- **Revenue Insights**: Calculates **rental store revenue since March 2017**.  
- **Actor Popularity**: Lists the **top 5 actors by the number of movies** since 2015.  
- **Genre Trends**: Analyzes the number of **Drama, Travel, and Documentary films per year**.  
- **Customer Rentals**: Aggregates **rented horror films per customer and total spend**.  
- **Employee Performance**: Identifies the **top 3 revenue-generating employees** in 2017.  
- **Popular Rentals**: Lists the **top 5 most rented movies** and estimates **audience age**.  
- **Actor Career Gaps**: Determines **actors with the longest inactivity periods**.  

### **Transaction Management (`TCL`)**
- **Rental & Payment Transactions**: Ensures **safe processing of rentals and payments** in a single transaction.  
- **Rollback Mechanisms**: Prevents **data corruption** by rolling back transactions on failure.  
- **Inventory Updates**: Safeguards **movie availability** through controlled inventory updates.  
- **Multi-Step Operations**: Uses **multiple CTEs and transactions** to maintain database integrity.  

## **How to Run the Scripts?**  

The queries are designed for **PostgreSQL** and can be executed in any SQL environment that supports PostgreSQL syntax.  
