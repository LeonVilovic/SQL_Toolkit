SELECT 
    OBJECT_NAME(ius.object_id) AS [TableName],
    i.name AS [IndexName],
    i.type_desc AS [IndexType],
    ius.user_seeks AS [Seeks],
    ius.user_scans AS [Scans],
    ius.user_lookups AS [Lookups],
    ius.user_updates AS [Updates],
    (ius.user_seeks + ius.user_scans + ius.user_lookups) AS [TotalReads],
    ius.last_user_seek AS [LastSeek],
    ius.last_user_update AS [LastUpdate]
FROM 
    sys.dm_db_index_usage_stats ius
INNER JOIN 
    sys.indexes i ON ius.object_id = i.object_id AND ius.index_id = i.index_id
WHERE 
    ius.database_id = DB_ID() 
    AND OBJECTPROPERTY(ius.object_id, 'IsUserTable') = 1
	--AND OBJECT_NAME(ius.object_id) = 'Audit'
ORDER BY 
    [TotalReads] DESC;
