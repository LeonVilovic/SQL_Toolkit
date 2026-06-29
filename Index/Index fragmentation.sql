SELECT 
    OBJECT_NAME(ips.object_id) AS [TableName],
    i.name AS [IndexName],
    ips.index_type_desc AS [IndexType],
    ROUND(ips.avg_fragmentation_in_percent, 2) AS [FragmentationPercent],
    ips.page_count AS [PageCount]
FROM 
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN 
    sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
ORDER BY 
    ips.avg_fragmentation_in_percent DESC;