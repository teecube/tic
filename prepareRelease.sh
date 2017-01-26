#!/bin/sh

chmod $RELEASE_SH_CHMOD ./release.sh

. release.properties

$MAVEN_RELEASE_ADDITIONAL_ARGS="-gs /home/m2/settings.xml -P additional,maven,site,t3-release"

# configure repository and checkout $GIT_BRANCH_TO_RELEASE_FROM instead of current release branch
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL
git config --global push.default upstream
git branch -d $GIT_BRANCH_TO_RELEASE_FROM
git checkout -b $GIT_BRANCH_TO_RELEASE_FROM remotes/origin/$GIT_BRANCH_TO_RELEASE_FROM
git branch --set-upstream-to=origin/$GIT_BRANCH_TO_RELEASE_FROM $GIT_BRANCH_TO_RELEASE_FROM

