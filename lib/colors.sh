#!DO_NOT_EXECUTE

# Utility script that implements pretty colors for logging.

if [ -z "$__IG_COLORS_SH" ]; then

readonly __IG_COLORS_SH=1

### Constants ###

# Background colors
readonly cbRed='\033[41m'    # Red
readonly cbYellow='\033[43m' # Yellow
readonly cbBlue='\033[44m'   # Blue
readonly cbGreen='\033[42m'  # Green
readonly cbGray='\033[40m'  # Gray

# Foreground colors
readonly cfRed='\033[31m'    # Red
readonly cfYellow='\033[33m' # Yellow
readonly cfBlue='\033[34m'   # Blue
readonly cfGreen='\033[32m'  # Green
readonly cfGray='\033[90m'   # Gray

# Reset color
readonly caReset='\033[0m'     # Reset

### Functions ###

function becho {
    local color="$1"
    local ident="$2"
    local rest="${@:3}"
    local date=$(date +'%H:%M:%S.%3N')
    echo -e "${cfGray}[${date}] ${cbGray}${color}${ident}${caReset} ${rest}"
}

function decho {
    becho $cfGray "DEBUG" "${@}"
}

function lecho {
    becho $cfGreen "  LOG" "${@}"
}

function iecho {
    becho $cfBlue " INFO" "${@}"
}

function wecho {
    becho $cfYellow " WARN" "${@}"
}

function eecho {
    becho $cfRed "ERROR" "${@}" >&2
}

fi