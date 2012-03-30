#!/bin/sh

###############################################################################
#
#   File:      pp_wrapper.sh
#   Version:   0.3
#   Component: Preproc
#
#   Author(s): Mathias.Beck@obs.unige.ch (MB)
#              T. Jaffe (TJ)
#
#   Purpose:   provide a wrapper for Preproc to run on several
#              revolutions with stopping Preproc at the end of each rev.
#
#   Revision History:
#
#      0.3    27-Feb-2002  TJ    removed CONS specific and added parameter
#
#      0.2    06-Feb-2002  MB    added writing of rev-file pipeline 
#                                trigger RRRR_pp.done
#
#      0.1    05-Feb-2003  MB    initial prototype
#
###############################################################################


#
# system commands
#
DATE=/bin/date
CP=/bin/cp
MV=/bin/mv
RM=/bin/rm
TOUCH=/bin/touch
GREP=/bin/grep
LS=/bin/ls
TAIL=/bin/tail
SED=/bin/sed
BASENAME=/bin/basename
MKDIR=/bin/mkdir
#
PREPROC=${ISDC_ENV}/bin/Preproc


###############################################################################
#
# pp_wrp_usage
#
#   Purpose:   provide the usage to the user
#
###############################################################################
pp_wrp_usage() {
   echo ">>>>>        "
   echo ">>>>>        "
   echo ">>>>> Usage: pp_wrapper.sh [--h] --system=(nrt|cons) RRRR_1 RRRR_2 ...."
   echo ">>>>>        "
   echo ">>>>>        This script uses the following env. vars:"
   echo ">>>>>        "
   echo ">>>>>           ISDC_SITE"
   echo ">>>>>           ISDC_ENV"
   echo ">>>>>           REP_BASE_PROD"
   echo ">>>>>           REP_BASE_TM"
   echo ">>>>>        "
}


###############################################################################
#
# pp_wrp_log
#
#   Purpose:   provide a logging mechanism
#
###############################################################################
pp_wrp_log() {

   if [ ${DATE} != "" ] ; then
      mess_date=`${DATE} +"%Y-%m-%dT%H:%M:%S"`
   else
      mess_date=""
   fi
   mess_text=$2
   case $1 in
    'l')
      mess_type=">>>>> Log     "
      ;;
    'w')
      mess_type="!!!!! Warning "
      ;;
    'e')
      mess_type="***** Error   "
      ;;
    'q')
      mess_type="????? Question"
      ;;
    'c')
      mess_type="              "
      ;;
   esac
#   echo "$mess_type; $mess_date; $mess_text"

    if [ "$PP_DIR_LOG" != "" ] ; then

	echo "$mess_type; $mess_date; $mess_text" >> \
	    ${PP_DIR_LOG}/pp_wrapper_log.txt 2>&1

    else
	echo "$mess_type;  $mess_date; $mess_text"

    fi


}


###############################################################################
#
# pp_wrp_chk_env
#
#   Purpose:   check the set-up
#
###############################################################################
pp_wrp_chk_env() {

    if [ !  ${system} = "nrt" ] && [ ! $system = "cons"  ] ; then 
	echo "-> Abort:  set system to nrt or cons"
	exit 1
    fi

    #
    #  relevant settings
    #
    PP_DIR_WORK=${ISDC_SITE}/run/work/${system}_pp
    PP_DIR_LOG=${ISDC_SITE}/run/log/${system}_pp
    PIPE_REV_DIR_INPUT=${ISDC_SITE}/run/pipelines/${system}/${system}rev/input

   if [ x${ISDC_SITE} = x ] ; then
      pp_wrp_log "e" "environment variable ISDC_SITE is not set"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${ISDC_SITE} ] ; then
      pp_wrp_log "e" "directory ISDC_SITE (${ISDC_SITE}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${ISDC_ENV} = x ] ; then
      pp_wrp_log "e" "environment variable ISDC_ENV is not set"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${ISDC_ENV} ] ; then
      pp_wrp_log "e" "directory ISDC_ENV (${ISDC_ENV}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${REP_BASE_PROD} = x ] ; then
      pp_wrp_log "e" "environment variable REP_BASE_PROD is not set"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${REP_BASE_PROD} ] ; then
      pp_wrp_log "e" "directory REP_BASE_PROD (${REP_BASE_PROD}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${REP_BASE_TM} = x ] ; then
      pp_wrp_log "e" "environment variable REP_BASE_TM is not set"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${REP_BASE_TM} ] ; then
      pp_wrp_log "e" "directory REP_BASE_TM (${REP_BASE_TM}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${PP_DIR_WORK} ] ; then
      pp_wrp_log "e" "pp work-directory (${PP_DIR_WORK}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${PP_DIR_LOG} ] ; then
      pp_wrp_log "e" "pp log-directory (${PP_DIR_LOG}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${PIPE_REV_DIR_INPUT} ] ; then
      pp_wrp_log "e" "pp log-directory (${PIPE_REV_DIR_INPUT}) does not exist"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -x ${PREPROC} ] ; then
      pp_wrp_log "e" "pp binary file (${ISDC_ENV}/bin/Preproc) not executable"
      pp_wrp_log "c" "-> Abort"
      exit 2
   fi
}


