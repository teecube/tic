#!/bin/sh

chmod $RELEASE_SH_CHMOD ./release.sh

. release.properties

# configure repository and checkout $GIT_BRANCH_TO_RELEASE_FROM instead of current release branch
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL
git config --global push.default upstream
git branch -d $GIT_BRANCH_TO_RELEASE_FROM
git checkout -b $GIT_BRANCH_TO_RELEASE_FROM remotes/origin/$GIT_BRANCH_TO_RELEASE_FROM
git branch --set-upstream-to=origin/$GIT_BRANCH_TO_RELEASE_FROM $GIT_BRANCH_TO_RELEASE_FROM

# releasing T3
git clone https://git.teecu.be/teecube/t3.git
cd t3
git checkout master
RELEASE_VERSION=$(mvn -q -N build-helper:parse-version -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}' exec:exec)
DEV_VERSION=$(mvn -q -N build-helper:parse-version -Dexec.executable="echo" -Dexec.args='${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.nextIncrementalVersion}-${parsedVersion.qualifier}' exec:exec)
git checkout release
sed -i "s/\(RELEASE_VERSION=\).*\$/\1${RELEASE_VERSION}/" release.properties
sed -i "s/\(DEV_VERSION=\).*\$/\1${DEV_VERSION}/" release.properties
git add release.properties && git commit -m "Triggering release"
git push origin release

