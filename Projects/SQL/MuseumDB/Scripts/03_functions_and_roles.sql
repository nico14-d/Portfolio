/*
Function: inventory_update

Description:
This function updates specific columns in the `inventory` table, ensuring data integrity and applying necessary validation rules.

Function Parameters:
1. pk_value (INTEGER): The primary key identifying the row to be updated.
2. column_name (TEXT): The name of the column to be updated.
3. new_value (TEXT): The new value to be inserted.

Restrictions:
- Updates to `inventory_id`, `name`, and `acquisition_date` are not allowed to maintain data integrity.
- The `description` column must not exceed 500 characters.
- The `value` column must be a valid numeric format (NUMERIC(10,2)).

Execution:
- Uses dynamic SQL to update the specified column.
- Enforces validation to prevent invalid updates.
- Returns an error message if an invalid update is attempted.

Example Usage:
SELECT inventory_update (1, 'value', '420000.69');
SELECT inventory_update(1, 'description', 'Updated description.');
SELECT inventory_update(1, 'description', repeat('A', 501)); -- Should return an error.
*/

CREATE OR REPLACE FUNCTION museum.inventory_update (pk_value INT, column_name TEXT, new_value TEXT)
RETURNS VOID
AS $$
DECLARE 
    dynamic_query TEXT;
BEGIN
    -- Restrict updates to specific columns
    IF column_name IN ('name', 'acquisition_date', 'inventory_id') THEN
        RAISE EXCEPTION 'Updating column "%" is not allowed.', column_name;
    END IF;

    -- Apply validation rules
    IF column_name = 'description' AND length(new_value) > 500 THEN
        RAISE EXCEPTION 'Invalid description: length exceeds 500 characters.';
    ELSIF column_name = 'value' AND NOT new_value ~ '^\d+(\.\d{1,2})?$' THEN
        RAISE EXCEPTION 'Invalid value format. Expected NUMERIC(10,2).';
    ELSIF column_name = 'value' AND new_value::NUMERIC > 9999999999.99 THEN
        RAISE EXCEPTION 'Value exceeds allowed range.';
    END IF;

    -- Construct and execute the update query
    IF column_name = 'value' THEN
        dynamic_query := 'UPDATE museum.inventory SET ' || column_name || ' = $1::NUMERIC WHERE inventory_id = $2';
    ELSE
        dynamic_query := 'UPDATE museum.inventory SET ' || column_name || ' = $1 WHERE inventory_id = $2';
    END IF;

    EXECUTE dynamic_query USING new_value, pk_value;
END;
$$ LANGUAGE plpgsql;


/*
Function: add_ticket_transaction

Description:
This function inserts a new transaction into the `tickets` table, ensuring data integrity, price validation, and correct ticket assignment.

Function Parameters:
1. input_ticket_type_name (TEXT): The name of the ticket type being purchased.
2. input_ticket_quantity (INTEGER): The number of tickets being purchased.

Validations:
- Ensures ticket quantity is greater than 0.
- Checks if the ticket type exists in `ticket_types`.
- Retrieves and calculates the total transaction cost.

Execution:
- Inserts a new ticket purchase record into the `tickets` table.
- Raises a notice confirming a successful transaction.

Example Usage:
SELECT museum.add_ticket_transaction('normal', 3);
SELECT museum.add_ticket_transaction('invalid_type', 2); -- Should return an error.
*/

CREATE OR REPLACE FUNCTION museum.add_ticket_transaction (
    input_ticket_type_name TEXT,
    input_ticket_quantity INT
)
RETURNS VOID
AS $$
DECLARE 
    ticket_type_id INT;
    price_per_ticket NUMERIC(5,2);
    total_price NUMERIC(10,2);
