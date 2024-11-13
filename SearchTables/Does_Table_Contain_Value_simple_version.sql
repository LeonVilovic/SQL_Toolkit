--query returns a list of tables that match search parametars
--Author: Leon Vilovic vilovic.leon@gmail.com
  
-----DECLARATION OF SEARCH PARAMETERS
---------------------------------------
DECLARE  @TableName NVARCHAR(128)='TableName';
DECLARE  @SearchValue VARCHAR(50)='1234567';
---------------------------------------
---------------------------------------

  DECLARE @SQLQuery NVARCHAR(MAX);

    SET @SQLQuery = N'
        IF EXISTS (
            SELECT top 1 1
            FROM ' + QUOTENAME(@TableName) + N'
            WHERE ';

    SELECT @SQLQuery = @SQLQuery + COLUMN_NAME + N' = @SearchValue OR '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @TableName 
	AND DATA_TYPE NOT IN ('smalldatetime','datetime','bit') -- ignored fields
	AND DATA_TYPE IN ('varchar','nvarchar') -- comment out this line for wide search 


    -- Remove the trailing 'OR'
    SET @SQLQuery = LEFT(@SQLQuery, LEN(@SQLQuery) - 3);

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

	--SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName