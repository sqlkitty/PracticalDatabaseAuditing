USE [Auditing]; 
CREATE TABLE [dbo].[AuditChanges](
	[event_time] [datetime2](7) NOT NULL,
	[statement] [nvarchar](4000) NULL,
	[server_instance_name] [nvarchar](128) NULL,
	[database_name] [nvarchar](128) NULL,
	[schema_name] [nvarchar](128) NULL,
	[session_server_principal_name] [nvarchar](128) NULL,
	[server_principal_name] [nvarchar](128) NULL,
	[object_Name] [nvarchar](128) NULL,
	[file_name] [nvarchar](260) NOT NULL,
	[client_ip] [nvarchar](128) NULL,
	[application_name] [nvarchar](128) NULL,
	[host_name] [nvarchar](128) NULL, 
	[succeeded] [bit] NULL, 
	[audit_action] [nvarchar](50) NULL
) ON [PRIMARY]; 
CREATE CLUSTERED INDEX [CIX_EventTime_User_Server_DB] ON [dbo].[AuditChanges]
(
	[event_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]; 
