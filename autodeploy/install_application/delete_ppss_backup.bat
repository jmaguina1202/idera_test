@echo off
rem
rem  $Revision$
rem
rem  Copyright (c) 2014 by PROS, Inc.  All Rights Reserved.
rem  This software is the confidential and proprietary information of
rem  PROS Inc. ("Confidential Information").
rem  You shall not disclose such Confidential Information and shall use it
rem  only in accordance with the terms of the license agreement you entered
rem  into with PROS.
rem
rem  @Author  jmaguina
rem 

rem - Deletes backup folders
for /d %%x in (%1*) do rd /s /q "%%x"

rem - Unlocks the folder with the installer
cd C:\unlocker\
Unlocker.exe %2 /S
cd ..
rem - Deletes the files that were copied into the server
del build.properties
del build.xml
del installer.properties
del logfile.log
del po_queries.sql
del post_installation_linux.sh
del pros_monitor.bat
del restore.sql

