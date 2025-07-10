#!/bin/bash
source "$FUELECO_LOCATION/settings.sh"
source "$FUELECO_LOCATION/helper.sh"
source "$FUELECO_LOCATION/domain.sh"
source "$FUELECO_LOCATION/io.sh"

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
        DATE_HEADER="DATE"
        KM_HEADER="KM"
        LITERS_HEADER="LITERS"
        PRICE_HEADER="PRICE"
        ECO_HEADER="L/100KM"
        max_date_len=${#DATE_HEADER}
        max_km_len=${#KM_HEADER}
        max_liters_len=${#LITERS_HEADER}
        max_price_len=${#PRICE_HEADER}
        max_eco_len=${#ECO_HEADER}

        while read -r line; do 
            read -r date km l price <<< $(echo "$line" | tr ',' '\n')
            read -r date_len km_len liters_len price_len <<< $(echo "${#date},${#km},${#l},${#price}" | tr ',' '\n')

            if [ "$date_len" -gt "$max_date_len" ]; then
                max_date_len="$date_len"
            fi
            if [ "$km_len" -gt "$max_km_len" ]; then
                max_km_len="$km_len"
            fi
            if [ "$liters_len" -gt "$max_liters_len" ]; then
                max_liters_len="$liters_len"
            fi
            if [ "$price_len" -gt "$max_price_len" ]; then
                max_price_len="$price_len"
            fi
            lpkm=$(calculate "$l" "$km")
            lpkm_len="${#lpkm}"
            if [ "$lpkm_len" -gt "$max_eco_len" ]; then
                max_eco_len="$lpkm_len"
            fi

        done < <(tail -n +2 "$DATA_FILE")

        show_formatted "$DATE_HEADER:$max_date_len"  "$KM_HEADER:$max_km_len"  "$LITERS_HEADER:$max_liters_len"  "$PRICE_HEADER:$max_price_len" "$ECO_HEADER:$max_eco_len"

        while read -r line; do 
            read -r date km l price <<< $(echo "$line" | tr ',' '\n')
            lpkm=$(calculate "$l" "$km")
            show_formatted "$date:$max_date_len"  "$km:$max_km_len"  "$l:$max_liters_len"  "$price:$max_price_len" "$lpkm:$max_eco_len"
        done < <(tail -n +2 "$DATA_FILE")

        ;;
    test)
        ;;

    esac



