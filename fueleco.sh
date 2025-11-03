#!/bin/bash
source "$FUELECO_LOCATION/settings.sh"
source "$FUELECO_LOCATION/helper.sh"
source "$FUELECO_LOCATION/domain.sh"
source "$FUELECO_LOCATION/io.sh"
source "$FUELECO_LOCATION/logger.sh"

liters="$NOT_PROVIDED"
km="$NOT_PROVIDED"
pl="$NOT_PROVIDED"
p="$NOT_PROVIDED"
use_profile_arg="$NOT_PROVIDED"
date="$(date +%Y:%m:%d)"

profile="$(get_stored_profile)"

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

    -pl=*)
        pl="${arg#-pl=}"
        pl=$(echo "$pl" | bc)
        ;;

    -p=*)
        p="${arg#-p=}"
        p=$(echo "$p" | bc)
        ;;

    -date=*)
        date="${arg#-date=}"
        ;;

    --debug)
        LOG_LEVEL="$DEBUG"

esac
done

DEBUG FUELECO "Active profile: $profile"

# Execute command
DEBUG FUELECO "Command: $cmd"
case "$cmd" in
    calc)
        REQUIRE       "$liters" "$km" on-error: 'Liters and kilometers are mandatory.'
        REQUIRE NOT:0 "$km"           on-error: 'Kilometers can not be 0'

        lpkm=$(calculate "$liters" "$km")
        mpg=$(convert FROM:LPKM TO:MPG "$lpkm")

        echo "Fuel Economy: $lpkm L/100km // $mpg mpg"
        ;;

    use)
        formatting="$1"
        if [ -n "$formatting" ]; then
            use_profile_arg="$formatting"
        fi
        REQUIRE "$use_profile_arg" on-error: "Profile not provided and is mandatory" 
        store_profile "$use_profile_arg"
        ;;

    add)
        REQUIRE "$profile" on-error: 'No profile set. Use -profile, or set profile with `fueleco use _profile_`'
        echo "Not implemented yet"
        ;;

    report)
        echo "Not implemented yet"
        ;;

    stats)
        echo "Not implemented yet"
        ;;

    show)
        if [ -e "$DATA_LOCATION/$profile.csv" ]; then
            DATE_HEADER="DATE"
            KM_HEADER="KM"
            LITERS_HEADER="LITERS"
            PRICE_HEADER="PRICE"
            PRICE_PER_LITER_HEADER="PRICE/L"
            ECO_HEADER="L/100KM"
            max_date_len=${#DATE_HEADER}
            max_km_len=${#KM_HEADER}
            max_liters_len=${#LITERS_HEADER}
            max_price_len=${#PRICE_HEADER}
            max_price_per_liter_len=${#PRICE_PER_LITER_HEADER}
            max_eco_len=${#ECO_HEADER}

            while read -r line; do 
                read -r date km l price price_per_liter <<< $(echo "$line" | tr ',' '\n')
                read -r date_len km_len liters_len price_len price_per_liter_len <<< $(echo "${#date},${#km},${#l},${#price},${#price_per_liter}" | tr ',' '\n')

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
                if [ "$price_per_liter_len" -gt "$max_price_per_liter_len" ]; then
                    max_price_per_liter_len="$price_per_liter_len"
                fi
                lpkm=$(calculate "$l" "$km")
                lpkm_len="${#lpkm}"
                if [ "$lpkm_len" -gt "$max_eco_len" ]; then
                    max_eco_len="$lpkm_len"
                fi

            done < <(tail -n +2 "$DATA_LOCATION/$profile.csv")

            show_formatted "$DATE_HEADER:$max_date_len" "$KM_HEADER:$max_km_len" "$LITERS_HEADER:$max_liters_len" "$PRICE_HEADER:$max_price_len" "$PRICE_PER_LITER_HEADER:$max_price_per_liter_len" "$ECO_HEADER:$max_eco_len" 

            while read -r line; do 
                read -r date km l price price_per_liter <<< $(echo "$line" | tr ',' '\n')
                lpkm=$(calculate "$l" "$km")
                show_formatted "$date:$max_date_len"  "$km:$max_km_len"  "$l:$max_liters_len"  "$price:$max_price_len" "$price_per_liter:$max_price_per_liter_len" "$lpkm:$max_eco_len"
            done < <(tail -n +2 "$DATA_LOCATION/$profile.csv")


        else
            echo "No profile data found for profile: $profile"
        fi

        ;;
    test)
        ;;

    profile)
        echo "Active profile: $profile"

    esac



