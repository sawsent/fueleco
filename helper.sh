# Constants
export NOT_PROVIDED="ARG_NOT_PROVIDED"
export ENABLE_DEBUG="false"

# Functions
DEBUG() {
    if [ "$ENABLE_DEBUG" = "true" ]; then
        identifier="$1"
        shift
        echo "[$identifier] $@"
    fi
}

export -f DEBUG
REQUIRE() {
    fail_if_equal_to="$ARG_NOT_PROVIDED"
    fail="false"
    error_message="A required parameter is missing."
    for arg in $@; do
        case "$arg" in 
            NOT:*)
                fail_if_equal_to="${arg#NOT:}"
                DEBUG "REQUIRE" "Set require to fail if equal to '$fail_if_equal_to'"
                ;;
            on-error:)
                shift
                error_message="$@"
                break
                ;;
            "$fail_if_equal_to")
                fail="true"
                ;;
        esac
        shift
    done
    if [ "$fail" = "true" ]; then
        echo "$error_message"
        exit 1
    fi
}
export -f REQUIRE

