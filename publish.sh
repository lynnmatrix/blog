# Temporarily store uncommited changes
git stash 

# Build new files
stack exec site clean
stack exec site build

# Overwrite existing files with new files
rsync -a --filter='P _site/'      \
         --filter='P _cache/'     \
         --filter='P .git/'       \
         --filter='P .gitignore'  \
         --filter='P .stack-work' \
         --delete-excluded        \
         _site/ ../lynnmatrix.github.com

pushd ../lynnmatrix.github.com
# Commit
git add -A
git commit -m "Publish."

# Push
git push origin master:master
popd

# Restoration
git stash pop
