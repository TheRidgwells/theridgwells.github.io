# Changelog

All notable changes to theridgwells.github.io are documented here. Sections follow a fixed order: Added, Changed,
Fixed, Removed, Security, Deprecated. It uses [Date Versioning](https://datevers.ing) (`YY.MM.DD`, the UTC release date, with `-1`, `-2`… for later
releases the same day) since v26.11.07, its first stable release; v0.1.0 was pre-stable, on
[Semantic Versioning](https://semver.org) `0.x.y`.

## v26.11.07

### Changed

- **The first stable release.** The redirect moves from pre-stable [Semantic Versioning](https://semver.org) (`0.x.y`)
  to [Date Versioning](https://datevers.ing): from now on each release is its UTC release date as `YY.MM.DD`, with
  `-1`, `-2`… for later releases the same day. There is no 1.0.0; this is v26.11.07, and it never goes back to `0.x.y`
  (the commit scripts refuse). Releases now go on the `test` branch with a pull request into `main`, like the
  family's other repos. Nothing else changes but the version.

### Fixed

- **`tests/version.sh` holds once the project is stable.** It expected the commit script to accept a `0.x.y` version,
  which it rightly refuses once there's a Date Version tag. It now checks that `VERSION.md` is a Date Version; the
  switch itself (accepted before a Date Version tag, refused after) is still tested in a scratch repository.

## v0.1.0

### Added

- **The redirect**: `theridgwells.github.io` sends visitors to [github.com/TheRidgwells](https://github.com/TheRidgwells),
  where the family's public repos are.
- `commit.sh` / `commit.bat` (they read `VERSION.md`, check it, commit and tag) and `tests/version.sh`.
