source "$FUELECO_LOCATION/helper.sh"
source "$FUELECO_LOCATION/settings.sh"

store_profile() {
    DEBUG IO "Saving profile: $1"
    profile_to_store="$1"
    echo "$profile_to_store" > "$PROFILE_FILE"
}

get_stored_profile() {
    if [ -e "$PROFILE_FILE" ]; then
        read -r stored_profile < "$PROFILE_FILE"
    else
        stored_profile="$NOT_PROVIDED"
    fi
    echo "$stored_profile"
}


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

export -f show_formatted
export -f get_stored_profile
export -f store_profile
