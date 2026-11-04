SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS SQLVersion,
    sqlserver_start_time AS SQLStartTime,
    DATEDIFF(HOUR, sqlserver_start_time, GETDATE()) AS UptimeHours
FROM sys.dm_os_sys_info;