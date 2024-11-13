use msdb
GO
select max(restore_date) as time_date
from restorehistory
where destination_database_name='AdventureWorks2022'
and restore_type='D'