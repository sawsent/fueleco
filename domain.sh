
# Calculates L/100km
# args: 
#   1. liters
#   2. km
#   3. (optional) precision
calculate() {
    l="$1"
    km="$2"
    p="$PRECISION"
    if [ -n "$3" ]; then 
        p="$3" 
    fi

    lpkm=$(echo "scale=$(echo "$p + 2" | bc); ($l / $km) * 100" | bc)
    lpkm=$(echo "scale=$p; $lpkm / 1" | bc)

    echo "$lpkm"
}
export -f calculate

convert() {
    p="$PRECISION"
    for arg in "$@"; do
        case "$arg" in
            FROM:*)
                from="${arg#FROM:}"
                ;;
            TO:*)
                to="${arg#TO:}"
                ;;
            --precision:*)
                p="${arg#--precision:}"
                ;;
            *)
                amount="$arg"
                ;;
        esac
    done

    case "$from" in
        LPKM)
            case "$to" in 
                MPG)
                    converted=$(echo "scale=$p; (235.215 / $amount)" | bc)
                    echo "$converted"
                    ;;
            esac
            ;;
    esac
}
export -f convert
