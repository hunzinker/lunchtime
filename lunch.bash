#!/usr/bin/env bash
#
# It's lunchtime!!

BINARIES=( sort )

DATA_FILE="${HOME}/.lunchdata"

# Maximum number of places to prevent repeats.
MAX_DATA_FILE_LINES=5

PLACES="whole foods
patxis
chipotle
sweet ginger
true food kitchen
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
kona grill
california pizza kitchen
margs
eggshell cafe
patio grilling party"

COIN_FLIP=
LUNCHTIME=

usage() {

cat <<-USAGE

    Lunchtime

    usage: lunch.bash [-f]

    -f lunchbox file            Path to lunchbox file.

    (-h)                        Display this message.

    License:
    MIT

    Author:
    Ken Seal

USAGE
}

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

        case $name in
            "Darwin")
                echo "System: ${name}  "
                echo "brew install coreutils should fix the problem..."
                ;;
            "Linux")
                echo "System: ${name}  "
                echo "sudo <package manager> install coreutils should fix the problem..."
                ;;
            *)
                echo "System: ${name}  "
                echo "Not supported :'("
                ;;
        esac

        exit 1
    fi

}

#
# Ensure binaries are available.
#
_check_binaries() {

    for b in ${BINARIES[@]}; do
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

    COIN_FLIP=$(expr ${RANDOM} % 2)

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
        LUNCHTIME=$(echo "${PLACES}" | sort -R | head -n 1)
    else
        LUNCHTIME=$(echo "${PLACES}" | sort -R | tail -n 1)
    fi

    _no_repeats

    if [ -z "${LUNCHTIME}" ]; then
        echo "An unexpected error occurred. Go to McDonalds..."
        exit 1
    fi
}

while getopts ':f:h' OPTION; do
    case $OPTION in
    f)  FILE="${OPTARG}"
        if [ -e $FILE ]; then
            PLACES=$(<$FILE)
        else
            printf "Irregular file for -%s\n" $OPTARG
            exit 1
        fi
        ;;
    h)  usage
        exit 0
        ;;
    \:) printf "Argument missing from -%s option\n" $OPTARG
        usage
        exit 1
        ;;
    \?) printf "Unknown option: -%s\n" $OPTARG
        usage
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

lunchtime

cat <<-ART
######################################################################
###################. .. ......############/----------------###########
###############... .. .... .. ..######## / I want to go to \          
#############..... .... ... .....#######/  $LUNCHTIME /               
###########....,...,;,...... ... .#####/ /############################
##########.....(*)(*).\... ......#####//##############################
##########.... .......|⊐...... .######################################
###########......,___/........########################################
#############...............##########################################
######################################################################
ART

exit 0
