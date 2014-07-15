Files in this repository are fetched by the Jenkins build workers when they're
launched, to perform their initial setup.

Access is by HTTP with OAuth API keys, from accounts in the 2ndq-machine-deploy
team (which has only read only access to the repo).

The generated/ directory contains the scripts that're actually run, composed
from the snippets in the top level. You need to:

	make
	git add generated

and then commit.
