# Temporarily store uncommited changes
git stash 

#中文正则问题，所以这里临时改locale  https://recalll.co/app/?q=regex%20-%20RE%20error:%20illegal%20byte%20sequence%20on%20Mac%20OS%20X
LC_ALL_BK=$LC_ALL
LANG_BK=$LANG
export LC_ALL=C
export LANG=C
echo "alter locale"
locale

echo "Build new site"
stack exec site clean
stack exec site build

echo  "recover locale"
export LC_ALL=$LC_ALL_BK
export LANG=$LANG_BK
locale

echo "Overwrite existing files with new files"
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

echo "Push site to github pages"
git push origin master:master
popd

# Restoration
git stash pop
