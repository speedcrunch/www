#! /usr/bin/env bash

#------------------------------------------------------------------------------#
# This file is part of the speedcrunch.org website development.                #
#                                                                              #
# Helder Correia <helder.pereira.correia@gmail.com>                            #
#                                                                              #
# It generates the whole speedcrunch.org website (including translations) to   #
# the directory defined by $DOM.                                               #
#                                                                              #
# It uses the Universal Template Translation Tools - bundled -                 #
# (http://code.google.com/p/ut3/). The msgmerge tool from GNU Gettext          #
# (http://www.gnu.org/software/gettext/), the bash shell                       #
# (http://www.gnu.org/software/bash/bash.html) and Python (http://python.org/) #
# are required to run this script.                                             #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# directories                                                                  #
#------------------------------------------------------------------------------#

DOM="speedcrunch.org"
UT3="ut3"

#------------------------------------------------------------------------------#
# macros                                                                       #
#------------------------------------------------------------------------------#

T2P="python $UT3/template2pot.py -l ""<i18n>"" -r ""</i18n>"" -s ""<hint>"" -e ""</hint>"""
P2H="python $UT3/po2final.py     -l ""<i18n>"" -r ""</i18n>"" -s ""<hint>"" -e ""</hint>"""
MSM="msgmerge -U --quiet"

#------------------------------------------------------------------------------#
# extract marked strings and create POT                                        #
#------------------------------------------------------------------------------#

$T2P -o locale/speedcrunch.org.pot templates/*.html

#------------------------------------------------------------------------------#
# merge and generate pages                                                     #
#------------------------------------------------------------------------------#

LANGS="de_DE en_US es_ES fr_FR it_IT nl_NL pt_BR pt_PT ru_RU"

for lang in $LANGS
do
	touch locale/speedcrunch.org.$lang.po
	mkdir -p $DOM/$lang
	$MSM locale/speedcrunch.org.$lang.po locale/speedcrunch.org.pot
	$P2H -t templates/index.html       -i locale/$DOM.$lang.po -o $DOM/$lang/index.html
	$P2H -t templates/features.html    -i locale/$DOM.$lang.po -o $DOM/$lang/features.html
	$P2H -t templates/screenshots.html -i locale/$DOM.$lang.po -o $DOM/$lang/screenshots.html
	$P2H -t templates/faq.html         -i locale/$DOM.$lang.po -o $DOM/$lang/faq.html
	$P2H -t templates/download.html    -i locale/$DOM.$lang.po -o $DOM/$lang/download.html
done

#------------------------------------------------------------------------------#
# copy images, CSS, JS and redirecting root files                              #
#------------------------------------------------------------------------------#
cp -Rf css flags icons images js root/* $DOM

