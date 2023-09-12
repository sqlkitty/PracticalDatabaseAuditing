DECLARE @drives TABLE 
(driveletter VARCHAR(1), size INT);

INSERT INTO @drives 
EXEC MASTER..xp_fixeddrives;

SELECT * FROM @drives
WHERE driveletter = 'E';
