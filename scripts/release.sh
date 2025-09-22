#!/bin/bash

# Script to help with version management and publishing
# Usage: ./scripts/release.sh [version]
# Example: ./scripts/release.sh 1.0.1

set -e

# Check if version is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.1"
    exit 1
fi

VERSION=$1

# Validate version format (basic check)
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+.*$ ]]; then
    echo "Error: Version must be in format x.y.z (e.g., 1.0.1)"
    exit 1
fi

echo "🚀 Preparing release $VERSION"

# Update version in pubspec.yaml
echo "📝 Updating pubspec.yaml version to $VERSION"
sed -i.bak "s/^version: .*/version: $VERSION/" pubspec.yaml && rm pubspec.yaml.bak

# Update CHANGELOG.md header if it exists
if [ -f "CHANGELOG.md" ]; then
    echo "📝 Updating CHANGELOG.md"
    # Add new version entry at the top
    sed -i.bak "1s/^/## $VERSION\n\n- \n\n/" CHANGELOG.md && rm CHANGELOG.md.bak
fi

# Run tests to make sure everything works
echo "🧪 Running tests..."
dart test

# Check formatting
echo "✨ Checking code formatting..."
dart format -o none . --set-exit-if-changed

# Analyze code
echo "🔍 Analyzing code..."
dart analyze

# Dry run publish
echo "🔍 Testing package publishing..."
dart pub publish --dry-run

echo "✅ All checks passed!"
echo ""
echo "Next steps:"
echo "1. Review and edit CHANGELOG.md if needed"
echo "2. Commit changes: git add . && git commit -m 'Release v$VERSION'"
echo "3. Create and push tag: git tag v$VERSION && git push origin v$VERSION"
echo "4. Create GitHub release at: https://github.com/ahmtydn/hive_plus/releases/new"
echo ""
echo "Or run the following commands:"
echo "git add ."
echo "git commit -m 'Release v$VERSION'"
echo "git tag v$VERSION"
echo "git push origin main"
echo "git push origin v$VERSION"