#!/bin/bash
# theridgwells.github.io - Git commit + tag script
# Commits whatever's staged/unstaged and tags it with the version currently
# in VERSION.md, read dynamically so this script never goes stale the way a
# hardcoded version number does.
#   ./commit.sh                   check VERSION.md, commit and tag
#   ./commit.sh --check VERSION   only check VERSION (tests/version.sh uses this)
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$1" = "--check" ]; then CHECK_ONLY=1; VERSION="$2"; else VERSION="$(tr -d '[:space:]' < "$DIR/VERSION.md")"; fi

# Pre-stable: Semantic Versioning on 0.x.y. The first stable release is the first Date Version
# (https://datevers.ing: the UTC release date as YY.MM.DD, plus -1, -2... for later releases that
# day), with no 1.0.0, and once there is one there's no going back to 0.x.y.
SEMVER0='^0\.[0-9]+\.[0-9]+$'
DATEVER='^[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])(-[1-9][0-9]*)?$'
if [[ "$VERSION" =~ $SEMVER0 ]]; then
    STABLE="$(git -C "$DIR" tag -l 'v*' | sed 's/^v//' | grep -E "$DATEVER" | head -1 || true)"
    if [ -n "$STABLE" ]; then
        echo "VERSION.md holds '$VERSION', but v$STABLE is a Date Version: this project is stable, so it can't go back to 0.x.y." >&2
        exit 1
    fi
else
    DATE="${VERSION%%-*}"
    if ! [[ "$VERSION" =~ $DATEVER ]] || [ "$(date -u -d "20${DATE//./-}" +%y.%m.%d 2>/dev/null)" != "$DATE" ]; then
        echo "VERSION.md holds '$VERSION', which is neither a pre-stable 0.x.y version nor a Date Version (YY.MM.DD or YY.MM.DD-N, see https://datevers.ing)." >&2
        exit 1
    fi
    TODAY="$(date -u +%y.%m.%d)"
    if [[ "$DATE" > "$TODAY" ]]; then
        echo "VERSION.md is dated $DATE, after today ($TODAY UTC). Date Versions can't be in the future." >&2
        exit 1
    elif [[ "$DATE" < "$TODAY" ]]; then
        echo "Warning: VERSION.md is dated $DATE, but today is $TODAY (UTC). Releasing today? Use $TODAY." >&2
    fi
fi
[ -n "$CHECK_ONLY" ] && exit 0

git add -A
if ! git diff --cached --quiet; then
    git commit -m "$(cat <<EOF
Release v${VERSION}

See CHANGELOG.md for details.
EOF
)"
else
    echo "Nothing to commit - tagging the current HEAD as v${VERSION}."
fi

if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
    echo "Tag v${VERSION} already exists - skipping."
else
    git tag -a "v${VERSION}" -m "theridgwells.github.io v${VERSION}"
    echo "Tagged v${VERSION}."
fi

# Push just this tag: GitHub starts no workflows when more than three tags are pushed at once.
echo "Push with: git push origin main v${VERSION}"