###############################################################################
#
# pp_wrp_doit
#
#   Purpose:   do the real work for one given revno
#
###############################################################################
pp_wrp_doit() {

   revno=$1

   pp_wrp_log "l" "prepare pp set-up for revno: ${revno} for system $system"
   #
   # set the COMMONLOGFILE
   #
   COMMONLOGFILE=${PP_DIR_LOG}/pp_${revno}_log.txt
   export COMMONLOGFILE

   cd ${PP_DIR_WORK}
   #
   # set up the read-only parameter-file
   #
   if [ ! -r Preproc.prm ] ; then
      pp_wrp_log "e" "pp input parameter-file for revno ${revno} (${PP_DIR_WORK}/Preproc.prm) does not exist" 
      exit 5
   fi
   if [ -r Preproc.prm.${revno} ] ; then
      pp_wrp_log "l" "using existing input parameter-file Preproc.prm.${revno}"
   else
      pp_wrp_log "l" "generating new input parameter-file Preproc.prm.${revno}"
      line_first=`${GREP} FIRST_TLM_FILE Preproc.prm`
      file_first="tm0000000000000000.next"
      #
      line_last=`${GREP} LAST_TLM_FILE Preproc.prm`
      tmp_1=`${LS} -1 ${REP_BASE_TM}/${revno}/*.fits* | ${TAIL} -1`
      file_last=`${BASENAME} ${tmp_1} .gz`
      #
      ${SED} -e "s^${line_first}^FIRST_TLM_FILE = ${revno}/${file_first}^" \
      	 -e "s^${line_last}^LAST_TLM_FILE = ${revno}/${file_last}^" Preproc.prm \
      	 > Preproc.prm.${revno}
      my_status=$?
      if [ ${my_status} -ne 0 ] ; then
      	 pp_wrp_log "e" "sed command for Preproc.prm completed with error for revno: ${revno}"
      	 pp_wrp_log "c" "exit code: ${my_status}"
      	 pp_wrp_log "c" "-> Abort"
      	 exit 6
      else
      	 pp_wrp_log "l" "sed command for Preproc.prm completed successfully for revno: ${revno}"
      fi
   fi
   ${CP} Preproc.prm.${revno} Preproc.prm

   #
   # clean the read-write parameter-file
   #
   if [ -f Preproc.RW.prm ] ; then
      ${RM} -f Preproc.RW.prm
   fi
   ${TOUCH} Preproc.RW.prm

   pp_wrp_log "l" "set-up completed for revno: ${revno}"
   
   pp_wrp_log "l" "launch Preproc for revno: ${revno}"
   ${PREPROC} >> ${PP_DIR_LOG}/pp_2_screen_log.txt 2>&1
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      pp_wrp_log "e" "Preproc completed with error for revno: ${revno}"
      pp_wrp_log "c" "exit code: ${my_status}"
      pp_wrp_log "c" "-> Abort"
      exit 7
   else
      pp_wrp_log "l" "Preproc completed successfully for revno: ${revno}"
   fi

   PP_DIR_LOG_SAVE=${REP_BASE_PROD}/scw/${revno}/rev.000/logs
   if [ ! -d ${PP_DIR_LOG_SAVE} ] ; then
      pp_wrp_log "l" "creating log-directory: ${PP_DIR_LOG_SAVE}"
      ${MKDIR} -p ${PP_DIR_LOG_SAVE}
   fi
   ${CP} ${COMMONLOGFILE}* ${PP_DIR_LOG_SAVE}/.
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      pp_wrp_log "e" "copying Preproc log-files completed with error for revno: ${revno}"
      pp_wrp_log "c" "exit code: ${my_status}"
   else
      pp_wrp_log "l" "copying Preproc log-files completed successfully for revno: ${revno}"
   fi

   ${TOUCH} ${PIPE_REV_DIR_INPUT}/${revno}_pp.done
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      pp_wrp_log "e" "could not create trigger for rev-file pipeline for revno: ${revno}"
      pp_wrp_log "c" "exit code: ${my_status}"
   else
      pp_wrp_log "l" "trigger for rev-file pipeline created successfully for revno: ${revno}"
   fi
}


###############################################################################
#
# main loop
#
###############################################################################

if [ $# -lt 1 ] ; then
   pp_wrp_log "e" "at least one argument is expected"
   pp_wrp_usage
   pp_wrp_log "c" "-> Abort"
   exit 1
fi


while [ $# -ne 0 ] ; do

    if [ $1 = "--h" ] ; then
	pp_wrp_usage
	exit 0

    elif [ $1 = "--system=nrt" ] ; then

	system="nrt"

    elif [ $1 = "--system=cons" ] ; then

	system="cons"
    
    else 

	pp_wrp_chk_env
    
	revno=$1
	pp_wrp_doit ${revno}

    fi

    shift

done
