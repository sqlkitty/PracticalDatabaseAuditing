USE [YourDBName];
ALTER TABLE [dbo].[YourTableName] ENABLE CHANGE_TRACKING 
WITH (TRACK_COLUMNS_UPDATED = OFF); 