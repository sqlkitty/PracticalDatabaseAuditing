CREATE SERVER AUDIT miauditstorage
TO URL 
(
PATH = 'URL from Figure 13-22', 
RETENTION_DAYS = 30
); 
ALTER SERVER AUDIT [miauditstorage] WITH (STATE = ON);
