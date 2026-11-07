<p align="center">
  <img src="https://global.media.ridgwell.family/logo.png" height="100" alt="The Ridgwell Family">
</p>

# theridgwells.github.io

### *Sends theridgwells.github.io to [the Ridgwell Family on GitHub](https://github.com/TheRidgwells).*

GitHub Pages serves this repo at `theridgwells.github.io`. It has no site of its own: `index.html` redirects to the
organisation's GitHub page, so anyone who finds the address lands somewhere useful. The family's own sites are
listed at [projects.ridgwell.family](https://projects.ridgwell.family), and their status is at
[status.ridgwell.family](https://status.ridgwell.family).

## How it works

`index.html` is a `meta refresh` to `https://github.com/TheRidgwells`, with a canonical link to the same address and a
plain link for anyone whose browser doesn't follow it. GitHub Pages publishes it from `main` (no workflow needed).

## Versioning

This project is **stable** and uses [Date Versioning](https://datevers.ing): each release is its UTC release date as `YY.MM.DD`
(tag `vYY.MM.DD`), with `-1`, `-2`… for later releases the same day. v26.11.07 was its first stable release; before
it, v0.1.0 was pre-stable, on [Semantic Versioning](https://semver.org) `0.x.y`. There is no 1.0.0, and it never goes
back. To release, on the `test` branch: update `CHANGELOG.md`, bump `VERSION.md`, run `bash tests/version.sh`, then
`./commit.sh` (or `commit.bat`); push `test` and the new tag, and open a pull request into `main`.

## Licence

Copyright © 2026 The Ridgwell Family. All rights reserved.

---

*Built & Maintained by <img src="https://leo.media.ridgwell.family/icon.png" height="14" alt="Leo JD Ridgwell" valign="middle"> [Leo JD Ridgwell](https://leo.ridgwell.family), Hosted by <img src="https://github.com/TheRidgwells.png" height="14" alt="The Ridgwell Family" valign="middle"> [The Ridgwell Family](https://the.ridgwell.family).*
