-----------------------------ObjectName------------------
DECLARE @ObjectName VARCHAR(100) = 'YourObjectName'
----------------------------------------------------------

-- Check if the object is a table
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = @ObjectName)
    SELECT 'Table' AS ObjectType, @ObjectName AS ObjectName

-- Check if the object is a view
ELSE IF EXISTS (SELECT 1 FROM sys.views WHERE name = @ObjectName)
    SELECT 'View' AS ObjectType, @ObjectName AS ObjectName

-- Check if the object is a stored procedure
ELSE IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = @ObjectName)
    SELECT 'Stored Procedure' AS ObjectType, @ObjectName AS ObjectName

-- Check if the object is a function
ELSE IF EXISTS (SELECT 1 FROM sys.objects WHERE name = @ObjectName AND type_desc LIKE '%FUNCTION%')
    SELECT 'Function' AS ObjectType, @ObjectName AS ObjectName

-- If the object doesn't exist or is of an unsupported type
ELSE
    SELECT 'Unknown' AS ObjectType, @ObjectName AS ObjectName