:: NOTE! Ensure the path for IF NOT EXIST is what you want!
IF NOT EXIST "C:\SQLBackups\" md "C:\SQLBackups"
:: NOTE! Change the server and instance names below, removing square brackets! 
:: This is likely in the syntax of ServerName\SQLEXPRESS
:: NOTE! Ensure the path below matches the path you specified for the IF NOT EXIST
sqlcmd -S localhost\SQLEXPRESS -E -Q "EXEC sp_BackupDatabases @backupLocation='C:\SQLBackups\', @backupType='F'"
:: NOTE: The path for @backupLocation= must close with a backslash \ before the closing single quote, otherwise it will try to write the backups to next lower directory