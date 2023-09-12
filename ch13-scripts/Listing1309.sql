SELECT n.value('(@timestamp)[1]', 'datetime') as timestamp,
       n.value('(action[@name="sql_text"]/value)[1]', 'nvarchar(max)') as [sql], 
       n.value('(action[@name="client_hostname"]/value)[1]', 'nvarchar(50)') as [client_hostname], 
       n.value('(action[@name="username"]/value)[1]', 'nvarchar(50)') as [user],
       n.value('(action[@name="database_name"]/value)[1]', 'nvarchar(50)') as [database_name],
       n.value('(action[@name="client_app_name"]/value)[1]', 'nvarchar(50)') as [client_app_name]
FROM (SELECT CAST(event_data as XML) as event_data
FROM sys.fn_xe_file_target_read_file('https://azuresqldbaudits.blob.core.windows.net/xelfiles/ xelauditdata_0_132972103478750000.xel', NULL, NULL, NULL)) ed
CROSS APPLY ed.event_data.nodes('event') as q(n)
WHERE n.value('(@timestamp)[1]', 'datetime') 
>= DATEADD(HOUR, -4, GETDATE())
ORDER BY timestamp DESC;
