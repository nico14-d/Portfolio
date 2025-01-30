BEGIN;

-- Explanation:
-- This block inserts new locations into the locations table, including "Tatras" and "Dolomites."
-- Each location is checked for uniqueness by location_name and location_type to prevent duplicate entries.

-- Define locations to be inserted
WITH new_locations AS (
    SELECT 
        'Tatras' AS location_name,
        'region' AS location_type
    UNION ALL 
    SELECT 
        'Dolomites', 
        'region'
)

-- Insert into locations table, ensuring no duplicates by name and type
INSERT INTO outdoor_sports.locations (location_name, location_type)
SELECT 
    nl.location_name,
    nl.location_type
FROM new_locations AS nl
WHERE 
    NOT EXISTS (  -- Prevents duplicate entries
        SELECT 1
        FROM outdoor_sports.locations AS l
        WHERE upper(l.location_name) = upper(nl.location_name) 
          AND upper(l.location_type) = upper(nl.location_type)  -- Checks for duplicate name and type
    )
RETURNING *;  -- Returns inserted locations for verification



-- Explanation:
-- This block inserts new users into the users table. Users "nico14d", "johnDoe", and "dude" are added.
-- Each user is checked for uniqueness by username to prevent duplicate entries.

-- Define users to be inserted
WITH new_users AS (
    SELECT 
        'nico14d' AS username,
        'Nicola' AS first_name,
        'Dudzinski' AS last_name,
        'nicola.dudzinski@gmail.com' AS email,
        '1234xd' AS password_hash
    UNION ALL
    SELECT 
        'johnDoe',
        'John',
        'Doe',
        'john.doe@email.com',
        'lalala'
    UNION ALL
    SELECT 
        'dude',
        'Mr',
        'Lebowski',
        'the.dude@gmail.com',
        '1234'
)

-- Insert into users table, ensuring no duplicate usernames
INSERT INTO outdoor_sports.users (username, first_name, last_name, email, password_hash)
SELECT 
    nu.username,
    nu.first_name,
    nu.last_name,
    nu.email,
    nu.password_hash
FROM new_users AS nu
WHERE 
    NOT EXISTS (  -- Prevents duplicate entries based on username
        SELECT 1
        FROM outdoor_sports.users AS u
        WHERE upper(u.username) = upper(nu.username)  -- Checks for duplicate username
    )
RETURNING *;  -- Returns details of inserted users for verification



-- Explanation:
-- This block inserts new activities into the activities table. Activities "Hiking" and "Skiing" are added.
-- Each activity is checked for uniqueness by name to prevent duplicate entries.

-- Define activities to be inserted
WITH new_activities AS (
    SELECT 
        'Hiking' AS activity_name,
        'Outdoor activity involving walking in nature' AS description
    UNION ALL
    SELECT
        'Skiing',
        'Outdoor winter sport involving gliding over snow on skis, typically on mountains or slopes'
)

-- Insert into activities table, ensuring no duplicate activity names
INSERT INTO outdoor_sports.activities (activity_name, description)
SELECT 
    na.activity_name,
    na.description
FROM new_activities AS na
WHERE
    NOT EXISTS (  -- Prevents duplicate entries based on activity_name
        SELECT 1
        FROM outdoor_sports.activities AS a
        WHERE upper(a.activity_name) = upper(na.activity_name)  -- Checks for duplicate activity_name
    )
RETURNING *;  -- Returns details of inserted activities for verification



-- Explanation:
-- This block inserts two new user groups, "Hiking in Tatras" and "Skiing in Dolomites," into the user_groups table.
-- Each group is linked to a specific location and activity.
-- Duplicate group names are avoided by ensuring uniqueness based on the group_name field.

