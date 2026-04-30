#!/bin/bash

RESET="\033[0m"

case $bg_name in
    1) COLOR_LEFT_BG="\033[47m" ;;
    2) COLOR_LEFT_BG="\033[41m" ;;
    3) COLOR_LEFT_BG="\033[42m" ;;
    4) COLOR_LEFT_BG="\033[44m" ;;
    5) COLOR_LEFT_BG="\033[45m" ;;
    6) COLOR_LEFT_BG="\033[40m" ;;
esac

case $fg_name in
    1) COLOR_LEFT_FG="\033[37m" ;;
    2) COLOR_LEFT_FG="\033[31m" ;;
    3) COLOR_LEFT_FG="\033[32m" ;;
    4) COLOR_LEFT_FG="\033[34m" ;;
    5) COLOR_LEFT_FG="\033[35m" ;;
    6) COLOR_LEFT_FG="\033[30m" ;;
esac

case $bg_value in
    1) COLOR_RIGHT_BG="\033[47m" ;;
    2) COLOR_RIGHT_BG="\033[41m" ;;
    3) COLOR_RIGHT_BG="\033[42m" ;;
    4) COLOR_RIGHT_BG="\033[44m" ;;
    5) COLOR_RIGHT_BG="\033[45m" ;;
    6) COLOR_RIGHT_BG="\033[40m" ;;
esac

case $fg_value in
    1) COLOR_RIGHT_FG="\033[37m" ;;
    2) COLOR_RIGHT_FG="\033[31m" ;;
    3) COLOR_RIGHT_FG="\033[32m" ;;
    4) COLOR_RIGHT_FG="\033[34m" ;;
    5) COLOR_RIGHT_FG="\033[35m" ;;
    6) COLOR_RIGHT_FG="\033[30m" ;;
esac