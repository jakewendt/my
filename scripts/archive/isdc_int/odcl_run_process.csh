#!/bin/csh
#------------------------------------------------------------------------
#                          REVISION HISTORY                             -
#                                                                       -
#------------------------------------------------------------------------
#  MOD            PR                                                    -
# LEVEL   DATE   NUMBER  Who	 Description                            -
# ----- -------- ------  ------ -----------------------------------------
#  000	 06/20/97 33431	 WMiller Initial version			-
#  001   07/24/97 34781  WMiller Run PSF updater                        -
#  002   11/14/97 34811  WMiller Modify for new startup procedure       -
#  003   01/27/98 36125  WMiller Delete password file if necessary      -
#  004   04/28/98 36608  WMiller Password sent via command line         -
#  005   09/10/99 39673  MSwam   Add eval to TASK line
#  006   02/15/00 40675  WMiller Echo version info
#  007   07/13/00 40985  WMiller Handle logfile now
#  008   11/27/00 42874  WMiller Translate time stamp for log file      -
#------------------------------------------------------------------------
#
# Module:      ODCL_RUN_PROCESS.CSH
#
#-----------------------------------------------------------------------------
# INPUT PARAMETERS:
#
#	PROCESS_NAME, PATH_FILE, TIME_STAMP
#
#-----------------------------------------------------------------------------
# DESCRIPTION:
#
#  This shell script will create the process status file, run the requested
#  OPUS pipeline process, then cleanup.
#
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
onintr abexit                            # exit on stop
#
#---------------------------------------------------------------------------
#
#		    Define the task and path file.
#
#---------------------------------------------------------------------------
setenv PROCESS_NAME  $1
set res_path = `osfile_stretch_file $2`
setenv PATH_FILE $res_path
setenv PATH_FILE_NAME  `basename $PATH_FILE`
setenv TIME_STAMP  $3
set l_host = `uname -n | awk -F. '{print $1}'`
#
#---------------------------------------------------------------------------
#
#                   Create the process log file
#
#---------------------------------------------------------------------------
set ohome = `osfile_stretch_file OPUS_HOME_DIR:`
set log = "blank"
if ( $?MSG_REPORT_LEVEL)  then
  if ( $MSG_REPORT_LEVEL == "MSG_NONE" ) then
   set log = /dev/null
  endif
endif 
if ( $log == "blank") then 
   set hexpid = `opus_id -p $$`
   set hostname = `opus_id -n $l_host`
   set log = $ohome/${PROCESS_NAME}-${TIME_STAMP}-${hostname}-${hexpid}.log
   touch $log
   echo "ODCL: +++ odcl_run_process.csh started +++" >>&! $log
   echo "ODCL:" >>&! $log
   echo "ODCL: $OPUS_VERSION" >>&! $log
   echo "ODCL:" >>&! $log
   echo "ODCL: Input parameters:" >>&! $log
   echo "ODCL:     PROCESS_NAME = $PROCESS_NAME" >>&! $log
   echo "ODCL:     PATH_FILE    = $PATH_FILE" >>&! $log
   set cvts = `time_stamp $TIME_STAMP`
   echo "ODCL:     TIME_STAMP   = $TIME_STAMP ($cvts)" >>&! $log
   if ( $4 == "") then
      echo "ODCL:     PASSWORD? No" >>&! $log
   else
      echo "ODCL:     PASSWORD? Yes" >>&! $log
   endif
endif
#
#---------------------------------------------------------------------------
#
#                   Fetch the TASK line from the process resource file
#
#---------------------------------------------------------------------------
echo "ODCL:" >>&! $log
echo "ODCL: Fetching TASK line from process resource file...(odcl_get_resource_command)" >>&! $log
echo "ODCL:" >>&! $log
if ( $4 == "" ) then
   eval `odcl_get_resource_command -p $PROCESS_NAME` # this setenv's $TASK
else
   eval `odcl_get_resource_command -p $PROCESS_NAME -v $4` # this setenv's $TASK
endif
###########
#  Added/modified by TJ:
echo "DEBUG:  Process task is:  $TASK" >>&! $log
echo "DEBUG:  Prepending nice" >>&! $log
setenv TASK "nice +15 $TASK"
echo "DEBUG:  Full task is:  $TASK" >>&! $log
echo "ODCL:" >>&! $log
#echo "ODCL: Task to be run: $which_task[1] (`/bin/which $which_task[1]`)" >>&! $log
echo "ODCL:" >>&! $log
###########
#
#---------------------------------------------------------------------------
#
#                   Create the process status file
#
#---------------------------------------------------------------------------
echo "ODCL:" >>&! $log
echo "ODCL: Creating process PSTAT...(odcl_create_psffile)" >>&! $log
echo "ODCL:" >>&! $log
odcl_create_psffile -p $PATH_FILE_NAME -r $PROCESS_NAME -t $TIME_STAMP -i $$ -c $l_host >>&! $log
if ( $status != "0" ) then
  echo "ODCL:" >>&! $log
  echo "ODCL: PSTAT creation error *************************" >>&! $log
  exit 1
endif
#
#---------------------------------------------------------------------------
#
#	Run the process.
#
#---------------------------------------------------------------------------
echo "ODCL:" >>&! $log
echo "ODCL: Running the process..." >>&! $log
echo "ODCL:" >>&! $log
eval $TASK >>&! $log
set save_status = $status
echo "ODCL:" >>&! $log
echo "ODCL: Process exited. Cleaning up...(odcl_cleanup)" >>&! $log
echo "ODCL:" >>&! $log
#
#---------------------------------------------------------------------------
#
#                  Cleanup PSF and OSF files if necessary.
#
#---------------------------------------------------------------------------
if ( $save_status != "0" ) then         # Process terminated abnormally.
  set option = "absent"
else
  set option = "delete"
endif
#
odcl_cleanup -p $PATH_FILE -r $$ -o $option >>&! $log
if ( $status != "0" ) then
  echo "ODCL:" >>&! $log
  echo "ODCL: PSTAT cleanup error *************************" >>&! $log
  exit 1
endif
#
#---------------------------------------------------------------------------
#
#                  Exit.
#
#---------------------------------------------------------------------------
exit 0
#
#---------------------------------------------------------------------------
#
#                  ERROR HANDLERS.
#
#---------------------------------------------------------------------------
abexit:
  exit 1
#
