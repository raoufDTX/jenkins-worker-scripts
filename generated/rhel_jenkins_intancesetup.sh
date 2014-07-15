#!/bin/bash
#
# This script sets up an Red Hat Enterprise Linux instance as a Jenkins worker
# 
# It's used for all versions and architectures. Add tests for `arch` etc
# if you want to branch for different worker types.

yum -y update
yum -y install git
yum -y groupinstall "Development tools"


yum install -y glibc-devel bison flex perl-ExtUtils-Embed perl-ExtUtils-MakeMaker python-devel tcl-devel readline-devel zlib-devel \
       openssl-devel krb5-devel e2fsprogs-devel libxml2-devel libxslt-devel pam-devel uuid-devel openldap-devel perl-DBI \
       perl-DBD-Pg perl-DBIx-Safe ruby ruby-devel bash-completion  python-setuptools ant libevent-devel perl-Test-Simple \ 
       cmake proj-devel geos-devel boost-devel CGAL-devel wxGTK-devel R-devel gdal-devel json-c-devel perl-HTML-Template \
       perl-HTML-Template perl-TermReadKey unixODBC-devel java-1.5.0-gcj-devel gcc-java net-tools openssh-clients \
       nano subversion postgresql-server make rpm-sign gnupg libtool swig doxygen sphinx byacc buildsys-macros

# Some special packages we are going to need
yum -y install openjade docbook-style-dsssl python-gnupg python-pexpect

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
