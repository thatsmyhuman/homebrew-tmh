# homebrew-tmh

Homebrew tap for the **thatsmyhuman** CLI suite: `tmh`, `tmh-broker`, and
`mcp-agent`.

> **Licensing.** The formula wrapper is **MIT-licensed**. The installed binaries
> (`tmh`, `tmh-broker`, `mcp-agent`) are **proprietary** and covered by their own
> license.

## Install (macOS)

```sh
brew install thatsmyhuman/tmh/tmh
```

This tap is **macOS-only**. On Linux, use the install script from
[`thatsmyhuman/tmh-install`](https://github.com/thatsmyhuman/tmh-install):

```sh
curl -fsSL \
  https://github.com/thatsmyhuman/tmh-install/releases/latest/download/install.sh | sh
```

(The formula refuses to install on Linuxbrew and points you to the one-liner.)

## Dependencies

The formula declares `depends_on "softhsm"` — Homebrew installs SoftHSM
automatically, providing the PKCS#11 token store that `tmh` uses for agent key
material.

## After installing

Initialize the SoftHSM token store (idempotent — this is the same contract the
install script uses, so both channels reach the same post-install state), then
enroll:

```sh
tmh init-hsm
tmh enroll --portal-url <your-portal-url>
```

## Verifying releases

Binaries are distributed as signed GitHub Releases in the `tmh-install` repo.
Each release is signed with [minisign](https://jedisct1.github.io/minisign/); the
formula's `sha256` fields pin the exact artifacts. The pinned minisign public key
is published at `{portal}/minisign.pub` and in the
[tmh-install README](https://github.com/thatsmyhuman/tmh-install#readme).

```
untrusted comment: thatsmyhuman release signing key
RWRuUhkMimvWU+Xp3zPJLvzFwmCuLenHg4WB5xNtNMqGF4+LsiK7Upgc
```


## No telemetry

Neither the formula nor the binaries perform any telemetry or phone-home.
