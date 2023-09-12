USE [master];
CREATE SERVER AUDIT [Audit_AuditingUser]
TO FILE 
(FILEPATH = N'E:\sqlaudit\auditinguser\'
,MAXSIZE = 100 MB
,MAX_FILES = 4
,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE)
WHERE ([server_principal_name]='auditing' 
AND [schema_name]<>'sys')
ALTER SERVER AUDIT [Audit_AuditingUser] WITH (STATE = ON);
