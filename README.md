# README
### SQL Express Manual Scheduled Backups Kit

#### Table of Contents

1. [About](#about)
2. [Getting Started](#getting-started)
3. [Troubleshooting](#troubleshooting)
4. [License](#license)

## About

This is a compilation of scripts and references to allow you, a database administrator running SQL Server Express 2017 or 2019, to create a .bat file for scheduling backups as Express Edition does not natively come with this feature.

## Getting Started

First, we will need to create the sp_BackupDatabases stored procedure

* This is in reference to Step A of https://docs.microsoft.com/en-us/troubleshoot/sql/admin/schedule-automate-backup-database
	
* The actual script is linked at https://raw.githubusercontent.com/microsoft/mssql-support/master/sample-scripts/backup_restore/SQL_Express_Backups.sql
	
* To facilitate simplicity, you may also find sp_BackupDatabases_creation_script.sql in this Kit based off of the script described in b., current as of 1/11/2021
  *Always review scripts and code as it relates to your version of software, OS, and environment!
	
* If copy/pasting, in SSMS create New Query, copy/paste script into query, execute
	
* If you wish to use the provided .sql script, open it in SQL Server Management Studio and execute
  *Always review scripts and code as it relates to your version of software, OS, and environment!

Once that is done we will need to create a batch file (.bat) that uses the sqlcmd Utility for creating a full backup of each database using Windows Authentication
	
* Described in Example 1 of Step C of https://docs.microsoft.com/en-us/troubleshoot/sql/admin/schedule-automate-backup-database
	
* SQLScheduledBackup.bat is the recommended title
	
* It is recommended to create a sub-directory of C:\ (or, ideally, D:\ or just some other non-C:\ drive) and naming it SQLBackups, e.g. C:\SQLBackups
  * If you forget this part, it is okay; the script has a fail-safe that includes an IF statement to ensure this directory exists, you just need to edit the directory path if you choose something other than C:\SQLBackups
  * Side note: BE ABSOLUTELY CERTAIN you have properly named each directory path and SQL server name used!
	
* Copy/paste the below into a .txt file, save as SQLScheduledBackup.bat to your Desktop (or preferred directory), and edit all of the items as referenced by the comments (which start with double-colons `::` in the code):

`
:: NOTE! Ensure the path for IF NOT EXIST is what you want!
IF NOT EXIST "C:\SQLBackups\" md "C:\SQLBackups"
:: NOTE! Change the server and instance names below, removing square brackets! 
:: This is likely in the syntax of ServerName\SQLEXPRESS
:: NOTE! Ensure the path below matches the path you specified for the IF NOT EXIST
sqlcmd -S [server_name]\[instance_name] -E -Q "EXEC sp_BackupDatabases @backupLocation='C:\SQLBackups\', @backupType='F'"
:: NOTE! The path for @backupLocation= must close with a backslash \ before the closing single quote, otherwise it will try to write the backups to next lower directory
`	
	
After we have the .bat file it is recommended that we test it. Pending success, we can now use Task Scheduler (or your preferred scheduling medium) to schedule the .bat file to run at the frequency of your choosing. This will allow us to create and maintain backups of your SQL Server Express databases on a recurring basis.

**NOTE:** It is HIGHLY recommended that, in addition to taking backups, test them regularly.

## Troubleshooting

* No sqlcmd Utility? You're likely running SQL Server 2016 or newer. 
  * For downloading the sqlcmd Utility and reviewing syntax, check out https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver15
		
* Getting Access Denied error when running script? You may just need to add full permissions for the MSSQLEXRESS user
  * Open SQL Server Configuration Manager
  * Select SQL Server Services in left-hand pane
  * Right-click SQL Server (SQLEXPRESS)
  * On Log On tab highlight and copy the entire Account Name (likely something like NT Service\MSSQL$SQLEXPRESS)
  * Within File Explorer navigate to the backup destination and open its folder properties
  * On the Security tab click Edit to change permissions
  * For Groups or user names select Add
  * For Object Types ensure all are selected
  * For Locations change to ensure the local machine, and not your domain, is selected
  * Paste your Account Name and Check Name it
  * Click OK
  * Back on the Security tab ensure your SQL account name (again, likely shown simply as MSSQL$SQLEXPRESS) has full permissions, and press Apply
  * If you are unable to manage any of the above yourself, it is recommened you seek out your local database/systems/IT administrator
		
## License

Distributed under the MIT license.

Copyright 2021 James Anderson, Escalation Engineer, Salient Systems Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
