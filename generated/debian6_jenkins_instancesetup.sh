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

# Work around for Jenkins bug https://issues.jenkins-ci.org/browse/JENKINS-16027
JENKINS_WORKDIR=/var/cache/jenkins
mkdir $JENKINS_WORKDIR
chown admin $JENKINS_WORKDIR
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
  git clone --quiet --mirror --bare "git://10.0.0.250/git/mirror-git.postgresql.org-postgresql.git"
fi

#----- END common.sh -----#
