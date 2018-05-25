#!/bin/sh

if [[ -z $1 ]] || [[ -z $2 ]]; then
    echo "Usage: $(basename $0) PACKAGE_REPO_DIR SOURCE_REPO_DIR"
    exit 1
fi

package_repo=$(cd $1 && pwd)
source_repo=$(cd $2 && pwd)

cd $source_repo
git fetch --tags

latest_tag=$(git -C "$source_repo" describe --tags $(git rev-list --tags --max-count=1) | sed 's/^v//' | sed 's/\+.*//')
latest_message=$(git -C "$package_repo" log -1 --pretty=format:'%s')

if [[ $latest_tag = $latest_message ]]; then
    echo "Commit message \"$latest_message\" of the package is up to date. Nothing to do."
    exit
fi

cd $package_repo
git -C "$package_repo" checkout master
sed "s/^pkgver=.*/pkgver=$latest_tag/" PKGBUILD > PKGBUILD.new && \
rm PKGBUILD && \
mv PKGBUILD.new PKGBUILD && \
makepkg --printsrcinfo > .SRCINFO && \
git -C "$package_repo" add -A && \
git -C "$package_repo" commit -m "$latest_tag" && \
git -C "$package_repo" push -u origin master
