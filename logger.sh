# Log Levels
export DEBUG="5"
export INFO="4"
export WARN="3"
export ERROR="2"
export CRITICAL="1"
export NO_LOGS="0"
export LOG_LEVEL="0"

DEBUG() {
    if [ "$LOG_LEVEL" -ge "$DEBUG" ]; then
        identifier="$1"
        shift
        echo "[DEBUG] [$identifier] $@"
    fi
}

export -f DEBUG
