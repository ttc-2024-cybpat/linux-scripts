#!DO_NOT_EXECUTE

# Utility script that checks for root and lets the script elevate to root if needed.

if [ -z "$__IG_ROOT_SH" ]; then

readonly __IG_ROOT_SH=1

### Sourcing ###

source "$CYBPAT_ROOT/lib/colors.sh"

### Functions ###

# Print the arguments of the calling script, in order.
function script_args {
    local n=${#BASH_ARGV[@]}

    if (( $n > 0 )); then
        # Get the last index of the args in BASH_ARGV.
        local n_index=$(( $n - 1 ))

        # Loop through the indexes from largest to smallest.
        for i in $(seq ${n_index} -1 0); do
            if (( $i < $n_index )); then
                echo -n ' '
            fi

            echo -n "${BASH_ARGV[$i]}"
        done

        echo
    fi
}

# Check if we are root
function isroot {
    if [ "$(id -u)" -ne 0 ]; then
        return 1
    fi
    return 0
}

# Elevate to root if not already
function elevate {
    if ! isroot; then
        decho "Elevating to root..."

        # Execute the command with any arguments passed to elevate
        local args=$(script_args)
        sudo -E "$0" $args
        exit 0
    fi
}

fi