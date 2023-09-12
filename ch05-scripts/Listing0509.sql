USE master;
SELECT 
	sas.name as ServerAuditSpecName, 
	sfa.name as AuditSpecName,
	sasd.audit_action_name,
	sas.is_state_enabled
FROM sys.server_audit_specifications sas
LEFT JOIN sys.server_audit_specification_details sasd
ON sas.server_specification_id = sasd.server_specification_id
LEFT JOIN sys.server_file_audits sfa 
ON sas.audit_guid = sfa.audit_guid;

