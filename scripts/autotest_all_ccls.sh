#!/bin/sh

DIRS="calnet_authenticated"
DIRS="${DIRS} simply_authorized"
DIRS="${DIRS} simply_commentable"
DIRS="${DIRS} simply_discussable"
DIRS="${DIRS} simply_documents"
DIRS="${DIRS} simply_helpful"
DIRS="${DIRS} simply_pages"
DIRS="${DIRS} simply_photos"
DIRS="${DIRS} simply_taggable"
DIRS="${DIRS} simply_testable"
DIRS="${DIRS} simply_trackable"
DIRS="${DIRS} ucb_ccls_abstracts"
DIRS="${DIRS} ucb_ccls_buffler"
DIRS="${DIRS} ucb_ccls_clic"
DIRS="${DIRS} ucb_ccls_engine"
DIRS="${DIRS} ucb_ccls_homex"

echo $DIRS

for dir in $DIRS
do
cat << EOF | osascript > /dev/null 2>&1
tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
tell application "Terminal" to do script "cd github_repo/jakewendt/$dir" in selected tab of the front window
tell application "Terminal" to do script "bash" in selected tab of the front window
tell application "Terminal" to do script "nice -n 20 autotest" in selected tab of the front window
EOF
done


#	http://elsethenif.wordpress.com/2009/06/11/open-a-new-tab-on-terminal-with-the-same-path-on-mac-os-x/
