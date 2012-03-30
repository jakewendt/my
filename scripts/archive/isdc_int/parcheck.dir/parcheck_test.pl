  ISDCPipeline::PipelineStep(
            "step" => "adp - Copy Alerts",
            "program_name" => "testexec",
            "par_OutDir" => "$ENV{ALERTS}",
            "par_OutDir2" => "",
            "par_Subsystem" => "ADP",
            "par_DataStream" => "realTime",
#           "par_SCWIndex" => "",               #  should be here
            "par_bogus" => "$newworkdir",
            "par_test-1" => "$newworkdir",
            "par_test+1" => "$newworkdir",
            "par_test.1" => "$newworkdir",
            "subdir" => "$newworkdir",
            "logfile" => "$ENV{LOG_FILES}/$opuslink",
           )
