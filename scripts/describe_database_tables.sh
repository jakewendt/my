#!/bin/sh

usage() {
	echo >&2 "\nUsage: $0 [-d database]\n"
	exit 1;
}

while getopts d: opt
do
	case "$opt" in
		d)  database="$OPTARG";;
		\?)		# unknown flag
			usage; exit 1;;
	esac
done
shift `expr $OPTIND - 1`

if [ x"$database" = x ]; then
	usage
fi

for table in `\
	mysql \
	--user=root \
	--column-names=false \
	--execute='show tables;' \
	--database=$database`
do 
	echo "\nTable: $table"
	mysql \
	--user=root \
	--table=true \
	--execute="describe $table;" \
	--database=$database
done
