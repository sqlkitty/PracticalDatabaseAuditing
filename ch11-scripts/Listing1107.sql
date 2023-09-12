USE [master]; 
EXEC master.dbo.sp_addlinkedserver @server = N'YourCentralizedAuditServerName', @srvproduct=N'SQL Server';

EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N' YourCentralizedAuditServerName ', @locallogin = NULL , @useself = N'False', @rmtuser = N'sqlauditing', @rmtpassword = N'CreateStrongPasswordHere';
