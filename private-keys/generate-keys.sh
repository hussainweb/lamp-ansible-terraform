#!/usr/bin/env bash

key_file_name=${1:-'server_key'}
key_comment=${2:-'Server'}

ssh-keygen -t rsa -b 4096 -f "$key_file_name" -N "" -C "$key_comment"
