#! /usr/bin/tcsh -f

# clean up old things
rm -r $OPUS_MISC_REP/ifts/inbox/*
rm -rf $OPUS_WORK/adp/input/*
rm -rf $OPUS_WORK/adp/scratch/*
rm -rf $OPUS_WORK/adp/logs/*
rm -rf $OPUS_WORK/adp/pfiles/*
rm -rf $OPUS_MISC_REP/trigger/adp/*

# start the alert daemon

#(setenv PFILES ${PFILES}:/isdc/integration/bin; /isdc/integration/bin/am_daemon SleepTime=5 ConfigFile=/home/oneel/tmp/am_daemon.cfg &)

#
if (-e $REP_BASE_PROD/aux) then 
    echo "Please clean up REP_BASE_PROD"
    exit 1
endif

cd $REP_BASE_PROD
/unige/gnu/bin/tar xvzf ~/test_data/aux_dummy-1.0.tgz


# first moc files

cp ~/test_data/aux_test_data/revno $OPUS_MISC_REP/ifts/inbox/revno

 sleep 30

cp ~/test_data/aux_test_data/orbita_2002_05_11 $OPUS_MISC_REP/ifts/inbox/orbita

 sleep 60

# now all of the ISOC files

cp ~/test_data/aux_test_data/pad_99_0001.fits $OPUS_MISC_REP/ifts/inbox/

cp ~/test_data/aux_test_data/iop_99_0001.fits $OPUS_MISC_REP/ifts/inbox/

cp ~/test_data/aux_test_data/pod_0043_0001.fits $OPUS_MISC_REP/ifts/inbox/

cp ~/test_data/aux_test_data/opp_0043_0001_0001.tar $OPUS_MISC_REP/ifts/inbox/

cp ~/test_data/aux_test_data/ocs_99000010001_0001.fits $OPUS_MISC_REP/ifts/inbox/

 sleep 30

# more MOC files

cp ~/test_data/aux_test_data/0043_01.PAF $OPUS_MISC_REP/ifts/inbox/
# below is an attempt to fudge the pointing ids which failed.
#cp ~/test_data/adp/0043_01.PAF.0000 $OPUS_MISC_REP/ifts/inbox/0043_01.PAF

 sleep 30

cp ~/test_data/aux_test_data/TSF*INT $OPUS_MISC_REP/ifts/inbox/

 sleep 30

cp ~/test_data/aux_test_data/*.ASF  $OPUS_MISC_REP/ifts/inbox/

# again, below is a failed attempt to fudge the pointing ids.  
#cp ~/test_data/adp/asf/*.ASF $OPUS_MISC_REP/ifts/inbox/

sleep 30

#cp ~/test_data/aux_test_data/THF_020827_0001.DAT $OPUS_MISC_REP/ifts/inbox/
cp ~/test_data/aux_test_data/THF_020816*.DAT $OPUS_MISC_REP/ifts/inbox/

sleep 30

cp ~/test_data/aux_test_data/THF_020816_0030.DAT $OPUS_MISC_REP/ifts/inbox/

sleep 30

cp ~/test_data/aux_test_data/THF_020816_0031.DAT $OPUS_MISC_REP/ifts/inbox/

 sleep 30

cp ~/test_data/aux_test_data/*.OLF $OPUS_MISC_REP/ifts/inbox/

 sleep 180

#  Now, fudge some things to trigger it for archiving
# 

exit

cp $REP_BASE_PROD/aux/adp/0043.000/orbit_predicted.fits  $REP_BASE_PROD/aux/adp/0043.000/orbit_historic.fits


cp  ~/test_data/aux_test_data/0043_0001.AHF $OPUS_MISC_REP/ifts/inbox/

# sleep 30

