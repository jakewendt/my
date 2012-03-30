#!/usr/bin/perl -w

use strict;
use ISDCPipeline;
#use Archiving;
use Datasets;
use lib "$ENV{ISDC_OPUS}/nrtrev/";
use RevSPI;

##### debugging only
#
#$ENV{EVENT_NAME} = "soxx_00000000001_001";
$ENV{OPUS_WORK} = "/isdc/integration/isdc_int/run/pipelines/nrt/";
$ENV{REP_BASE_PROD} = "/isdc/integration/isdc_int/data/nrt/tst_int_flight_nrt";
$ENV{OSF_DATASET} = "0096_arc_prep";
#$ENV{OBSDIR} = "$ENV{REP_BASE_PROD}/obs";
$ENV{SCWDIR} = "$ENV{REP_BASE_PROD}/scw";
$ENV{PARFILES} = "$ENV{OPUS_WORK}/nrtrev/pfiles/";
#$ENV{TIME_STAMP} = "0000";
$ENV{LOG_FILES} = "$ENV{OPUS_WORK}/nrtrev/logs";
$ENV{WORKDIR} = "$ENV{OPUS_WORK}/nrtrev/scratch/";
$ENV{OUTPATH} = $ENV{REP_BASE_PROD};
$ENV{PROCESS_NAME} = "nrvgen";
my $proc = "Rev Gen NRT test";
$ENV{PATH_FILE_NAME} = "nrtrev.path";
$ENV{ALERTS} = "$ENV{OPUS_MISC_REP}/alert/nrt";
#my $stream = "NRT";
my $workdir = "$ENV{WORKDIR}/$ENV{OSF_DATASET}";
#######################

my $stamp = "20030731000000";
my $osfname = $ENV{OSF_DATASET};
my $dataset = $ENV{OSF_DATASET};
my $type = "arc";
my $revno = "0096";
my $prevrev = "0095";
my $nexrev = "0097";

#`mkdir $ENV{OPUS_WORK}/nrtrev/scratch/${revno}_arc_prep` if (!-d "$ENV{OPUS_WORK}/nrtrev/scratch/${revno}_arc_prep");
#`rm $ENV{OPUS_WORK}/nrtrev/scratch/${revno}_arc_prep/*`;

$ENV{IC_ALIAS} = "NRT";

RevSPI::ACAspec($proc,$stamp,$workdir,$osfname,$dataset,$type,$revno,$prevrev,$nexrev);

print "done\n";
exit 0;

