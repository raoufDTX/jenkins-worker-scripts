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
#----- BEGIN common.sh -----#

# Clone a copy of the PostgreSQL upstream repo from our local mirror. This will save
# time and bandwidth when cloning working directories, allowing us to fully clean
# our working directories for every build.
#
# Expects the git repo to be on the Jenkins master server at http://server/git/git.postgresql.org-postgresql.git
#
# We must clone from QA's *private* IP:
if test -e mirror-git.postgresql.org-postgresql.git ; then
  sudo git --git-dir mirror-git.postgresql.org-postgresql.git fetch
else
  echo "Cloning a PostgreSQL mirror as a --reference"
  git clone --quiet --mirror --bare "git://10.0.0.250/git/mirror-git.postgresql.org-postgresql.git"
  echo "Done cloning"
fi

#----- END common.sh -----#
