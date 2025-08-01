#!/bin/bash
# Manual upstream sync script

set -e

echo "🔄 Starting upstream sync process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if upstream remote exists
if ! git remote | grep -q "upstream"; then
    echo -e "${YELLOW}Adding upstream remote...${NC}"
    git remote add upstream https://github.com/twentyhq/twenty.git
fi

# Fetch latest from upstream
echo "📥 Fetching latest from upstream..."
git fetch upstream

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "Current branch: ${GREEN}$CURRENT_BRANCH${NC}"

# Create a new branch for the sync
SYNC_BRANCH="sync-upstream-$(date +%Y%m%d-%H%M%S)"
echo -e "Creating sync branch: ${GREEN}$SYNC_BRANCH${NC}"
git checkout -b $SYNC_BRANCH

# Try to merge upstream
echo "🔀 Attempting to merge upstream/main..."
if git merge upstream/main --no-edit; then
    echo -e "${GREEN}✅ Merge successful!${NC}"
    
    # Run tests
    echo "🧪 Running tests..."
    if yarn test; then
        echo -e "${GREEN}✅ Tests passed!${NC}"
        
        echo -e "\n${GREEN}Next steps:${NC}"
        echo "1. Review the changes: git diff $CURRENT_BRANCH"
        echo "2. Push the branch: git push origin $SYNC_BRANCH"
        echo "3. Create a pull request on GitHub"
    else
        echo -e "${RED}❌ Tests failed! Please fix the issues before proceeding.${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Merge conflicts detected!${NC}"
    echo -e "${YELLOW}Please resolve conflicts manually and then run:${NC}"
    echo "  git add ."
    echo "  git commit"
    echo "  yarn test"
    echo "  git push origin $SYNC_BRANCH"
    exit 1
fi