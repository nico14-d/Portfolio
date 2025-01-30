/* 
Step 1: Create the Database
---------------------------
Run the following command in DBeaver to create a new database named "social_media".
This command should be executed while connected to an existing database (e.g., "postgres" or "dvdrental").

CREATE DATABASE social_media;

Step 2: Create a New Database Connection
----------------------------------------
After creating the database, you need to establish a connection to it in DBeaver.
To do this:
1. Click on the "New Connection" button (green plus icon in DBeaver).
2. In the "Select your database" window, choose "PostgreSQL".
3. In the connection settings, set the Database field to "social_media" (leave the Host and Port settings unchanged as default). 
	You should type in the Password that was set during the creation of your PostgreSQL user (the same password you used in pgAdmin or PostgreSQL configuration). 
4. Click **Finish** to create the new connection.

Step 3: Refresh the Database List
-----------------------------------
Once the new connection is created, click on the newly created "social_media" connection in the **Databases** panel on the left side of the DBeaver window. 
You should now see the "social_media" database.

Step 4: Create the Schema
-------------------------
Once connected to the "social_media" database, create a schema to logically group the tables for this project. 
In this case, we will use a schema named "outdoor_sports". 
Run the following command in a new SQL script connected to the "social_media" database:

CREATE SCHEMA IF NOT EXISTS outdoor_sports;

Step 5: Run the Script to Create Tables and Insert Data
-------------------------------------------------------
After creating the schema, you can proceed with the main script to create tables, constraints, and insert data into the "outdoor_sports" schema.

Paste the entire script BELOW for creating tables, constraints, and inserting data.
Ensure you are still connected to the "social_media" database.
*/


-- Creating physical database

-- STEP 1 creating table: locations
CREATE TABLE IF NOT EXISTS outdoor_sports.locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    location_type CHAR(9) NOT NULL,
    parent_location_id INT
);

-- Constraints for table: locations
ALTER TABLE outdoor_sports.locations
ADD CONSTRAINT chk_location_type CHECK (location_type IN ('continent', 'country', 'region')), -- Ensures location_type is a valid value
ADD CONSTRAINT fk_parent_location FOREIGN KEY (parent_location_id) REFERENCES outdoor_sports.locations(location_id); -- Defines hierarchical relationship within locations



-- STEP 2 creating table: users
CREATE TABLE IF NOT EXISTS outdoor_sports.users (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(32) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    location_id INT
);

-- Constraints for table: users
ALTER TABLE outdoor_sports.users
ADD CONSTRAINT fk_user_location FOREIGN KEY (location_id) REFERENCES outdoor_sports.locations(location_id), -- Links each user to a specific location
ADD CONSTRAINT unique_username UNIQUE (username), -- Ensures username is unique across all users
ADD CONSTRAINT chk_registration_date CHECK (registration_date >= '2020-01-01'); -- Ensures registration date is not before January 1, 2000


