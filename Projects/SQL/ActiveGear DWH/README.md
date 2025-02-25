# Data Warehouse for ActiveGear

## Project Overview

This project focuses on building a Data Warehouse (DWH) for ActiveGear, a sporting goods retailer. The goal is to create a robust, scalable, and well-documented DWH solution that enables in-depth sales data analysis and supports data-driven decision-making within the company. The project encompasses data modeling, ETL processes, and DWH implementation, adhering to industry best practices and naming conventions.

The DWH is designed to consolidate data from two simulated CSV files (online and in-store sales data) into a structured format optimized for analytical queries. The project includes the creation of both a 3NF (Third Normal Form) model for data integrity and a Dimensional Model (Star Schema) for efficient analytical reporting. Key decisions include a transaction-level granularity, SCD Type 2 implementation for product dimension, and comprehensive naming conventions for all database objects.

A key aspect of this project is the implementation of automated ETL processes using stored procedures, a custom logging function, and a dedicated logging table to track data lineage, monitor performance, and capture errors during data loading.

The ultimate objective is to provide ActiveGear with the ability to analyze sales trends, understand customer behavior, and optimize business strategies related to product offerings, marketing campaigns, and resource allocation.

## Key Features & Technologies:

*   **Data Modeling (3NF & Dimensional)** – Designed and implemented both a 3NF model (BL_3NF) to minimize data redundancy and a Dimensional Model (BL_DM) optimized for OLAP queries. Detailed table structures for both layers are described in the dedicated section.
*   **ETL Processes** – Developed automated ETL processes using stored procedures to extract, transform, and load data from CSV files into a staging area (SA), 3NF layer, and finally into the Dimensional Model.
*   **Automated ETL with Stored Procedures:** Created stored procedures in the cleaning layer (BL_CL) to automate the data loading process from the staging area to the 3NF and DM layers.
*   **SCD Type 2 Implementation** – Implemented SCD Type 2 logic for the `DIM_PRODUCTS_SCD` dimension to track historical changes in product attributes.
*   **Logging Functionality** - Implemented a custom logging function and trigger on a dedicated logging table to track ETL process execution, row counts, status, and error messages.
*   **Naming Conventions** – Adhered to strict naming conventions based on the "INITIAL GUIDELINES OF STAR AGGREGATION LAYER MODELING" document to ensure consistency and readability.
*   **Surrogate Keys** - Utilized sequences to generate surrogate keys for all dimension tables to ensure data integrity and efficient querying.
*   **Data Staging** – Created staging area (SA) with external and source tables to facilitate data loading and transformation processes.
*   **DDL/DML Scripting** – Developed reusable DDL and DML scripts for creating and populating all database objects in the DWH.
*   **Data Quality and Monitoring:** Implemented a custom logging mechanism to monitor the ETL process, track row counts, and capture any errors encountered during data loading.

## Core Analysis Components:

The project focuses on building a robust and well-structured data warehouse, including:

*   **Data Sourcing & Staging:** Extraction of data from `online_sales` and `instore_sales` CSV files into the staging area (schemas `sa_online_sales` and `sa_instore_sales`).
*   **3NF Layer (BL_3NF):** Creation of core entity tables (CE_*) following the Third Normal Form, including SCD Type 2 implementation for `CE_PRODUCTS_SCD`.
*   **Dimensional Model (BL_DM):** Design and implementation of the Star Schema, including dimension tables (DIM_*) and fact table (`FCT_SALES_DD`).
*   **Automated ETL Processes:** Implemented automated ETL processes using stored procedures, a custom logging function, and a dedicated logging table to track data lineage, monitor performance, and capture errors during data loading.

## Table Structures

### 3NF (BL_3NF) Layer

This layer focuses on minimizing data redundancy and ensuring data integrity.

*   **CE_CUSTOMERS:** Stores customer information.
*   **CE_PRODUCTS_SCD:** Stores product information with SCD Type 2 implementation.
*   **CE_PAYMENTS:** Stores payment method information.
*   **CE_SHIPPING:** Stores shipping method information.
*   ... (and other core entity tables)

### Dimensional Model (BL_DM) Layer

This layer is optimized for analytical queries and reporting.

*   **DIM_CUSTOMERS:** Customer dimension table.
*   **DIM_PRODUCTS_SCD:** Product dimension table (SCD Type 2).
*   **DIM_PAYMENTS:** Payment dimension table.
*   **DIM_SHIPPING:** Shipping dimension table.
*   **FCT_SALES_DD:** Fact table containing sales transaction data.

This DWH provides a **solid foundation for analytical reporting and data-driven decision-making** at ActiveGear. It enables the company to **gain valuable insights into sales performance, customer behavior, and product trends.** Future enhancements could include integration with additional data sources, implementation of more advanced analytics techniques, and the development of interactive dashboards.

[**See the Code >**]([URL do GitHub Repository]) (Replace with the link to your GitHub repository)

---

**Note:** This project is still under development, but the core components are functional. Future enhancements will focus on:

*   Implementing more robust error handling and data validation processes.
*   Optimizing ETL scripts for performance and scalability.
*   Developing comprehensive documentation for all database objects and ETL processes.
*   Adding unit tests to ensure data quality and integrity.

I am continuously learning and improving my skills, and I welcome any feedback or suggestions for improvement.
