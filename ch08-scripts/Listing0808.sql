ALTER EVENT SESSION [audit_sa] ON SERVER 
ADD EVENT sqlserver.sql_transaction(
ACTION(
sqlserver.client_app_name,
sqlserver.client_hostname,
sqlserver.database_name,
sqlserver.server_instance_name,
sqlserver.server_principal_name,
sqlserver.sql_text)
WHERE ([sqlserver].[server_principal_name]=N'sa'));
