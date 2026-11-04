SELECT
    DB_NAME(ips.database_id) AS DatabaseName,
    OBJECT_NAME(ips.object_id, ips.database_id) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(
    DB_ID(), NULL, NULL, NULL, 'LIMITED'
) ips
JOIN sys.indexes i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id
WHERE ips.page_count > 1000
ORDER BY ips.avg_fragmentation_in_percent DESC;


--Typical starting guidelines:
--Below 5%: No action.
--5–30%: Consider reorganizing.
--Above 30%: Consider rebuilding.