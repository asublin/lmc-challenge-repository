#!/bin/bash

# Render present challenge annoucement in text format.

source common.sh

########
# Main #
########

present_challenge="$(get_present_challenge)"
lmc_round=$(get_lmc_round "${present_challenge}")
lmc_title="$(get_lmc_title "${present_challenge}")"
lmc_start_date=$(get_lmc_start_date "${present_challenge}")
lmc_end_date=$(get_lmc_end_date "${present_challenge}")
lmc_short_description="$(get_lmc_short_description "${present_challenge}")"
lmc_long_description="$(get_lmc_long_description "${present_challenge}")"

echo "Subject:"
echo "Libre Music Challenge #${lmc_round} ${lmc_title}"
echo
echo "Body:"
echo "Welcome to the Libre Music Challenge #${lmc_round}!"
echo
echo "[b]${lmc_short_description}[/b]"
echo
pandoc --from=markdown <<< "$lmc_long_description" --to=pandoc-bbcode-phpbb/phpbb.lua
echo
echo "Entries must be posted here before ?? ????? UTC. Meaning the last minute to submit your entry will be ?? ????? 23:59 UTC."
echo
echo "The general rules can be found [url=???]here[/url] (and will be rendered in a nicer format eventually)."
