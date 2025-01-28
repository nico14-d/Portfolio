-- Populating the tables with dynamically generated sample data, ensuring that 
-- each table has at least 6+ rows (for a total of 36+ rows across all tables) for the last 3 months.
-- 
-- This script:
-- 1. Utilizes **Common Table Expressions (CTEs)** to structure data insertion dynamically.
-- 2. Prevents **hardcoding** values by referencing existing data where possible.
-- 3. Ensures **data integrity** by checking for duplicates before inserting new records.
-- 4. Implements **case-insensitive comparisons** to avoid redundant entries.
-- 5. Uses **RETURNING** to verify inserted records after execution.


BEGIN;

-- STEP 1a: Define values to be inserted into ticket_types
-- This step uses a CTE to define new ticket types to be added to the table.
WITH new_ticket_types AS (
	SELECT 
		'normal' AS ticket_type_name,
		50.00 AS price,
		'Standard ticket for one person.' AS ticket_description
	UNION ALL
	SELECT 
		'discounted_child',
		25.00,
		'Discounted ticket for children under 12 years.'
	UNION ALL
	SELECT
		'discounted_student',
		30.00,
		'Discounted ticket for students with ID.'
	UNION ALL
	SELECT 
		'disabled',
		20.00,
		'Special ticket for disabled visitors.'
	UNION ALL
	SELECT
		'family',
		125.00,
		'Family ticket for 2 adults and 2 children.'
	UNION ALL
	SELECT
		'group',
		800.00,
		'Group ticket for up to 20 people.'
)

-- STEP 1b: Insert into ticket_types table, ensuring no duplicates
-- This step inserts new ticket types into the table.
-- It checks for duplicates by verifying if a ticket type with the same name already exists.
-- If a duplicate is found, the item will not be inserted.
INSERT INTO museum.ticket_types (ticket_type_name, price, ticket_description)
SELECT
	ntt.ticket_type_name,
	ntt.price, 
	ntt.ticket_description
FROM new_ticket_types AS ntt
WHERE 
	NOT EXISTS ( -- Prevents duplicate entries
		SELECT 1
		FROM museum.ticket_types AS tt
		WHERE LOWER(tt.ticket_type_name) = LOWER(ntt.ticket_type_name) -- Ensures case-insensitive comparison
	)
RETURNING *; -- Returns the inserted rows for verification



-- STEP 2a: Define values to be inserted into inventory
-- This step uses a CTE to define new inventory items to be added to the table.
WITH new_inventory AS (
	SELECT 
		'Tyrannosaurus Rex Skeleton' AS name,
		'Full skeletal structure of a Tyrannosaurus Rex.' AS description,
		'2024-10-15'::DATE AS acquisition_date,
		2500000.00 AS value
	UNION ALL
	SELECT
		'Woolly Mammoth Fossil',
		'Fossilized remains of a prehistoric woolly mammoth.',
		'2024-09-05'::DATE,
		1500000.00
	UNION ALL
	SELECT
		'Stone Tools of Early Humans',
		'Set of stone tools used by early humans.',
		'2024-10-10'::DATE,
		50000.00
	UNION ALL 
	SELECT 
		'Trilobite Fossil',
		'Well-preserved trilobite fossil from the Cambrian era.',
		'2024-11-01'::DATE,
		10000.00
	UNION ALL
	SELECT
		'Dinosaur Egg Fossil',
		'Fossilized dinosaur egg in excellent condition.',
		'2024-10-20'::DATE,
		75000.00
	UNION ALL
	SELECT
		'Saber-Toothed Tiger Skull',
		'Skull of a saber-toothed tiger from the Ice Age.',
		'2024-09-15'::DATE,
		120000.00
)

-- STEP 2b: Insert into inventory table, ensuring no duplicates
-- This step inserts new inventory items into the table.
-- It checks for duplicates by verifying if an item with the same name already exists.
-- If a duplicate is found, the item will not be inserted.
INSERT INTO museum.inventory (name, description, acquisition_date, value)
SELECT
	ni.name,
	ni.description,
	ni.acquisition_date,
	ni.value
FROM new_inventory AS ni 
WHERE 
	NOT EXISTS ( -- Prevents duplicate entries
		SELECT 1
		FROM museum.inventory AS i
		WHERE LOWER(i.name) = LOWER(ni.name) -- Checks if the name already exists in the inventory table
	)
RETURNING *; -- Returns the inserted rows for verification



