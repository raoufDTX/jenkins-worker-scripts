#!/bin/bash
#
# This script sets up a Debian instance as a Jenkins worker
# 
# It's used for all versions and architectures. Add tests for `arch` etc
# if you want to branch for different worker types.

export DEBIAN_FRONTEND=noninteractive 
export DEBIAN_PRIORITY=critical

# no longer required with the new AMIs:
#cat >  /etc/apt/sources.list <<"__END__"
#deb http://ftp.ie.debian.org/debian squeeze main
#deb-src http://ftp.ie.debian.org/debian/ squeeze main
#deb http://security.debian.org/ squeeze/updates main
#deb-src http://security.debian.org/ squeeze/updates main
#__END__

apt-get -q update
apt-get install aptitude
aptitude -q2 -y upgrade
aptitude -q2 -y install openjdk-6-jre-headless
aptitude -q2 -y build-dep postgresql
aptitude -q2 -y install libreadline6-dev git curl
