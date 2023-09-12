SELECT DISTINCT 
	event_time,
	aa.name as audit_action,
	statement,
	succeeded, 
	database_name,
	server_instance_name, 
	schema_name, 
	session_server_principal_name, 
	server_principal_name, 
	object_Name, 
	file_name, 
	client_ip, 
	application_name, 
	file_name
FROM  msdb.dbo.rds_fn_get_audit_file ('D:\rdsdbdata\SQLAudit\*.sqlaudit',default,default) af
INNER JOIN sys.dm_audit_actions aa 
ON aa.action_id = af.action_id
WHERE event_time > DATEADD(HOUR, -1, GETDATE())
ORDER BY event_time DESC;