-- STEP 3a: Define values to be inserted into employees
-- This step uses a CTE to define new employees to be added to the table.
WITH new_employees AS (
	SELECT 
		'John' AS first_name,
		'Doe' AS last_name,
		'Curator' AS employee_position,
		'2024-10-01'::DATE AS hire_date
	UNION ALL
	SELECT 
		'Jane',
		'Smith',
		'Museum Director',
		'2024-11-15'::DATE
	UNION ALL
	SELECT 
		'Emily',
		'Johnson',
		'Exhibition Designer',
		'2024-11-01'::DATE
	UNION ALL
	SELECT 
		'Michael',
		'Brown',
		'Paleontologist',
		'2024-10-10'::DATE
	UNION ALL
	SELECT 
		'Sarah',
		'Davis',
		'Curator',
		'2024-09-20'::DATE
	UNION ALL
	SELECT 
		'David',
		'Miller',
		'Tour Guide',
		'2024-10-01'::DATE
)

-- STEP 3b: Insert into employees table, ensuring no duplicates
-- This step inserts new employees into the table.
-- It checks for duplicates by verifying if an employee with the same first name, last name, and hire date already exists.
-- If a duplicate is found, the employee will not be inserted.
INSERT INTO museum.employees (first_name, last_name, employee_position, hire_date)
SELECT
	ne.first_name,
	ne.last_name,
	ne.employee_position,
	ne.hire_date
FROM new_employees AS ne
WHERE 
	NOT EXISTS ( -- Prevents duplicate entries
		SELECT 1
		FROM museum.employees AS e
		WHERE LOWER(e.first_name) = LOWER(ne.first_name) 
		AND LOWER(e.last_name) = LOWER(ne.last_name)
		AND e.hire_date = ne.hire_date -- Checks if the same employee with the same hire date already exists
	)
RETURNING *; -- Returns the inserted rows for verification



-- STEP 4a: Define values to be inserted into exhibitions
-- This step uses a CTE to define new exhibitions to be added to the table.
WITH new_exhibitions AS (
	SELECT 
		'Age of Dinosaurs' AS exhibition_name,
		1 AS curator_id, -- John Doe
		'2024-10-01'::DATE AS start_date,
		'2024-12-01'::DATE AS end_date
	UNION ALL
	SELECT 
		'Ice Age Giants',
		1, -- John Doe
		'2024-09-01'::DATE,
		'2025-02-01'::DATE
	UNION ALL
	SELECT 
		'Evolution of Early Humans',
		5, -- Sarah Davis
		'2024-10-01'::DATE,
		'2025-01-15'::DATE
	UNION ALL
	SELECT 
		'Fossils of the Cambrian',
		5, -- Sarah Davis
		'2024-10-15'::DATE,
		'2024-11-15'::DATE
	UNION ALL
	SELECT 
		'Jurassic Wonders',
		1, -- John Doe
		'2024-11-01'::DATE,
		'2025-05-01'::DATE
	UNION ALL
	SELECT 
		'Life Underwater',
		5, -- Sarah Davis
		'2024-11-01'::DATE,
		'2025-03-01'::DATE
)

-- STEP 4b: Insert into exhibitions table, ensuring no duplicates
-- This step inserts new exhibitions into the table.
-- It checks for duplicates by verifying if an exhibition with the same name and curator ID already exists.
-- If a duplicate is found, the exhibition will not be inserted.
INSERT INTO museum.exhibitions (exhibition_name, curator_id, start_date, end_date)
SELECT
	ne.exhibition_name,
	ne.curator_id,
	ne.start_date,
	ne.end_date
FROM new_exhibitions AS ne
WHERE 
	NOT EXISTS ( -- Prevents duplicate entries
		SELECT 1
		FROM museum.exhibitions AS e
		WHERE LOWER(e.exhibition_name) = LOWER(ne.exhibition_name) -- Checks if the exhibition name already exists
		AND e.curator_id = ne.curator_id -- Ensures the curator ID is also checked
	)
RETURNING *; -- Returns the inserted rows for verification



-- STEP 5a: Define values to be inserted into exhibition_inventory dynamically with case insensitivity using LOWER
-- This step dynamically maps exhibitions to inventory items based on their names, ignoring case sensitivity.
WITH new_exhibition_inventory AS (
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Age of Dinosaurs')) AS exhibition_id,
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Tyrannosaurus Rex Skeleton')) AS inventory_id
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Age of Dinosaurs')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Dinosaur Egg Fossil'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Ice Age Giants')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Woolly Mammoth Fossil'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Ice Age Giants')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Saber-Toothed Tiger Skull'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Evolution of Early Humans')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Stone Tools of Early Humans'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Fossils of the Cambrian')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Trilobite Fossil'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Jurassic Wonders')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Tyrannosaurus Rex Skeleton'))
	UNION ALL
	SELECT 
		(SELECT exhibition_id FROM museum.exhibitions WHERE LOWER(exhibition_name) = LOWER('Life Underwater')),
		(SELECT inventory_id FROM museum.inventory WHERE LOWER(name) = LOWER('Trilobite Fossil'))
)

