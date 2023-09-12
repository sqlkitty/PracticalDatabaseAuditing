CREATE EVENT SESSION [AuditLogins] ON SERVER 
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,
	     sqlserver.client_hostname,
	     sqlserver.server_principal_name)
    WHERE ((([severity]=(14)) 
		  AND ([error_number]=(18456))) 
		  AND ([state]>(1)))),
ADD EVENT sqlserver.login(
    ACTION(sqlserver.client_app_name,
	     sqlserver.client_hostname,
	     sqlserver.server_principal_name))
ADD TARGET package0.event_file(
SET filename=N'E:\audits\AuditLogins.xel',
		max_file_size=(10),
		max_rollover_files=(10))
WITH (STARTUP_STATE=ON);
ALTER EVENT SESSION [AuditLogins] ON SERVER 
STATE=START; 
