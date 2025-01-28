/* 
Step 1: Create the Database
---------------------------
Run the following command in DBeaver to create a new database named "museum_db".
This command should be executed while connected to an existing database (e.g., "postgres").

CREATE DATABASE museum_db;

Step 2: Create a New Database Connection
----------------------------------------
After creating the database, you need to establish a connection to it in DBeaver.
To do this:
1. Click on the "New Connection" button (green plus icon in DBeaver).
2. In the "Select your database" window, choose "PostgreSQL".
3. In the connection settings, set the Database field to "museum_db" (leave the Host and Port settings unchanged as default). 
	You should type in the Password that was set during the creation of your PostgreSQL user (the same password you used in pgAdmin 
	or PostgreSQL configuration). 
4. Click **Finish** to create the new connection.

Step 3: Refresh the Database List
-----------------------------------
Once the new connection is created, click on the newly created "museum_db" connection in the **Databases** panel on the left side 
of the DBeaver window. 
You should now see the "museum_db" database.

Step 4: Create the Schema
-------------------------
Once connected to the "museum_db" database, create a schema to logically group the tables for this project. 
In this case, we will use a schema named "museum". 
Run the following command in a new SQL script connected to the "museum_db" database:

CREATE SCHEMA IF NOT EXISTS museum;

Step 5: Run the Script to Create Tables
-------------------------------------------------------


Use the entire script BELOW for creating schema, tables and constraints.
Ensure you are still connected to the "museum_db" database.
*/



-- Creating physical database

-- STEP 0 creating a schema
CREATE SCHEMA IF NOT EXISTS museum;


-- STEP 1a: Creating table ticket_types
CREATE TABLE IF NOT EXISTS museum.ticket_types (
    ticket_type_id SERIAL PRIMARY KEY, -- unique identifier for ticket types
    ticket_type_name VARCHAR (20) NOT NULL, -- type of ticket (e.g., standard, family)
    price NUMERIC (5,2) NOT NULL, -- price of the ticket
    ticket_description VARCHAR (255) -- description of the ticket conditions
);

-- STEP 1b: Drop constraints if they exist
ALTER TABLE museum.ticket_types
DROP CONSTRAINT IF EXISTS chk_ticket_type,
DROP CONSTRAINT IF EXISTS chk_ticket_price;

-- STEP 1c: Add constraints for table ticket_types
ALTER TABLE museum.ticket_types
ADD CONSTRAINT chk_ticket_type CHECK (
    ticket_type_name IN (
        'normal',
        'discounted_child',
        'discounted_student',
        'disabled',
        'family',
        'group'
    ) -- ensures ticket type is valid
),
ADD CONSTRAINT chk_ticket_price CHECK (price > 0 -- ensures ticket price is greater than 0
);


-- STEP 2a: Creating table inventory
CREATE TABLE IF NOT EXISTS museum.inventory (
    inventory_id SERIAL PRIMARY KEY, -- unique identifier for inventory items
    name VARCHAR (255) NOT NULL, -- name of the inventory item
    description VARCHAR (500) DEFAULT 'No description provided', -- description of the item
    acquisition_date DATE NOT NULL, -- date the item was acquired
    value NUMERIC (10,2) NOT NULL DEFAULT 0.00 -- estimated value of the item
);

-- STEP 2b: Drop constraints if they exist
ALTER TABLE museum.inventory
DROP CONSTRAINT IF EXISTS unique_inventory_name,
DROP CONSTRAINT IF EXISTS chk_acquisition_date,
DROP CONSTRAINT IF EXISTS chk_value;

-- STEP 2c: Add constraints for table inventory
ALTER TABLE museum.inventory
ADD CONSTRAINT unique_inventory_name UNIQUE (name), -- ensures each inventory item has a unique name
ADD CONSTRAINT chk_acquisition_date CHECK (acquisition_date > '2024-07-01'), -- ensures acquisition date is after '2024-07-01'
ADD CONSTRAINT chk_value CHECK (value >= 0); -- ensures value cannot be negative


-- STEP 3a: Creating table employees
CREATE TABLE IF NOT EXISTS museum.employees (
    employee_id SERIAL PRIMARY KEY, -- unique identifier for employees
    first_name VARCHAR (50) NOT NULL, -- employee's first name
    last_name VARCHAR (50) NOT NULL, -- employee's last name
    full_name VARCHAR (101) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED, -- full name of the employee, automatically generated
    employee_position VARCHAR(100) NOT NULL DEFAULT 'General Staff', -- position of the employee in the museum
    hire_date DATE NOT NULL -- date the employee was hired
);

-- STEP 3b: Drop constraints if they exist
ALTER TABLE museum.employees
DROP CONSTRAINT IF EXISTS chk_hire_date;

-- STEP 3c: Add constraints for table employees
ALTER TABLE museum.employees
ADD CONSTRAINT chk_hire_date CHECK (hire_date > '2024-07-01'); -- ensures hire date is after '2024-07-01'


