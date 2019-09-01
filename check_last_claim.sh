#!/bin/bash
################################################################################
#
# Script created by @samnoble @ankh2054 for https://eosdublin.com & https://www.eos42.io
#
# Visit https://github.com/eos42/Nagios-Plugins/ for details.
#
################################################################################
DIR=/opt
PRODUCER=teloskitchen
DAY=86400

producer_state=$(cleos get table eosio eosio producers -l 1 -k owner -L teloskitchen)
LAST_CLAIM=$(echo $producer_state | jq -r '.rows[0].last_claim_time')

# Calculate diff
CLAIM_TIME=$(date -d "$LAST_CLAIM" +"%s")
NOW=$(date +"%s")
DIFF="$(($NOW-$CLAIM_TIME))"


if [ $DIFF -gt $DAY ]; then
        echo "Your last claim was over 24 hours ago"
        exit 2
else
        echo "Last claim action was on ${LAST_CLAIM}"
        exit 0
fi
