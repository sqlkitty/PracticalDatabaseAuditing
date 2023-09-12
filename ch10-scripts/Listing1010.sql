INSERT INTO Auditing.dbo.AuditChangesTemporal 
(event_time, statement)  
SELECT DATEADD(mi, DATEPART(TZ, SYSDATETIMEOFFSET()), event_time) as event_time, statement
FROM sys.fn_get_audit_file ('e:\sqlaudit\*.sqlaudit',default,default) af
WHERE DATEADD(mi, DATEPART(TZ, SYSDATETIMEOFFSET()), event_time) > DATEADD(HOUR, -4, GETDATE());
