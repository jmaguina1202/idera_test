#!/bin/sh
#
# $Revision$
#
# Copyright (c) 2014 by PROS, Inc.  All Rights Reserved.
#  This software is the confidential and proprietary information of
#  PROS Inc. ("Confidential Information").
#  You shall not disclose such Confidential Information and shall use it
#  only in accordance with the terms of the license agreement you entered
#  into with PROS.
#
#  @Author  jmaguina
#

#  This unlock the PPSS folder
chmod -R 777 PPSS

#  This deletes the backups
rm -rf PPSS_bak*
