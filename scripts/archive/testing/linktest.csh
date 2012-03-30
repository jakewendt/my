#!/bin/csh -f


set dir  = "linktestdir"
echo "dir = $dir"
rmdir $dir
set link = "linktestlink"
echo "link = $link"
\rm $link


mkdir $dir
if ( -d $dir ) echo  "Made $dir" 

ln -s  $dir $link
echo "Made link"

if ( -d $link ) echo  "Link is dir"  
if ( -e $link ) echo  "Link exists"  
if ( -f $link ) echo  "Link is file" 
if ( -o $link ) echo  "Link is owned by user" 
if ( -r $link ) echo  "Link is readable" 
if ( -w $link ) echo  "Link is writable" 
if ( -x $link ) echo  "Link is executable" 
if ( -z $link ) echo  "Link is zero length" 
#if ( -l $link ) echo  "Link is link" 

rmdir $dir
if ( ! -d $dir ) echo  "Removed $dir" 

if ( -d $link ) echo  "Link is dir"  
if ( -e $link ) echo  "Link exists"  
if ( -f $link ) echo  "Link is file" 
if ( -o $link ) echo  "Link is owned by user" 
if ( -r $link ) echo  "Link is readable" 
if ( -w $link ) echo  "Link is writable" 
if ( -x $link ) echo  "Link is executable" 
if ( -z $link ) echo  "Link is zero length" 
#if ( -l $link ) echo  "Link is link" 


ls $link >&/dev/null
@ exit_status = $status
echo "exit_status = $exit_status"
if ( ! $exit_status ) then
	echo "Link is still there"
else
	echo "Link is gone"
endif

rm  $link
if ( ! -e $link ) echo  "Removed $link" 

ls $link >&/dev/null
@ exit_status = $status
echo "exit_status = $exit_status"
if ( ! $exit_status ) then
	echo "Link is still there"
else
	echo "Link is gone"
endif




