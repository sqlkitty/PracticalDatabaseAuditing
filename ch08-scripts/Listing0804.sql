SELECT es.name AS ExtendedEventName, 
		se.name AS EventName, 
		sa.name AS GlobalFieldName, 
		se.predicate AS Filter
FROM sys.server_event_session_events se
INNER JOIN sys.server_event_sessions es
ON se.event_session_id = es.event_session_id
INNER JOIN sys.server_event_session_actions sa
ON sa.event_session_id = es.event_session_id
AND sa.event_id = se.event_id
WHERE es.event_session_id = 70049;
