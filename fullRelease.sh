#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 ticReleaseVersion ticDevVersion" >&2
    exit 1
fi

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

cd ..
rm -rf ./t3/

# releasing
RELEASE_VERSION=$1 && sed -i "s/\(RELEASE_VERSION=\).*\$/\1${RELEASE_VERSION}/" release.properties
DEV_VERSION=$2 && sed -i "s/\(DEV_VERSION=\).*\$/\1${DEV_VERSION}/" release.properties
git add release.properties && git commit -m "Triggering release"
git push origin release
