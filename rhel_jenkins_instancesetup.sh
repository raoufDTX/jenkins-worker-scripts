#!/bin/bash
#
# This script sets up an Red Hat Enterprise Linux instance as a Jenkins worker
# 
# It's used for all versions and architectures. Add tests for `arch` etc
# if you want to branch for different worker types.
#
# To push updates of this script to S3, use:
#    s3cmd put --acl-private --no-progress rhel_jenkins_instancesetup.sh s3://2q-jenkins-resources/rhel_jenkins_instancesetup.sh
#
# The public URL for this file is:
#    http://2q-jenkins-resources.s3.amazonaws.com/rhel_jenkins_instancesetup.sh?AWSAccessKeyId=AKIAJZPC6FQAU4REUX2A&Expires=1670373735&Signature=nnnwC%2Fjmc8F69ZR5GGMnyf%2BVZ64%3D

yum -y update
yum -y install git
yum -y groupinstall "Development tools"


yum install -y glibc-devel bison flex perl-ExtUtils-Embed perl-ExtUtils-MakeMaker python-devel tcl-devel readline-devel zlib-devel \
       openssl-devel krb5-devel e2fsprogs-devel libxml2-devel libxslt-devel pam-devel uuid-devel openldap-devel perl-DBI \
       perl-DBD-Pg perl-DBIx-Safe ruby ruby-devel bash-completion  python-setuptools ant libevent-devel perl-Test-Simple \
       cmake proj-devel geos-devel boost-devel CGAL-devel wxGTK-devel R-devel gdal-devel json-c-devel perl-HTML-Template \
       perl-HTML-Template perl-TermReadKey unixODBC-devel java-1.5.0-gcj-devel gcc-java net-tools openssh-clients \
       nano subversion postgresql-server make rpm-sign gnupg libtool swig doxygen sphinx byacc buildsys-macros rpmdevtools createrepo

# Some special packages we are going to need
yum -y install openjade docbook-style-dsssl python-gnupg python-pexpect

