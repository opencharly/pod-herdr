# pod-herdr

The herdr (herdr.dev) stack for [opencharly/charly](https://github.com/opencharly/charly):

- **candy/herdr** — installs the pinned herdr v0.8.2 release binary, supervises a
  headless `herdr server`, and bridges the in-venue NDJSON unix socket to
  TCP:8095 (socat) so host-side consumers can reach it.
- **check-herdr-pod** — the disposable R10 bed: deploys the herdr box and probes
  it through BOTH surfaces of the compiled-in herdr plugin
  ([plugin-herdr](https://github.com/opencharly/plugin-herdr)): the live `herdr:`
  check verb (host side, via the reverse channel) and the
  `charly herdr --endpoint tcp://127.0.0.1:${HOST_PORT:8095}` CLI — the R3
  parity proof, plus the full workspace/split/run/wait/agent flow.

## The R10 bed

```bash
charly check run check-herdr-pod
```

The bed asserts: the herdr server answers `ping` over the venue bridge (verb),
the CLI reaches the same venue (R3 parity), a workspace create → pane split →
pane run → pane wait-output → agent report flow works end to end, and the verbs
`workspace-list` / `agent-list` / `pane-wait-output` / `session-snapshot` read
it all back.

## Session targeting (safety)

The focused Herdr session is off-limits from outside; the bed and CLI target a
venue explicitly (`--endpoint`, `${HOST_PORT:8095}`). See the herdr skill in
the marketplace corpus.
