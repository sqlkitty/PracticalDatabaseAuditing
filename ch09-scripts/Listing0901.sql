USE master;
EXEC sys.xp_readerrorlog 
0, --0 = current log file, 1 = archive file #1, etc 
1, --1 or NULL = error log, 2 = SQL Agent log 
N'Configuration option', --String you want to find 
NULL, --String you can set to further refine results 
NULL, --Start time
NULL, --End time
N'asc'; --orders results asc = ascending, desc = descending 
