#!/bin/bash

set -ev
if [ "$TRAVIS_OS_NAME" == "osx" ]; then
	if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
		echo "Build on MacOSX: Pull Request"
		mvn -f xtraitj.releng/pom.xml clean verify -Dfindbugs.skip=true
	else
		echo "Skipping build on MacOSX for standard commit"
	fi
else
	echo "Build on Linux"
	mvn -f xtraitj.releng/pom.xml clean verify -Dfindbugs.skip=true -Pjacoco-report coveralls:report
fi 