-- Define user groups to be inserted
WITH new_user_groups AS (
    SELECT 
        'Hiking in Tatras' AS group_name,
        'Group for hiking enthusiasts exploring the Tatras mountains.' AS group_description,
        (SELECT location_id FROM outdoor_sports.locations WHERE UPPER(location_name) = UPPER('Tatras')) AS region_id,
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Hiking')) AS activity_id
    UNION ALL 
    SELECT 
        'Skiing in Dolomites',
        'Group for skiing enthusiasts visiting the Dolomites in winter.',
        (SELECT location_id FROM outdoor_sports.locations WHERE UPPER(location_name) = UPPER('Dolomites')),
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Skiing'))
)

-- Insert into user_groups table, ensuring no duplicate group names
INSERT INTO outdoor_sports.user_groups (group_name, group_description, region_id, activity_id)
SELECT
    nug.group_name,
    nug.group_description,
    nug.region_id,
    nug.activity_id
FROM new_user_groups AS nug
WHERE 
    NOT EXISTS (  -- Prevents duplicate entries based on group_name
        SELECT 1
        FROM outdoor_sports.user_groups AS ug
        WHERE upper(ug.group_name) = upper(nug.group_name)  -- Checks for duplicate group_name
    )
RETURNING *;  -- Returns details of inserted groups for verification



-- Explanation:
-- This block inserts two user activities, linking specific users to their respective activities along with their proficiency levels.
-- Duplicate user-activity pairs are avoided by ensuring each combination of user_id and activity_id is unique.

-- Define user activities to be inserted
WITH new_user_activities AS (
    SELECT
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Hiking')) AS activity_id,
        'advanced' AS proficiency_level
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')),
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Skiing')),
        'beginner'
)

-- Insert into user_activities table, ensuring no duplicate user-activity pairs
INSERT INTO outdoor_sports.user_activities (user_id, activity_id, proficiency_level)
SELECT	
    nua.user_id, 
    nua.activity_id,
    nua.proficiency_level
FROM new_user_activities AS nua
WHERE 
    NOT EXISTS (  -- Prevents duplicate entries by ensuring unique user-activity pairs
        SELECT 1
        FROM outdoor_sports.user_activities AS ua
        WHERE ua.user_id = nua.user_id AND ua.activity_id = nua.activity_id  -- Checks for duplicate user-activity pair
    )
RETURNING *;  -- Returns details of inserted user activities for verification



-- Explanation:
-- This block inserts new group members by linking specific users to their respective groups along with assigned roles.
-- Duplicate user-group pairs are avoided by ensuring each combination of user_id and group_id is unique.

-- Define new group members with details
WITH new_groups_members AS (
    SELECT
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        (SELECT group_id FROM outdoor_sports.user_groups WHERE UPPER(group_name) = UPPER('Hiking in Tatras')) AS group_id,
        'admin' AS user_role  -- Assigns admin role to nico14d in the Hiking in Tatras group
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')),
        (SELECT group_id FROM outdoor_sports.user_groups WHERE UPPER(group_name) = UPPER('Skiing in Dolomites')),
        'moderator'  -- Assigns moderator role to johnDoe in the Skiing in Dolomites group
)

-- Insert into groups_members table, ensuring no duplicate user-group pairs
INSERT INTO outdoor_sports.groups_members (user_id, group_id, user_role)
SELECT	
    ngm.user_id,
    ngm.group_id,
    ngm.user_role
FROM new_groups_members AS ngm
WHERE 
    NOT EXISTS (  -- Prevents duplicate user-group entries by ensuring unique pairs
        SELECT 1
        FROM outdoor_sports.groups_members AS gm
        WHERE gm.user_id = ngm.user_id AND gm.group_id = ngm.group_id  -- Checks for duplicate user-group pair
    )
RETURNING *;  -- Returns details of inserted group members for verification



-- Explanation:
-- This block inserts two events, each linked to a specific activity and location, with detailed descriptions. 
-- The first event is a summer hiking event in the Tatras, and the second is a winter skiing event in the Dolomites.
-- Duplicate event names are prevented to ensure each event remains unique.

