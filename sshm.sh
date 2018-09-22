#! /bin/bash

# -------------------------------------------------
# CONFIG
# -------------------------------------------------
config_path=~/.sshm.conf
default_config_path=./sshm_default.conf
SSHARGS=""
k=""
v=""

# Helper functions - Read and write to and from the config file
sed_escape() {
	sed -e 's/[]\/$*.^[]/\\&/g'
}

cfg_write() { # key, value
	cfg_delete "$config_path" "$1"
	echo "$1=$2" >> "$config_path"
}

cfg_read() { # key -> value
	test -f "$config_path" && grep "^$(echo "$1" | sed_escape)=" "$config_path" | sed "s/^$(echo "$1" | sed_escape)=//" | tail -1
}

cfg_delete() { # key
	test -f "$config_path" && sed -i "/^$(echo $1 | sed_escape).*$/d" "$config_path"
}

cfg_haskey() { # key
	test -f "$config_path" && grep "^$(echo "$1" | sed_escape)=" "$config_path" > /dev/null
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
if [ ! -e $config_path ]; then
	cp $default_config_path $config_path
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
			echo adding to ssh command >&2
			SSHARGS="$SSHARGS $1"
			;;
	esac
	shift
done

echo sshargs:\"$SSHARGS\"
ssh $SSHARGS 
