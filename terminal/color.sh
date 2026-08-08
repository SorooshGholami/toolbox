#!/bin/bash
# Prints a sample line in every standard ANSI terminal color so you can
# preview the palette (regular, bold, underline, background, and
# high-intensity variants).

declare -A colors

colors[Color_Off]='\033[0m'

# Regular
colors[Black]='\033[0;30m'
colors[Red]='\033[0;31m'
colors[Green]='\033[0;32m'
colors[Yellow]='\033[0;33m'
colors[Blue]='\033[0;34m'
colors[Purple]='\033[0;35m'
colors[Cyan]='\033[0;36m'
colors[White]='\033[0;37m'

# Bold
colors[BBlack]='\033[1;30m'
colors[BRed]='\033[1;31m'
colors[BGreen]='\033[1;32m'
colors[BYellow]='\033[1;33m'
colors[BBlue]='\033[1;34m'
colors[BPurple]='\033[1;35m'
colors[BCyan]='\033[1;36m'
colors[BWhite]='\033[1;37m'

# Underline
colors[UBlack]='\033[4;30m'
colors[URed]='\033[4;31m'
colors[UGreen]='\033[4;32m'
colors[UYellow]='\033[4;33m'
colors[UBlue]='\033[4;34m'
colors[UPurple]='\033[4;35m'
colors[UCyan]='\033[4;36m'
colors[UWhite]='\033[4;37m'

# Background
colors[On_Black]='\033[40m'
colors[On_Red]='\033[41m'
colors[On_Green]='\033[42m'
colors[On_Yellow]='\033[43m'
colors[On_Blue]='\033[44m'
colors[On_Purple]='\033[45m'
colors[On_Cyan]='\033[46m'
colors[On_White]='\033[47m'

# High Intensity
colors[IBlack]='\033[0;90m'
colors[IRed]='\033[0;91m'
colors[IGreen]='\033[0;92m'
colors[IYellow]='\033[0;93m'
colors[IBlue]='\033[0;94m'
colors[IPurple]='\033[0;95m'
colors[ICyan]='\033[0;96m'
colors[IWhite]='\033[0;97m'

# Bold High Intensity
colors[BIBlack]='\033[1;90m'
colors[BIRed]='\033[1;91m'
colors[BIGreen]='\033[1;92m'
colors[BIYellow]='\033[1;93m'
colors[BIBlue]='\033[1;94m'
colors[BIPurple]='\033[1;95m'
colors[BICyan]='\033[1;96m'
colors[BIWhite]='\033[1;97m'

# High Intensity backgrounds
colors[On_IBlack]='\033[0;100m'
colors[On_IRed]='\033[0;101m'
colors[On_IGreen]='\033[0;102m'
colors[On_IYellow]='\033[0;103m'
colors[On_IBlue]='\033[0;104m'
colors[On_IPurple]='\033[0;105m'
colors[On_ICyan]='\033[0;106m'
colors[On_IWhite]='\033[0;107m'

white=${colors[White]}

for name in "${!colors[@]}"; do
    echo -e "$name = ${colors[$name]}Sample text${white}"
done