-- Define event details for two events
WITH new_events AS (
    SELECT 
        'Summer Hiking in Western Tatras 2024. Edition 1' AS event_name,
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Hiking')) AS activity_id,
        '2024-07-09'::DATE AS event_date,  -- Sets event date for the summer hiking event
        (SELECT location_id FROM outdoor_sports.locations WHERE UPPER(location_name) = UPPER('Tatras')) AS location_id,
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS created_by,
        'Join us for the first edition of the Summer Hiking in Western Tatras! ' ||
        'Over a three-day program, we will conquer some of the most popular peaks: ' ||
        'Starorobociański Wierch, the Red Peaks Massif, and explore popular caves including ' ||
        'Jaskinia Harda, Jaskinia Marmurowa, and Jaskinia Miętusia. ' ||
        'Accommodations will be provided at the mountain shelter in Chochołowska Valley ' ||
        'and on Ornak glade.' AS event_description  -- Event description for summer hiking event
    UNION ALL 
    SELECT 
        'Winter Holidays in Dolomites 2025',
        (SELECT activity_id FROM outdoor_sports.activities WHERE UPPER(activity_name) = UPPER('Skiing')),
        '2025-02-14'::DATE,  -- Sets event date for the winter holidays in Dolomites
        (SELECT location_id FROM outdoor_sports.locations WHERE UPPER(location_name) = UPPER('Dolomites')),
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')),
        'Experience the magic of winter in the Dolomites! This exclusive 2025 winter holiday offers ' ||
        'a thrilling program including skiing on some of the most popular slopes, guided snowshoeing tours, ' ||
        'and cozy evenings in a mountain lodge. Participants will explore famous ski trails ' ||
        'and take in breathtaking views of the Dolomite peaks. Accommodations are arranged in a charming lodge ' ||
        'nestled in the heart of the mountains.'  -- Event description for winter holidays
)

-- Insert new values into events table, checking for duplicates
INSERT INTO outdoor_sports.events (event_name, activity_id, event_date, location_id, created_by, event_description)
SELECT
    ne.event_name,
    ne.activity_id,
    ne.event_date,
    ne.location_id,
    ne.created_by,
    ne.event_description
FROM new_events AS ne
WHERE 
    NOT EXISTS (  -- Prevents duplicate event names
        SELECT 1
        FROM outdoor_sports.events AS e
        WHERE e.event_name = ne.event_name  -- Checks for duplicate event_name
    )
RETURNING *;  -- Returns details of inserted events



-- Explanation:
-- This block inserts participants into specific events, linking users to the events they are attending.
-- Each user-event pair is unique, preventing duplicate entries of the same user in the same event.

-- Define event participants with details
WITH new_event_participants AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')) AS user_id,
        (SELECT event_id FROM outdoor_sports.events WHERE UPPER(event_name) = UPPER('Winter Holidays in Dolomites 2025')) AS event_id
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')),
        (SELECT event_id FROM outdoor_sports.events WHERE UPPER(event_name) = UPPER('Summer Hiking in Western Tatras 2024. Edition 1'))
)

-- Insert participants into events_participants table, ensuring no duplicate user-event pairs
INSERT INTO outdoor_sports.events_participants (user_id, event_id)
SELECT
    nep.user_id,
    nep.event_id
FROM new_event_participants AS nep
WHERE 
    NOT EXISTS (  -- Prevents duplicate user-event pairs
        SELECT 1
        FROM outdoor_sports.events_participants AS ep
        WHERE ep.user_id = nep.user_id AND ep.event_id = nep.event_id  -- Checks for duplicate user-event pair
    )
RETURNING *;  -- Returns details of inserted event participants for verification



-- Explanation:
-- This block inserts new posts made by users in specific groups with accompanying content and image URLs.
-- No duplicate check is applied here. As this is a social platform, users may post content that is identical or similar
-- over time, such as recurring questions about trails or accommodations.

