# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -f /my/home/ccls/bash_profile ]; then
	. /my/home/ccls/bash_profile
fi




# User specific environment and startup programs

#                  JOBID PARTITION NAME USER ST TIME NODES NODELIST(REASON)
#                    7       9      15    8   2  10    6      ???
#alias sq='squeue -o "%.7i %.9P %.25j %.8u %.2t %.10M %.6D %R"'


#export GEM_HOME=/my/home/jwendt/.gem
#export GEM_PATH=$GEM_HOME

export SLURM_MAX_QUEUE_SIZE=500


#	for crontab
export EDITOR=vim


alias simple_queue='simple_queue.sh'

alias top='top -u jwendt'


#	bash aliases don't take parameters, but functions do
function relink(){ \rm $1; ln -s $2 $1; }

# Send to /dev/null otherwise ...
# 10854: old priority 0, new priority 19
#
#	doesn't seem to make any difference, nevertheless
#
#renice +19 $$ > /dev/null


#	#	color codes need wrapped in \[ \] or will muck up history scrolling
#	#	something about not counting these control characters
#	uname=`uname -n`
#	#if [ $uname = "ec0000" -o $uname = "genepi1.berkeley.edu"  ] ; then
#	if [ $uname = "n0.berkeley.edu" ] ; then
#		PS1="\[\e[42;37m\] [\u@\h \W]\\$ \[\e[m\] "	#	GREEN means GO!
#		export PATH=$HOME/dna/bin:$HOME/dna/trinity:$PATH
#	else
#		PS1="\[\e[41;37m\] [\u@\h \W]\\$ \[\e[m\] "	#	RED means STOP!
#		alias gzip="echo \"OUCH! Don't do that here.\""	#	the double double quotes are so i can use the apostrophe
#	#	export PATH=$HOME/dna/bin:$HOME/dna/trinity_ec:$PATH
#		export PATH=$HOME/dna/bin:$HOME/dna/trinityrnaseq_r2014_04_13p1_ec:$PATH
#		export PATH=/usr/local/jre1.7.0_67/bin:$PATH
#	fi


