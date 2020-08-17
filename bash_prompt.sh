#!/bin/bash

# the default prompt options
#
# g: show Git branch
# u: show username
# h: show hostname
# n: move prompt to next line down
# P: show final segment and reset to default terminal colours
# p: show path (limited to max 20 chars)
# S: add extra spacing around each segment
# s: use narrow segments
# t: override terminal title
# w: show path (Bash's default path)
# W: show basename of path
#
# the order of the options determines the order we show options
# in the prompt
#
# you can override these by setting PROMPT_OPTIONS yourself
DEFAULT_PROMPT_OPTIONS=SnuhpPtn$
DEFAULT_PROMPT_MAXPATH=44

# a list of ANSI escape sequences for us to use
ANSI_SGR='\e'
ANSI_RESET=0
ANSI_BOLD=1
ANSI_FG_BLACK=30
ANSI_BG_BLACK=40
ANSI_FG_RED=31
ANSI_BG_RED=41
ANSI_FG_GREEN=32
ANSI_BG_GREEN=42
ANSI_FG_YELLOW=33
ANSI_BG_YELLOW=43
ANSI_FG_BLUE=34
ANSI_BG_BLUE=44
ANSI_FG_MAGENTA=35
ANSI_BG_MAGENTA=45
ANSI_FG_CYAN=36
ANSI_BG_CYAN=46
ANSI_FG_GREY=37
ANSI_BG_GREY=47

ANSI_FG_BRIGHT_GRAY=90
ANSI_BG_BRIGHT_GRAY=100
ANSI_FG_BRIGHT_RED=91
ANSI_BG_BRIGHT_RED=101
ANSI_FG_BRIGHT_GREEN=92
ANSI_BG_BRIGHT_GREEN=102
ANSI_FG_BRIGHT_YELLOW=93
ANSI_BG_BRIGHT_YELLOW=103
ANSI_FG_BRIGHT_BLUE=94
ANSI_BG_BRIGHT_BLUE=104
ANSI_FG_BRIGHT_MAGENTA=95
ANSI_BG_BRIGHT_MAGENTA=105
ANSI_FG_BRIGHT_CYAN=96
ANSI_BG_BRIGHT_CYAN=106
ANSI_FG_WHITE=97
ANSI_BG_WHITE=107

PS_SPACING=""

# build up a set of ansi colours
# accepts a variable number of parameters
function _ansi_colors() {
    local es="\[${ANSI_SGR}[$1"
    shift
    while [[ -n $1 ]] ;  do
        es="${es};$1"
        shift
    done
    es="${es}m\]";

    echo -n $es
}

function _ansi_fg_256() {
    echo -n '\[\e[38;5;'$1'm\]'
}

function _ansi_bg_256() {
    echo -n '\[\e[48;5;'$1'm\]'
}

# echoes the branch icon
function _branch_icon() {
    if [[ $color_prompt = yes && -z $TERM_PROGRAM ]] ; then
        echo -ne "\uE0A0"
    fi
}

# echoes the triangular separator
function _prompt_separator() {
    if [[ $color_prompt = yes && -z $TERM_PROGRAM ]] ; then
        echo -ne "\uE0B0"
    fi
}

# $1 - BG color for the prompt segment
# $2 - FG color for the prompt segment
# $3 - any extra ANSI characters (like BOLD)
# $4 - segment contents
function _prompt_segment() {
    if [[ $color_prompt = yes ]] ; then
        let end_color=$1-10
        echo -n "`_ansi_colors $1``_prompt_separator``_ansi_colors $ANSI_RESET $1 $2 $3`${PS_SPACING}$4${PS_SPACING}`_ansi_colors $ANSI_RESET $end_color`"
    else
        echo -n " $4 "
    fi
}

# $1 - BG color for the prompt segment
# $2 - FG color for the prompt segment
# $3 - any extra ANSI characters (like BOLD)
# $4 - segment contents
function _prompt_segment_256() {
    if [[ $color_prompt = yes ]] ; then
        echo -n "`_ansi_bg_256 $1``_prompt_separator``_ansi_colors $ANSI_RESET $3``_ansi_bg_256 $1``_ansi_fg_256 $2`${PS_SPACING}$4${PS_SPACING}`_ansi_colors $ANSI_RESET``_ansi_fg_256 $1`"
    else
        echo -n " $4 "
    fi
}