-- Define new posts with content and image URLs
WITH new_posts AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        (SELECT group_id FROM outdoor_sports.user_groups WHERE UPPER(group_name) = UPPER('Hiking in Tatras')) AS group_id,
        'Looking for the best one-day trails in the Tatras under 30 km? Here are three recommendations: ' ||
        '1. Kasprowy Wierch via Gąsienicowa Valley – scenic views and a challenging ascent. ' ||
        '2. Czarny Staw Gąsienicowy and Zawrat – a beautiful high-altitude hike. ' ||
        '3. Morskie Oko to Rysy – the highest peak in Poland with breathtaking vistas. Perfect for a full day adventure!' AS post_content,
        'https://examplehikingblog.com/trails/tatra-top-day-hikes' AS image_url
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')),
        (SELECT group_id FROM outdoor_sports.user_groups WHERE UPPER(group_name) = UPPER('Skiing in Dolomites')),
        'Looking for recommendations on the best places to stay near the ski routes in the Dolomites. ' ||
        'Any suggestions for cozy mountain lodges or hotels with great access to the slopes? ' ||
        'I’d love to hear about any hidden gems or must-visit spots!' AS post_content,
        'https://examplehikingforum.com/discussions/dolomites-accommodation' AS image_url
)

-- Insert posts into posts table without duplicate checks
INSERT INTO outdoor_sports.posts (user_id, group_id, post_content, image_url)
SELECT	
    np.user_id,
    np.group_id,
    np.post_content,
    np.image_url
FROM new_posts AS np
RETURNING *; -- Returns details of inserted posts



-- Explanation:
-- This block inserts new comments on a specific post identified by content keywords and group.
-- Duplicate check is not applied as users on this social platform can post identical or similar comments over time.
-- This flexibility allows users to repeat questions, provide similar feedback, or post the same comment accidentally or intentionally.

-- Define comments for a specific post
WITH new_post_comments AS (
    SELECT 
        (SELECT post_id FROM outdoor_sports.posts 
         WHERE UPPER(post_content) LIKE UPPER('%best one-day trails in the tatras%')
         	AND group_id = (
            	SELECT group_id 
             	FROM outdoor_sports.user_groups 
             	WHERE UPPER(group_name) = UPPER('Hiking in Tatras')
             	LIMIT 1)) AS post_id,  -- Selects post based on content and group
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')) AS user_id,
        'Great suggestions! I’ll definitely try out these trails.' AS comment_content
    UNION ALL 
    SELECT 
        (SELECT post_id FROM outdoor_sports.posts 
         WHERE UPPER(post_content) LIKE UPPER('%best one-day trails in the tatras%')
         	AND group_id = (
            	SELECT group_id 
            	FROM outdoor_sports.user_groups 
            	WHERE UPPER(group_name) = UPPER('Hiking in Tatras')
            	LIMIT 1)) AS post_id,
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        'If you want more suggestions pls dm' AS comment_content
)

-- Insert comments into post_comments table without duplicate restrictions
INSERT INTO outdoor_sports.post_comments (post_id, user_id, comment_content)
SELECT
    npc.post_id,
    npc.user_id,
    npc.comment_content
FROM new_post_comments AS npc
RETURNING *; -- Returns details of inserted comments for verification



-- Explanation:
-- Step 1: Define two reactions, dynamically identifying post IDs based on content and group.
-- Step 2: Insert reactions while avoiding duplicates, ensuring each user can react only once per post.

-- Step 1: Define reactions for specific posts
WITH new_reactions AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        (SELECT post_id FROM outdoor_sports.posts
         WHERE UPPER(post_content) LIKE UPPER('%best one-day trails in the tatras%')
         AND group_id = (
             SELECT group_id
             FROM outdoor_sports.user_groups
             WHERE UPPER(group_name) = UPPER('Hiking in Tatras')
             LIMIT 1)) AS post_id,  -- Reaction to post about hiking trails in Tatras
        TRUE AS reaction_type  -- Thumbs up reaction (boolean 1 represents a positive reaction)
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')),
        (SELECT post_id FROM outdoor_sports.posts
         WHERE UPPER(post_content) LIKE UPPER('%ski routes in the Dolomites%')
         AND group_id = (
             SELECT group_id
             FROM outdoor_sports.user_groups
             WHERE UPPER(group_name) = UPPER('Skiing in Dolomites')
             LIMIT 1)),  -- Reaction to post about accommodation in the Dolomites
        TRUE  -- Thumbs up reaction (boolean 1 represents a positive reaction)
)

