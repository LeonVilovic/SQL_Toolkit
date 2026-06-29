SELECT 
    s.session_id,
    s.login_name,
    r.status,
    r.start_time,
    r.command,
	r.blocking_session_id,
    t.text AS running_query
	
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s
    ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
ORDER BY r.start_time DESC;
