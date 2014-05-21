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

rem - Wait some time before start the status verification of the installation.
ping -n 90 127.0.0.1 -w 1000 

rem - :::::::::::::::::::::::::::::::::::::::::::::::::::
rem -  Loop through this until installation is completed
rem - :::::::::::::::::::::::::::::::::::::::::::::::::::

:verify_installation_status 

rem - Verify if the 'Installation successful' string exists inside pros_install.log file
find "Installation successful." %1\pros_install.log
if %errorlevel%==0 goto success

rem - Verify if the 'Installation failed' string exists inside pros_install.log file
find "Installation failed." %1\pros_install.log
if %errorlevel%==0 goto failure

rem - If there were no expected strings, wait some time before verify the installation status again.
ping -n 30 127.0.0.1 -w 1000 
goto verify_installation_status

:success
rem - Finish the batch with succeed status.
exit /b 0

:failure
rem - Finish the batch with failure status.
exit /b 1
