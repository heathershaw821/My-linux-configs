#!/bin/bash


### SHELL ESCAPES ##############################################################

function esc() {
  echo -en "\[\e[$1m\]"
}

# MODIFIERS
RST=$(esc 0)
BOLD=$(esc 1)
DIM=$(esc 2)
UNDERLINE=$(esc 4)
BLINK=$(esc 5)
REVERSE=$(esc 7)

# FOREGROUND
DEFAULT=$(esc 39)
BLACK=$(esc 30)
RED=$(esc 31)
GREEN=$(esc 32)
YELLOW=$(esc 33)
BLUE=$(esc 34)
MAGENTA=$(esc 35)
CYAN=$(esc 36)
LGREY=$(esc 37)
GREY=$(esc 90)
LRED=$(esc 91)
LGREEN=$(esc 92)
LYELLOW=$(esc 93)
LBLUE=$(esc 94)
LMAGENTA=$(esc 95)
LCYAN=$(esc 96)
WHITE=$(esc 97)

# BACKGROUND
DEFAULTB=$(esc 49)
BLACKB=$(esc 40)
REDB=$(esc 41)
GREENB=$(esc 42)
YELLOWB=$(esc 43)
BLUEB=$(esc 44)
MAGENTAB=$(esc 45)
CYANB=$(esc 46)
LGREYB=$(esc 47)
GREYB=$(esc 100)
LREDB=$(esc 101)
LGREENB=$(esc 102)
LYELLOWB=$(esc 103)
LBLUEB=$(esc 104)
LMAGENTAB=$(esc 105)
LCYANB=$(esc 106)
WHITEB=$(esc 107)

### DRAWING ####################################################################

function box() {
  if [ $# -gt 1 ]; then
    echo -en $BOLD$1[$RST$2$BOLD$1]$RST
  else
    echo -en $BOLD$GREEN[$RST$1$BOLD$GREEN]$RST
  fi
}

### PLUGINS ####################################################################

function gitintegrate() {
  if [[ -d .git || -f .gitkeep ]]; then
    BRANCH=$(git branch | sed 's/current//g' | tr -d '*\n ')
    
    A=$(echo -n $GREEN'+'$RST | escape_sed)
    D=$(echo -n $RED'-'$RST | escape_sed)
    F=$(echo -n $LYELLOW'*'$RST | escape_sed)
    STAT=$(git diff --shortstat $BRANCH\
      | sed "s/\bfile[s]* changed\b/$F/g"\
      | sed "s/\binsertion[s]*\b//g"\
      | sed "s/\bdeletion[s]*\b//g"\
      | sed "s/-/$D/g"\
      | sed "s/\\+/$A/g"\
      | tr -d ' ()\n'
      )
    if [ -v $STAT ]; then 
      box $CYAN "$BRANCH"
    else
      box $CYAN "$BRANCH:$STAT"
    fi
  fi
}

enabled_prompt_plugins=gitintegrate

function plugins() {
  for plugin in $enabled_prompt_plugins; do
    OUTPUT=$($plugin)
    if [ -v $OUTPUT ]; then
      continue
    else
      echo -n '\n '$OUTPUT
    fi
  done
}

### INTERACTIVE PROMPT MAGIC ###################################################

if [ "$EUID" -eq 0 ]; then
  UIDC="$RED"
else
  UIDC="$RST$DEFAULT"
fi

function set_prompt() {
  PS1=$(box '\#')$(box '\u@\h:\W')$(plugins)"$UIDC ► "
}

PROMPT_COMMAND=set_prompt

### UTILITY FUNCTIONS ##########################################################

function escape_sed () {
  sed -e 's/[]\/$*.^[]/\\&/g'
}

### HELPFUL ALIAS STUFF ########################################################




