#!/bin/bash
source ./settings.sh
source ./helper.sh

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
        # Validate
        REQUIRE       "$liters" "$km" on-error: 'Liters and kilometers are mandatory.'
        REQUIRE NOT:0 "$km"           on-error: 'Kilometers can not be 0'

        liters_per_100km=$(echo "scale=$(echo "$DECIMALS + 2" | bc); ($liters / $km) * 100" | bc)
        liters_per_100km=$(echo "scale=$DECIMALS; $liters_per_100km / 1" | bc)
        echo "Liters per 100 km: $liters_per_100km"
        ;;
esac



