#!/usr/bin/env bash

HOST=
IP=

HOSTS_FILE="/tmp/hosts-find-$$.txt"
RED="\033[31;1m"

# FUNCTION

delete_temp_files() {

    [[ -f "$HOSTS_FILE" ]] && rm -rf "$HOSTS_FILE"
}

ctrl_c() {
    
    delete_temp_files

    echo -e "\n${RED}Scan aborted by user!\n" && exit 1

}

main() {

    trap ctrl_c 2

    for subdomain in $(cat $2)
    do
        host $subdomain.$1 | grep "has address" >> "$HOSTS_FILE"
    done

    if test -f "$HOSTS_FILE"
    then
        cat $HOSTS_FILE | sort -u | sed 's/has address/'

        delete_temp_files
    else
        echo "No subdomains found!"
    fi 
}

# EXECUTION

[[ $# -ne 2 ]] && echo "How to use: $0 site.com wordlist.txt" && exit 0

main "$@"