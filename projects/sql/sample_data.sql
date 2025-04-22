-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

INSERT INTO users VALUES
(1, 'Alice', 'Kyiv', '2024-01-10'),
(2, 'Bob', 'Lviv', '2024-01-12'),
(3, 'Olga', 'Odesa', '2024-01-15'),
(4, 'Ivan', 'Dnipro', '2024-01-20');

-- Sessions table
CREATE TABLE sessions (
    id INT PRIMARY KEY,
    user_id INT,
    session_start DATETIME,
    session_duration INT, -- seconds
    events_count INT
);

INSERT INTO sessions VALUES
(1, 1, '2024-04-01 10:00:00', 180, 3),
(2, 2, '2024-04-01 11:00:00', 60, 1),
(3, 1, '2024-04-02 09:30:00', 200, 4),
(4, 3, '2024-04-02 12:00:00', 120, 2),
(5, 4, '2024-04-03 08:45:00', 90, 1),
(6, 2, '2024-04-03 10:15:00', 150, 2);

-- Traffic sources table
CREATE TABLE traffic_sources (
    user_id INT,
    traffic_source VARCHAR(30)
);

INSERT INTO traffic_sources VALUES
(1, 'organic'),
(2, 'referral'),
(3, 'organic'),
(4, 'social');

-- Events table
CREATE TABLE events (
    id INT PRIMARY KEY,
    session_id INT,
    event_type VARCHAR(30),
    event_time DATETIME
);

INSERT INTO events VALUES
(1, 1, 'page_view', '2024-04-01 10:00:05'),
(2, 1, 'click', '2024-04-01 10:01:00'),
(3, 1, 'form_submit', '2024-04-01 10:02:30'),
(4, 2, 'page_view', '2024-04-01 11:00:10'),
(5, 3, 'page_view', '2024-04-02 09:30:10'),
(6, 3, 'click', '2024-04-02 09:31:00'),
(7, 3, 'scroll', '2024-04-02 09:32:00'),
(8, 3, 'form_submit', '2024-04-02 09:33:20'),
(9, 4, 'page_view', '2024-04-02 12:00:10'),
(10, 4, 'click', '2024-04-02 12:01:00'),
(11, 5, 'page_view', '2024-04-03 08:45:10'),
(12, 6, 'page_view', '2024-04-03 10:15:10'),
(13, 6, 'click', '2024-04-03 10:16:00');