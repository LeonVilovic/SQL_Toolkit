SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    c.client_net_address,
    s.program_name,
    s.status,
    s.cpu_time,
    s.memory_usage,
    s.total_elapsed_time
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_connections AS c
    ON s.session_id = c.session_id
ORDER BY s.session_id;
