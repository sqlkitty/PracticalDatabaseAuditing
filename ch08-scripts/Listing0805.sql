SELECT es.name AS ExtendedEventName, 
	 st.name AS TargetLocation
FROM sys.server_event_session_targets st 
INNER JOIN sys.server_event_sessions es
ON st.event_session_id = es.event_session_id
WHERE es.event_session_id = 70049;
