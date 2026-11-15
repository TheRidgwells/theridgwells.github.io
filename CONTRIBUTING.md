<p align="center">
  <img src="https://global.media.ridgwell.family/logo.png" height="80" alt="The Ridgwell Family">
</p>

# Contributing to theridgwells.github.io

This repo only redirects `theridgwells.github.io` to [github.com/TheRidgwells](https://github.com/TheRidgwells), so
there's little to change. If the destination ever changes, update both addresses in `index.html`.

- **Releases:** Date Versioning (`YY.MM.DD`, the UTC release date, with `-1`, `-2`… for later releases the same day),
  stable since v26.11.07; there is no 1.0.0 and no going back to `0.x.y`. On the `test` branch: update `CHANGELOG.md`
  (sections in the order Added, Changed, Fixed, Removed, Security, Deprecated), bump `VERSION.md`, run
  `bash tests/version.sh`, then `./commit.sh`; push `test` with the tag (`git push origin test --tags`), and take it
  through staging to main with pull requests (Branches and going live).
- Commits use your own git identity.

## Branches and going live

- **`main` is what's live.** Nothing is pushed to it directly: it only changes when a pull request from `staging` is merged, with a merge commit so the release tags stay in its history. GitHub Pages publishes the site from it.
- **`staging` is the last check before live.** It only changes when a pull request from `test` is merged. Nothing deploys from it: there's no staging copy of this site.
- **Work happens on `test`**, or on a branch off it that's merged back into it. Releases are made there too: `commit.sh` / `commit.bat` refuse to run on `staging` or `main`.
- **Going live:** push `test` with its tag (`git push origin test --tags`), open a pull request into staging (`gh pr create --base staging --head test`), check staging once it's merged, then open one from staging into main (`gh pr create --base main --head staging`). Leo merges both.
- Before opening a pull request, merge the branch it goes into back into yours if it has moved.
