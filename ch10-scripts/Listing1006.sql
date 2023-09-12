USE [YourDBName];   
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'YourTableName',  
@role_name     = NULL,  
@filegroup_name = NULL,  
@supports_net_changes = 0; 

