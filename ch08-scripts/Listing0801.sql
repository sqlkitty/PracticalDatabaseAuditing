CREATE EVENT SESSION [audit_sa] ON SERVER 
ADD EVENT sqlserver.rpc_completed(
ACTION(sqlserver.client_app_name,
 	sqlserver.client_hostname,
 	sqlserver.database_name,
 	sqlserver.server_instance_name,
 	sqlserver.server_principal_name,
 	sqlserver.sql_text)
    	WHERE ([sqlserver].[server_principal_name]=N'sa')),
ADD EVENT sqlserver.sql_batch_completed(
ACTION(sqlserver.client_app_name,
 	sqlserver.client_hostname,
 	sqlserver.database_name,
 	sqlserver.server_instance_name,
 	sqlserver.server_principal_name,
 	sqlserver.sql_text)
    WHERE ([sqlserver].[server_principal_name]=N'sa'))
ADD TARGET package0.event_file(
SET filename=N'e:\audits\audit_sa',
max_file_size=(10),
max_rollover_files=(5))
WITH (STARTUP_STATE=ON);

ALTER EVENT SESSION [audit_sa] ON SERVER 
STATE=START; 
