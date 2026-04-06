------------------------------------------------------------
-- 0) TEMP-Tabellen aus vorherigen Läufen entfernen
------------------------------------------------------------
DROP TABLE IF EXISTS temp_sessions_gefiltert;
DROP TABLE IF EXISTS temp_user_session_counts;
DROP TABLE IF EXISTS temp_users_aktiv;
DROP TABLE IF EXISTS temp_sessions_aktiv;
DROP TABLE IF EXISTS temp_session_id_aktiv;
DROP TABLE IF EXISTS temp_user_id_aktiv;
DROP TABLE IF EXISTS temp_trip_id_aktiv;
DROP TABLE IF EXISTS temp_users_aktiv_gefiltert;
DROP TABLE IF EXISTS temp_hotels_aktiv;
DROP TABLE IF EXISTS temp_flights_aktiv;

------------------------------------------------------------
-- 1) Sessions filtern: nur ab 2023‑01‑05
------------------------------------------------------------
CREATE TEMP TABLE temp_sessions_gefiltert AS
SELECT *
FROM sessions
WHERE session_start >= '2023-01-05';

------------------------------------------------------------
-- 2) Gruppieren nach user_id und Anzahl Sessions berechnen
------------------------------------------------------------
CREATE TEMP TABLE temp_user_session_counts AS
SELECT
    user_id,
    COUNT(*) AS anzahl_sessions
FROM temp_sessions_gefiltert
GROUP BY user_id;

------------------------------------------------------------
-- 3) Nur aktive User behalten (anzahl_sessions > 7)
------------------------------------------------------------
CREATE TEMP TABLE temp_users_aktiv AS
SELECT *
FROM temp_user_session_counts
WHERE anzahl_sessions > 7;

------------------------------------------------------------
-- 4) Aktive Sessions extrahieren
------------------------------------------------------------
CREATE TEMP TABLE temp_sessions_aktiv AS
SELECT s.*
FROM temp_sessions_gefiltert s
JOIN temp_users_aktiv u USING (user_id);

------------------------------------------------------------
-- 5) Listen erzeugen: session_id, user_id, trip_id (unique)
------------------------------------------------------------
CREATE TEMP TABLE temp_session_id_aktiv AS
SELECT DISTINCT session_id
FROM temp_sessions_aktiv;

CREATE TEMP TABLE temp_user_id_aktiv AS
SELECT DISTINCT user_id
FROM temp_sessions_aktiv;

CREATE TEMP TABLE temp_trip_id_aktiv AS
SELECT DISTINCT trip_id
FROM temp_sessions_aktiv
WHERE trip_id IS NOT NULL;

------------------------------------------------------------
-- 6) Users filtern
------------------------------------------------------------
CREATE TEMP TABLE temp_users_aktiv_gefiltert AS
SELECT u.*
FROM users u
JOIN temp_user_id_aktiv a USING (user_id);

------------------------------------------------------------
-- 7) Hotels filtern
------------------------------------------------------------
CREATE TEMP TABLE temp_hotels_aktiv AS
SELECT h.*
FROM hotels h
JOIN temp_trip_id_aktiv t USING (trip_id);

------------------------------------------------------------
-- 8) Flights filtern
------------------------------------------------------------
CREATE TEMP TABLE temp_flights_aktiv AS
SELECT f.*
FROM flights f
JOIN temp_trip_id_aktiv t USING (trip_id);

------------------------------------------------------------
-- 9) TEMP-Tabellen sichtbar machen (Liste anzeigen)
------------------------------------------------------------
SELECT schemaname, tablename
FROM pg_catalog.pg_tables
WHERE schemaname LIKE 'pg_temp%';

------------------------------------------------------------
-- 10) KPI-Gesamttabelle (eine Zeile)
------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM temp_users_aktiv) AS aktive_nutzer,
    (SELECT COUNT(*) FROM temp_sessions_aktiv) AS aktive_sessions,
    (SELECT COUNT(*) FROM temp_trip_id_aktiv) AS aktive_trips,
    (SELECT COUNT(*) FROM temp_hotels_aktiv) AS aktive_hotels,
    (SELECT COUNT(*) FROM temp_flights_aktiv) AS aktive_flights,
    (SELECT MIN(anzahl_sessions) FROM temp_users_aktiv) AS min_sessions_pro_user,
    (SELECT MAX(anzahl_sessions) FROM temp_users_aktiv) AS max_sessions_pro_user,
    (SELECT AVG(anzahl_sessions) FROM temp_users_aktiv) AS avg_sessions_pro_user,
    (SELECT AVG(hotels_pro_trip)
     FROM (
         SELECT trip_id, COUNT(*) AS hotels_pro_trip
         FROM temp_hotels_aktiv
         GROUP BY trip_id
     ) x) AS avg_hotels_pro_trip,
    (SELECT AVG(flights_pro_trip)
     FROM (
         SELECT trip_id, COUNT(*) AS flights_pro_trip
         FROM temp_flights_aktiv
         GROUP BY trip_id
     ) y) AS avg_flights_pro_trip;

SELECT * FROM temp_sessions_aktiv ORDER BY user_id, session_start;
SELECT * FROM temp_flights_aktiv ORDER BY trip_id;
SELECT * FROM temp_hotels_aktiv order by trip_id;
SELECT * FROM temp_users_aktiv_gefiltert order by user_id;