-- STEP 3 creating table: activities
CREATE TABLE IF NOT EXISTS outdoor_sports.activities (
    activity_id SERIAL PRIMARY KEY,
    activity_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

-- Constraints for table: activities
ALTER TABLE outdoor_sports.activities
ADD CONSTRAINT unique_activity_name UNIQUE (activity_name); -- Ensures each activity has a unique name


-- STEP 4 creating table: user_groups
CREATE TABLE IF NOT EXISTS outdoor_sports.user_groups (
    group_id BIGSERIAL PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL,
    group_description VARCHAR(255) NOT NULL,
    region_id INT NOT NULL,
    activity_id INT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: user_groups
ALTER TABLE outdoor_sports.user_groups
ADD CONSTRAINT unique_group_name UNIQUE (group_name), -- Ensures group names are unique
ADD CONSTRAINT chk_group_description_length CHECK (LENGTH(group_description) >= 16), -- Enforces minimum length for group description
ADD CONSTRAINT fk_group_region FOREIGN KEY (region_id) REFERENCES outdoor_sports.locations(location_id), -- Links group to a specific location/region
ADD CONSTRAINT fk_group_activity FOREIGN KEY (activity_id) REFERENCES outdoor_sports.activities(activity_id), -- Links group to a specific activity
ADD CONSTRAINT chk_creation_date CHECK (creation_date >= '2020-01-01'); -- Ensures group creation date is not before January 1, 2000



-- STEP 5 creating table: user_activities
CREATE TABLE IF NOT EXISTS outdoor_sports.user_activities (
    user_id BIGINT NOT NULL,
    activity_id INT NOT NULL,
    proficiency_level CHAR(12),
    PRIMARY KEY (user_id, activity_id)
);

-- Constraints for table: user_activities
ALTER TABLE outdoor_sports.user_activities
ADD CONSTRAINT fk_user_activity_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Associates user with specific activities
ADD CONSTRAINT fk_user_activity_activity FOREIGN KEY (activity_id) REFERENCES outdoor_sports.activities(activity_id), -- Links activity to the user
ADD CONSTRAINT chk_proficiency_level CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced')); -- Restricts proficiency level to defined values


-- STEP 6 creating table: groups_members
CREATE TABLE IF NOT EXISTS outdoor_sports.groups_members (
    user_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    user_role CHAR(10) NOT NULL DEFAULT 'member',
    PRIMARY KEY (user_id, group_id)
);

-- Constraints for table: groups_members
ALTER TABLE outdoor_sports.groups_members
ADD CONSTRAINT fk_groups_member_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Links group membership to user
ADD CONSTRAINT fk_groups_member_group FOREIGN KEY (group_id) REFERENCES outdoor_sports.user_groups(group_id), -- Links membership to a specific group
ADD CONSTRAINT chk_user_role CHECK (user_role IN ('member', 'moderator', 'admin')); -- Ensures role is either member, moderator, or admin


-- STEP 7 creating table: events
CREATE TABLE IF NOT EXISTS outdoor_sports.events (
    event_id BIGSERIAL PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    activity_id INT NOT NULL,
    event_date DATE NOT NULL,
    location_id INT NOT NULL,
    created_by BIGINT NOT NULL,
    event_description VARCHAR(500)
);

-- Constraints for table: events
ALTER TABLE outdoor_sports.events
ADD CONSTRAINT unique_event_name UNIQUE (event_name), -- Ensures each event name is unique
ADD CONSTRAINT fk_event_activity FOREIGN KEY (activity_id) REFERENCES outdoor_sports.activities(activity_id), -- Links event to specific activity
ADD CONSTRAINT chk_event_date CHECK (event_date >= '2020-01-01'), -- Ensures event date is not before January 1, 2000
ADD CONSTRAINT fk_event_location FOREIGN KEY (location_id) REFERENCES outdoor_sports.locations(location_id), -- Associates event with location
ADD CONSTRAINT fk_event_created_by FOREIGN KEY (created_by) REFERENCES outdoor_sports.users(user_id); -- Specifies user who created the event


-- STEP 8 creating table: events_participants
CREATE TABLE IF NOT EXISTS outdoor_sports.events_participants (
    user_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, event_id)
);

-- Constraints for table: events_participants
ALTER TABLE outdoor_sports.events_participants
ADD CONSTRAINT fk_events_participant_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Links participant to user
ADD CONSTRAINT fk_events_participant_event FOREIGN KEY (event_id) REFERENCES outdoor_sports.events(event_id); -- Links participant to event



-- STEP 9 creating table: posts
CREATE TABLE IF NOT EXISTS outdoor_sports.posts (
    post_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    group_id BIGINT NOT NULL,
    post_content TEXT NOT NULL,
    image_url VARCHAR(500) DEFAULT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: posts
ALTER TABLE outdoor_sports.posts
ADD CONSTRAINT fk_post_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Associates post with user who created it
ADD CONSTRAINT fk_post_group FOREIGN KEY (group_id) REFERENCES outdoor_sports.user_groups(group_id), -- Links post to a specific group
ADD CONSTRAINT chk_image_url CHECK (image_url LIKE 'http%' OR image_url IS NULL), -- Ensures image_url starts with 'http' if provided
ADD CONSTRAINT chk_creation_date_post CHECK (creation_date >= '2020-01-01'); -- Ensures post date is not before January 1, 2000


-- STEP 10 creating table: post_comments
CREATE TABLE IF NOT EXISTS outdoor_sports.post_comments (
    comment_id BIGSERIAL PRIMARY KEY,
    post_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comment_content TEXT NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: post_comments
ALTER TABLE outdoor_sports.post_comments
ADD CONSTRAINT fk_comment_post FOREIGN KEY (post_id) REFERENCES outdoor_sports.posts(post_id), -- Links comment to specific post
ADD CONSTRAINT fk_comment_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Associates comment with the user who made it
ADD CONSTRAINT chk_creation_date_comment CHECK (creation_date >= '2020-01-01'); -- Ensures comment date is not before January 1, 2000


-- STEP 11 creating table: reactions
CREATE TABLE IF NOT EXISTS outdoor_sports.reactions (
    reaction_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    reaction_type BOOLEAN NOT NULL,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: reactions
ALTER TABLE outdoor_sports.reactions
ADD CONSTRAINT fk_reaction_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Links reaction to the user who reacted
ADD CONSTRAINT fk_reaction_post FOREIGN KEY (post_id) REFERENCES outdoor_sports.posts(post_id), -- Links reaction to specific post
ADD CONSTRAINT unique_user_reaction UNIQUE (user_id, post_id), -- Ensures a user can only react once per post
ADD CONSTRAINT chk_creation_date_reaction CHECK (creation_date >= '2020-01-01'); -- Ensures reaction date is not before January 1, 2000


-- STEP 12 creating table: friends
CREATE TABLE IF NOT EXISTS outdoor_sports.friends (
    friendship_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    friend_id BIGINT NOT NULL,
    status CHAR(8) NOT NULL
);

-- Constraints for table: friends
ALTER TABLE outdoor_sports.friends
ADD CONSTRAINT fk_friend_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id), -- Associates friendship record with a user
ADD CONSTRAINT fk_friend_friend FOREIGN KEY (friend_id) REFERENCES outdoor_sports.users(user_id), -- Links friendship to another user
ADD CONSTRAINT unique_friendship UNIQUE (user_id, friend_id), -- Ensures only one friendship status between two users
ADD CONSTRAINT chk_friendship_status CHECK (status IN ('pending', 'rejected', 'accepted')), -- Restricts status to specific values
ADD CONSTRAINT chk_not_self_friend CHECK (user_id <> friend_id); -- Prevents user from being friends with themselves



-- STEP 13 creating table: messages
CREATE TABLE IF NOT EXISTS outdoor_sports.messages (
    message_id BIGSERIAL PRIMARY KEY,
    sender_id BIGINT NOT NULL,
    receiver_id BIGINT NOT NULL,
    message_content TEXT NOT NULL,
    sent_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: messages
ALTER TABLE outdoor_sports.messages
ADD CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES outdoor_sports.users(user_id), -- Links message to sender user
ADD CONSTRAINT fk_message_receiver FOREIGN KEY (receiver_id) REFERENCES outdoor_sports.users(user_id), -- Links message to receiver user
ADD CONSTRAINT chk_sent_date CHECK (sent_date >= '2020-01-01'); -- Ensures message date is not before January 1, 2000


-- STEP 14 creating table: media
CREATE TABLE IF NOT EXISTS outdoor_sports.media (
    media_id BIGSERIAL PRIMARY KEY,
    post_id BIGINT,
    event_id BIGINT,
    media_url VARCHAR(500) NOT NULL,
    media_type CHAR(5) NOT NULL,
    upload_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for table: media
ALTER TABLE outdoor_sports.media
ADD CONSTRAINT fk_media_post FOREIGN KEY (post_id) REFERENCES outdoor_sports.posts(post_id), -- Links media to specific post if applicable
ADD CONSTRAINT fk_media_event FOREIGN KEY (event_id) REFERENCES outdoor_sports.events(event_id), -- Links media to event if applicable
ADD CONSTRAINT chk_media_url CHECK (media_url LIKE 'http%'), -- Ensures media_url starts with 'http'
ADD CONSTRAINT chk_media_type CHECK (media_type IN ('image', 'video', 'gif')), -- Restricts media type to image, video, or gif
ADD CONSTRAINT chk_upload_date CHECK (upload_date >= '2020-01-01'), -- Ensures upload date is not before January 1, 2000
ADD CONSTRAINT chk_post_or_event CHECK ((post_id IS NOT NULL AND event_id IS NULL) OR (post_id IS NULL AND event_id IS NOT NULL)); -- Ensures media is linked to either a post or an event, not both


-- STEP 15 creating table: notification_types
CREATE TABLE IF NOT EXISTS outdoor_sports.notification_types (
    notification_type_id SERIAL PRIMARY KEY,
    notification_type_name VARCHAR(50) NOT NULL
);

-- Constraints for table: notification_types
ALTER TABLE outdoor_sports.notification_types
ADD CONSTRAINT unique_notification_type_name UNIQUE (notification_type_name); -- Ensures each notification type name is unique


-- STEP 16 creating table: notifications
CREATE TABLE IF NOT EXISTS outdoor_sports.notifications (
    notification_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,  -- User receiving the notification
    notification_type INT NOT NULL,
    reference_user_id BIGINT,  -- Reference to another user (e.g., for friend requests)
    reference_event_id BIGINT,  -- Reference to an event (e.g., for event invitations)
    reference_post_id BIGINT,  -- Reference to a post (e.g., for new post notifications)
    message VARCHAR(255) NOT NULL,
    notification_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Constraints for notifications table (ON DELETE CASCADE added to ensure consistency if referenced entities are deleted)
-- The ON DELETE CASCADE option is applied on each reference constraint to ensure that notifications are removed if the 
-- associated user, event, or post is deleted from the database. This approach prevents users from seeing stale or 
-- invalid notifications that reference non-existent entities, such as:
-- - Friend requests from users who deleted their accounts
-- - Event invitations when the event has been canceled or removed
-- - Post notifications when the post is deleted by the author
ALTER TABLE outdoor_sports.notifications
ADD CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES outdoor_sports.users(user_id),  -- Links to the user receiving the notification
ADD CONSTRAINT fk_notification_type FOREIGN KEY (notification_type) REFERENCES outdoor_sports.notification_types(notification_type_id),  -- Links to notification type
ADD CONSTRAINT fk_notification_reference_user FOREIGN KEY (reference_user_id) REFERENCES outdoor_sports.users(user_id) ON DELETE CASCADE,  -- Cascade delete for user references
ADD CONSTRAINT fk_notification_reference_event FOREIGN KEY (reference_event_id) REFERENCES outdoor_sports.events(event_id) ON DELETE CASCADE,  -- Cascade delete for event references
ADD CONSTRAINT fk_notification_reference_post FOREIGN KEY (reference_post_id) REFERENCES outdoor_sports.posts(post_id) ON DELETE CASCADE,  -- Cascade delete for post references
ADD CONSTRAINT chk_notification_date CHECK (notification_date >= '2000-01-01'),  -- Ensures valid notification date
ADD CONSTRAINT chk_single_reference CHECK (
    (reference_user_id IS NOT NULL AND reference_event_id IS NULL AND reference_post_id IS NULL) OR
    (reference_user_id IS NULL AND reference_event_id IS NOT NULL AND reference_post_id IS NULL) OR
    (reference_user_id IS NULL AND reference_event_id IS NULL AND reference_post_id IS NOT NULL)
);  -- Ensures only one reference field is populated per notification


-- Adding a timestamp column 'record_ts' to track when a record was created.
-- This helps in versioning, auditing, and tracking data changes over time.
-- The default value is set to CURRENT_DATE to ensure existing and new records have a timestamp.


ALTER TABLE outdoor_sports.locations
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.users
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.activities
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.user_groups
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.user_activities
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.groups_members
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.events
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.events_participants
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.posts
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.post_comments
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.reactions
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.friends
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.messages
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.media
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.notification_types
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;

ALTER TABLE outdoor_sports.notifications
ADD COLUMN record_ts DATE NOT NULL DEFAULT CURRENT_DATE;


-- Verifying if 'record_ts' has been correctly assigned to all records.
-- If the count is greater than 0, it means some records are missing timestamps.


-- Check if 'record_ts' has been set for all records in the 'locations' table
SELECT COUNT(*) 
FROM outdoor_sports.locations 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'users' table
SELECT COUNT(*) 
FROM outdoor_sports.users 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'activities' table
SELECT COUNT(*) 
FROM outdoor_sports.activities 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'user_groups' table
SELECT COUNT(*) 
FROM outdoor_sports.user_groups 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'user_activities' table
SELECT COUNT(*) 
FROM outdoor_sports.user_activities 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'groups_members' table
SELECT COUNT(*) 
FROM outdoor_sports.groups_members 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'events' table
SELECT COUNT(*) 
FROM outdoor_sports.events 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'events_participants' table
SELECT COUNT(*) 
FROM outdoor_sports.events_participants 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'posts' table
SELECT COUNT(*) 
FROM outdoor_sports.posts 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'post_comments' table
SELECT COUNT(*) 
FROM outdoor_sports.post_comments 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'reactions' table
SELECT COUNT(*) 
FROM outdoor_sports.reactions 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'friends' table
SELECT COUNT(*) 
FROM outdoor_sports.friends 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'messages' table
SELECT COUNT(*) 
FROM outdoor_sports.messages 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'media' table
SELECT COUNT(*) 
FROM outdoor_sports.media 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'notification_types' table
SELECT COUNT(*) 
FROM outdoor_sports.notification_types 
WHERE record_ts IS NULL;

-- Check if 'record_ts' has been set for all records in the 'notifications' table
SELECT COUNT(*) 
FROM outdoor_sports.notifications 
WHERE record_ts IS NULL;
