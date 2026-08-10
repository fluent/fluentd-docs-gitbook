#!/bin/bash

#
# build script on netlify
# 

set -ex

function info()
{
    MESSAGE="$1"
    echo -e "[\e[32;40mINFO\e[0m] ${MESSAGE}"
}

function install_plugins()
{
    info "Install npm packages"
    # Install the exact versions recorded in package-lock.json.
    # --ignore-scripts: no dependency requires install-time scripts
    npm ci --ignore-scripts
}

if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
fi
git fetch origin 0.12
git fetch origin 1.0

install_plugins

info "Setup worktree"
for d in _build/0.12 _build/1.0; do
    if [ -d "$d" ]; then
        git worktree remove --force $d
        rm -rf $d
    fi
done
mkdir -p _build/{0.12,1.0}
mkdir -p _book/{0.12,1.0}

git worktree add _build/0.12 origin/0.12
git worktree add _build/1.0 origin/1.0

cp -f book.json FOOTER.md _build/0.12
sed -i -e 's/Fluentd 1.0/Fluentd 0.12/' _build/0.12/book.json
cp -r styles _layouts _build/0.12/
cp -f book.json _build/1.0

info "Building latest branch"
npx honkit build
info "Building 0.12 branch"
(cd _build/0.12 && npx honkit build . ../../_book/0.12)
info "Building 1.0 branch"
(cd _build/1.0 && npx honkit build . ../../_book/1.0)

info "Copy assets to visible directory"
rsync -avzi _build/0.12/.gitbook/assets/ _book/0.12/assets/
rsync -avzi _build/1.0/.gitbook/assets/ _book/1.0/assets/
rsync -avzi .gitbook/assets/ _book/assets/

info "Done"
