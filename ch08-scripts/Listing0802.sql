SELECT name, description
FROM sys.dm_xe_objects 
WHERE object_type ='Event'
ORDER BY name 

SELECT name, description
FROM sys.dm_xe_objects 
WHERE object_type ='Action'
ORDER BY name
