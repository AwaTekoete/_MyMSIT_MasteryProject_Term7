SELECT
    COUNT(*) FILTER (WHERE cancellation = TRUE) AS cancellations,
    COUNT(*) AS total_sessions,
    ROUND(
        COUNT(*) FILTER (WHERE cancellation = TRUE)::numeric
        / COUNT(*) * 100,
        2
    ) AS cancellation_rate_percent
FROM sessions;