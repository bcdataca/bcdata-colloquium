
function checkGitStatus {
    cd $1 && if [[ $(git status -s) ]]
    then
	echo "The working directory is dirty. Please commit any pending changes."
	exit 1;
    fi
}

# extended regular expressions like !(.git) to remove all but .git files. 
shopt -s extglob
# remove old site data
find . -name "20*" -maxdepth 1 -print0 | xargs -0 rm -rd
# get current directory (e.g. .../bcdata-deployed)
DIR=$(pwd)

# find all bcdata-src repositories
find .. -name "bcdata-src*" -print | while read f; do
    # go to that directory
    cd "$f" &&
	# run the buildSite script to build the site into e.g. public/2017
	./scripts/buildSite.sh &&
	# move that site from public/2017 to $DIR/2017
	find ./public -name "20*" -maxdepth 1 | xargs -I '{}' mv {} $DIR
done
