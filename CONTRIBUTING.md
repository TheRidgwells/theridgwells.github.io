<p align="center">
  <img src="https://global.media.ridgwell.family/logo.png" height="80" alt="The Ridgwell Family">
</p>

# Contributing to theridgwells.github.io

This repo only redirects `theridgwells.github.io` to [github.com/TheRidgwells](https://github.com/TheRidgwells), so
there's little to change. If the destination ever changes, update both addresses in `index.html`.

- **Releases:** Date Versioning (`YY.MM.DD`, the UTC release date, with `-1`, `-2`… for later releases the same day),
  stable since v26.11.07; there is no 1.0.0 and no going back to `0.x.y`. On the `test` branch: update `CHANGELOG.md`
  (sections in the order Added, Changed, Fixed, Removed, Security, Deprecated), bump `VERSION.md`, run
  `bash tests/version.sh`, then `./commit.sh`; push `test` and the tag, and open a pull request into `main`.
- Commits use your own git identity.
