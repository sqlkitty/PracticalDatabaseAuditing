USE dbname;
SELECT 
	das.name, 
	sfa.name, 
	dasd.audit_action_name,
	das.is_state_enabled 
FROM sys.server_file_audits sfa
LEFT JOIN sys.database_audit_specifications das
ON sfa.audit_guid = das.audit_guid
LEFT JOIN sys.database_audit_specification_details dasd
ON das.database_specification_id = dasd.database_specification_id;
