#!/bin/sh

PLACES="whole foods,patxis,chipotle,sweet ginger,true food,tony p's,pasta
pasta pasta,mici,continental deli,zaidys,101 asian,so perfect eats,mad
greens,little olies's,earls,north,cherry cricket,hapa,the hawt,bombay clay
oven,cherry creek grill,aye caramba,shotgun willi's,machette,crepes a la
crepes,eggshell cafe"

echo $PLACES | tr "," "\n" | sort -R | sort -R | sort -R | head -n 1
