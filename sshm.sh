#! /bin/bash

# -------------------------------------------------
# CONFIG
# -------------------------------------------------
CONFIG_PATH=~/.sshm.conf
DEFAULT_CONFIG_PATH=./sshm_default.conf
SSHARGS=""
TMP_VIMRC="/tmp/.vimrc"

# to be taken out of the config file
VIMRC="testing_RC22"
WRITE_FILE="echo $VIMRC > $TMP_VIMRC"

# Helper functions - Read and write to and from the config file
sed_escape() {
	sed -e 's/[]\/$*.^[]/\\&/g'
}

cfg_write() { # key, value
	cfg_delete "$config_path" "$1"
	echo "$1=$2" >> "$config_path"
}

cfg_read() { # key -> value
	test -f "$CONFIG_PATH" && grep "^$(echo "$1" | sed_escape)=" "$CONFIG_PATH" | sed "s/^$(echo "$1" | sed_escape)=//" | tail -1
}

cfg_delete() { # key
	test -f "$CONFIG_PATH" && sed -i "/^$(echo $1 | sed_escape).*$/d" "$CONFIG_PATH"
}

cfg_haskey() { # key
	test -f "$CONFIG_PATH" && grep "^$(echo "$1" | sed_escape)=" "$CONFIG_PATH" > /dev/null
}

cfg_update() { # key, value
	if  cfg_haskey "$1" 
	then
		cfg_delete "$1"
		cfg_write "$1" "$2"
	else
		echo "Unknown configuration variable: $1"
	fi
}

# Create the config file if not exist
if [ ! -e $CONFIG_PATH ]; then
	cp $DEFAULT_CONFIG_PATH $CONFIG_PATH
fi

# -------------------------------------------------
# Get user ARGS
# -------------------------------------------------
while [ ! $# -eq 0 ]
do
	echo $# args # Testing echo statements
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
		--config | -c)
			cfg_update "$(cut -d'=' -f1 <<<$2)" "$(cut -d'=' -f2 <<<$2)"
			shift
			exit
			;;
		*)
			#the idea is that if we don't accept the command, it's probably for ssh >.>
			echo adding to ssh command >&2
			SSHARGS="$SSHARGS $1"
			;;
	esac
	shift
done

# testing statement
echo sshargs:\"$SSHARGS\"

#run ssh with commands to write a  temp .vimrc
ssh -t $SSHARGS "$WRITE_FILE; bash -l"
