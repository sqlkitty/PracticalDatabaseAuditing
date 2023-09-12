SELECT es.name AS ExtendedEventName, 
		sf.name AS SettingName, 
		sf.value AS SettingValue
FROM sys.server_event_session_fields sf 
INNER JOIN sys.server_event_sessions es
ON sf.event_session_id = es.event_session_id
WHERE es.event_session_id = 70049;