-- Step 2: Insert reactions into reactions table, ensuring no duplicates
INSERT INTO outdoor_sports.reactions (user_id, post_id, reaction_type)
SELECT
    nr.user_id,
    nr.post_id,
    nr.reaction_type
FROM new_reactions AS nr
WHERE 
    NOT EXISTS (  -- Prevents duplicate reactions by the same user on the same post
        SELECT 1
        FROM outdoor_sports.reactions r
        WHERE r.user_id = nr.user_id AND r.post_id = nr.post_id -- UNIQUE constraint on (user_id, post_id) further enforces this.
    )
RETURNING *;  -- Returns all inserted reactions for verification



-- Explanation:
-- Step 1: Define two friendships between users, dynamically identifying user IDs based on usernames.
-- Step 2: Insert friendship records while avoiding duplicates. The platform ensures only unique friendships (one per user pair).

-- Step 1: Define new friendships
WITH new_friends AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')) AS user_id,
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS friend_id,
        'accepted' AS status  -- Defines the status of friendship as accepted
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')),
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('johnDoe')),
        'pending' -- Defines the status of friendship as pending
)

-- Step 2: Insert friendships into friends table, ensuring no duplicates
INSERT INTO outdoor_sports.friends (user_id, friend_id, status)
SELECT
    nf.user_id,
    nf.friend_id,
    nf.status
FROM new_friends AS nf
WHERE 
    NOT EXISTS (  -- Prevents duplicate friendships by checking if the same user_id and friend_id pair already exists
        SELECT 1
        FROM outdoor_sports.friends AS f
        WHERE f.user_id = nf.user_id AND f.friend_id = nf.friend_id
    )
RETURNING *;  -- Returns all inserted friendships for verification



-- Explanation:
-- Step 1: Define two messages dynamically, identifying sender and receiver IDs based on usernames.
-- Step 2: Insert messages into the messages table. No duplicate condition is applied here, as users can send identical messages freely.

-- Step 1: Define messages between users
WITH new_messages AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')) AS sender_id,
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS receiver_id,
        'yo dude' AS message_content
    UNION ALL
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')),
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')),
        'yo, what/’s up?' AS message_content  -- Corrected quotes for the message text
)

-- Step 2: Insert messages into messages table
INSERT INTO outdoor_sports.messages (sender_id, receiver_id, message_content)
SELECT
    nm.sender_id,
    nm.receiver_id,
    nm.message_content
FROM new_messages AS nm
RETURNING *;  -- Returns all inserted messages for verification



-- Explanation:
-- Step 1: Define media entries, dynamically identifying post or event ID for each media item.
-- Step 2: Insert media entries while avoiding duplicates, ensuring each media item is associated only with either a post or an event.

-- Step 1: Define new media items
WITH new_media AS (
	SELECT 
		(SELECT post_id FROM outdoor_sports.posts 
         WHERE UPPER(post_content) LIKE UPPER('%best one-day trails in the tatras%')) AS post_id,
		NULL AS event_id,  -- Set event_id as NULL since this media is linked to a post
		'https://examplemedia.com/videos/tatra-trails.mp4' AS media_url,  -- Example video URL for Tatra trails
		'video' AS media_type
	UNION ALL 
	SELECT 
		NULL,  -- Set post_id as NULL since this media is linked to an event
		(SELECT event_id FROM outdoor_sports.events
         WHERE UPPER(event_name) LIKE UPPER('%Western Tatras 2024. Edition 1')),
		'https://examplemedia.com/images/western-tatras-2024.jpg',
		'image'
)

-- Step 2: Insert media items into media table, ensuring no duplicates
INSERT INTO outdoor_sports.media (post_id, event_id, media_url, media_type)
SELECT 
	nm.post_id,
	nm.event_id,
	nm.media_url,
	nm.media_type
