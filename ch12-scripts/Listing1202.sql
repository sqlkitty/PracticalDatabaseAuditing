USE master
GO
sp_configure 'show advanced options',1 
reconfigure
GO
sp_configure 'Database Mail XPs',1
reconfigure
GO
