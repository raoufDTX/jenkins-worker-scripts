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
#----- BEGIN common.sh -----#

# These should be injected by the EC2 plugin, but aren't.
# See https://issues.jenkins-ci.org/browse/JENKINS-23864
#
JENKINS_PRIVATE_IP=10.0.0.250
JENKINS_REMOTE_FS_ROOT=/var/cache/jenkins

# Remote FS root should be created by EC2 plugin, but isn't.
# See https://issues.jenkins-ci.org/browse/JENKINS-16027

mkdir -p $JENKINS_REMOTE_FS_ROOT
if id ec2-user >& /dev/null ; then
    chown -R ec2-user $JENKINS_REMOTE_FS_ROOT
elif id admin &> /dev/null; then
    chown -R admin $JENKINS_REMOTE_FS_ROOT
else
    echo "WARNING: Don't know what owner to give to $JENKINS_REMOTE_FS_ROOT"
fi

# Override DNS by adding a hosts entry for qa.2ndquadrant.com that points to
# its EC2 private IP for within VPC. Because our DNS is at 1and1 we don't have
# the option of using Route53's split-horizon support.
if ! grep -q 'qa.2ndquadrant.com' /etc/hosts; then
    echo "$JENKINS_PRIVATE_IP qa.2ndquadrant.com" >> /etc/hosts
fi

# Clone a copy of the PostgreSQL upstream repo from our local mirror. This will save
# time and bandwidth when cloning working directories, allowing us to fully clean
# our working directories for every build.
#
# Expects the git repo to be on the Jenkins master server at http://server/git/git.postgresql.org-postgresql.git
#
# We must clone from QA's *private* IP:
if test -e mirror-git.postgresql.org-postgresql.git ; then
  # Refresh on node restart
  echo "Updating the --reference PostgreSQL mirror"
  # We used to sudo git fetch here, so reset permissions
  sudo chown -R $(id -un) mirror-git.postgresql.org-postgresql.git
  # then update
  git --git-dir mirror-git.postgresql.org-postgresql.git fetch
else
  # Clone on first start
  echo "Cloning a PostgreSQL mirror as a --reference"
  git clone --quiet --mirror --bare "git://$JENKINS_PRIVATE_IP/git/mirror-git.postgresql.org-postgresql.git"
  echo "Done cloning"
fi

#----- END common.sh -----#
