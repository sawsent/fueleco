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

create_profile_if_doesnt_exist() {
    profile_to_create="$1"
    DEBUG IO "Creating profile: $profile_to_create"

    if [ -e "$DATA_LOCATION/$profile_to_create.csv" ]; then
        DEBUG IO "Profile $profile_to_create already exists."
    else
        touch "$DATA_LOCATION/$profile_to_create.csv"
        echo "date,km,liters,price,price_per_liter" > "$DATA_LOCATION/$profile_to_create.csv"
    fi
}

add_entry() {
    profile="$1"
    date="$2"
    km="$3"
    liters="$4"
    price="$5"
    price_per_liter="$6"

    if [ -e "$DATA_LOCATION/$profile.csv" ]; then
        DEBUG IO "Storing new entry on profile $profile: date=$date, liters=$liters, km=$km, price=$price, price_per_liter=$price_per_liter"
        echo "$date,$km,$liters,$price,$price_per_liter" >> "$DATA_LOCATION/$profile.csv"
    else
        echo "Profile $profile does not exist"
    fi
}

delete_profile() {
    profile="$1"
    if [ -e "$DATA_LOCATION/$profile.csv" ]; then
        DEBUG IO "Deleting profile $profile"
        rm "$DATA_LOCATION/$profile.csv"
    else
        echo "Profile $profile does not exist"
    fi
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
export -f create_profile_if_doesnt_exist
export -f add_entry
