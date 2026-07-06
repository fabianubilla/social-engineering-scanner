#!/bin/bash
# =============================================================================
# social-engineering-scanner
# educational project by Fabian Ubilla
# License: MIT
#
# A script to learn why detecting digital manipulation is a hard problem.
# It searches for words associated with social engineering techniques and scores
# them. The point is not what it detects, but understanding where and how it
# fails.
#
# Requires: Bash. No external dependencies.
# =============================================================================


# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
RESET='\033[0m'

# ── Global state ─────────────────────────────────────────────────────────────
SCORE=0
TEXT=""
FINAL_LESSON=""
GUIDED_VERDICT=""   # Overrides the generic result block in guided examples.


# ── UI helpers ───────────────────────────────────────────────────────────────

print_header() {
    clear
    echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${WHITE}social-engineering-scanner${RESET}                         ${CYAN}│${RESET}"
    echo -e "${CYAN}│${RESET}  ${GRAY}educational project${RESET}                                ${CYAN}│${RESET}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

pause_screen() {
    echo ""
    echo -e "${GRAY}[ press Enter to continue ]${RESET}"
    read -r
}

pause_section() {
    # Pause between sections with a more visible divider.
    echo ""
    echo -e "${CYAN}·····················································${RESET}"
    echo -e "${GRAY}  [ Enter to continue ]${RESET}"
    echo -e "${CYAN}·····················································${RESET}"
    read -r
    clear
    echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}│${RESET}  ${WHITE}social-engineering-scanner${RESET}                         ${CYAN}│${RESET}"
    echo -e "${CYAN}│${RESET}  ${GRAY}educational project by Fabian Ubilla${RESET}               ${CYAN}│${RESET}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

print_divider() {
    echo -e "${BLUE}──────────────────────────────────────────────────────${RESET}"
}

print_section_title() {
    echo ""
    echo -e "${MAGENTA}▌ $1${RESET}"
    print_divider
}

print_box_line() {
    local color="$1"
    local text="$2"
    echo -e "${color}│${RESET}  $text"
}

print_box_blank() {
    local color="$1"
    echo -e "${color}│${RESET}"
}


# ── Text normalization ───────────────────────────────────────────────────────
# Lowercase + replace accented characters.
# Prevents "URGENT" or "urgent" with accents from bypassing detection.
normalize_text() {
    echo "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | sed 'y/áéíóúüñÁÉÍÓÚÜÑ/aeiouunAEIOUUN/'
}


# ── Search engine ────────────────────────────────────────────────────────────
# Match single-word keywords as whole words to avoid substring false positives
# like "hr" inside "afterward". Multi-word phrases are matched literally.
keyword_matches() {
    local haystack="$1"
    local keyword="$2"
    local escaped_keyword=""

    if [[ "$keyword" == *" "* ]]; then
        grep -Fq -- "$keyword" <<<"$haystack"
        return
    fi

    escaped_keyword=$(printf '%s\n' "$keyword" | sed 's/[][(){}.^$+*?|\\-]/\\&/g')
    grep -Eq "(^|[^[:alnum:]_])${escaped_keyword}([^[:alnum:]_]|$)" <<<"$haystack"
}

# For each matched word, print an alert and add 1 point to the score.
scan_signals() {
    local signal_name="$1"
    local signal_description="$2"
    shift 2
    local keywords=("$@")
    local matched_words=""

    for keyword in "${keywords[@]}"; do
        if keyword_matches "$normalized_text" "$keyword"; then
            matched_words="${matched_words}${YELLOW}'${keyword}'${RESET} "
            (( SCORE++ ))
        fi
    done

    if [ -n "$matched_words" ]; then
        echo -e "${RED}  [ DETECTED ]  $signal_name${RESET}"
        echo -e "      ${GRAY}$signal_description${RESET}"
        echo -e "      Found words: $matched_words"
    else
        echo -e "${GREEN}  [ no signals ]  $signal_name${RESET}"
    fi
    echo ""
}


# ── Full analysis ────────────────────────────────────────────────────────────
run_analysis() {
    SCORE=0
    normalized_text=$(normalize_text "$TEXT")

    # ── STAGE 1: show the text ─────────────────────────────────────────────
    print_section_title "ANALYZED TEXT"
    echo -e "${GRAY}${TEXT:0:600}${RESET}"
    if [ ${#TEXT} -gt 600 ]; then
        echo -e "${GRAY}[continues - the engine analyzed the full message]${RESET}"
    fi

    pause_section

    # ── STAGE 2: detected signals ──────────────────────────────────────────
    echo ""
    echo -ne "${YELLOW}  Analyzing "
    for i in {1..20}; do echo -ne "."; sleep 0.03; done
    echo -e " done${RESET}"

    print_section_title "DETECTED SIGNALS"

    # ── SIGNAL 1: URGENCY
    # Creates pressure to act before verifying.
    scan_signals \
        "URGENCY - they pressure you into acting before thinking" \
        "They want you to act before verifying whether the message is real." \
        "urgent" "expires" "immediate" "today" "now" "24 hours" \
        "deadline" "suspension" "block" "final notice" "consequences" \
        "action required" "limit" "quick" "due" "bank closing"

    # ── SIGNAL 2: AUTHORITY
    # Impersonates a figure of power to trigger automatic obedience.
    scan_signals \
        "AUTHORITY - they pretend to be someone in power" \
        "They exploit respect for hierarchy so you obey without questioning." \
        "manager" "director" "ceo" "legal" "police" "tax agency" "treasury" \
        "boss" "bank" "support" "admin" "security" "official" \
        "auditor" "lawyer" "court" "hr" "supervisor"

    # ── SIGNAL 3: LURE
    # Offers something unexpected to lower the recipient's guard.
    scan_signals \
        "LURE - something too good to be true" \
        "They use rewards to distract you from the real risk." \
        "won" "bonus" "prize" "gift" "free" "offer" \
        "refund" "benefit" "selected" "exclusive" \
        "discount" "reward" "balance" "credited"

    pause_section

    # ── STAGE 3: result ────────────────────────────────────────────────────
    echo ""
    echo -e "${MAGENTA}▌ RESULT${RESET}"
    print_divider

    if [ -n "$GUIDED_VERDICT" ]; then
        echo -e "$GUIDED_VERDICT"
    else
        if [ "$SCORE" -eq 0 ]; then
            echo -e "  Level:  ${GREEN}NO SIGNALS${RESET}  ($SCORE points)"
            echo ""
            echo -e "  ${GRAY}The detector did not find any matches in its rules."
            echo -e "  That does not mean the message is legitimate."
            echo -e "  It only means it avoided the words in the list.${RESET}"
        elif [ "$SCORE" -le 3 ]; then
            echo -e "  Level:  ${YELLOW}MILD SIGNALS${RESET}  ($SCORE points)"
            echo ""
            echo -e "  ${GRAY}The text contains words that appear in"
            echo -e "  fraudulent messages, but also in legitimate ones."
            echo -e "  The detector cannot distinguish the context.${RESET}"
        else
            echo -e "  Level:  ${RED}STRONG SIGNALS${RESET}  ($SCORE points)"
            echo ""
            echo -e "  ${GRAY}The text triggered multiple rules."
            echo -e "  That raises suspicion, but it does not prove fraud."
            echo -e "  The detector recognizes patterns, not intentions.${RESET}"
        fi
    fi

    print_divider

    # ── STAGE 4: lesson (guided examples only) ─────────────────────────────
    if [ -n "$FINAL_LESSON" ]; then
        pause_section
        echo -e "$FINAL_LESSON"
    fi
}


# =============================================================================
# GUIDED EXAMPLES
#
# Pedagogical order:
#   1. Clean email       -> detector works. Baseline.
#   2. CEO fraud         -> detector works. Real case.
#   3. False positive    -> detector fails on a legitimate message.
#   4. Bypass            -> detector misses a real scam.
# =============================================================================

show_clean_email_example() {
    echo ""
    echo -e "${GREEN}┌─ What you are about to see ─────────────────────────${RESET}"
    print_box_blank $GREEN
    print_box_line $GREEN "A real newsletter. There is no intention to deceive."
    print_box_blank $GREEN
    print_box_line $GREEN "${GRAY}Question before seeing the result:${RESET}"
    print_box_line $GREEN "${WHITE}what do you expect the script to detect?${RESET}"
    print_box_blank $GREEN
    echo -e "${GREEN}└─────────────────────────────────────────────────────${RESET}"
    pause_screen

    TEXT="Hello,

This week on the platform: new Python courses, UX design,
and networking fundamentals. We also published the monthly
summary with the most viewed content from the community.

You can manage your preferences or unsubscribe
at any time from your profile.

Content team"

    GUIDED_VERDICT="  Level:  ${GREEN}NO SIGNALS${RESET}

  ${GRAY}This message is a legitimate newsletter.
  The detector did not find any matches.
  In this case, that is the correct answer.${RESET}"

    FINAL_LESSON="
${GREEN}┌─ What happened ─────────────────────────────────────${RESET}
${GREEN}│${RESET}
${GREEN}│${RESET}  The detector worked well.
${GREEN}│${RESET}
${GREEN}│${RESET}  The text has no urgency words,
${GREEN}│${RESET}  authority, or promises.
${GREEN}│${RESET}  It is just information - there is nothing to hook onto.
${GREEN}│${RESET}
${GREEN}└─────────────────────────────────────────────────────${RESET}

${GRAY}┌─ The question that matters ─────────────────────────${RESET}
${GRAY}│${RESET}
${GRAY}│${RESET}  Could a scammer write a message
${GRAY}│${RESET}  just as clean?
${GRAY}│${RESET}
${GRAY}│${RESET}  Yes.
${GRAY}│${RESET}
${GRAY}│${RESET}  That is why 'no signals' does not mean 'safe'.
${GRAY}│${RESET}  It only means it did not use the words in the list.
${GRAY}│${RESET}
${GRAY}└─────────────────────────────────────────────────────${RESET}"

    run_analysis
}

show_ceo_fraud_example() {
    echo ""
    echo -e "${RED}┌─ What you are about to see ─────────────────────────${RESET}"
    print_box_blank $RED
    print_box_line $RED "Someone pretends to be the boss and asks for a transfer."
    print_box_blank $RED
    print_box_line $RED "It is one of the most costly frauds for companies."
    print_box_line $RED "The FBI calls it Business Email Compromise (BEC)."
    print_box_blank $RED
    print_box_line $RED "${GRAY}Question before seeing the result:${RESET}"
    print_box_line $RED "${WHITE}how many signals do you think it will detect?${RESET}"
    print_box_blank $RED
    echo -e "${RED}└─────────────────────────────────────────────────────${RESET}"
    pause_screen

    TEXT="Hello, this is Robert Sanchez, general manager.

I am in a board meeting and cannot talk
by phone right now.

I need you to make a transfer today before
bank closing to a new supplier.

The amount is \$2,800,000 and it is related to
approved bonuses for the quarter close.

I will send you the account details through this channel.

Do not mention it to the rest of the team yet
until it is done.

Thanks"

    GUIDED_VERDICT="  Level:  ${RED}STRONG SIGNALS${RESET}

  ${GRAY}This message is a real CEO fraud case.
  The detector caught it because the attacker used words
  that are inside its rules.${RESET}"

    FINAL_LESSON="
${RED}┌─ What happened ─────────────────────────────────────${RESET}
${RED}│${RESET}
${RED}│${RESET}  The detector worked here.
${RED}│${RESET}
${RED}│${RESET}  Authority:   'manager', 'board'
${RED}│${RESET}  Urgency:     'today', 'now', 'closing'
${RED}│${RESET}  Benefit:     'bonuses'
${RED}│${RESET}
${RED}└─────────────────────────────────────────────────────${RESET}

${YELLOW}┌─ The signal the script does not detect ─────────────${RESET}
${YELLOW}│${RESET}
${YELLOW}│${RESET}  'Do not mention it to the rest of the team yet.'
${YELLOW}│${RESET}
${YELLOW}│${RESET}  That is called isolation.
${YELLOW}│${RESET}  It is one of the clearest signs of real CEO fraud:
${YELLOW}│${RESET}  preventing the victim from verifying with someone
${YELLOW}│${RESET}  before acting.
${YELLOW}│${RESET}
${YELLOW}│${RESET}  The detector caught the message because of the words.
${YELLOW}│${RESET}  But the real danger was the isolation.
${YELLOW}│${RESET}
${YELLOW}└─────────────────────────────────────────────────────${RESET}"

    run_analysis
}

show_false_positive_example() {
    echo ""
    echo -e "${YELLOW}┌─ What you are about to see ─────────────────────────${RESET}"
    print_box_blank $YELLOW
    print_box_line $YELLOW "A ${WHITE}completely legitimate${RESET} email from a real bank."
    print_box_blank $YELLOW
    print_box_line $YELLOW "There is no deception. It is bank marketing."
    print_box_blank $YELLOW
    print_box_line $YELLOW "${GRAY}Question before seeing the result:${RESET}"
    print_box_line $YELLOW "${WHITE}will it mark it as dangerous?${RESET}"
    print_box_blank $YELLOW
    echo -e "${YELLOW}└─────────────────────────────────────────────────────${RESET}"
    pause_screen

    TEXT="Dear customer,

Your preferred-rate offer expires today.

If you take the loan before end of business,
the bank applies the special rate of 0.8% per month.

This offer is exclusive to selected customers.

For more information, contact your account executive
or visit your nearest branch.

National Bank - Commercial Division"

    GUIDED_VERDICT="  Level:  ${RED}STRONG SIGNALS${RESET}  - but the message is legitimate.

  ${YELLOW}This is a false positive.${RESET}

  ${GRAY}The detector found: 'expires', 'today', 'bank',
  'offer', and 'selected'.

  But the email is real.
  It is legitimate bank marketing.${RESET}"

    FINAL_LESSON="
${YELLOW}┌─ What happened ─────────────────────────────────────${RESET}
${YELLOW}│${RESET}
${YELLOW}│${RESET}  The detector raised an alert.
${YELLOW}│${RESET}  The message is not a scam.
${YELLOW}│${RESET}
${YELLOW}│${RESET}  This is called a false positive.
${YELLOW}│${RESET}
${YELLOW}└─────────────────────────────────────────────────────${RESET}

${GRAY}┌─ Why it happened ───────────────────────────────────${RESET}
${GRAY}│${RESET}
${GRAY}│${RESET}  The detector does not understand context.
${GRAY}│${RESET}
${GRAY}│${RESET}  It does not know whether 'bank' is the real sender
${GRAY}│${RESET}  or someone trying to imitate one.
${GRAY}│${RESET}
${GRAY}│${RESET}  It does not know whether 'expires today' is a sales offer
${GRAY}│${RESET}  or artificial pressure from a scammer.
${GRAY}│${RESET}
${GRAY}│${RESET}  It only counts words.
${GRAY}│${RESET}
${GRAY}└─────────────────────────────────────────────────────${RESET}

${CYAN}┌─ Why it matters ───────────────────────────────────${RESET}
${CYAN}│${RESET}
${CYAN}│${RESET}  If the detector fails like this too often,
${CYAN}│${RESET}  people stop trusting it.
${CYAN}│${RESET}
${CYAN}│${RESET}  And when they stop trusting it, they ignore it.
${CYAN}│${RESET}  Even when it is right.
${CYAN}│${RESET}
${CYAN}└─────────────────────────────────────────────────────${RESET}

${CYAN}┌─ How to address it ─────────────────────────────────${RESET}
${CYAN}│${RESET}
${CYAN}│${RESET}  . [technical] ML classifier:
${CYAN}│${RESET}
${CYAN}│${RESET}    Train a model with thousands of real examples.
${CYAN}│${RESET}    The model learns that 'expires today' from a bank
${CYAN}│${RESET}    has a different statistical distribution
${CYAN}│${RESET}    than the same phrase in an anonymous message.
${CYAN}│${RESET}
${CYAN}│${RESET}  . [technical] Verify the message origin:
${CYAN}│${RESET}
${CYAN}│${RESET}    SPF: confirms the server is allowed
${CYAN}│${RESET}    to send from that domain.
${CYAN}│${RESET}
${CYAN}│${RESET}    DKIM: a digital signature that verifies the message
${CYAN}│${RESET}    was not altered in transit.
${CYAN}│${RESET}
${CYAN}│${RESET}    DMARC: coordinates SPF and DKIM, and defines what
${CYAN}│${RESET}    to do if either one fails.
${CYAN}│${RESET}
${CYAN}└─────────────────────────────────────────────────────${RESET}"

    run_analysis
}

show_bypass_example() {
    echo ""
    echo -e "${MAGENTA}┌─ What you are about to see ─────────────────────────${RESET}"
    print_box_blank $MAGENTA
    print_box_line $MAGENTA "A message designed to ${WHITE}evade this detector${RESET}."
    print_box_blank $MAGENTA
    print_box_line $MAGENTA "If you read it, it is clearly a scam."
    print_box_line $MAGENTA "The script will not find anything."
    print_box_blank $MAGENTA
    print_box_line $MAGENTA "${GRAY}Question before seeing the result:${RESET}"
    print_box_line $MAGENTA "${WHITE}why do you think it will evade it?${RESET}"
    print_box_blank $MAGENTA
    echo -e "${MAGENTA}└─────────────────────────────────────────────────────${RESET}"
    pause_screen

    TEXT="Hello, this is Caroline from finance.

I need you to process payment for this supplier
before 3:00 PM.

The amount is \$4,200,000. I am sending the account
details through this channel so you can handle it
yourself directly.

It is for quarter closing. Speak with me afterward
if you need more details, but make
the transfer first.

Thanks"

    GUIDED_VERDICT="  Level:  ${GREEN}NO SIGNALS${RESET}  - but the message is a scam.

  ${MAGENTA}The detector failed completely.${RESET}

  ${GRAY}The attacker avoided every word in the list.
  The script did not find anything.
  The message is fraudulent.${RESET}"

    FINAL_LESSON="
${MAGENTA}┌─ What happened ─────────────────────────────────────${RESET}
${MAGENTA}│${RESET}
${MAGENTA}│${RESET}  The detector found no signals.
${MAGENTA}│${RESET}  But the message is a scam.
${MAGENTA}│${RESET}
${MAGENTA}│${RESET}  This is called a bypass.
${MAGENTA}│${RESET}
${MAGENTA}└─────────────────────────────────────────────────────${RESET}

${GRAY}┌─ Why it happened ───────────────────────────────────${RESET}
${GRAY}│${RESET}
${GRAY}│${RESET}  The attacker knows how the detector works.
${GRAY}│${RESET}
${GRAY}│${RESET}  They did not use 'urgent'. They did not mention 'manager'.
${GRAY}│${RESET}  They did not offer prizes.
${GRAY}│${RESET}  They used everyday office language.
${GRAY}│${RESET}
${GRAY}│${RESET}  Fixed rules are predictable.
${GRAY}│${RESET}  If the attacker knows what triggers the detector,
${GRAY}│${RESET}  they can design the message to avoid it.
${GRAY}│${RESET}
${GRAY}└─────────────────────────────────────────────────────${RESET}

${CYAN}┌─ How to address it ─────────────────────────────────${RESET}
${CYAN}│${RESET}
${CYAN}│${RESET}  . [technical] ML classifier:
${CYAN}│${RESET}
${CYAN}│${RESET}    A model trained on thousands of examples
${CYAN}│${RESET}    learns complete statistical patterns,
${CYAN}│${RESET}    not specific words. An attacker who avoids
${CYAN}│${RESET}    'urgent' does not avoid the pattern of real fraud.
${CYAN}│${RESET}
${CYAN}│${RESET}  . [technical] Language models (LLMs):
${CYAN}│${RESET}
${CYAN}│${RESET}    They understand semantics - they read the message
${CYAN}│${RESET}    the way a human would. ChatGPT and Claude
${CYAN}│${RESET}    are examples of this technology.
${CYAN}│${RESET}
${CYAN}│${RESET}  . [process] Separate detection from execution:
${CYAN}│${RESET}
${CYAN}│${RESET}    For transfers and high-risk actions,
${CYAN}│${RESET}    no detector should be the only barrier.
${CYAN}│${RESET}    Always verify through a different channel.
${CYAN}│${RESET}    This is not code - it is policy.
${CYAN}│${RESET}
${CYAN}└─────────────────────────────────────────────────────${RESET}"

    run_analysis
}


# =============================================================================
# MAIN MENU
# =============================================================================

while true; do
    print_header

    echo -e "${WHITE}  Select what you want to do:${RESET}"
    echo ""
    echo -e "  ${GREEN}1)${RESET} Clean email           ${GRAY}- the detector finds nothing${RESET}"
    echo -e "  ${RED}2)${RESET} CEO fraud             ${GRAY}- detected by the scanner${RESET}"
    echo -e "  ${YELLOW}3)${RESET} False positive       ${GRAY}- legitimate email that triggers alerts${RESET}"
    echo -e "  ${MAGENTA}4)${RESET} Bypass                ${GRAY}- scam that evades the detector${RESET}"
    echo ""
    echo -e "  ${BLUE}5)${RESET} Analyze custom text  ${GRAY}- paste a message manually${RESET}"
    echo -e "  ${BLUE}6)${RESET} Analyze a text file  ${GRAY}- load a .txt${RESET}"
    echo ""
    echo -e "  ${GRAY}7) Exit${RESET}"
    echo ""

    read -p "  Option (1-7): " option
    echo ""

    case $option in
        1)
            print_header
            echo -e "  ${CYAN}-- EXAMPLE 1 - Clean email --${RESET}"
            show_clean_email_example
            pause_screen
            ;;

        2)
            print_header
            echo -e "  ${CYAN}-- EXAMPLE 2 - CEO fraud --${RESET}"
            show_ceo_fraud_example
            pause_screen
            ;;

        3)
            print_header
            echo -e "  ${CYAN}-- EXAMPLE 3 - False positive --${RESET}"
            show_false_positive_example
            pause_screen
            ;;

        4)
            print_header
            echo -e "  ${CYAN}-- EXAMPLE 4 - Bypass --${RESET}"
            show_bypass_example
            pause_screen
            ;;

        5)
            FINAL_LESSON=""
            GUIDED_VERDICT=""
            print_header
            echo -e "  ${BLUE}-- Manual text --${RESET}"
            echo ""
            echo -e "${YELLOW}  Paste the text line by line.${RESET}"
            echo -e "${GRAY}  Type 'end' on an empty line to analyze it.${RESET}"
            echo -e "${GRAY}  Type 'cancel' to return to the menu.${RESET}"
            echo ""
            TEXT=""
            while IFS= read -r line; do
                [ "$line" = "cancel" ] && { TEXT=""; break; }
                [ "$line" = "end" ] && break
                TEXT="$TEXT$line"$'\n'
            done
            if [ -z "$TEXT" ]; then
                echo -e "${GRAY}  Returning to the menu.${RESET}"
                sleep 1
            else
                run_analysis
                pause_screen
            fi
            ;;

        6)
            FINAL_LESSON=""
            GUIDED_VERDICT=""
            print_header
            echo -e "  ${BLUE}-- Load file --${RESET}"
            echo ""
            echo -e "${GRAY}  Type 'cancel' to return to the menu.${RESET}"
            echo ""
            read -rp "  Path to the .txt file: " file_path
            if [ "$file_path" = "cancel" ] || [ -z "$file_path" ]; then
                echo -e "${GRAY}  Returning to the menu.${RESET}"
                sleep 1
            elif [ -f "$file_path" ]; then
                TEXT=$(cat "$file_path")
                if [ -z "$TEXT" ]; then
                    echo -e "${RED}  The file is empty.${RESET}"
                    sleep 2
                else
                    run_analysis
                    pause_screen
                fi
            else
                echo -e "${RED}  File not found: $file_path${RESET}"
                echo -e "${GRAY}  Check the path and try again.${RESET}"
                sleep 2
            fi
            ;;

        7)
            echo -e "  ${GRAY}Exiting.${RESET}"
            echo ""
            exit 0
            ;;

        *)
            echo -e "  ${RED}Invalid option.${RESET}"
            sleep 1
            ;;
    esac

    # Reset state for the next analysis run.
    SCORE=0
    TEXT=""
    FINAL_LESSON=""
    GUIDED_VERDICT=""
done
