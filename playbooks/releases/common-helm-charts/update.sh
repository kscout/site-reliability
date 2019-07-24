#!/usr/bin/env bash
# update.sh - Update dependent Git repositories

# Helpers
prog_dir=$(realpath $(dirname "$0"))

function die() {
    echo "Error: $@" >&2
    exit 1
}

function bold() {
    echo "$(tput bold)$@$(tput sgr0)"
}

function usage() {
    cat <<EOF
$0 - Update dependent Git repositories

Usage: $0 [-h,-w WRK_DIR] COMMON_CHART

Options:
-h            Show help text
-w WRK_DIR    Directory common charts and dependent repositories will be cloned.
              Defaults to "$prog_dir/wrk"

Arguments:
COMMON_CHART    Name of chart to update, one of: http-service or mongo

Configuration:
SLACK_WEBHOOK    Incoming Slack webhook for channel to send PR links

Behavior:
1. Gets latest tag for chart
2. Checks out tag in submodule for dependent repositories
3. Commits
4. Opens pull requests
5. Messages maintainers on Slack with PR links
EOF
}

function git_uri() {
    echo "git@github.com:kscout/$1.git"
}

function github_url() {
    echo "https://github.com/kscout/$1"
}

# Check dependencies installed
for program in git curl hub; do
    if ! which "$program" &> /dev/null; then
	die "$program must be installed and in PATH"
    fi
done

# Options
while getopts "w:h" opt; do
    case "$opt" in
	w) WRK_DIR="$OPTARG" ;;
	h)
	    usage
	    exit 1
	    ;;
	?) die "Unknown option" ;;
    esac
done

shift $((OPTIND-1))

# Arguments
COMMON_CHART="$1"
shift

if [ -z "$COMMON_CHART" ]; then
    usage
    die "COMMON_CHART argument required"
fi

if [[ ! "$COMMON_CHART" =~ ^http-service|mongo$ ]]; then
    usage
    die "COMMON_CHART argument must be on of: http-service or mongo"
fi

# Configuration
WRK_DIR="$prog_dir/wrk"

if [ -z "$SLACK_WEBHOOK" ]; then
    usage
    die "SLACK_WEBHOOK environment variable must be set"
fi

case "$COMMON_CHART" in
    http-service)
	dependent_repos=("chat-bot-api" "chat-bot-training-data" "slack-chat-bot-api" "kscout.io" "serverless-registry-api")
	in_dependent_repo_path=deploy/charts/http
	;;
    mongo)
	dependent_repos=("chat-bot-api" "serverless-registry-api")
	in_dependent_repo_path=deploy/charts/mongo
	;;
esac

COMMON_CHART_REPO="$COMMON_CHART-chart"

# Get common chart
mkdir -p "$WRK_DIR"
cd "$WRK_DIR"

bold "Updating common chart \"$COMMON_CHART\""

if [ ! -d "$COMMON_CHART" ]; then
    if ! git clone $(git_uri "$COMMON_CHART_REPO") "$COMMON_CHART"; then
	die "Failed to clone common chart"
    fi
fi

cd "$COMMON_CHART"
if ! git pull origin master; then
    die "Failed to update common chart"
fi

if ! git fetch origin; then
    die "Failed to fetch common chart tags"
fi

COMMON_CHART_TAG=$(git tag --list | sort -n | head -n 1)
if [[ "$?" != "0" ]]; then
    die "Failed to determine latest common chart tag"
fi
if [ -z "$COMMON_CHART_TAG" ]; then
    die "Did not find any tags in common chart"
fi

bold "Common chart tag is \"$COMMON_CHART_TAG\""

# Check authenticated with GitHub API
bold "Checking authentication with GitHub API"
if ! hub api; then
    die "Failed to authenticate with GitHub API"
fi

# Checkout common chart tag in each dependent repo
UPDATE_BRANCH="$COMMON_CHART_REPO-update-$COMMON_CHART_TAG"

for dependent_repo in "${dependent_repos[@]}"; do
    cd "$WRK_DIR"

    set +x
    
    bold "Updating dependent repository \"$dependent_repo\""

    set -x
    
    if [ ! -d "$dependent_repo" ]; then
	if ! git clone $(git_uri "$dependent_repo") "$dependent_repo"; then
	    die "Failed to clone dependent repository"
	fi
    fi

    cd "$dependent_repo"

    if ! git checkout master; then
	die "Failed to checkout dependent repository master branch"
    fi

    if ! git pull origin master; then
	die "Failed to update dependent repository"
    fi

    if ! git submodule update --init; then
	die "Failed to initialize and update dependent repository submodules"
    fi

    if ! git reset HEAD --hard; then
	die "Failed to reset repo"
    fi

    if [ ! -d "$in_dependent_repo_path" ]; then
	die "Failed to find common chart in dependent repository"
    fi

    if ! git branch | grep "$UPDATE_BRANCH" &> /dev/null; then
	if ! git checkout -b "$UPDATE_BRANCH"; then
	    die "Failed to checkout update branch in dependent repository"
	fi
    else
	if ! git checkout "$UPDATE_BRANCH"; then
	    die "Failed to checkout update branch in dependent repository"
	fi
    fi

    cd "$in_dependent_repo_path"

    if ! git checkout "$COMMON_CHART_TAG"; then
	die "Failed to checkout common chart tag in dependent repository"
    fi

    cd "$WRK_DIR/$dependent_repo"

    if ! git add "$in_dependent_repo_path"; then
	die "Failed to stage common chart change"
    fi

    if git diff-index --quiet HEAD --; then
	echo "Nothing to commit"
	echo "Next..."
	continue
    fi
    
    if ! git commit -m "updated $COMMON_CHART_REPO to $COMMON_CHART_TAG"; then
	die "Failed to commit common chart update"
    fi

    if ! git push origin "$UPDATE_BRANCH"; then
	die "Failed to push updated depenedent repository branch"
    fi

    if [[ "$(hub pr list -h $UPDATE_BRANCH | wc -l)" == "0" ]]; then
	
	pr_url=$(hub pull-request --message "Update $COMMON_CHART_REPO to $COMMON_CHART_TAG")
	if [[ "$?" != "0" ]]; then
	    die "Failed to open pull request"
	fi
	
	if ! curl -X POST -H 'Content-type: application/json' -L "$SLACK_WEBHOOK" --data "{\"text\": \"*Pull request review*\n<$(github_url $COMMON_CHART_REPO)|$COMMON_CHART common chart> updated to \`$COMMON_CHART_TAG\` in <$(github_url $dependent_repo)|$dependent_repo>\n*<$pr_url|Pull Request>*\"}"; then
	    die "Failed to send PR URL to Slack"
	fi
    else
	echo "PR already exists"
    fi
done
