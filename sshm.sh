#! /bin/bash	
SSHARGS=""
TMP_VIMRC="/tmp/.vimrc"
VIMRC="testing_RC22"
WRITE_FILE="echo $VIMRC > $TMP_VIMRC"
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
ssh -t $SSHARGS "$WRITE_FILE; bash -l"
