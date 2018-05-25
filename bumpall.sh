#!/bin/sh

fetchrepo() {
    local dir=$1
    local source=$2

    [[ -d $dir ]] && return
    git init "$dir"
    git -C "$dir" remote add origin $source
    git -C "$dir" fetch --tags
}

fetchrepo mackerel-agent-plugins https://github.com/mackerelio/mackerel-agent-plugins.git
fetchrepo mackerel-check-plugins https://github.com/mackerelio/go-check-plugins.git

./bump.sh mackerel-agent-plugins-git mackerel-agent-plugins
./bump.sh mackerel-check-plugins-git mackerel-check-plugins