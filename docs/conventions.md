# Conventions

## Layers
1. **Device common** — fixes every ROM needs on a device (`devices/<codename>/`, device-tree branch `common-<android>`).
2. **ROM adapter** — what one ROM needs to build for a device: product makefile, artifact allowlist,
   duplicate-module removals, ROM-source fixes (`roms/<rom>/`, device-tree branch `<rom>-<android>`).
3. **Features** — what we add or remove by choice (`vendor_chiranz`, switched per ROM).

## Fixes
Every fix is recorded in the ROM's `FIXES.md` (or the device's `common-fixes.md`) as:
**error → cause → fix → where it lives** (repo, branch, commit). Nothing is changed without a reason written down.

## Tests
Each test pass is a dated entry in `roms/<rom>/TESTS.md`: build tested, what the owner tried on the phone,
what the logs show, known noise, open items.

## Pinning
Every ROM has a pinned manifest (exact commits). Patches record their base commit.

## Never committed
- Personal data (names, emails, phone serials, SSIDs, IPs, hostnames)
- Signing keys, tokens, keyboxes
- Proprietary binaries (Google APKs, vendor blobs) — the notes say where to fetch them
- Hard-coded paths or server details — scripts read environment variables
