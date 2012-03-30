#!/usr/bin/perl -w -I /isdc/integration/isdc_int/sw/nrt_sw/prod/opus/pipeline_lib/

use ISDCPipeline;


print `echo this is a single line command`;

#	there can be no comments after the \\
#	all white space except 1 space is removed with the \\
#	apparently you cannot begin a line of a multiline command
#	with the word 'command' or perhaps any other executable
#	unless you use double quotes or something, but
#	then the white space is not removed.
print `echo "this is  \\
		a multiple \\
		line \\
		command"`;

print `$ISDCPipeline::myecho this is a test of ISDCPipeline::myecho`;
print `$ISDCPipeline::myecho "this is a test of ISDCPipeline::myecho"`;
print `$ISDCPipeline::myecho this is a \\
	test of ISDCPipeline::myecho`;
print `$ISDCPipeline::myecho "this is a \\
	test of ISDCPipeline::myecho"`;

print `$ISDCPipeline::myls \\
		$ENV{HOME} \\
		$ENV{ISDC_OPUS}`;


exit;


