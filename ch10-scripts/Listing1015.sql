SELECT n.value('(@timestamp)[1]', 'datetime') as timestamp,
	 n.value('(@name)[1]', 'nvarchar(15)') as name,
       n.value('(action[@name="client_hostname"]/value)[1]', 'nvarchar(50)') as [client_hostname], 
      n.value('(action[@name="server_principal_name"]/value)[1]', 'nvarchar(50)') as [user],
       n.value('(action[@name="client_app_name"]/value)[1]', 'nvarchar(50)') as [client_app_name],
	 n.value('(data[@name="message"]/value)[1]', 'nvarchar(50)') as [message]
FROM (SELECT CAST(event_data as XML) as event_data
FROM sys.fn_xe_file_target_read_file('e:\audits\AuditLogins*.xel', NULL, NULL, NULL)) ed
CROSS APPLY ed.event_data.nodes('event') as q(n)
WHERE n.value('(@timestamp)[1]', 'datetime') >= DATEADD(HOUR, -1, GETDATE())
ORDER BY timestamp DESC;
