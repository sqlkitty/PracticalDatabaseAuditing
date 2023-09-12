DECLARE @profilename varchar(30); 
DECLARE @emailaddress varchar(100); 
DECLARE @displayname varchar(50);
DECLARE @mailserver varchar(50); 

/* CHANGE ONLY THESE FOUR VARIABLES */
SET @profilename = 'yourdbmailprofilename'; 
SET @emailaddress = 'youremail@domain.com';
SET @displayname = 'yourservername SQL Server Alerting'; 
SET @mailserver = 'smtp.domain.com'; 

IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = 'yourdbmailprofilename')  
  BEGIN 
    EXECUTE msdb.dbo.sysmail_add_profile_sp 
      @profile_name = @profilename, 
      @description  = ''; 
  END 
  
IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_account 
WHERE  name = @profilename) 
  BEGIN 
    EXECUTE msdb.dbo.sysmail_add_account_sp 
    @account_name    = @profilename, 
    @email_address   = @emailaddress, 
    @display_name    = @displayname, 
    @replyto_address = @emailaddress, 
    @description     = '', 
    @mailserver_name = @mailserver, 
    @mailserver_type = 'SMTP', 
    @port            = '25', 
    @username        =  NULL , 
    @password        =  NULL ,  
    @use_default_credentials =  0 , 
    @enable_ssl              =  0 ; 
  END 
   
IF NOT EXISTS(SELECT * 
              FROM msdb.dbo.sysmail_profileaccount pa 
                INNER JOIN msdb.dbo.sysmail_profile p 
    ON pa.profile_id = p.profile_id 
                INNER JOIN msdb.dbo.sysmail_account a 
                ON pa.account_id = a.account_id   
              WHERE p.name = @profilename 
                AND a.name = @profilename)  
  BEGIN  
    EXECUTE msdb.dbo.sysmail_add_profileaccount_sp 
      @profile_name = @profilename, 
      @account_name = @profilename, 
      @sequence_number = 1 ; 
  END  
