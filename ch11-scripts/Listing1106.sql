USE [master]; 
CREATE LOGIN [sqlauditing] WITH PASSWORD=N'testing1234!', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON;

USE [Auditing]; 
CREATE USER [sqlauditing] FOR LOGIN [sqlauditing]; 
ALTER ROLE [db_datareader] ADD MEMBER [sqlauditing];
ALTER ROLE [db_datawriter] ADD MEMBER [sqlauditing];
