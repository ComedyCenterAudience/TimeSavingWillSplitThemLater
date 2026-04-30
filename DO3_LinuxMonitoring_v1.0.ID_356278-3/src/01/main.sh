#!/bin/bash

source functions.sh

if [ "$#" -ne 1 ]; then
  echo "Please input a text. For example: '$0 hello'"
  exit 1
fi

param="$1"

if number "$param"; then
  echo "Sorry, parametr is a number."
else
  echo "$param"
fi