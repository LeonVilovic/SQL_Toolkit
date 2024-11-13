--query returns a list of tables that match search parametars
--Author: Leon Vilovic vilovic.leon@gmail.com

--SELECT *
--FROM INFORMATION_SCHEMA.TABLES
--WHERE TABLE_TYPE = 'BASE TABLE' 
--AND TABLE_CATALOG = 'KB_DataReport'; --Insert name of database here

IF object_id ('tempdb..#TableNames') IS NOT NULL  DROP TABLE #TableNames;
IF object_id ('tempdb..#SearchParametars') IS NOT NULL  DROP TABLE #SearchParametars;
CREATE TABLE #TableNames (TableName NVARCHAR(128));
CREATE TABLE #SearchParametars (SearchParametar NVARCHAR(128));
-----DECLARATION OF SEARCH PARAMETERS
---------------------------------------
INSERT INTO #TableNames (TableName)
VALUES ('TableName1')
,('TableName2')
,('TableName3')


INSERT INTO #SearchParametars (SearchParametar)
VALUES ('1234567')
,('1234569')
,('1234560')
,('1234561')
---------------------------------------
---------------------------------------

DECLARE  @TableName NVARCHAR(128);
DECLARE  @SearchValue VARCHAR(50); 

DECLARE @Index1 INT = 0;
DECLARE @Index2 INT = 0;

DECLARE @Index1Max INT = (SELECT COUNT(*) FROM #TableNames);
DECLARE @Index2Max INT = (SELECT COUNT(*) FROM #SearchParametars);

DECLARE @Cursor1 CURSOR, @Cursor2 CURSOR;

SET @Cursor1 = CURSOR LOCAL FAST_FORWARD FOR SELECT TableName FROM #TableNames;
SET @Cursor2 = CURSOR LOCAL FAST_FORWARD FOR SELECT SearchParametar FROM #SearchParametars;


OPEN @Cursor1;

WHILE @Index1<@Index1Max

BEGIN --beginning of outer loop
FETCH NEXT FROM @Cursor1 INTO @TableName;

OPEN @Cursor2;

WHILE @Index2<@Index2Max

BEGIN --beginning of inner loop

FETCH NEXT FROM @Cursor2 INTO @SearchValue;

DECLARE @SQLQuery NVARCHAR(MAX);
    SET @SQLQuery = N'
        IF EXISTS (
            SELECT top 1 1
            FROM ' + QUOTENAME(@TableName) + N'
            WHERE ';

    SELECT @SQLQuery = @SQLQuery + COLUMN_NAME + N' = @SearchValue OR '
    FROM information_schema.columns
    WHERE TABLE_NAME = @TableName 
	AND DATA_TYPE NOT IN ('smalldatetime','datetime','bit') -- ignored fields
	AND DATA_TYPE IN ('varchar','nvarchar') -- comment out this line for wide search 
    
    SET @SQLQuery = LEFT(@SQLQuery, LEN(@SQLQuery) - 3); -- Remove the trailing 'OR'

    SET @SQLQuery = @SQLQuery + N'
        )
        BEGIN
            PRINT ''Value '+ @SearchValue +' EXISTS in the table '+ QUOTENAME(@TableName) +'. '';
        END
        ELSE
        BEGIN
            PRINT ''Value '+ @SearchValue +' does not exist in the table '+ QUOTENAME(@TableName) +'.'';
        END';

    EXEC sp_executesql @SQLQuery, N'@SearchValue VARCHAR(50)', @SearchValue;

SET @Index2 = @Index2+1;
END --inner loop close
CLOSE @Cursor2;

SET @Index2 = 0;
SET @Index1 = @Index1+1;
END --outer loop close

CLOSE @Cursor1;

DEALLOCATE @Cursor1;

DEALLOCATE @Cursor2;




