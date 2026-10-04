# Scripts

All driven by `roms/<rom>/rom.conf`. Paths come from the environment: `ROMS_DIR` (trees, default `~/roms`),
`RELEASE_DIR`, `QUEUE_DIR`, `LOG_DIR`.

| Script | Does |
|---|---|
| `sync.sh <rom> [--pinned]` | `repo init` + our local manifests + `repo sync` |
| `apply.sh <rom>` | Applies `roms/<rom>/patches` (checks each base commit, skips already-applied) |
| `make-keys.sh <rom>` | Fresh release keys from the ROM's template (`KEY_SUBJECT` required) |
| `build.sh <rom> [variant] [jobs]` | lunch + make, copies the zip and its sha256 to `RELEASE_DIR` |
| `queue.sh` | One build at a time, each waiting for enough free disk |
| `verify-zip.sh <zip>` | Fingerprint, signing certificate and hash of a zip |
