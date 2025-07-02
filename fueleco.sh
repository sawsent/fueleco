#!/bin/bash
source ./settings.sh
source ./helper.sh
source ./domain.sh

liters="$ARG_NOT_PROVIDED"
km="$ARG_NOT_PROVIDED"

# Collect command
cmd="$1"
shift

# Collect args
for arg in "$@"; do
case "$arg" in
    -l=*)
        liters="${arg#-l=}"
        liters=$(echo "$liters" | bc)
        ;;

    -km=*)
        km="${arg#-km=}"
        km=$(echo "$km" | bc)
        ;;

    --debug)
        ENABLE_DEBUG="true"

esac
done

# Execute command
case "$cmd" in
    calc)
        REQUIRE       "$liters" "$km" on-error: 'Liters and kilometers are mandatory.'
        REQUIRE NOT:0 "$km"           on-error: 'Kilometers can not be 0'

        lpkm=$(calculate "$liters" "$km")
        mpg=$(convert FROM:LPKM TO:MPG "$lpkm")

        echo "Fuel Economy: $lpkm L/100km // $mpg mpg"
        ;;

    add)
        echo "Not implemented yet"
        ;;

    avg)
        echo "Not implemented yet"
        ;;

    stats)
        echo "Not implemented yet"
        ;;

    show)
        echo "Not implemented yet"
        ;;

esac



