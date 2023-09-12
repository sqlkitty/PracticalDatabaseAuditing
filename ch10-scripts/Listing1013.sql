USE master;
SELECT  
	event_time,
	aa.name as audit_action,
	server_instance_name,  
	server_principal_name,  
	client_ip, 
	application_name, 
	host_name
FROM sys.fn_get_audit_file ('E:\audits\*.sqlaudit',default,default) af
INNER JOIN sys.dm_audit_actions aa 
ON aa.action_id = af.action_id
WHERE event_time > DATEADD(HOUR, -4, GETDATE())
ORDER BY event_time DESC;
