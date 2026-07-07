#!/bin/bash

# Render present challenge annoucement in text format.

source common.sh

########
# Main #
########

present_challenge="$(get_present_challenge)"
lmc_round=$(get_lmc_round "${present_challenge}")
lmc_title=$(get_lmc_title "${present_challenge}")
lmc_start_date=$(get_lmc_start_date "${present_challenge}")
lmc_end_date=$(get_lmc_end_date "${present_challenge}")

echo "Title:"
echo "Libre Music Challenge #${lmc_idx} ${lmc_title}"
echo
echo "Body:"
echo "Welcome to the Libre Music Challenge #${lmc_idx}!"
#NEXT
