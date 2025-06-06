#!/bin/sh
##################
# OoklaServer install and management script
# (C) 2013 Ookla
##################
BASE_DOWNLOAD_PATH='https://install.speedtest.net/ooklaserver/stable/'
INSTALL_DIR=''
DAEMON_FILE='OoklaServer'
PID_FILE="$DAEMON_FILE.pid"


display_usage() {
	echo "This script can be used to install or control a Ookla Server."
	echo  "Usage:"
	echo  "$0 [-f|--force] [-i|--installdir <dir>] command"
	echo  ""
	echo  "  Valid commands: install, start, stop, restart"
	echo  "   install - downloads and installs the Ookla server"
	echo  "   start   - starts the server if not running"
	echo  "   stop    - stops the server if running"
	echo  "   restart - stops the server if running, and restarts it"
	echo  " "
	echo  "  -f|--force           Do not prompt before install"
	echo  "  -i|--install <dir>   Install to specified folder instead of the current folder"
	echo  "  -h|--help            This help"
	echo  ""
	}

has_command() {
	type "$1" >/dev/null 2>&1
}

detect_platform() {
	# detect operating system
	case $( uname -s ) in
	Darwin)
		server_package='macosx'
		;;
	Linux)
		server_package='linux32'
		arch=`uname -m`
		if [ "$arch" = "x86_64" ]; then
			server_package='linux64'
		fi
		;;
	FreeBSD)
		server_package='freebsd32'
		arch=`uname -m`
		if [ "$arch" = "amd64" ]; then
			server_package='freebsd64'
		fi
		;;
	*)
		echo "Please Select the server Platform : "
		echo "1) macOS"
		echo "2) Linux (32bit)"
		echo "3) Linux (64bit)"
		echo "4) FreeBSD (32bit)"
		echo "5) FreeBSD (64bit)"

		read n
		case $n in
			1) server_package='macosx';;
			2) server_package='linux32';;
			3) server_package='linux64';;
			4) server_package='freebsd32';;
			5) server_package='freebsd64';;
		esac
	esac

	echo "Server Platform is $server_package"
}

confirm_install() {
	if [ "$INSTALL_DIR" != "" ]; then
		printf "This will install the Ookla server for $server_package to folder $INSTALL_DIR. Please confirm (y/n) > "
	else
		printf "This will install the Ookla server for $server_package to the current folder. Please confirm (y/n) > "
	fi
    read response
    if [ "$response" != "y" ]; then
		echo "Exiting program."
		exit 1
   fi
}

goto_speedtest_folder() {
	# determine if base install folder exists
	dir_full=`pwd`
	dir_base=`basename $dir_full`

	echo "Checking Directory Structure"
	if [ "$INSTALL_DIR" != "" ]; then
		if [ "$dir_base" != "$INSTALL_DIR" ]; then
			if [ ! -d "$INSTALL_DIR" ]; then
				mkdir "$INSTALL_DIR"
				scriptname=`basename $0`
				# copy script to folder
				cp "$scriptname" "$INSTALL_DIR"
			fi

			cd "$INSTALL_DIR"
		fi
	fi
}

download_install() {
	# download the v3 server files with either wget or curl or fetch
	gzip_download_file="OoklaServer-$server_package.tgz"
	gzip_download_url="$BASE_DOWNLOAD_PATH$gzip_download_file"

	curl_path=`command -v curl`
	wget_path=`command -v wget`
	fetch_path=`command -v fetch`

	echo "Downloading Server Files"
	if [ -n "$curl_path" ]; then
		curl -O $gzip_download_url

	elif [ -n "$wget_path" ]; then
		wget "$gzip_download_url" -O "$gzip_download_file"

	elif [ -n "$fetch_path" ]; then
		# fetch is found in base OS in FreeBSD
		fetch -o "$gzip_download_file" "$gzip_download_url"
	else
		echo "This script requires CURL or WGET or FETCH"
		exit 1
	fi

	# extract package
	if [ -f "$gzip_download_file" ]; then
		echo "Extracting Server Files"
		tar -zxovf "$gzip_download_file"
		rm "$gzip_download_file"
		if [ ! -f "${DAEMON_FILE}.properties" ]; then
			cp "${DAEMON_FILE}.properties.default" "${DAEMON_FILE}.properties"
		fi
	else
		echo "Error download server package"
		exit 1
	fi

}

