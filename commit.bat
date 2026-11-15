@echo off
setlocal
REM theridgwells.github.io - Git commit + tag script (Windows)
REM Commits whatever's staged/unstaged and tags it with the version
REM currently in VERSION.md, read dynamically so this script never goes
REM stale the way a hardcoded version number does.

set "DIR=%~dp0"
set /p VERSION=<"%DIR%VERSION.md"

REM Pre-stable: Semantic Versioning on 0.x.y. The first stable release is the first Date Version
REM (https://datevers.ing: the UTC release date as YY.MM.DD, plus -1, -2... for later releases that
REM day), with no 1.0.0, and once there is one there's no going back to 0.x.y.
powershell -NoProfile -Command "$v = '%VERSION%'.Trim(); $dv = '^\d{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12]\d|3[01])(-[1-9]\d*)?$'; if ($v -match '^0\.[0-9]+\.[0-9]+$') { if (@(git -C '%DIR%.' tag -l 'v*' | Where-Object { $_.Substring(1) -match $dv }).Count) { exit 4 }; exit 0 }; if ($v -notmatch $dv) { exit 1 }; $d = $v.Split('-')[0]; $p = [DateTime]::MinValue; if (-not [DateTime]::TryParseExact($d, 'yy.MM.dd', [Globalization.CultureInfo]::InvariantCulture, 'None', [ref]$p)) { exit 1 }; $t = [DateTime]::UtcNow.ToString('yy.MM.dd'); if ($d -gt $t) { exit 2 }; if ($d -lt $t) { exit 3 }; exit 0"
if errorlevel 4 (
    echo VERSION.md holds %VERSION%, but this project already has a Date Version tag: it's stable, so it can't go back to 0.x.y.
    exit /b 1
) else if errorlevel 3 (
    echo Warning: VERSION.md is dated before today ^(UTC^). Releasing today? Use today's date.
) else if errorlevel 2 (
    echo VERSION.md holds %VERSION%, which is dated in the future ^(UTC^). Date Versions can't be.
    exit /b 1
) else if errorlevel 1 (
    echo VERSION.md holds %VERSION%, which is neither a pre-stable 0.x.y version nor a Date Version ^(YY.MM.DD or YY.MM.DD-N, see https://datevers.ing^).
    exit /b 1
)

REM Releases are made on test (or a branch off it). staging and main only change through pull requests:
REM test -> staging -> main (CONTRIBUTING.md, "Branches and going live").
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set "BRANCH=%%b"
if "%BRANCH%"=="main" goto wrongbranch
if "%BRANCH%"=="staging" goto wrongbranch
goto branchok
:wrongbranch
echo You're on %BRANCH%. Releases are made on test, then go test -^> staging -^> main through pull requests: git switch test
exit /b 1
:branchok

git add -A
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Release v%VERSION%" -m "See CHANGELOG.md for details."
) else (
    echo Nothing to commit - tagging the current HEAD as v%VERSION%.
)

git rev-parse "v%VERSION%" >nul 2>&1
if errorlevel 1 (
    git tag -a "v%VERSION%" -m "theridgwells.github.io v%VERSION%"
    echo Tagged v%VERSION%.
) else (
    echo Tag v%VERSION% already exists - skipping.
)

echo Push with: git push origin %BRANCH% --tags
echo Then open a pull request into staging: gh pr create --base staging --head %BRANCH%
echo Once staging is checked, open one from staging into main: gh pr create --base main --head staging