-- STEP 4a: Creating table exhibitions
CREATE TABLE IF NOT EXISTS museum.exhibitions (
    exhibition_id SERIAL PRIMARY KEY, -- unique identifier for exhibitions
    curator_id INT NOT NULL, -- foreign key to reference the curator (employee)
    exhibition_name VARCHAR (255) NOT NULL, -- name of the exhibition
    start_date DATE NOT NULL, -- start date of the exhibition
    end_date DATE NOT NULL -- end date of the exhibition
);

-- STEP 4b: Drop constraints if they exist
ALTER TABLE museum.exhibitions
DROP CONSTRAINT IF EXISTS fk_exhibition_curator,
DROP CONSTRAINT IF EXISTS unique_exhibition_name,
DROP CONSTRAINT IF EXISTS chk_start_date,
DROP CONSTRAINT IF EXISTS chk_end_date,
DROP CONSTRAINT IF EXISTS chk_end_after_start;

-- STEP 4c: Add constraints for table exhibitions
ALTER TABLE museum.exhibitions
ADD CONSTRAINT fk_exhibition_curator FOREIGN KEY (curator_id) REFERENCES museum.employees(employee_id), -- links curator_id to employees table
ADD CONSTRAINT unique_exhibition_name UNIQUE (exhibition_name), -- ensures exhibition names are unique
ADD CONSTRAINT chk_start_date CHECK (start_date > '2024-07-01'), -- ensures start date is after '2024-07-01'
ADD CONSTRAINT chk_end_date CHECK (end_date > '2024-07-01'), -- ensures end date is after '2024-07-01'
ADD CONSTRAINT chk_end_after_start CHECK (end_date > start_date); -- ensures end date is after start date


-- STEP 5a: Creating table exhibition_inventory (bridge table)
CREATE TABLE IF NOT EXISTS museum.exhibition_inventory (
    exhibition_id INT NOT NULL, -- foreign key referencing exhibitions
    inventory_id INT NOT NULL, -- foreign key referencing inventory
    PRIMARY KEY (exhibition_id, inventory_id) -- unique combination of exhibition_id and inventory_id
);

-- STEP 5b: Drop constraints if they exist
ALTER TABLE museum.exhibition_inventory
DROP CONSTRAINT IF EXISTS fk_exhibition_inventory_exhibition,
DROP CONSTRAINT IF EXISTS fk_exhibition_inventory_inventory;

-- STEP 5c: Add constraints for table exhibition_inventory
ALTER TABLE museum.exhibition_inventory
ADD CONSTRAINT fk_exhibition_inventory_exhibition FOREIGN KEY (exhibition_id) REFERENCES museum.exhibitions(exhibition_id), -- links exhibition_id to exhibitions
ADD CONSTRAINT fk_exhibition_inventory_inventory FOREIGN KEY (inventory_id) REFERENCES museum.inventory(inventory_id); -- links inventory_id to inventory


-- STEP 6a: Creating table tickets
CREATE TABLE IF NOT EXISTS museum.tickets (
    ticket_id SERIAL PRIMARY KEY, -- unique identifier for tickets
    ticket_type_id INTEGER NOT NULL, -- foreign key referencing ticket types (to be added later)
    purchase_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- date and time the ticket was purchased
    ticket_quantity INTEGER NOT NULL -- number of tickets purchased
);

-- STEP 6b: Drop constraints if they exist
ALTER TABLE museum.tickets
DROP CONSTRAINT IF EXISTS chk_purchase_timestamp,
DROP CONSTRAINT IF EXISTS chk_ticket_quantity,
DROP CONSTRAINT IF EXISTS fk_tickets_ticket_type;

-- STEP 6c: Add constraints for table tickets
ALTER TABLE museum.tickets
ADD CONSTRAINT chk_purchase_timestamp CHECK (purchase_timestamp > '2024-07-01'), -- ensures purchase timestamp is after '2024-07-01'
ADD CONSTRAINT chk_ticket_quantity CHECK (ticket_quantity > 0), -- ensures ticket quantity is greater than 0
ADD CONSTRAINT fk_tickets_ticket_type FOREIGN KEY (ticket_type_id) REFERENCES museum.ticket_types(ticket_type_id); -- links ticket_type_id to ticket_types table


-- STEP 7a: Creating table visitors
CREATE TABLE IF NOT EXISTS museum.visitors (
    visitor_id SERIAL PRIMARY KEY, -- unique identifier for visitors
    ticket_id INTEGER NOT NULL, -- foreign key referencing tickets 
    visit_timestamp TIMESTAMP NOT NULL -- date and time of the visit
);

-- STEP 7b: Drop constraints if they exist
ALTER TABLE museum.visitors
DROP CONSTRAINT IF EXISTS chk_visit_timestamp,
DROP CONSTRAINT IF EXISTS fk_visitors_tickets;

-- STEP 7c: Add constraints for table visitors
ALTER TABLE museum.visitors
ADD CONSTRAINT chk_visit_timestamp CHECK (visit_timestamp > '2024-07-01'), -- ensures visit timestamp is after '2024-07-01'
ADD CONSTRAINT fk_visitors_tickets FOREIGN KEY (ticket_id) REFERENCES museum.tickets(ticket_id); -- links ticket_id to tickets table
