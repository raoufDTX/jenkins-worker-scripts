#!/bin/bash

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
#----- BEGIN common.sh -----#

# These should be injected by the EC2 plugin, but aren't.
# See https://issues.jenkins-ci.org/browse/JENKINS-23864
#
JENKINS_PRIVATE_IP=10.0.0.133
JENKINS_REMOTE_FS_ROOT=/var/cache/jenkins

# Remote FS root should be created by EC2 plugin, but isn't.
# See https://issues.jenkins-ci.org/browse/JENKINS-16027

mkdir -p $JENKINS_REMOTE_FS_ROOT

# Set up EBS ephemeral instance store and make it the Jenkins workspace if
# available
ephemeral0=$(curl -f -s http://169.254.169.254/2012-01-12/meta-data/block-device-mapping/ephemeral0)
if test -n "$ephemeral0"; then
    # contains device node name like "sdb". The local host might use Xen style
    # names like xvb instead; have to detect this and remap.
    rootdev="$(df -h / | awk '/^\/dev/ { print $1 }')"
    if test "$rootdev" = "/dev/xvda1"; then
        ephemeral0="/dev/${ephemeral0/sd/xvd}"
    elif test "$rootdev" = "/dev/sda1"; then
        # No action, it's already in sdx format
        ephemeral0="/dev/${ephemeral0}"
    else
        echo "Unable to determine device node format for rootdev=$rootdev"
        ephemeral0=""
    fi

    if test -n "$ephemeral0"; then
        echo "Formatting ephemeral volume $ephemeral0"
        mkfs -t ext4 $ephemeral0
        echo "Mounting $ephemeral0 on $JENKINS_REMOTE_FS_ROOT"
        mount -t ext4 -o noatime,data=writeback,barrier=0 $ephemeral0 $JENKINS_REMOTE_FS_ROOT
    fi
else
    echo "Not using ephemeral storage: no ephemeral0 mapped"
fi

# Set Jenkins root ownership
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
  git --git-dir mirror-git.postgresql.org-postgresql.git fetch
else
  # Clone on first start
  echo "Cloning a PostgreSQL mirror as a --reference"
  git clone --quiet --mirror --bare "git://$JENKINS_PRIVATE_IP/git/mirror-git.postgresql.org-postgresql.git"
  echo "Done cloning"
fi

#----- END common.sh -----#