restart_if_running() {
	stop_if_running
	start
}

stop_process() {
	daemon_pid="$1"
	printf "Stopping $DAEMON_FILE Daemon ($daemon_pid)"
	kill "$daemon_pid" >/dev/null 2>&1
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
		if kill -0 "$daemon_pid" >/dev/null 2>&1 ; then
			sleep 1
			printf " ."
		else
			break
		fi
	done
	echo ""
}

stop_if_running() {
	if [ -f "$PID_FILE" ]; then
		daemon_pid=`cat $PID_FILE`
		if [ $daemon_pid ]; then
			stop_process "$daemon_pid"
			if has_command pgrep; then
				pids=$(pgrep OoklaServer 2>&1)
				if [ -n "$pids" ]; then
					echo "Additional $DAEMON_FILE processes running; stopping"
					for daemon_pid in $pids; do
						stop_process "$daemon_pid"
					done
					pids=$(pgrep OoklaServer 2>&1)
					if [ -n "$pids" ]; then
						echo "Lingering $DAEMON_FILE processes running; killing ($pids)"
						kill -9 $pids
					fi
				fi
			fi
		fi
	fi
}

start_if_not_running() {
	if [ -f "$PID_FILE" ]; then
		daemon_pid=`cat $PID_FILE`
		if [ $daemon_pid ]; then
			if kill -0 "$daemon_pid" > /dev/null 2>&1 ; then
				echo "$DAEMON_FILE ($daemon_pid) is already running"
				exit 1
			fi
		fi
	fi
	start
}

start() {
	printf "Starting $DAEMON_FILE"
	dir_full=`pwd`
	if [ -f "$DAEMON_FILE" ]; then
		chmod +x "$DAEMON_FILE"
		daemon_cmd="./$DAEMON_FILE --daemon --pidfile=$dir_full/$PID_FILE"
		# echo "$daemon_cmd"
		`$daemon_cmd`
	else
		echo ""
		echo "Daemon not installed. Please run install first."
		exit 1
	fi

	# wait for PID file to be created and verify daemon started

	for i in 1 2 3 4 5 6 7 8 9 10; do
		sleep 1
		if [ -f "$PID_FILE" ]; then break; fi
		printf " ."
	done
	echo ""
    if [ -f "$PID_FILE" ]; then
		daemon_pid=`cat $PID_FILE`
		echo "Daemon Started ($daemon_pid)"
	else
		echo "Failed to Start Daemon"
	fi
}

##### Main

prompt=1
action=help
while [ "$1" != "" ]; do
    case $1 in
		install )				action=install
								;;
		stop )					action=stop
								;;
		start )					action=start
								;;
		restart )				action=restart
								;;
		help )					action=help
								;;
        -i | --installdir )        shift
                                INSTALL_DIR=$1
                                ;;
        -f | --force )    		prompt=0
                                ;;
        -h | --help )           display_usage
                                exit
                                ;;
        * )                     display_usage
                                exit 1
    esac
    shift
done

if [ "$action" = "restart" ]; then
	restart_if_running
fi

if [ "$action" = "start" ]; then
	start_if_not_running
fi

if [ "$action" = "stop" ]; then
	stop_if_running
fi


if [ "$action" = "help" ]; then
	display_usage
fi

if [ "$action" = "install" ]; then
	detect_platform
	if [ "$prompt" = "1" ]; then
		confirm_install
	fi

	goto_speedtest_folder

	download_install

	restart_if_running

	echo "NOTE:"
	echo ""
	echo "We strongly recommend following instructions at"
	echo ""
	echo "   https://www.ookla.com/support/a87011938/"
	echo ""
	echo "to ensure your daemon starts automatically when the system reboots"
	echo ""
fi
