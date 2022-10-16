#! /usr/bin/bash

ADDRESS="root@194.233.76.227"
PASSWORD="22l1QbIiAZRqPdLNSnob70Jlx5G"
# PASSWORD="WebxFront@IKU22"
SERVER_LANDING_DIR="/usr/share/nginx/html/webx"
SERVER_MERCHANT_DIR="/usr/share/nginx/html/admin"
SERVER_WEBX_ADMIN_DIR="/usr/share/nginx/html/webxadmin"

PROJECTS=("landing" "merchant" "webxadmin")

CYAN='\033[1;36m'
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

while getopts "p:d:" flag
do
	case "$flag" in
		p) project="$OPTARG";;
		d) local_dir="$OPTARG";;
	esac
done

exitWithMessage() {
	echo -e "${RED}$1${NC}"
	exit 1
}

if [ -z "$project" ] || [ -z "$local_dir" ]; then
	exitWithMessage "${CYAN}Usage:${NC} ./deploy.sh -p <project> -d <local_dir>${NC}"
elif [ "$project" != "${PROJECTS[0]}" ] && [ "$project" != "${PROJECTS[1]}" ] && [ "$project" != "${PROJECTS[2]}" ]; then
	exitWithMessage "Project should be one of the following: $(IFS=,; echo "${PROJECTS[*]}")"
fi

if [ "$project" == "${PROJECTS[0]}" ]; then
	server_dir="$SERVER_LANDING_DIR"
elif [ "$project" == "${PROJECTS[1]}" ]; then
	server_dir="$SERVER_MERCHANT_DIR"
elif [ "$project" == "${PROJECTS[2]}" ]; then
	server_dir="$SERVER_WEBX_ADMIN_DIR"
fi

delete_dir="$server_dir/*"

echo -e "Removing existing files from ${YELLOW}$delete_dir ${NC}"
sshpass -p "$PASSWORD" ssh $ADDRESS 'find '$delete_dir' -type f -exec rm {} \;'
echo -e "${CYAN}Removed successfully.${NC}"

echo -e "Uploading files from ${YELLOW}'$local_dir'${NC} to ${YELLOW}'$server_dir' ${NC}"
# echo "sshpass -p "$PASSWORD" rsync -av --stats --human-readable $local_dir $ADDRESS:$server_dir"
sshpass -p "$PASSWORD" rsync -av --stats --human-readable $local_dir $ADDRESS:$server_dir
echo -e "${GREEN}Done.${NC}"
