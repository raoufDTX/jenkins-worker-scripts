#!/bin/bash
#
# This script sets up a Debian 6 instance as a Jenkins worker
# 
# It's used for all versions and architectures. Add tests for `arch` etc
# if you want to branch for different worker types.

export DEBIAN_FRONTEND=noninteractive 
export DEBIAN_PRIORITY=critical
cat >  /etc/apt/sources.list <<"__END__"
deb http://ftp.ie.debian.org/debian squeeze main
deb-src http://ftp.ie.debian.org/debian/ squeeze main
deb http://security.debian.org/ squeeze/updates main
deb-src http://security.debian.org/ squeeze/updates main
__END__
apt-get -q update
apt-get -q -y dist-upgrade
apt-get -q -y upgrade
apt-get -q -y install openjdk-6-jre-headless
apt-get -q -y build-dep postgresql
apt-get -q -y install libreadline6-dev git
