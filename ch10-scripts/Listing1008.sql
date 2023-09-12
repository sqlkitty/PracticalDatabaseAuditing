USE YourDBName;  
DECLARE @from_lsn binary(10), @to_lsn binary(10);  
SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_YourTableName');  
SET @to_lsn   = sys.fn_cdc_get_max_lsn();  
SELECT * 
FROM cdc.fn_cdc_get_all_changes_dbo_AuditData  
     (@from_lsn, @to_lsn, N'all');  
