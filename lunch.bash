#!/usr/bin/env bash
#
# It's lunchtime!!

BINARIES=( bc sort )

DATA_FILE="${HOME}/.lunchdata"

# Maximum number of places to prevent repeats.
MAX_DATA_FILE_LINES=5

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
phat thai
kona grill
california pizza kitchen
margs
eggshell cafe
patio grilling party"

COIN_FLIP=
LUNCHTIME=

#
# Ensure we have access to sort -R, --random-sort
#
_check_sort() {

    local name=$(uname)
    local fail=0

    echo "foo" | sort -R > /dev/null 2>&1

    if [ $? -gt 0 ]; then
        fail=1
    fi

    if [ ${fail} -gt 0 ]; then

        if [ "${name}" == "Darwin" ]; then
            echo "System: ${name}  "
            echo "brew install coreutils should fix the problem..."
        elif [ "${name}" == "Linux" ]; then
            echo "System: ${name}  "
            echo "sudo <package manager> install coreutils should fix the problem..."
        else
            echo "System: ${name}  "
            echo "Not supported :'("
        fi

        exit 1
    fi

}

#
# Ensure binaries are available.
#
_check_binaries() {

    for b in ${BINARIES}; do
        hash "$b" > /dev/null 2>&1
        if [ $? -gt 0 ]; then
            echo "Missing binary: ${b}  please install to continue..."
            exit 1
        fi
    done

    _check_sort

}

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

    local lines=0

    if [ ! -e "${DATA_FILE}" ]; then
        > ${DATA_FILE}
        return
    fi

    lines=$(wc -l ${DATA_FILE} | cut -d " " -f 1)

    if [ $lines -ge $MAX_DATA_FILE_LINES ]; then
        > ${DATA_FILE}
    fi

}

#
# Make sure we don't eat at the same place more than once a week!
#
_no_repeats() {

    local repeat=0

    while read line; do
        if [ "${line}" == "${LUNCHTIME}" ]; then
            repeat=1
            break
        fi
    done < $DATA_FILE

    if [ $repeat -gt 0 ]; then
        lunchtime
    else
        echo $LUNCHTIME >> $DATA_FILE
    fi

}

#
# Where to?
#
lunchtime() {

    _check_binaries

    _flip_coin
    _check_data_file

    if [[ $COIN_FLIP -eq 0 ]]; then
        LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | head -n 1)
    else
        LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | tail -n 1)
    fi

    _no_repeats

    if [ -z "${LUNCHTIME}" ]; then
        echo "An unexpected error occurred. Go to McDonalds..."
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