BEGIN
    -- Validate quantity
    IF input_ticket_quantity <= 0 THEN
        RAISE EXCEPTION 'Ticket quantity must be greater than 0. Provided: %', input_ticket_quantity;
    END IF;

    -- Find ticket type details
    SELECT tt.ticket_type_id, tt.price
    INTO ticket_type_id, price_per_ticket
    FROM museum.ticket_types tt
    WHERE tt.ticket_type_name = input_ticket_type_name;

    -- Validate ticket type existence
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ticket type "%" does not exist.', input_ticket_type_name;
    END IF;

    -- Calculate total price
    total_price := input_ticket_quantity * price_per_ticket;

    -- Insert transaction
    INSERT INTO museum.tickets (ticket_type_id, ticket_quantity)
    VALUES (ticket_type_id, input_ticket_quantity);

    -- Confirm transaction
    RAISE NOTICE 'Transaction successful: % tickets of type "%" for a total of %.', 
        input_ticket_quantity, input_ticket_type_name, total_price;
END;
$$ LANGUAGE plpgsql;


/*
View: present_analytics

Description:
This view aggregates ticket sales data, presenting key analytics for the most recent quarter.
It calculates total tickets sold, revenue, and unique visitors.

Logic:
1. Determines the most recent quarter from the `tickets` table.
2. Aggregates relevant sales and visitor data.
3. Excludes unnecessary fields (e.g., surrogate keys) and duplicates.

Columns:
- ticket_type: The name of the ticket type.
- total_tickets_sold: Total number of tickets sold per type.
- total_revenue: Total revenue generated per type.
- total_visitors: Number of unique visitors per type.

Example Query:
SELECT * FROM present_analytics;
*/

CREATE OR REPLACE VIEW present_analytics AS
WITH latest_quarter_cte AS (
    SELECT 
        EXTRACT(YEAR FROM MAX(t.purchase_timestamp)) AS latest_year,
        EXTRACT(QUARTER FROM MAX(t.purchase_timestamp)) AS latest_quarter
    FROM museum.tickets AS t
),
aggregated_data AS (
    SELECT 
        tt.ticket_type_name AS ticket_type,
        EXTRACT(MONTH FROM t.purchase_timestamp) AS month,
        SUM(t.ticket_quantity) AS total_tickets_sold,
        SUM(t.ticket_quantity * tt.price) AS total_revenue,
        COUNT(DISTINCT v.visitor_id) AS total_visitors
    FROM museum.tickets AS t
    INNER JOIN museum.ticket_types AS tt ON t.ticket_type_id = tt.ticket_type_id
    LEFT JOIN museum.visitors AS v ON t.ticket_id = v.ticket_id
    WHERE EXTRACT(YEAR FROM t.purchase_timestamp) = (SELECT latest_year FROM latest_quarter_cte)
      AND EXTRACT(QUARTER FROM t.purchase_timestamp) = (SELECT latest_quarter FROM latest_quarter_cte)
    GROUP BY tt.ticket_type_name, EXTRACT(MONTH FROM t.purchase_timestamp)
)
SELECT 
    month,
    ticket_type,
    total_tickets_sold,
    total_revenue,
    total_visitors
FROM aggregated_data
ORDER BY month, ticket_type;


/*
Role: manager (Read-Only)

Description:
This role provides read-only access to the `museum` schema, allowing users to perform `SELECT` queries without modifying data.

Permissions:
- Can log in and execute `SELECT` queries on all tables.
- Cannot modify or create new records.

Verification:
- Use `SET ROLE manager;` to switch to the role and test permissions.

Example Queries:
SELECT * FROM museum.tickets; -- Allowed
CREATE TABLE test_table (id SERIAL PRIMARY KEY, data TEXT); -- Should fail
*/

-- Create a read-only role
CREATE ROLE manager WITH login PASSWORD '1234';

-- Grant read-only access
GRANT USAGE ON SCHEMA museum TO manager;
GRANT SELECT ON ALL TABLES IN SCHEMA museum TO manager;

-- Verify role permissions
SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'manager';

-- Test role permissions
SET ROLE manager;
SELECT * FROM museum.tickets;
CREATE TABLE museum.test_table (id SERIAL PRIMARY KEY, data TEXT); -- Expected to fail
RESET ROLE;
