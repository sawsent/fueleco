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
