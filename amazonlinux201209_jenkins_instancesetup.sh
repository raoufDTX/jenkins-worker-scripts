#!/bin/bash
#
# This script sets up an Amazon Linux 2012-09 instance as a Jenkins worker
# 
# It's used for all versions and architectures. Add tests for `arch` etc
# if you want to branch for different worker types.

yum -y update
yum -y install git
yum -y groupinstall "Development tools"

# Here's how we SHOULD be able to get Pg's dependencies
# but the Amazon packages lack source RPMs!
#yum-builddep -y postgresql
# We should be able to get an SRPM using yumdownloader --source
# but again, Amazon's repos lack SRPMs
# Amazon provides:
#    get_reference_source -p packagename
# for SRPMs, but it requires that the package be installed locally first,
# somewhat defeating the point.
#
# So we'll fall back to a manually maintained dependency list.
# This is obtained using:
#  apt-get install postgresql9
#  echo 'yes' | get_reference_source -p postgresql9
#  yum builddep /usr/src/srpm/debug/postgresql9-9.2.1-1.28.amzn1.src.rpm
#  yum remove postgresql postgresql9*
# then filtered for versions and culled of dependenies.

yum -y install m4 zlib-devel libxml2-devel perl-ExtUtils-MakeMaker perl-Test-Harness perl-devel perl-ExtUtils-ParseXS libsepol-devel libselinux-devel python26-devel libcom_err-devel libgpg-error-devel libgcrypt-devel ncurses-devel keyutils-libs-devel krb5-devel openssl-devel readline-devel openldap-devel uuid-devel gettext libxslt-devel python-devel tcl-devel glibc-devel perl-ExtUtils-Embed bison flex systemtap-sdt-devel pam-devel
