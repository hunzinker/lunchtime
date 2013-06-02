#!/bin/sh
#
# It's lunchtime!!

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

COIN_FLIP=$(echo "${RANDOM} % 2" | bc)

if [[ $COIN_FLIP -eq 0 ]]; then
    LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | head -n 1)
else
    LUNCHTIME=$(echo "${PLACES}" | sort -R | sort -R | sort -R | tail -n 1)
fi

cat <<-ART
##############################################################################
##############################################################################
#########################. .. ......############/----------------#############
#####################... .. .... .. ..######## / I want to go to \            
###################..... .... ... .....#######/  $LUNCHTIME /                 
#################....,...,;,...... ... .#####/ /##############################
################.....(*)(*).\... ......#####//################################
################.... .......|>...... .########################################
#################......,___/........##########################################
###################...............############################################
##############################################################################
##############################################################################
ART
