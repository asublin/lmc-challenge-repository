#!/bin/bash

# Randomly select a challenge file from the future folder.  Move it to
# the present folder and move the existing challenge in the present
# folder to the past folder.

source common.sh

########
# Main #
########

# Randomly select next challenge
nbr_challenges=$(ls -1 future | wc -l)
if [[ 0 -eq ${nbr_challenges} ]]; then
    log_error "No more challenge.  Please populate the future folder with challenges."
fi
rnd_challenge=$((RANDOM % ${nbr_challenges}))

# Retrieve today's date
today_date=$(date +%F)

# Calculate next round index
nbr_present_challenges=$(get_present_challenge | wc -l)
if [[ 1 -ne ${nbr_present_challenges} ]]; then
    log_error "There is not exactly one challenge in the present folder.  Please clean up the folder."
fi
present_challenge="$(get_present_challenge)"
present_challenge_base="$(basename "${present_challenge}")"
previous_lmc_idx=$(get_lmc_idx "${present_challenge_base}")
lmc_idx=$((previous_lmc_idx + 1))

# Move existing present challenge to past
log_info "Move previous challenge \"${present_challenge}\" to the past folder"
mv "${present_challenge}" past

# Move selected challenge from future to present.
i=0
for f in future/*; do
    f_base=$(basename "${f}")
    if [[ $i -eq $rnd_challenge ]]; then
        dst="present/LMC${lmc_idx} - ${today_date} - ${f_base}"
        mv "${f}" "${dst}"
        iplusone=$((i + 1))
        log_info "Select challenge \"${f}\" and move it to \"${dst}\""
    fi
    i=$((i + 1))
done

# Complete challenge with round, start date and end date
# NEXT
# Complete challenge with general fields
log_info "Complete \"$dst\" with general fields"
jq '. += {"rules": {}}' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules += { "general": [], "submission": [], "voting": []}' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
# General rules
jq '.rules.general += ["The challenge starts on the 1st of every odd month (Jan, Mar, May, Jul, Sep, Nov) and ends on the 15th (excluded) of the follow month."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["All submissions must be made with free (libre) software only.  This includes the DAW and all plugins.  A non-free operating system is allowed."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["Submissions must be original work produced specifically for this context.  No covers, remakes, or remixes of existing work."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["There is no song length limit."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["Collaborations are allowed."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["Regardless of any challenge-specific restriction on plugins, basic utility plugins are always allowed, unless specified otherwise.  These include things like Limiter, EQ and Filtering, Volume and Pan, and MIDI manipulation."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.general += ["Regardless of any software restriction, you are also allowed to use any hardware device to enhance your workflow, e.g. MIDI keyboard or other controllers."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
# Submission rules
jq '.rules.submission += ["You must submit your entry before the 15th of the following month, i.e. at 11:59pm (UTC) the lastest on the 14th."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.submission += ["To submit you must post a link of your entry to the thread corresponding to the current round on the Linux Musicians forum."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
# Voting rules
jq '.rules.voting += ["Voting runs from the 15th to the end of the following month of the challenge.  Failure to vote in time will result in disqualification."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["Voting is done by ranking 5 submissions (excluding yours) from 1st (best) to 5th (worse among the 5 best)."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["Participants of previous challenges are also welcome to vote, even if they have not made a submission."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["5 points are attributed to the submission with the highest rank, 4 to the second, 3 to the third, 2 to the fourth and 1 to the fifth.  No points are attributed to submissions that have not been ranked."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["The submission with the most points wins.  In case of ties all submissions with the maximum number of points are winners."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["Dependening on the round the winner(s) may receive prize(s) such as AUDIO tokens."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
jq '.rules.voting += ["To vote, post a message with your ranking to the corresponding thread on the Linux Musicians forum, or send it as private message to one of the organizers of the challenge."]' "${dst}" > "${dst}.$$" && mv "${dst}.$$" "${dst}"
