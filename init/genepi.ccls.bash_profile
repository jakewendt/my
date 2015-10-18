#
#	The following few lines should be added to your ~/.bash_profile to
#	take full advantage of the shared CCLS data.
#	Placing them at the top will allow you to override them.
#	Placing them at the bottom will allow it to override you.
#	Choose wisely.
#
#		if [ -f /my/home/ccls/bash_profile ]; then
#			. /my/home/ccls/bash_profile
#		fi
#







alias ..="cd .."

#               JOBID PARTITION NAME USER ST TIME NODES NODELIST(REASON)
#                 7       6      40    6   2  10    1      ???
alias sq='squeue -o "%.7i %.6P %.45j %.6u %.2t %.10M %.1D %R"'
alias sqme='squeue -o "%.7i %.6P %.45j %.6u %.2t %.10M %.1D %R" -u `whoami`'

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ll -a'
alias h='history'
alias gzip='gzip --best'

alias ec='ssh ec0001'

alias archive='archive.sh'



#function cd_with_umask(){ \cd $1; pwd; if [[ `readlink $PWD` =~ ^/my/home/ccls ]] ; then umask 0002; else umask 0022; fi; }
#alias cd=cd_with_umask



export BLASTDB=/my/home/ccls/indexes/blast
export BOWTIE2_INDEXES=/my/home/ccls/indexes/bowtie2
export GEM_HOME=/my/home/ccls/rubygems



uname=`uname -n`

alias srun='srun --share --nice --exclude=n[0000-0009]'


#	seem the same now
#	20150303 - Trying to use trinity compiled on n0 on the cluster.
#export PATH=/my/home/ccls/sw/bin:/my/home/ccls/sw/trinity:$PATH
#	/my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats)
#	/my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats: /usr/lib64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats)
#	/my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats: /usr/lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats)
#	Error, cmd: /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/..//Inchworm/bin/fastaToKmerCoverageStats --reads single.fa --kmers jellyfish.K25.min2.kmers.fa --kmer_size 25  --num_threads 8  --DS  > single.fa.K25.stats died with ret 256 at /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/insilico_read_normalization.pl line 727.
#	Error, cmd: /my/home/ccls/nobackup/sw/trinityrnaseq-2.0.6/util/insilico_read_normalization.pl --seqType fa --JM 40G  --max_cov 50 --CPU 8 --output /my/home/ccls/data/working/TCGA_Glioma/G26383/trinity_output.nobackup/insilico_read_normalization --single /my/home/ccls/data/working/TCGA_Glioma/G26383/G26383.fasta died with ret 512 at /my/home/ccls/sw/trinity/Trinity line 2116.




#	Color codes need wrapped in \[ \] or will muck up history scrolling.
#	Something about not counting these control characters.

#
#	20150303 must maintain 2 copies of trinity and therefore 2 paths
#	

#if [ $uname = "n0.berkeley.edu" ] ; then
#if [ $uname = "n0n.berkeley.edu" ] ; then
#if [ $uname = "n0n" ] ; then
if [ $uname = "n0" ] ; then

	PS1="\[\e[42;37m\] [\u@\h \W]\\$ \[\e[m\] "	#	GREEN means GO!

	export PATH=/my/home/ccls/sw/bin:/my/home/ccls/sw/trinity:$PATH

	#	Cluster jobs will be killed in the evening during
	#		system cleanup if ssh from n0 still open.
	#		Remove the ec alias so can never from n0 to the cluster.
	alias ec="echo \"Don't connect to ec through n0. Jobs will get cleaned at night.\""
	alias ec1="echo \"Don't connect to ec1 through n0. Jobs will get cleaned at night.\""

else
	#	Add some stuff to minimize chance of accidentally doing work on ec or genepi1.

	PS1="\[\e[41;37m\] [\u@\h \W]\\$ \[\e[m\] "	#	RED means STOP!

	#
	#	Aliases DO NOT get passed to srun jobs.
	#
	#	the double double quotes are so i can use the apostrophe
	alias gzip="echo \"OUCH! Don't do that here.\""	
	alias gunzip="echo \"OUCH! Don't do that here.\""	
	alias tar="echo \"OUCH! Don't do that here.\""	
	alias ec_fasta_split_and_blast.sh="echo \"OUCH! Don't do that here.\""	


	export PATH=/my/home/ccls/sw/bin:/my/home/ccls/sw/trinity_ec:$PATH

	#	TEMPORARY adjustment for java 1.7 upgrade
#	export PATH=/usr/local/jre1.7.0_67/bin:$PATH
fi


# [jwendt@n0 ~]$  echo ${HOSTNAME}
#n0.berkeley.edu
# [jwendt@n0 ~]$  echo ${HOSTNAME%%.*}
#n0
# [jwendt@n0 ~]$  echo ${HOSTNAME%.*}
#n0.berkeley
# [jwendt@n0 ~]$  echo ${HOSTNAME##*.}
#edu
# [jwendt@n0 ~]$  echo ${HOSTNAME#*.}
#berkeley.edu


#	this is primarily for the sqlite3 problem
#PATH=/my/home/ccls/sw/bin-${HOSTNAME%%.*}:$PATH


#function archive(){ 
#	while [ $# -ne 0 ] ; do
#		if [ -f "$1" ] ; then
#			echo "Archiving :$1:"
#			chmod -f +w md5sums
#			chmod -w $1
#			md5sum $1 >> md5sums
#			gzip --best --verbose $1
#			md5sum ${1}.gz >> md5sums
#			chmod -w md5sums
#		else
#			echo "$1 not a file? Skipping"
#		fi
#	shift
#	done
#}
