# MuseumDB: Mini Database for Museum Management


## Project Overview

This project presents a mini relational database for museum management. 
The primary goal was to design a conceptual, logical, and physical model and implement a fully functional PostgreSQL database that efficiently manages museum collections and exhibits.

## Key Features & Technologies:

- **PostgreSQL Database Implementation** – Includes well-defined **tables, relationships, constraints, primary & foreign keys**.  
- **Inventory & Exhibition Management** – Tracks historical items and associates them with museum **exhibitions**.  
- **Employee & Curator Records** – Stores information about museum staff, such as **curators and guides**.  
- **Visitor & Ticketing System** – Manages ticket purchases and visitor attendance using a relational model.  
- **Data Integrity & Duplication Control** – Implements **constraints and validation rules** to ensure consistency.  
- **Stored Functions & Queries** – Custom SQL **procedures** for data updates and ticket transactions.  

## Core Database Components:

- Inventory - Museum collection with acquisition details and estimated value.
- Exhibitions - Thematic displays of artifacts with curator assignments.
- Exhibition Items - Bridge table linking exhibits with their respective exhibitions.
- Employees - Museum staff database, including curators and other personnel.
- Visitors & Tickets - System for tracking ticket purchases and visitor attendance.
- SQL Functions - Custom stored procedures for updating records and managing transactions.


This model serves as a **foundation for museum data management**. It can be **expanded with additional tables** (e.g., donor information, maintenance logs, and event planning) to support more complex museum operations.
