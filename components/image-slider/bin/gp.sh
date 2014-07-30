#!/bin/bash -e

# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# usage gp Polymer core-item [branch]
# Run in a clean directory passing in a GitHub org and repo name
org="seiffert"
repo="image-slider"
branch="master"

# make folder (same as input, no checking!)
mkdir temp
git clone https://$org@github.com/$org/$repo.git --single-branch temp

# switch to gh-pages branch
pushd temp >/dev/null
git checkout --orphan gh-pages

# remove all content
git rm -rf -q .

# use bower to install runtime deployment
bower cache clean $repo # ensure we're getting the latest from the desired branch.
echo "{
  \"name\": \"$repo#gh-pages\",
  \"private\": true
}
" > bower.json
echo "{
  \"directory\": \"components\"
}
" > .bowerrc
bower install --save $org/$repo#$branch

# redirect by default to the component folder
echo "<META http-equiv="refresh" content=\"0;URL=components/$repo/\">" >index.html

# send it all to github
git add -A .
git commit -am 'gh-pages update'
git push -u origin gh-pages --force

popd >/dev/null

rm -fr temp
