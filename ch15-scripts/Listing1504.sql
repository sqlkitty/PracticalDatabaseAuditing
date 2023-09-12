USE [master];

ALTER SERVER AUDIT [AuditSpecification] WITH (STATE = OFF);

ALTER SERVER AUDIT [AuditSpecification]
WHERE [database_name]<>'rdsadmin' 
AND session_server_principal_name <>'WORKGROUP\EC2AMAZ-QG7G9L3$'
and schema_name <> 'sys'
and server_principal_name <> 'rdsa';

ALTER SERVER AUDIT [AuditSpecification] WITH (STATE = ON);
