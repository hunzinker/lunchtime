#!/bin/sh
#
# It's lunchtime!!

DATA_FILE="${HOME}/.lunchdata"

PLACES="whole foods
patxis
chipotle
sweet ginger
true food kitchen
tony p's
pasta pasta pasta
mici
continental deli
zaidys
101 asian
so perfect eats
mad greens
little olies's
earls
north
cherry cricket
hapa
the hawt
bombay clay oven
cherry creek grill
aye caramba
shotgun willi's
machette
crepes a la crepes
eggshell cafe"

COIN_FLIP=
REPEAT=
LUNCHTIME=

#
# Heads or tails?
#
_flip_coin() {

    COIN_FLIP=$(echo "${RANDOM} % 2" | bc)

}

#
# Ensure data file exists.
#
_check_data_file() {

    local max=5
    local lines=0

    if [[ ! -e "${DATA_FILE}" ]]; then
        > ${DATA_FILE}
        return
    fi

    lines=$(wc -l ${DATA_FILE} | cut -d " " -f 1)

    if [[ $lines -ge $max ]]; then
        > ${DATA_FILE}
    fi

}

#
# Make sure we don't eat at the same place more than once a week!
#
_no_repeats() {

    REPEAT=0

    while read line; do
        if [[ "${line}" == "${LUNCHTIME}" ]]; then
            REPEAT=1
            break
        fi
    done < $DATA_FILE

    if [[ $REPEAT -gt 0 ]]; then
        lunchtime
    else
        echo $LUNCHTIME >> $DATA_FILE
    fi

}

#
# Where to?
#
lunchtime() {

    _flip_coin
    _check_data_file

    if [[ $COIN_FLIP -eq 0 ]]; then
        LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | head -n 1)
    else
        LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | tail -n 1)
    fi

    _no_repeats

    if [[ -z ${LUNCHTIME} ]]; then
        echo "An unexpected error occurred. Go to McDonalds."
        exit 1
    fi
}

lunchtime

cat <<-ART
##############################################################################
##############################################################################
#########################. .. ......############/----------------#############
#####################... .. .... .. ..######## / I want to go to \            
###################..... .... ... .....#######/  $LUNCHTIME /                 
#################....,...,;,...... ... .#####/ /##############################
################.....(*)(*).\... ......#####//################################
################.... .......|⊐...... .########################################
#################......,___/........##########################################
###################...............############################################
##############################################################################
##############################################################################
ART

exit 0
