#! /bin/bash	
SSHARGS=""
while [ ! $# -eq 0 ]
do
	echo $# args
	echo $1 arg1
	echo sshargs:\"$SSHARGS\"
	case "$1" in
		--help | -h)
#			helpmenu
			exit
			;;
		--take-over-world)
			echo Done >&2
			exit
			;;
		*)
			echo adding to ssh command >&2
			SSHARGS="$SSHARGS $1"
			;;
	esac
	shift
done

echo sshargs:\"$SSHARGS\"
ssh $SSHARGS 
