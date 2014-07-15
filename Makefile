all: generated/amazonlinux201209_jenkins_instancesetup.sh generated/debian_jenkins_instancesetup.sh generated/packaging-rpm.sh generated/rhel_jenkins_intancesetup.sh

generated/%.sh: %.sh common.sh
	mkdir -p generated
	cat `basename $<` common.sh > $@

clean:
	rm -rf generated


.PHONY: clean
