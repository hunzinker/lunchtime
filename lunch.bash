#!/usr/bin/env bash
#
# It's lunchtime!!

##---- Global Variables ----------------------------------------------------##


VERSION="0.1.0"

BINARIES=( sort )

DATA_FILE="${HOME}/.lunchdata"

# Maximum number of places to prevent repeats.
MAX_DATA_FILE_LINES=5

# Default lunch choices.
PLACES="Chipotle
Jimmy John's
Subway
Taco Bell
Wendy's
Whole Foods"

FILE=
COIN_FLIP=
LUNCHTIME=


##---- End Global Variables ------------------------------------------------##



##---- Private -------------------------------------------------------------##


#
# Check max data file lines.
#
_check_max_data_file_lines() {

    local num=$(echo "${PLACES}" | wc -l)
    if [ $num -lt $MAX_DATA_FILE_LINES ]; then
        MAX_DATA_FILE_LINES="${num}"
    fi

}

#
# Validate and read input file.
#
_validate_file() {

    if [ ! -e $FILE ]; then
        printf "Irregular file: %s\n" $FILE
        exit 1
    fi

    PLACES=$(<$FILE)

    _check_max_data_file_lines

}

#
# Ensure we have access to sort -R, --random-sort
#
_check_sort() {

    local name=$(uname)

    echo "foo" | sort -R > /dev/null 2>&1

    if [ $? -gt 0 ]; then

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


##---- End Private ---------------------------------------------------------##



##---- Public --------------------------------------------------------------##


usage() {

cat <<-USAGE

    Lunchtime v$VERSION

    usage: lunch.bash [OPTIONS]

    Optional arguments:

    -f lunchbox file            Path to newline (\n) delimited lunchbox file.

    -v version                  Display version and exit.
    (-h)                        Display this message and exit.

    License:
    MIT

    Author:
    Ken Seal

USAGE
}

#
# Where to?
#
lunchtime() {

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


##---- End Public ----------------------------------------------------------##



##---- Begin ---------------------------------------------------------------##


while getopts ':f:vh' OPTION; do
    case $OPTION in
    f)  FILE="${OPTARG}"
        _validate_file
        ;;
    v)  echo "v${VERSION}"
        exit 0
        ;;
    h)  usage
        exit 0
        ;;
    \:) printf "Argument missing: %s option\n" $OPTARG
        usage
        exit 1
        ;;
    \?) printf "Unknown option: %s\n" $OPTARG
        usage
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

_check_binaries

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


##---- End -----------------------------------------------------------------##
