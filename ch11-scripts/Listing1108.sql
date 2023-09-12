DECLARE @CentralServerName varchar(100);  
DECLARE @AuditFilePath varchar(250); 

/* CHANGE ONLY THESE TWO VARIABLES */
SET @CentralServerName = 'yourcentralservername';  
SET @AuditFilePath = 'e:\sqlaudit\*.sqlaudit'; 

/* DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU ARE ON A SQL SERVER OLDER THAN 2019 
	If you are on an older version, refer to the section in the chapter to explain the changes */ 
DROP TABLE IF EXISTS ##tempvariables; 
DECLARE @sql varchar(max);
SET @sql = N'INSERT INTO ' + @CentralServerName + '.Auditing.dbo.AuditChanges 
	SELECT DATEADD(mi, DATEPART(TZ, SYSDATETIMEOFFSET()), event_time) as event_time, statement, 
	server_instance_name, database_name, schema_name, session_server_principal_name, 
	server_principal_name, object_Name, file_name, client_ip, application_name, 
	host_name, succeeded, aa.name AS audit_action
	FROM sys.fn_get_audit_file ('''+@AuditFilePath+''',default,default) af
	INNER JOIN sys.dm_audit_actions aa 
	ON aa.action_id = af.action_id
	WHERE DATEADD(mi, DATEPART(TZ, SYSDATETIMEOFFSET()), event_time) > DATEADD(HOUR, -4, GETDATE());';

SELECT @CentralServerName AS servername, 
@AuditFilePath as auditfilepath, @sql as stepsql
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
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Audit Changes Collection', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
DECLARE @stepsql varchar(max); 
SET @stepsql = (SELECT stepsql from ##tempvariables); 
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'audit sql server changes', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=3, 
		@retry_interval=3, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@stepsql, 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'every 4 hours get audit into from sqlaudit files on disk', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190812, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'c68b91ed-4f7f-4fe4-874a-670982cb20cb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
