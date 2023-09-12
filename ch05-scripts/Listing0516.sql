USE master;
ALTER SERVER AUDIT AuditSpecification 
WITH (STATE = OFF); 

USE master;
ALTER SERVER AUDIT SPECIFICATION [ServerAuditSpecification] 
WITH (STATE = OFF); 

USE Auditing;
ALTER DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification_Auditing] WITH (STATE = OFF); 
