#!/bin/sh

DIRS=""
DIRS="ccls/calnet_authenticated"
DIRS="${DIRS} jakewendt/simply_sessions"
DIRS="${DIRS} jakewendt/rails_extension"
DIRS="${DIRS} jakewendt/ruby_extension"
DIRS="${DIRS} jakewendt/simply_authorized"
DIRS="${DIRS} jakewendt/simply_commentable"
DIRS="${DIRS} jakewendt/simply_discussable"
DIRS="${DIRS} jakewendt/simply_documents"
DIRS="${DIRS} jakewendt/simply_helpful"
DIRS="${DIRS} jakewendt/simply_pages"
DIRS="${DIRS} jakewendt/simply_photos"
DIRS="${DIRS} jakewendt/simply_taggable"
#DIRS="${DIRS} jakewendt/simply_testable"
DIRS="${DIRS} jakewendt/simply_trackable"
DIRS="${DIRS} jakewendt/use_db"
DIRS="${DIRS} ccls/abstracts"
DIRS="${DIRS} ccls/buffler"
DIRS="${DIRS} ccls/clic"
DIRS="${DIRS} ccls/homex"
DIRS="${DIRS} ccls/odms"
DIRS="${DIRS} ccls/ccls_engine"

echo $DIRS

i=-1
for dir in $DIRS
do
#	add some sort of sleep time to delay to avoid crushing the processor
i=`expr $i + 1`
naptime=`expr 60 \* $i`
#	sleep $naptime
cat << EOF | osascript > /dev/null 2>&1
tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
tell application "Terminal" to do script "cd github_repo/$dir" in selected tab of the front window
tell application "Terminal" to do script "sleep $naptime; nice +20 autotest" in selected tab of the front window
EOF
done
#tell application "Terminal" to do script "bash" in selected tab of the front window
#	in my tcsh, the -n can't be used and the number must have a sign
#	gotta love it when people follow standards
#tell application "Terminal" to do script "sleep $naptime; nice -n 20 autotest" in selected tab of the front window


#	http://elsethenif.wordpress.com/2009/06/11/open-a-new-tab-on-terminal-with-the-same-path-on-mac-os-x/


#	DO NOT MINIMIZE THE CALLING WINDOW BEFORE THE TABS ARE CREATED
#	OTHERWISE THE COMMANDS GET SENT TO ANOTHER WINDOW AND IT ENDS BADLY!

#	ALSO, IT WOULD BE NICE TO USE THE CALLING WINDOW RATHER THAN "the front window" WHICH
#	CAN CHANGE BETWEEN PRESSING ENTER AND SCRIPT DOING IT

