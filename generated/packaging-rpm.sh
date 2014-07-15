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
