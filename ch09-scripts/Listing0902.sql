USE [master];
CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification_spconfigure]
FOR SERVER AUDIT [AuditSpecification]
ADD (EXECUTE ON OBJECT::[sys].[sp_configure] BY [public])
WITH (STATE = ON); 
