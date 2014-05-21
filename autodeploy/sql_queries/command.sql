--
--  $Revision$
--
--  Copyright (c) 2014 by PROS, Inc.  All Rights Reserved.
--  This software is the confidential and proprietary information of
--  PROS , Inc. ("Confidential Information").
--  You shall not disclose such Confidential Information and shall use it
--  only in accordance with the terms of the license agreement you entered
--  into with PROS.
--
--  @Author  jmaguina
-- 

/*disconect and reconect the database to get exclusive connection to it*/
alter database $(database_name) set offline with rollback immediate
alter database $(database_name) set online
go

/*This checks if there is a database with a given name. It it exists, it will be deleted*/
BEGIN
IF DB_ID('$(database_name)') IS NOT NULL
    DROP DATABASE $(database_name)
END

/*This executes the command from the stored procedure and deletes it afterwards*/
EXEC sp_RestoreFromAllFilesInDirectory $(database_file_backup), $(files_folder) , $(files_folder)

DROP PROCEDURE sp_RestoreFromAllFilesInDirectory

-- Reset database of 'admin' user
use $(database_name)
update SY_USER_INFO 
set PASSWORD = '3c6d1h524j1d4h3h50325w4m1zi2t1v563c1u4n', 
STATUS = 'UnLocked', 
LAST_LOGON_DATE = current_timestamp, 
PASSWORDUPDATEDATE = current_timestamp 
where LAST_NAME = 'admin';
go

-- Establish licence
UPDATE SY_SYSTEM_PARAMETER
SET VALUE='developer'
WHERE SUB_SYSTEM='PDK' AND PRMTR='CUSTOMER_NAME';
UPDATE SY_SYSTEM_PARAMETER
SET VALUE='SYCRW-HFLBB-MLAPA-DJVZD-TABDS'
WHERE SUB_SYSTEM='PDK' AND PRMTR='LICENSE_KEY';
go
