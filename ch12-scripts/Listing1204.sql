DECLARE @profilename varchar(30); 
DECLARE @mailrecipients varchar(100); 

/* CHANGE ONLY THESE TWO VARIABLES */
SET @profilename = '''yourdbmailprofilename'''; 
SET @mailrecipients = '''youremail@domain.com''';

/* DON'T CHANGE ANYTHING BELOW HERE */

DROP TABLE IF EXISTS ##tempvariables; 
DECLARE @sql varchar(max);
SET @sql = N'IF (select count(event_time)
	FROM [Auditing].[dbo].[AuditChanges]
	 WHERE event_time > getdate()-1) > 0 
	BEGIN 
	DECLARE @tableHTML  NVARCHAR(MAX) ;    
	SET @tableHTML =  
	N''<style type="text/css">
	#box-table
	{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	text-align: left;	
	border: #aaa; 
	}

	#box-table th
	{
	font-size: 13px;
	font-weight: normal;
	background: #f38630;;
	border: 2px solid #aaa;
	text-align: left; 
	color: #039;
	cellpadding: 10px; 
	cellspacing: 10px; 
	}

	#box-table td
	{
	border-right: 1px solid #aabcfe;
	border-left: 1px solid #aabcfe;
	border-bottom: 1px solid #aabcfe;
	cellpadding: 10px;
	cellspacing: 10px;
	}

	tr:nth-of-type(odd)	
	{ background-color:#aaa; color: #ccc }

	tr:nth-of-type(even)	
	{ background-color:#ccc; color: #aaa }

	</style>''+

	N''<H2>SQL Server Auditing Findings</H2>'' +  
	N''<table border="1" id="box-table">'' +  
	N''<tr><th>Event Time</th><th>Partial Statement</th>'' +  		
	N''<th>Server</th><th>Database</th><th>Schema</th>'' +  
	N''<th>User</th><th>Successful</th></tr>'' +  
	CAST ( ( 
		SELECT td = convert(varchar, [event_time], 22),       '''',  
		td = [audit_action], '''',  
		td = left([statement], 50), '''',  
		td = [server_instance_name], '''',  
		td = [database_name], '''',  
		td = [schema_name], '''',  
		td = [session_server_principal_name] '''',  
		td = [succeeded]
		FROM [Auditing].[dbo].[AuditChanges] 
		WHERE event_time > getdate()-1  
		ORDER BY event_time ASC  
		FOR XML PATH(''tr''), TYPE) AS NVARCHAR(MAX) ) +  
		N''</table>'' ;  
					  
EXEC msdb.dbo.sp_send_dbmail 					    
@recipients='+@mailrecipients+',  
@subject = ''Audit Findings - Changes on Production Servers Last 24 Hours'',  
@body = @tableHTML,  
@profile_name = '+@profilename+',
@body_format = ''HTML'';  
END';

SELECT @sql as stepsql
into ##tempvariables; 


USE [msdb]
GO
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

DECLARE @jobId BINARY(16)
EXEC  @ReturnCode =  msdb.dbo.sp_add_job 
@job_name=N'Audit Daily Email of Database Server Changes', 
@enabled=1, 
	@notify_level_eventlog=0, 
	@notify_level_email=2, 
	@notify_level_netsend=0, 
	@notify_level_page=0, 
	@delete_level=0, 
	@description=N'No description available.', 
	@category_name=N'[Uncategorized (Local)]', 
	@owner_login_name=N'sa',  
	@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
DECLARE @stepsql varchar(max); 
SET @stepsql = (SELECT stepsql from ##tempvariables); 
EXEC  @ReturnCode = msdb.dbo.sp_add_jobstep 
@job_id=@jobId, 
@step_name=N'audit findings of changed items on prod servers', 
	@step_id=1, 
	@cmdexec_success_code=0, 
	@on_success_action=1, 
	@on_success_step_id=0, 
	@on_fail_action=2, 
	@on_fail_step_id=0, 
	@retry_attempts=0, 
	@retry_interval=0, 
	@os_run_priority=0, 
	@subsystem=N'TSQL', 
	@command=@stepsql, 
@database_name=N'master', 
@flags=0

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'daily 11am auditing findings', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190812, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=235959, 
		@schedule_uid=N'8ed67b50-2fa6-4683-a714-9c4518fc1453'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
