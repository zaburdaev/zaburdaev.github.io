-- 1. Active users per day / Активні користувачі по днях
SELECT DATE(session_start) AS date, COUNT(DISTINCT user_id) AS active_users
FROM sessions
GROUP BY DATE(session_start)
ORDER BY date;

-- 2. Traffic sources / Джерела трафіку
SELECT traffic_source, COUNT(DISTINCT user_id) AS user_count
FROM traffic_sources
GROUP BY traffic_source
ORDER BY user_count DESC;

-- 3. Average session duration / Середня тривалість сесії
SELECT AVG(session_duration) AS avg_duration
FROM sessions;

-- 4. Bounce rate / Відсоток відмов
SELECT
  (SUM(CASE WHEN events_count = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS bounce_rate
FROM sessions;

-- 5. Returning visits / Повторні візити
SELECT user_id, COUNT(*) AS visit_count
FROM sessions
GROUP BY user_id
HAVING visit_count > 1;