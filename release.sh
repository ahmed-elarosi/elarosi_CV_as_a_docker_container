#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  release.sh — one command to release a new version
#
#  Usage:  ./release.sh <version> "<description>"
#
#  Examples:
#    ./release.sh 1.0.2 "Fix nginx read-only permissions"
#    ./release.sh 1.1.0 "Add projects section to CV"
#    ./release.sh 2.0.0 "Complete CV redesign"
#
#  What it does automatically:
#    1. Bumps version in Dockerfile
#    2. Bumps version in README.md
#    3. Prepends new entry in CHANGELOG.md
#    4. Commits all three files
#    5. Creates git tag vX.Y.Z
#    6. Pushes commit + tag → GitHub Actions builds & publishes
# ─────────────────────────────────────────────────────────────────
set -euo pipefail

NEW_VERSION="${1:-}"
CHANGE_DESC="${2:-}"

if [[ -z "$NEW_VERSION" || -z "$CHANGE_DESC" ]]; then
  echo ""
  echo "  Usage: ./release.sh <version> <description>"
  echo "  Example: ./release.sh 1.0.2 \"Fix nginx read-only permissions\""
  echo ""
  exit 1
fi

if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "  Error: version must be X.Y.Z (e.g. 1.0.2)"
  exit 1
fi

CURRENT_VERSION=$(grep -m1 'ARG VERSION=' Dockerfile | cut -d= -f2)

if [[ -z "$CURRENT_VERSION" ]]; then
  echo "  Error: could not read current version from Dockerfile"
  exit 1
fi

if [[ "$NEW_VERSION" == "$CURRENT_VERSION" ]]; then
  echo "  Error: v${NEW_VERSION} is already the current version"
  exit 1
fi

TAG="v${NEW_VERSION}"
DATE=$(date +%Y-%m-%d)

IFS='.' read -r CUR_MAJ CUR_MIN _ <<< "$CURRENT_VERSION"
IFS='.' read -r NEW_MAJ NEW_MIN _ <<< "$NEW_VERSION"

if   [[ "$NEW_MAJ" -gt "$CUR_MAJ" ]]; then CHANGE_TYPE="Breaking change"
elif [[ "$NEW_MIN" -gt "$CUR_MIN" ]]; then CHANGE_TYPE="New feature"
else                                        CHANGE_TYPE="Fix / update"
fi

echo ""
echo "  v${CURRENT_VERSION}  →  v${NEW_VERSION}  (${CHANGE_TYPE})"
echo "  ${CHANGE_DESC}"
echo ""

echo "  [1/3] Updating Dockerfile..."
sed -i.bak "s/ARG VERSION=${CURRENT_VERSION}/ARG VERSION=${NEW_VERSION}/" Dockerfile && rm -f Dockerfile.bak

echo "  [2/3] Updating README.md..."
sed -i.bak "s/${CURRENT_VERSION}/${NEW_VERSION}/g" README.md && rm -f README.md.bak

echo "  [3/3] Updating CHANGELOG.md..."
python3 - "$NEW_VERSION" "$CHANGE_TYPE" "$CHANGE_DESC" "$DATE" << 'PYEOF'
import sys
new_version, change_type, change_desc, today = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
new_entry = f"## [{new_version}] - {today}\n### {change_type}\n- {change_desc}\n\n"
with open("CHANGELOG.md", "r") as f:
    content = f.read()
if f"## [{new_version}]" in content:
    print(f"  Warning: v{new_version} already in CHANGELOG, skipping")
    sys.exit(0)
with open("CHANGELOG.md", "w") as f:
    f.write(content.replace("## [Unreleased]\n", "## [Unreleased]\n\n" + new_entry))
print(f"  Added v{new_version} entry")
PYEOF

echo ""
echo "  Committing..."
git add Dockerfile README.md CHANGELOG.md
git commit -m "release: v${NEW_VERSION} — ${CHANGE_DESC}"

echo "  Tagging ${TAG}..."
git tag "$TAG"

echo "  Pushing to GitHub..."
git push origin main
git push origin "$TAG"

echo ""
echo "  Done! Pipeline running at:"
echo "  https://github.com/ahmed-elarosi/elarosi_CV_as_a_docker_container/actions"
echo ""
echo "  Image ready in ~2 min:"
echo "  docker pull YOUR_USERNAME/ahmed-elarosi-cv:${NEW_VERSION}"
echo ""