-- STEP 5b: Insert into exhibition_inventory table, ensuring no duplicates
-- This step inserts new relationships into the table dynamically.
-- It checks for duplicates by verifying if a combination of exhibition_id and inventory_id already exists.
INSERT INTO museum.exhibition_inventory (exhibition_id, inventory_id)
SELECT
	nei.exhibition_id,
	nei.inventory_id
FROM new_exhibition_inventory AS nei
WHERE 
	NOT EXISTS ( -- Prevents duplicate entries
		SELECT 1
		FROM museum.exhibition_inventory AS ei
		WHERE ei.exhibition_id = nei.exhibition_id -- Checks if the exhibition_id matches
		AND ei.inventory_id = nei.inventory_id -- Checks if the inventory_id matches
	)
RETURNING *; -- Returns the inserted rows for verification



-- STEP 6a: Define values to be inserted into tickets with precise timestamps
-- This step uses a CTE to define new tickets data to be added to the table.
WITH new_tickets AS (
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('family')) AS ticket_type_id, -- family ticket
        '2024-10-04 10:00:00'::TIMESTAMP AS purchase_timestamp,
        1 AS ticket_quantity -- 1 family ticket purchased
    UNION ALL
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('normal')), -- normal tickets
        '2024-10-10 15:00:00'::TIMESTAMP,
        2 -- 2 tickets purchased
    UNION ALL
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('group')), -- group ticket
        '2024-11-05 09:00:00'::TIMESTAMP,
        1 -- 1 group ticket purchased
    UNION ALL
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('normal')), -- normal tickets
        '2024-09-30 17:00:00'::TIMESTAMP,
        3 -- 3 tickets purchased
    UNION ALL
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('normal')), -- single ticket
        '2024-10-01 08:30:00'::TIMESTAMP,
        1 -- 1 ticket purchased
    UNION ALL
    SELECT 
        (SELECT ticket_type_id FROM museum.ticket_types WHERE LOWER(ticket_type_name) = LOWER('normal')), -- normal tickets
        '2024-11-10 10:00:00'::TIMESTAMP,
        4 -- 4 tickets purchased
)

-- STEP 6b: Insert into tickets table, ensuring no duplicates
-- This step inserts new ticket data into the table dynamically.
-- It checks for duplicates by verifying if a combination of ticket_type_id, purchase_timestamp, and ticket_quantity already exists.
INSERT INTO museum.tickets (ticket_type_id, purchase_timestamp, ticket_quantity)
SELECT
    nt.ticket_type_id,
    nt.purchase_timestamp,
    nt.ticket_quantity
FROM new_tickets AS nt
WHERE 
    NOT EXISTS ( -- Prevents duplicate entries
        SELECT 1
        FROM museum.tickets AS t
        WHERE t.ticket_type_id = nt.ticket_type_id -- Checks if the ticket_type_id matches
          AND t.purchase_timestamp = nt.purchase_timestamp -- Checks if the purchase_timestamp matches
          AND t.ticket_quantity = nt.ticket_quantity -- Checks if the ticket_quantity matches
    )
RETURNING *; -- Returns the inserted rows for verification



-- STEP 7a: Define values to be inserted into visitors dynamically
-- This step dynamically maps visit data to tickets based on their IDs.
WITH new_visitors AS (
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-10-04 10:00:00') AS ticket_id, -- family group
        '2024-10-05 14:00:00'::TIMESTAMP AS visit_timestamp
    UNION ALL
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-10-10 15:00:00'), -- couple
        '2024-10-12 09:45:00'::TIMESTAMP
    UNION ALL
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-11-05 09:00:00'), -- school group
        '2024-11-06 12:00:00'::TIMESTAMP
    UNION ALL
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-09-30 17:00:00'), -- friends group
        '2024-10-01 10:15:00'::TIMESTAMP
    UNION ALL
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-10-01 08:30:00'), -- single visitor
        '2024-10-02 11:30:00'::TIMESTAMP
    UNION ALL
    SELECT 
        (SELECT ticket_id FROM museum.tickets WHERE purchase_timestamp = '2024-11-10 10:00:00'), -- group of friends
        '2024-11-12 16:30:00'::TIMESTAMP
)

-- STEP 7b: Insert into visitors table, ensuring no duplicates
-- This step inserts new visitor data into the table dynamically.
-- It checks for duplicates by verifying if a combination of ticket_id and visit_timestamp already exists.
INSERT INTO museum.visitors (ticket_id, visit_timestamp)
SELECT
    nv.ticket_id,
    nv.visit_timestamp
FROM new_visitors AS nv
WHERE 
    NOT EXISTS ( -- Prevents duplicate entries
        SELECT 1
        FROM museum.visitors AS v
        WHERE v.ticket_id = nv.ticket_id -- Checks if the ticket_id matches
          AND v.visit_timestamp = nv.visit_timestamp -- Checks if the visit_timestamp matches
    )
RETURNING *; -- Returns the inserted rows for verification


COMMIT;
