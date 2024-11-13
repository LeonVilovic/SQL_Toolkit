--Gugl kaze:
USE AdventureWorks2022;
GO

select schema_name(obj.schema_id) +  '.' + obj.name
        + case when referenced_minor_id = 0 then ''
               else '.' + col.name end as referenced_object,
       'referenced by' as 'ref',
       schema_name(ref_obj.schema_id) as referencing_schema,
       ref_obj.name as referencing_object_name,
       case when ref_obj.type_desc = 'USER_TABLE' 
                 and dep.referencing_minor_id != 0
            then 'COLUMN'
            else ref_obj.type_desc end as referencing_object_type,
       ref_col.name as referencing_column
from sys.sql_expression_dependencies dep (nolock)
join sys.objects obj (nolock)
     on obj.object_id = dep.referenced_id
left join sys.columns col (nolock)
     on col.object_id = dep.referenced_id
     and col.column_id = dep.referenced_minor_id
join sys.objects ref_obj (nolock)
     on ref_obj.object_id = dep.referencing_id
left join sys.columns ref_col (nolock)
     on ref_col.object_id = dep.referencing_id
     and ref_col.column_id = dep.referencing_minor_id
where schema_name(obj.schema_id) = 'dbo'  -- put object schema name here
      and obj.name = 'ErrorLog'     -- put object name here
order by referencing_schema,
         referencing_object_name;