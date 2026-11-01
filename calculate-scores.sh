#!/bin/bash

# Aggregates the votes of the participants to calculate their scores.

# Source common.sh
source common.sh

#############
# Functions #
#############

# Extract artists at given rank from present json file
artists_at_rank() {
    rank="$1"
    jq --arg r $rank '.votes.[] | select(has($r) and [$r] != null) | .[$r].artist' "${present_challenge}"
}

########
# Main #
########

# Declare associative array mapping entries to scores
declare -A entry_to_score

# # Declare arrays holding the ranked artists
# declare -a lst_1st=() lst_2nd=() lst_3rd=() lst_4th=() lst_5th=()

# Get present challenge filepath
present_challenge="$(get_present_challenge)"

# Fill lst_1st to lst_5th arrays
for r in {1..5}; do
    case $r in
        1) mapfile -t lst_1st <<< $(artists_at_rank $r)
           ;;
        2) mapfile -t lst_2nd <<< $(artists_at_rank $r)
           ;;
        3) mapfile -t lst_3rd <<< $(artists_at_rank $r)
           ;;
        4) mapfile -t lst_4th <<< $(artists_at_rank $r)
           ;;
        5) mapfile -t lst_5th <<< $(artists_at_rank $r)
           ;;
    esac
done

echo "Artists ranked first: ${lst_1st[@]}"
echo "Artists ranked second: ${lst_2nd[@]}"
echo "Artists ranked third: ${lst_3rd[@]}"
echo "Artists ranked fourth: ${lst_4th[@]}"
echo "Artists ranked fifth: ${lst_5th[@]}"

# Populate entry_to_score
for i in ${!lst_1st[@]}; do
    author="${lst_1st[${i}]}"
    if [ -n "$author" ]; then
        s=entry_to_score["$author"]
        entry_to_score["$author"]=$((s + 5))
    fi
done
for i in ${!lst_2nd[@]}; do
    author="${lst_2nd[${i}]}"
    if [ -n "$author" ]; then
        s=entry_to_score["$author"]
        entry_to_score["$author"]=$((s + 4))
    fi
done
for i in ${!lst_3rd[@]}; do
    author="${lst_3rdnd[${i}]}"
    if [ -n "$author" ]; then
        s=entry_to_score["$author"]
        entry_to_score["$author"]=$((s + 3))
    fi
done
for i in ${!lst_4th[@]}; do
    author="${lst_4th[${i}]}"
    if [ -n "$author" ]; then
        s=entry_to_score["$author"]
        entry_to_score["$author"]=$((s + 2))
    fi
done
for i in ${!lst_5th[@]}; do
    author="${lst_5th[${i}]}"
    if [ -n "$author" ]; then
        s=entry_to_score["$author"]
        entry_to_score["$author"]=$((s + 1))
    fi
done

# NEXT: produce a table (or CSV): Author, Track, Rank, Score
echo "${entry_to_score[@]}"
echo "${!entry_to_score[@]}"

# # NEXT: automatically populate present json file with scores
