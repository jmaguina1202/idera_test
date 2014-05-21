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

/*Create a Stored Procedure with all the needed operations*/
CREATE PROCEDURE sp_RestoreFromAllFilesInDirectory
 @SourceDirBackupFiles nvarchar(200), @DestDirDbFiles nvarchar(200), @DestDirLogFiles nvarchar(200) 
AS
SET NOCOUNT ON

/*Temporary table that will hold the files' names*/
CREATE TABLE #files(fname varchar(200),depth int, file_ int)
INSERT #files
EXECUTE master.dbo.xp_dirtree @SourceDirBackupFiles, 1, 1

/*Temporary table that will hold the results from the command RESTORE FILELISTONLY, which returns a list of the logical files of the database backup file*/
CREATE TABLE #dbfiles(
 LogicalName nvarchar(128) 
,PhysicalName nvarchar(260) 
,[Type] char(1) 
,FileGroupName nvarchar(128) 
,Size numeric(20,0)
,MaxSize numeric(20,0)
,FileId bigint
,CreateLSN numeric(25,0)
,DropLSN numeric(25,0)
,UniqueId uniqueidentifier
,ReadOnlyLSN numeric(25,0)
,ReadWriteLSN numeric(25,0)
,BackupSizeInBytes bigint
,SourceBlockSize bigint
,FilegroupId bigint
,LogGroupGUID uniqueidentifier
,DifferentialBaseLSN numeric(25)
,DifferentialBaseGUID uniqueidentifier
,IsReadOnly bigint
,IsPresent int 
,TDEThumbprint uniqueidentifier
)

/*Variables*/
DECLARE @fname varchar(200) 
DECLARE @dirfile varchar(300) 
DECLARE @LogicalName nvarchar(128) 
DECLARE @PhysicalName nvarchar(260) 
DECLARE @type char(1) 
DECLARE @DbName sysname 
DECLARE @sql nvarchar(1500) 

DECLARE files CURSOR FOR
SELECT fname FROM #files

DECLARE dbfiles CURSOR FOR
SELECT LogicalName, PhysicalName, Type FROM #dbfiles

OPEN files
FETCH NEXT FROM files INTO @fname
WHILE @@FETCH_STATUS = 0
BEGIN
SET @dirfile = @SourceDirBackupFiles + @fname

/*Set the name of the database to restored*/
SET @DbName = '$(database_name)'

/*Beginning of the sql command to restore the database*/
SET @sql = 'RESTORE DATABASE ' + @DbName + ' FROM DISK = ''' + @dirfile + ''' WITH MOVE '

TRUNCATE TABLE #dbfiles
INSERT #dbfiles
EXEC('RESTORE FILELISTONLY FROM DISK = ''' + @dirfile + '''')

OPEN dbfiles
FETCH NEXT FROM dbfiles INTO @LogicalName, @PhysicalName, @type

/*This will add the corresponding files to the final sql command*/
WHILE @@FETCH_STATUS = 0
BEGIN
IF CHARINDEX('.mdf', @PhysicalName) > 0
SET @sql = @sql + '''' + @LogicalName + ''' TO ''' + @DestDirDbFiles + @LogicalName + '.mdf'', MOVE '
ELSE IF CHARINDEX('.ndf', @PhysicalName) > 0
SET @sql = @sql + '''' + @LogicalName + ''' TO ''' + @DestDirDbFiles + @LogicalName + '.ndf'', MOVE '
ELSE IF CHARINDEX('.ldf', @PhysicalName) > 0
SET @sql = @sql + '''' + @LogicalName + ''' TO ''' + @DestDirLogFiles + @LogicalName + '.ldf'''
FETCH NEXT FROM dbfiles INTO @LogicalName, @PhysicalName, @type
END

/*This will execute the command to restore the database*/
PRINT @sql 
EXEC(@sql) 
CLOSE dbfiles 
FETCH NEXT FROM files INTO @fname 
END 
CLOSE files 
DEALLOCATE dbfiles 
DEALLOCATE files 
go