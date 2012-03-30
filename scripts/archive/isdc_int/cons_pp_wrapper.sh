#!/bin/sh

###############################################################################
#
#   File:      cons_pp_wrapper.sh
#   Version:   0.2
#   Component: Preproc
#
#   Author(s): Mathias.Beck@obs.unige.ch (MB)
#
#   Purpose:   provide a wrapper for CONS-Preproc to run on several
#              revolutions with stopping Preproc at the end of each rev.
#
#   Revision History:
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


#
# cons_pp relevant settings
#
CONS_PP_DIR_WORK=${ISDC_SITE}/run/work/cons_pp
CONS_PP_DIR_LOG=${ISDC_SITE}/run/log/cons_pp
CONS_PIPE_REV_DIR_INPUT=${ISDC_SITE}/run/pipelines/cons/consrev/input

###############################################################################
#
# cons_pp_wrp_usage
#
#   Purpose:   provide the usage to the user
#
###############################################################################
cons_pp_wrp_usage() {
   echo ">>>>>        "
   echo ">>>>>        "
   echo ">>>>> Usage: cons_pp_wrapper.sh [--h] RRRR_1 RRRR_2 ...."
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
# cons_pp_wrp_log
#
#   Purpose:   provide a logging mechanism
#
###############################################################################
cons_pp_wrp_log() {

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
   echo "$mess_type; $mess_date; $mess_text" >> \
      ${CONS_PP_DIR_LOG}/cons_pp_wrapper_log.txt 2>&1
}


###############################################################################
#
# cons_pp_wrp_chk_env
#
#   Purpose:   check the set-up
#
###############################################################################
cons_pp_wrp_chk_env() {

   if [ x${ISDC_SITE} = x ] ; then
      cons_pp_wrp_log "e" "environment variable ISDC_SITE is not set"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${ISDC_SITE} ] ; then
      cons_pp_wrp_log "e" "directory ISDC_SITE (${ISDC_SITE}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${ISDC_ENV} = x ] ; then
      cons_pp_wrp_log "e" "environment variable ISDC_ENV is not set"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${ISDC_ENV} ] ; then
      cons_pp_wrp_log "e" "directory ISDC_ENV (${ISDC_ENV}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${REP_BASE_PROD} = x ] ; then
      cons_pp_wrp_log "e" "environment variable REP_BASE_PROD is not set"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${REP_BASE_PROD} ] ; then
      cons_pp_wrp_log "e" "directory REP_BASE_PROD (${REP_BASE_PROD}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ x${REP_BASE_TM} = x ] ; then
      cons_pp_wrp_log "e" "environment variable REP_BASE_TM is not set"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${REP_BASE_TM} ] ; then
      cons_pp_wrp_log "e" "directory REP_BASE_TM (${REP_BASE_TM}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${CONS_PP_DIR_WORK} ] ; then
      cons_pp_wrp_log "e" "cons_pp work-directory (${CONS_PP_DIR_WORK}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${CONS_PP_DIR_LOG} ] ; then
      cons_pp_wrp_log "e" "cons_pp log-directory (${CONS_PP_DIR_LOG}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -d ${CONS_PIPE_REV_DIR_INPUT} ] ; then
      cons_pp_wrp_log "e" "cons_pp log-directory (${CONS_PIPE_REV_DIR_INPUT}) does not exist"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi

   if [ ! -x ${PREPROC} ] ; then
      cons_pp_wrp_log "e" "cons_pp binary file (${ISDC_ENV}/bin/Preproc) not executable"
      cons_pp_wrp_log "c" "-> Abort"
      exit 2
   fi
}


###############################################################################
#
# cons_pp_wrp_doit
#
#   Purpose:   do the real work for one given revno
#
###############################################################################
cons_pp_wrp_doit() {

   revno=$1

   cons_pp_wrp_log "l" "prepare cons_pp set-up for revno: ${revno}"
   #
   # set the COMMONLOGFILE
   #
   COMMONLOGFILE=${CONS_PP_DIR_LOG}/cons_pp_${revno}_log.txt
   export COMMONLOGFILE

   cd ${CONS_PP_DIR_WORK}
   #
   # set up the read-only parameter-file
   #
   if [ ! -r Preproc.prm ] ; then
      cons_pp_wrp_log "e" "cons_pp input parameter-file for revno ${revno} (${CONS_PP_DIR_WORK}/Preproc.prm) does not exist" 
      exit 5
   fi
   if [ -r Preproc.prm.${revno} ] ; then
      cons_pp_wrp_log "l" "using existing input parameter-file Preproc.prm.${revno}"
   else
      cons_pp_wrp_log "l" "generating new input parameter-file Preproc.prm.${revno}"
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
      	 cons_pp_wrp_log "e" "sed command for Preproc.prm completed with error for revno: ${revno}"
      	 cons_pp_wrp_log "c" "exit code: ${my_status}"
      	 cons_pp_wrp_log "c" "-> Abort"
      	 exit 6
      else
      	 cons_pp_wrp_log "l" "sed command for Preproc.prm completed successfully for revno: ${revno}"
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

   cons_pp_wrp_log "l" "set-up completed for revno: ${revno}"
   
   cons_pp_wrp_log "l" "launch Preproc for revno: ${revno}"
   ${PREPROC} >> ${CONS_PP_DIR_LOG}/cons_pp_2_screen_log.txt 2>&1
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      cons_pp_wrp_log "e" "Preproc completed with error for revno: ${revno}"
      cons_pp_wrp_log "c" "exit code: ${my_status}"
      cons_pp_wrp_log "c" "-> Abort"
      exit 7
   else
      cons_pp_wrp_log "l" "Preproc completed successfully for revno: ${revno}"
   fi

   CONS_PP_DIR_LOG_SAVE=${REP_BASE_PROD}/scw/${revno}/rev.000/logs
   if [ ! -d ${CONS_PP_DIR_LOG_SAVE} ] ; then
      cons_pp_wrp_log "l" "creating log-directory: ${CONS_PP_DIR_LOG_SAVE}"
      ${MKDIR} -p ${CONS_PP_DIR_LOG_SAVE}
   fi
   ${CP} ${COMMONLOGFILE}* ${CONS_PP_DIR_LOG_SAVE}/.
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      cons_pp_wrp_log "e" "copying Preproc log-files completed with error for revno: ${revno}"
      cons_pp_wrp_log "c" "exit code: ${my_status}"
   else
      cons_pp_wrp_log "l" "copying Preproc log-files completed successfully for revno: ${revno}"
   fi

   ${TOUCH} ${CONS_PIPE_REV_DIR_INPUT}/${revno}_pp.done
   my_status=$?
   if [ ${my_status} -ne 0 ] ; then
      cons_pp_wrp_log "e" "could not create trigger for rev-file pipeline for revno: ${revno}"
      cons_pp_wrp_log "c" "exit code: ${my_status}"
   else
      cons_pp_wrp_log "l" "trigger for rev-file pipeline created successfully for revno: ${revno}"
   fi
}


###############################################################################
#
# main loop
#
###############################################################################

if [ $# -lt 1 ] ; then
   cons_pp_wrp_log "e" "at least one argument is expected"
   cons_pp_wrp_usage
   cons_pp_wrp_log "c" "-> Abort"
   exit 1
fi

if [ $1 = "--h" ] ; then
   cons_pp_wrp_usage
   exit 0
fi

cons_pp_wrp_chk_env

while [ $# -ne 0 ] ; do
   revno=$1
   cons_pp_wrp_doit ${revno}
   shift
done
