USE [master];

DECLARE @statement NVARCHAR(max);
DECLARE @servername VARCHAR(50);
SET @servername = @@servername;

SELECT @statement = '
CREATE SERVER AUDIT [Audit_'+@servername+']
TO FILE 
(	FILEPATH = N''E:\sqlaudit\''
	,MAXSIZE = 50 MB
	,MAX_ROLLOVER_FILES = 4
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
)
ALTER SERVER AUDIT [Audit_'+@servername+'] WITH (STATE = ON);';

EXEC sp_executesql @statement;
