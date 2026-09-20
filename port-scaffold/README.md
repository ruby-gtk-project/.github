# port-scaffold

The shared setup every fork's `ruby` branch starts from: the `ruby-gtk` and
`ruby-gtk-testing` skills, the GTK4 dev shell, the house rubocop config and
custom cops, `AGENTS.md` (`CLAUDE.md` symlinks to it), and `Gemfile`.

Until now this existed only as whatever a fork happened to be created with.
`frogr-rb`, `workbench`, `workbench-demos` and `gtk-demos-and-examples` never
got it, and nothing in the org could put it there. This directory is the source
of truth; `apply.sh` is how a fork gets set up.

```sh
./apply.sh frogr-rb Frogr
```

That is the whole first setup step for a fork:

1. Creates `ruby` as an **orphan** branch — no upstream history, starts empty.
   Upstream is never even fetched.
2. Copies this scaffold onto it, with `{{APP}}` in `AGENTS.md` replaced by the
   app name (defaults to the repo name minus `-rb`).
3. Pulls the four parity skills from
   [`ruby-gtk-project/skills`](https://github.com/ruby-gtk-project/skills) into
   `.claude/skills/` — that repo stays their only home.
4. Pushes the branch and sets it as the repo's default.

It refuses if `ruby` already exists; recreating the branch would throw away
whatever port work is sitting on it.

## Why this matters for the board

The `initial-port` workflow only counts a fork as a port target when its
`ruby` branch has scaffolding on it. An unscaffolded fork is skipped every day
forever and never reaches the Initial port project. Scaffold first; the daily
run picks it up from there.
