# UPDATE THESE VARIABLES TO YOUR VALUES 
 
$OutputFile = "E:\powershell\sqlserverauditfindings.html"
$CentralServerName = "yourcentralserver"
$SendEmailFrom = "youremail@domain.com"
$SendEmailTo = "recipient@domain.com"
$SMTPServer = "smtp.domain.com"
$EmailSubject = "Audit Findings - Changes on SQL Server Production Servers in Last 7 Days"

# DON’T CHANGE ANYTHING BELOW

$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; text-align: left;}
BODY {width:800px;}
td:nth-child(2) {max-width: 400px;}
</style>
"@

#get rid of the file if it somehow still exists from a previous run 
if (Test-Path $OutputFile){ Remove-Item -Path $OutputFile -Force}

# make sure query returns at least one row 
$querycount = Invoke-Sqlcmd -Query "SELECT count(event_time) as count FROM [Auditing].[dbo].[AuditChanges] a 
WHERE event_time > getdate()-7" -ServerInstance $CentralServerName

# query audit data if there is at least one row and create an HTML file
if($querycount.count -gt 0) {
#query the last 7 days of audit events and convert to html file
Invoke-Sqlcmd -Query "SELECT convert(varchar, MAX([event_time]), 22) as event_time, [audit_action], [succeeded], [statement], [server_instance_name], [database_name],[schema_name],
[session_server_principal_name]
FROM [Auditing].[dbo].[AuditChanges] a 
WHERE event_time > getdate()-7    
GROUP BY [audit_action], [succeeded], [statement], [server_instance_name], [database_name], [schema_name], [session_server_principal_name]
ORDER BY server_instance_name, database_name, schema_name, session_server_principal_name DESC" `
-ServerInstance $CentralServerName | ConvertTo-HTML `
-Head $Header `
-Property event_time,audit_action,succeeded,statement,server_instance_name,database_name,schema_name,session_server_principal_name,name_in_ad `
| Out-File $OutputFile -Encoding utf8

# email file 
Send-MailMessage -From $SendEmailFrom `
-To $SendEmailTo `
-Subject $EmailSubject `
-Attachments $OutputFile `
-SmtpServer $SMTPServer 

# remove html file 
Remove-Item –path $OutputFile
} 

# no file is created because there weren’t any audit rows 
else {
Write-Output "nothing happened bc there were zero rows"
}
