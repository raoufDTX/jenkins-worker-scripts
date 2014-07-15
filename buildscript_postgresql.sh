#!/bin/bash
#
# This should be generalized into a script that can be shared across
# all the Jenkis Pg builds. For now it's here as notes.
#
set -x

# TODO: Make this into a Jenkins-provided env var
INSTALLCHECK=no

INSTALLDIR=`pwd`/regress_install

# TODO: Need to discover an uncontested port for Pg
# TODO: Need to shut down Pg reliably
# TODO: Support EXTRA_TESTS (see http://www.postgresql.org/docs/9.2/static/regress-run.html)
# TODO: cat regression diffs if found after each step

# Build and check core:
./configure --prefix="${INSTALLDIR}"
make
make check

if test "${INSTALLCHECK}" = yes; then

  # Install a copy of the server so we can run the contrib tests
  make install
  make -C contrib
  make -C contrib install

  # Fire up the server for testing, run the contrib tests, and shut down
  export LD_LIBRARY_PATH="${INSTALLDIR}/lib:${LD_LIBRARY_PATH}"
  export PATH="${INSTALLDIR}/bin:$PATH"
  initdb -D `pwd`/regress_db
  pg_ctl -w -D `pwd`/regress_db start
  make -C contrib installcheck
  make -C src/pl installcheck
  pg_ctl -w -D `pwd`/regress_db stop

fi

# Let "make world" make the docs if enabled
if test "${MAKE_DOCS}" = "yes"; then
  make world
fi
