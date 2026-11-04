SELECT
    d.name AS DatabaseName,
    MAX(CASE WHEN bs.type = 'D'
        THEN bs.backup_finish_date END) AS LastFullBackup,
    MAX(CASE WHEN bs.type = 'I'
        THEN bs.backup_finish_date END) AS LastDiffBackup,
    MAX(CASE WHEN bs.type = 'L'
        THEN bs.backup_finish_date END) AS LastLogBackup
FROM sys.databases d
LEFT JOIN msdb.dbo.backupset bs
    ON d.name = bs.database_name
GROUP BY d.name
ORDER BY d.name;