#!/bin/bash

VERSION=1.20

usage() {
cat <<EOF
Eschalot version $VERSION
Copyright (C) 2015 Bright Things UN Ltd. <info@bright-things.com>

Eschalot will use brute force to create "readable" .onion addresses.

Usage: eschalot [option [option]...]

Options:

    -h --help          Display this help text
    -v --verbose       Verbose output
    -s --search        Search for a specific phrase
    
EOF
}

if [ -z "$1" ]; then
    usage
    exit 1
fi

TEMP=`getopt -n mqtt2ts -o hvs: --longoptions help,verbose,search: -- "$@"`

if [ $? != 0 ]; then 
    usage
    exit 1
fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        --help) 
            usage
            exit 1
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        -s|--search)
            SEARCH="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *) 
            break;
            ;;
    esac
done

eschalot -ct5 -p $SEARCH | tee /tmp/result

# vim: ts=4 et
