#!/usr/bin/env bash
# Checks VERSION.md and the version rules in commit.sh. Pre-stable, the project uses Semantic
# Versioning on 0.x.y; its first stable release is its first Date Version (https://datevers.ing:
# the UTC release date as YY.MM.DD, plus -1, -2... for later releases the same day), with no 1.0.0.
# Run with: bash tests/version.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0
check() { # check "description" command...
    local name="$1"; shift
    if "$@"; then PASS=$((PASS + 1)); echo "ok   - $name"; else FAIL=$((FAIL + 1)); echo "FAIL - $name"; fi
}
accepts() { bash "$ROOT/commit.sh" --check "$1" >/dev/null 2>&1; }
refuses() { ! accepts "$1"; }

VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION.md")"
changelog_leads() {
    [ "$(grep -m1 -oE '^## v[^[:space:]]+' "$ROOT/CHANGELOG.md" | sed 's/^## v//')" = "$VERSION" ]
}

check "commit.sh accepts VERSION.md ($VERSION)" accepts "$VERSION"
check "the newest '## v...' heading in CHANGELOG.md is VERSION.md" changelog_leads

# The rules themselves
TODAY="$(date -u +%y.%m.%d)"
semver0_ok()  { accepts 0.3.0 && accepts 0.12.7; }
datever_ok()  { accepts "$TODAY" && accepts "$TODAY-2"; }
other_no()    { refuses 1.0.0 && refuses 1.2.3 && refuses 0.3 && refuses 0.3.0-rc1; }
bad_date_no() { refuses 26.02.30 && refuses 26.10.23-0; }
future_no()   { refuses "$(date -u -d tomorrow +%y.%m.%d)"; }
check "accepts a pre-stable 0.x.y (0.3.0, 0.12.7)" semver0_ok
check "accepts today's Date Version and a -N one" datever_ok
check "refuses 1.x and other SemVer (1.0.0, 1.2.3, 0.3, 0.3.0-rc1)" other_no
check "refuses an impossible date (26.02.30) and a bad suffix (26.10.23-0)" bad_date_no
check "refuses a Date Version in the future" future_no

# No going back: in a scratch repo with a Date Version tag, 0.x.y is refused
no_going_back() {
    local tmp; tmp="$(mktemp -d)" || return 1
    cp "$ROOT/commit.sh" "$tmp/" && git -C "$tmp" init -q \
        && git -C "$tmp" -c user.name=test -c user.email=test@example.invalid commit -q --allow-empty -m test \
        && bash "$tmp/commit.sh" --check 0.4.0 >/dev/null 2>&1 \
        && git -C "$tmp" tag v26.10.23 \
        && ! bash "$tmp/commit.sh" --check 0.4.0 >/dev/null 2>&1 \
        && bash "$tmp/commit.sh" --check "$(date -u +%y.%m.%d)" >/dev/null 2>&1
    local ok=$?; rm -rf "$tmp"; return $ok
}
check "refuses 0.x.y once a vYY.MM.DD tag exists" no_going_back

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
