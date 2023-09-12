USE [master];
ALTER SERVER AUDIT [AuditSpecification] WITH (STATE = OFF);
ALTER SERVER AUDIT [AuditSpecification]
TO FILE 
(	MAXSIZE = 25 MB
	,MAX_FILES = 3
)ALTER SERVER AUDIT [AuditSpecification] WITH (STATE = ON);
