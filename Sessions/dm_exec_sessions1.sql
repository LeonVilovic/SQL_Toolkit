SELECT 
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    cpu_time,
    memory_usage,
    total_elapsed_time,
    login_time,
    last_request_start_time,
    last_request_end_time
FROM sys.dm_exec_sessions;
