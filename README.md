Files in this repository are fetched by the Jenkins build workers when they're
launched, to perform their initial setup.

Access is by HTTP with OAuth API keys, from accounts in the 2ndq-machine-deploy
team (which has only read only access to the repo).

The generated/ directory contains the scripts that're actually run, composed
from the snippets in the top level. You need to:

	make
	git add generated

and then commit.


To use these scripts in a Jenkins worker init-script, use code like:

    #!/bin/bash
    set -o pipefail
    if ! curl -L -s --fail 'https://raw.githubusercontent.com/2ndQuadrant/jenkins-worker-scripts/master/generated/amazonlinux201209_jenkins_instancesetup.sh' | bash; then 
      echo "Setup script failed"
    fi
