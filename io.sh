source "$FUELECO_LOCATION/helper.sh"

show_formatted() {
    delimiter=" | "
    result=""

    for item in "$@" ; do
        if [ -n "$result" ]; then
            result+="$delimiter"
        fi

        read -r i il <<< $(echo "$item" | tr ':' '\n')
        result+="$i$(printf "%*s" "$(expr "$il" - "${#i}")" "")"

    done
    echo "$result"
}

get_stored_profile() {
    if [ -e filename ]; then
        stored_profile="$(read -r first_line < .profile)"
    else
        stored_profile="$NOT_PROVIDED"
    fi
    echo "$stored_profile"
}

export -f show_formatted
export -f get_stored_profile
