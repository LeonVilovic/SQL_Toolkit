SELECT
    DISTINCT
    vs.volume_mount_point AS Drive,
    vs.logical_volume_name AS VolumeName,
    vs.total_bytes / 1024 / 1024 / 1024 AS TotalGB,
    vs.available_bytes / 1024 / 1024 / 1024 AS FreeGB,
    CAST(
        100.0 * vs.available_bytes / vs.total_bytes
        AS DECIMAL(5,2)
    ) AS FreePercent
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(
    mf.database_id, mf.file_id
) vs
ORDER BY FreePercent;