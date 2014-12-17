#!/usr/bin/env sh

######
#
# Author: Kiwamu Okabe
# Author: Hongwei Xi (tidying-up)
#
######
#
# for installing ats-anairiats
#
######
#
ATSVER=$1
#
ATSPACK=\
ats-lang-anairiats-${ATSVER}
#
ATSPACKTGZ=${ATSPACK}-final.tgz
#
ATSLANGURL=\
http://sourceforge.net/project/ats-lang
#
######
#
WGETQ="wget -q"
TARZXF="tar zxf"
#
######
#
${WGETQ} \
${ATSLANGURL}/files/ats-lang/anairiats-1.0.0/${ATSPACKTGZ}
#
${TARZXF} ${ATSPACKTGZ}
#
######
#
cd ${ATSPACK}; ./configure; make all0
#
######

###### end of [setup.sh] ######
