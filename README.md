# pod-herdr

The [herdr](https://herdr.dev) terminal-multiplexer stack for the OpenCharly
candy library, as a standalone repo (kind-prefixed naming). It ships the herdr
server box and the disposable R10 bed that proves the herdr plugin surfaces.

## What it provides

- **`box/herdr`** — the Fedora 43 image composing the pinned herdr release binary
  with a supervised headless server (`herdr server`) and a TCP socket bridge
  (port `8095`, `socat` accept to the server's NDJSON unix socket), so host-side
  consumers can reach the venue from outside the pod.
- **`candy/herdr`** — the candy installing the pinned `herdr v0.8.2` binary, the
  `herdr-server` service (uid 1000, socket under `$HOME/.config/herdr/herdr.sock`)
  and the `herdr-bridge` service.
- **`check-herdr-pod`** — the disposable R10 bed that deploys the box and probes
  it through BOTH surfaces of the compiled-in herdr plugin: the live `herdr:`
  check verb (host side, via the reverse channel) and the
  `charly herdr --endpoint tcp://127.0.0.1:${HOST_PORT:8095}` CLI (the R3 parity
  proof), plus the full workspace/split/run/wait/agent flow.

| Property | Value |
|---|---|
| Base | `quay.io/fedora/fedora:43` |
| Port | `8095` (TCP socket bridge) |
| Services | `herdr-server` (priority 100), `herdr-bridge` (priority 200) |
| Env | `HERDR_SESSION=base` |
| Requires | `layer-supervisord`, `layer-socat`, `plugin-herdr` |
| Binary | pinned `herdr v0.8.2` (`linux-x86_64`) |

## How to use it

```bash
charly box build herdr
charly config herdr        # or compose 'herdr' into any app
charly start herdr
```

Host-side consumers then probe the venue through the bridge:

```bash
charly herdr --endpoint tcp://127.0.0.1:8095 status
```

## The R10 bed

```bash
charly check run check-herdr-pod
```

The bed asserts the herdr server answers `ping` over the venue bridge (verb), the
CLI reaches the same venue (R3 parity), a workspace create → pane split → pane run
→ pane wait-output → agent report flow works end to end, and the verbs
`workspace-list` / `agent-list` / `pane-wait-output` / `session-snapshot` read it
all back.

## Layout

- `box/herdr/charly.yml` — the `herdr` box image.
- `candy/herdr/charly.yml` — the `herdr` candy plus its start scripts.
- `charly.yml` — the `check-herdr-pod` bed and the `herdr-box` skill entity.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `CHANGELOG/` — per-CalVer history.
- `README.md` — this user overview.

## Related

- Owning skill: `/charly-automation:herdr-box` — the box properties, the build /
  deploy recipe, and the bed.
- `/charly-automation:herdr` — the `charly herdr` CLI and the `herdr:` check verb
  (plugin-herdr).
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI and image builder
- [`opencharly/opencharly`](https://github.com/opencharly/opencharly) — the umbrella
