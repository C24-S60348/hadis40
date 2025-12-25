#!/bin/bash

# Deploy Hadis 40 to GitHub Pages
# This script will deploy your Flutter web app to GitHub Pages

set -e  # Exit on error

echo "🚀 Deploying Hadis 40 to GitHub Pages..."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Install it with: brew install gh"
    echo "Or visit: https://cli.github.com/"
    exit 1
fi

# Check if user is logged in
if ! gh auth status &> /dev/null; then
    echo "🔐 Please login to GitHub first:"
    gh auth login
fi

# Build the web app
echo "📦 Building Flutter web app..."
flutter build web --release --base-href="/hadis40/"

# Navigate to build directory
cd build/web

# Initialize git if not already
if [ ! -d ".git" ]; then
    echo "🎯 Initializing git repository..."
    git init
    git checkout -b gh-pages
else
    echo "✓ Git repository already initialized"
fi

# Add all files
echo "📝 Adding files..."
git add .

# Commit
echo "💾 Committing changes..."
git commit -m "Deploy Hadis 40 web app - $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"

# Check if remote exists
if ! git remote | grep -q "origin"; then
    echo "🌐 Creating GitHub repository..."
    gh repo create hadis40 --public --source=. --remote=origin
fi

# Push to GitHub
echo "⬆️  Pushing to GitHub..."
git push -f origin gh-pages

# Get repository info
REPO_URL=$(gh repo view --json url -q .url)
PAGES_URL=$(echo $REPO_URL | sed 's/github.com/github.io/' | sed 's/\.git$//')

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📱 Your app will be available at:"
echo "   $PAGES_URL/hadis40/"
echo ""
echo "⏳ Note: It may take a few minutes for GitHub Pages to update."
echo ""
echo "🔧 To enable GitHub Pages:"
echo "   1. Go to: $REPO_URL/settings/pages"
echo "   2. Source: Deploy from branch"
echo "   3. Branch: gh-pages / (root)"
echo "   4. Save"
echo ""