# Simple BASH function that shortens
# a very long path for display by removing
# the left most parts and replacing them
# with a leading ...
#
# the first argument is the path
#
# the second argument is the maximum allowed
# length including the '/'s and ...
#
# from: http://hbfs.wordpress.com/2009/09/01/short-pwd-in-bash-prompts/
function _shorten_path ()
{
	x=${1}

	# replace $HOME with ~ character to save space
    x=${x/#${HOME}/\~}

	len="${#x}"
	max_len=$2

	if [[ $len -gt $max_len ]] ; then
		# finds all the '/' in
		# the path and stores their
		# positions
		#
		pos=()
		for ((i=0;i<len;i++)) ; do
			if [[ "${x:i:1}" == "/" ]] ; then
				pos=(${pos[@]} $i)
			fi
		done
		pos=(${pos[@]} $len)

		# we have the '/'s, let's find the
		# left-most that doesn't break the
		# length limit
		#
		i=0
		while [[ $((len - pos[i])) -gt $((max_len-1)) ]] && [[ -n ${pos[i]} ]] ; do
			i=$((i+1))
		done

		# let us check if it's OK to
		# print the whole thing
		#
		if [[ ${pos[i]} == 0 ]] ; then
			# the path is shorter than
			# the maximum allowed length,
			# so no need for ...
			#
			echo -n "${x}"

		elif [[ ${pos[i]} == $len ]] || [[ -z ${pos[i]} ]] ; then
			# constraints are broken because
			# the maximum allowed size is smaller
			# than the last part of the path, plus
			# '#'
			#
			echo -n "+${x:((len-max_len+1))}"
		else
			# constraints are satisfied, at least
			# some parts of the path, plus ..., are
			# shorter than the maximum allowed size
			#
			echo -n "+${x:pos[i]}"
		fi
	else
		echo -n "${x}"
	fi
}

# echoes the current git branch, suitable for use in the prompt
function _git_prompt() {
    local git_status=$(git status -unormal 2>&1)
    if ! [[ "$git_status" =~ fatal ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi_bg=28
            local ansi_fg=15
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi_bg=227
            local ansi_fg=0
        else
            local ansi_bg=127
            local ansi_fg=15
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --tags --exact-match || git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        _prompt_segment_256 $ansi_bg $ansi_fg $ANSI_BOLD "`_branch_icon`$branch"
    fi
}

# echoes the current hostname
function _host_prompt() {
    if [[ $color_prompt = "yes" ]]; then
        case "${ENV_TYPE,,}" in
            prod*)
                local ansi_fg=15
                local ansi_bg=160
                local extra=" (PROD)"
                ;;
            staging)
                local ansi_fg=0
                local ansi_bg=229
                local extra=" (STAGING)"
                ;;
            test*)
                local ansi_fg=15
                local ansi_bg=57
                local extra=" (TEST)"
                ;;
            vagrant|vm|virtual*)
                local ansi_fg=0
                local ansi_bg=249
                local extra=" (VM)"
                ;;
            *)
                local ansi_fg=15
                local ansi_bg=67
                local extra=""
                ;;
        esac

        _prompt_segment_256 $ansi_bg $ansi_fg $ANSI_BOLD '@\h'"${extra}"
    else
        echo -n "@\h"
    fi
}

# echoes the current path
function _path_basename_prompt() {
    if [[ "$color_prompt" = yes ]] ; then
        _prompt_segment_256 253 0 $ANSI_BOLD '\W'
    else
        echo -n '\W'
    fi
}

# echoes the current path
function _path_default_prompt() {
    if [[ "$color_prompt" = yes ]] ; then
        _prompt_segment_256 253 0 $ANSI_BOLD '\w'
    else
        echo -n '\w'
    fi
}

# echoes the current path
function _path_shortened_prompt() {
    local short_path=$(_shorten_path $PWD ${PROMPT_MAXPATH:-DEFAULT_PROMPT_MAXPATH})

    if [[ "$color_prompt" = yes ]] ; then
        _prompt_segment_256 253 0 $ANSI_BOLD "$short_path"
    else
        echo -n "$short_path"
    fi
}

# overrides the terminal's title
function _terminal_title() {
    local DEFAULT_TITLE="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]"

    if [[ -z $TERMINAL_TITLE ]] ; then
        echo -n "${DEFAULT_TITLE}"
        return
    fi

	# Gnome Terminal has removed the ability to set the Terminal title
	# from anywhere sensible
    #
	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
		xterm*|rxvt*)
            echo -n "\[\033]0;${TERMINAL_TITLE}\007"
    		;;
		*)
            echo -n "${DEFAULT_TITLE}"
    		;;
	esac
}

# echoes the current username
#
# we use a different colour for the ROOT user
function _user_prompt() {
    local USER_COLOR

    if [[ "$color_prompt" = yes ]]; then
        case "`id -u`" in
            0)
                user_bg=124
                user_fg=15
                ;;
            *)
                user_bg=25
                user_fg=15
                ;;
        esac

        _prompt_segment_256 $user_bg $user_fg $ANSI_BOLD '\u'
    else
        echo -n "\u"
    fi
}

# echoes out the final characters to finish the prompt
function _end_prompt() {
    if [[ $color_prompt = "yes" ]] ; then
        echo -n '\[\033[0m\] '
    else
        echo -n '\$ '
    fi
}

function _prompt_command() {
    PS1='${shell_chroot:+($shell_chroot)}'
    if [[ $color_prompt = yes ]] ; then
        PS1="$PS1"'\[\033[30m\]'
    fi

    local opts=${PROMPT_OPTIONS:-$DEFAULT_PROMPT_OPTIONS}
    while [[ -n $opts ]] ; do
        local opt=${opts:0:1}
        opts=${opts:1}

        case $opt in
            \$)
                PS1="$PS1"'\$ '
                ;;
            g)
                PS1="$PS1`_git_prompt`"
                ;;
            u)
                PS1="$PS1`_user_prompt`"
                ;;
            h)
                PS1="$PS1`_host_prompt`"
                ;;
            n)
                PS1="$PS1"'\n'
                ;;
            p)
                PS1="$PS1`_path_shortened_prompt`"
                ;;
            P)
                PS1="$PS1`_prompt_separator``_end_prompt`"
                ;;
            s)
                PS_SPACING=""
                ;;
            S)
                PS_SPACING=" "
                ;;
            t)
                PS1="$PS1`_terminal_title`"
                ;;
            w)
                PS1="$PS1`_path_default_prompt`"
                ;;
            W)
                PS1="$PS1`_path_basename_prompt`"
                ;;
        esac
    done
}

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [[ -z $PROMPT_COMMAND ]] ; then
    PROMPT_COMMAND="_prompt_command"
else
    PROMPT_COMMAND="$PROMPT_COMMAND ; _prompt_command"
fi