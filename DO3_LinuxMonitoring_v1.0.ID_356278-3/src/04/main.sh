#!/bin/bash

CONFIG_FILE="$(dirname "$0")/config.cfg"
DEFAULT_COL1_BG=1
DEFAULT_COL1_FG=2
DEFAULT_COL2_BG=3
DEFAULT_COL2_FG=4

col1_bg_val=$DEFAULT_COL1_BG
col1_fg_val=$DEFAULT_COL1_FG
col2_bg_val=$DEFAULT_COL2_BG
col2_fg_val=$DEFAULT_COL2_FG

col1_bg_src="default"
col1_fg_src="default"
col2_bg_src="default"
col2_fg_src="default"

if [ -f "$CONFIG_FILE" ] && [ -r "$CONFIG_FILE" ]; then
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        key=$(echo "$key" | xargs | tr -d '\r')
        value=$(echo "$value" | xargs | tr -d '\r')
        if [ -z "$key" ] || [ -z "$value" ]; then
            continue
        fi
        if ! [[ "$value" =~ ^[1-6]$ ]]; then
            echo "Invalid value for $key: must be 1-6." >&2
            exit 1
        fi
        case "$key" in
            column1_background)
                col1_bg_val=$value
                col1_bg_src="config"
                ;;
            column1_font_color)
                col1_fg_val=$value
                col1_fg_src="config"
                ;;
            column2_background)
                col2_bg_val=$value
                col2_bg_src="config"
                ;;
            column2_font_color)
                col2_fg_val=$value
                col2_fg_src="config"
                ;;
        esac
    done < "$CONFIG_FILE"
fi

if [ "$col1_bg_val" -eq "$col1_fg_val" ]; then
    echo "Column 1 background and font must differ." >&2
    exit 1
fi
if [ "$col2_bg_val" -eq "$col2_fg_val" ]; then
    echo "Column 2 background and font must differ." >&2
    exit 1
fi

bg_name=$col1_bg_val
fg_name=$col1_fg_val
bg_value=$col2_bg_val
fg_value=$col2_fg_val

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/color.sh"
source "$SCRIPT_DIR/info.sh"
source "$SCRIPT_DIR/output.sh"

echo

declare -A color_names=([1]="white" [2]="red" [3]="green" [4]="blue" [5]="purple" [6]="black")

[ "$col1_bg_src" = "default" ] && bg1_disp="default (${color_names[$col1_bg_val]})" || bg1_disp="$col1_bg_val (${color_names[$col1_bg_val]})"
[ "$col1_fg_src" = "default" ] && fg1_disp="default (${color_names[$col1_fg_val]})" || fg1_disp="$col1_fg_val (${color_names[$col1_fg_val]})"
[ "$col2_bg_src" = "default" ] && bg2_disp="default (${color_names[$col2_bg_val]})" || bg2_disp="$col2_bg_val (${color_names[$col2_bg_val]})"
[ "$col2_fg_src" = "default" ] && fg2_disp="default (${color_names[$col2_fg_val]})" || fg2_disp="$col2_fg_val (${color_names[$col2_fg_val]})"

echo "Column 1 background = $bg1_disp"
echo "Column 1 font color = $fg1_disp"
echo "Column 2 background = $bg2_disp"
echo "Column 2 font color = $fg2_disp"