FROM new_media AS nm
WHERE 
	NOT EXISTS (  -- Prevents duplicate media entries based on post/event ID and media_url
		SELECT 1
		FROM outdoor_sports.media AS m
		WHERE (m.post_id = nm.post_id AND m.media_url = nm.media_url) 
		OR (m.event_id = nm.event_id AND m.media_url = nm.media_url)
	)
RETURNING *;  -- Returns all inserted media items for verification



-- Explanation:
-- Step 1: Define two notification types to represent common user notifications.
-- Step 2: Insert notification types into notification_types table without duplicate checks, as uniqueness is ensured by a unique constraint.

-- Step 1: Define new notification types
WITH new_notification_types AS (
	SELECT 
		'New Friend Request' AS notification_type_name  -- Notification for new friend requests
	UNION ALL
	SELECT
		'New Event Invitation'  -- Notification for new event invitations
)

-- Step 2: Insert notification types into notification_types table
INSERT INTO outdoor_sports.notification_types (notification_type_name)
SELECT
	ntt.notification_type_name
FROM new_notification_types AS ntt
RETURNING *;  -- Returns all inserted notification types for verification



-- Explanation:
-- Step 1: Define new notifications with specific user, notification type, and references.
-- Step 2: Insert notifications into the notifications table, ensuring no duplicates, 
-- so that only unique notifications are added.

-- Step 1: Define new notifications for specific users
WITH new_notifications AS (
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('nico14d')) AS user_id,
        (SELECT notification_type_id FROM outdoor_sports.notification_types WHERE UPPER(notification_type_name) = UPPER('New Friend Request')) AS notification_type,
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')) AS reference_user_id,  -- Refers to friend request
        NULL::BIGINT AS reference_event_id,  -- Explicitly cast NULL to BIGINT due to PostgreSQL's default NULL as TEXT in CTEs
        NULL::BIGINT AS reference_post_id,  -- Explicitly cast NULL to BIGINT due to PostgreSQL's default NULL as TEXT in CTEs
        'You have a new friend request' AS message
    UNION ALL 
    SELECT 
        (SELECT user_id FROM outdoor_sports.users WHERE UPPER(username) = UPPER('dude')),
        (SELECT notification_type_id FROM outdoor_sports.notification_types WHERE UPPER(notification_type_name) = UPPER('New Event Invitation')),
        NULL::BIGINT,  -- Explicitly cast NULL to BIGINT due to PostgreSQL's default NULL as TEXT in CTEs
        (SELECT event_id FROM outdoor_sports.events WHERE UPPER(event_name) = UPPER('Winter Holidays in Dolomites 2025')),   -- Refers to event invitation
        NULL::BIGINT,  -- Explicitly cast NULL to BIGINT due to PostgreSQL's default NULL as TEXT in CTEs
        'You have a new event invitation'
)

-- Step 2: Insert notifications into notifications table, ensuring no duplicate notifications
INSERT INTO outdoor_sports.notifications (user_id, notification_type, reference_user_id, reference_event_id, reference_post_id, message)
SELECT
    nn.user_id,
    nn.notification_type,
    nn.reference_user_id,
    nn.reference_event_id,
    nn.reference_post_id,
    nn.message
FROM new_notifications AS nn
WHERE 
    NOT EXISTS (  -- Prevent duplicate notifications
        SELECT 1 
        FROM outdoor_sports.notifications n
        WHERE n.user_id = nn.user_id 
          AND n.notification_type = nn.notification_type
          AND COALESCE(n.reference_user_id, -1) = COALESCE(nn.reference_user_id, -1) -- Uses COALESCE to handle NULL values; -1 acts as a placeholder to treat NULLs as equivalent
          AND COALESCE(n.reference_event_id, -1) = COALESCE(nn.reference_event_id, -1) -- COALESCE with -1 ensures NULLs are handled consistently for comparison
          AND COALESCE(n.reference_post_id, -1) = COALESCE(nn.reference_post_id, -1) -- COALESCE with -1 ensures NULLs are handled consistently for comparison
    )
RETURNING *;  -- Returns inserted notifications for verification


COMMIT;
