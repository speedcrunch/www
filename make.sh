#! /usr/bin/env bash

#------------------------------------------------------------------------------#
# This file is part of the speedcrunch.org website development tree.           #
#                                                                              #
# Helder Correia <helder.pereira.correia@gmail.com>, 2009                      #
#                                                                              #
# It generates the whole speedcrunch.org website (including translations) to   #
# the directory defined by $PREFIX. Before, it validates the transations and   #
# aborts in case of error.                                                     #
#                                                                              #
# It uses the Universal Template Translation Tools - already included          #
# (http://code.google.com/p/ut3/).                                             #
#                                                                              #
# The msgmerge tool from GNU Gettext (http://www.gnu.org/software/gettext/),   #
# Bash (http://www.gnu.org/software/bash/bash.html), and Python                #
# (http://python.org/) are required in the system in order to run this script. #
#------------------------------------------------------------------------------#

if [ $PREFIX ]
then
    DIR=$PREFIX
else
    DIR="speedcrunch.org"
fi

# check translation files validity
for file in locale/*po
do
    if msgfmt -c -o /dev/null "$file"
    then
        echo -n ""
    else
        exit
    fi
done

# macros
T2P="python ut3/template2pot.py -l ""<i18n>"" -r ""</i18n>"" -s ""<hint>"" -e ""</hint>"""
P2H="python ut3/po2final.py     -l ""<i18n>"" -r ""</i18n>"" -s ""<hint>"" -e ""</hint>"""

# extract marked strings and create POT
$T2P -o locale/speedcrunch.org.pot templates/*.html

# merge strings and generate pages
for poFile in locale/*.po
do
    file=${poFile#locale/speedcrunch.org.}
    lang=${file%.po}
    touch locale/speedcrunch.org."$lang".po
    mkdir -p "$DIR"/"$lang"
    msgmerge -U --quiet locale/speedcrunch.org."$lang".po locale/speedcrunch.org.pot
    for htmlFile in templates/*.html
    do
        file=${htmlFile#templates/}
        $P2H -t templates/"$file" -i locale/speedcrunch.org."$lang".po -o "$DIR"/"$lang"/"$file"
    done
done

# copy images, CSS, JS and redirecting root files
cp -Rf css icons images root/* $DIR

