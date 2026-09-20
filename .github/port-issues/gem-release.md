Release **{{REPO}}** to [rubygems.org](https://rubygems.org). Everything below has to be true before the push.

### Complete
- [ ] Every window, dialog, page, menu item, keyboard shortcut, preference, action, empty state and error state the original has, the port has. Work through the upstream source file by file — that is the only way to know.
- [ ] No stubs, no `TODO`, no "not implemented yet" paths left in `lib/` or `bin/`.
- [ ] **Parity review completed.** Run the [Parity review](https://github.com/ruby-gtk-project/.github/actions/workflows/report-parity.lock.yml) workflow against this repo once the port looks finished. It compares the `ruby` branch against the original and opens a PR adding `PARITY_REPORT-<date>.md`. This box is ticked when a report on the current code says **PASS** — merge it, and link it here. A FAIL report is the gap list: fix it and run the review again.

### Functional
- [ ] The app launches and its main flows work, checked with `ruby-gtk-testing`.
- [ ] Runs from a clean checkout via the dev shell (`nix develop --command`).

### Packaged
- [ ] A `.gemspec` exists at the repo root, and `gem build` succeeds with no warnings.
- [ ] `gem install ./{{REPO}}-0.1.0.gem` in a clean directory installs, and the installed command launches the app. Building is not the same as shipping something that runs — this is the check that proves it.
- [ ] `spec.files` includes the non-Ruby assets: `.ui` files, GResource bundles, icons, GSettings schemas. A GTK gem that omits these installs fine and crashes on launch.
- [ ] `spec.executables` / `bin/` are wired so `gem install` gives a working command.
- [ ] Runtime dependencies declared with bounds (`gtk4` and friends), and `required_ruby_version` set.
- [ ] System dependencies (GTK4, libadwaita) documented in the README — bundler cannot install those.

### Legal and metadata
- [ ] `spec.license` and the `LICENSE` file match **upstream's** licence. This repo is a fork of a licensed app; the port inherits that licence, it does not get a new one.
- [ ] The gem name is free on rubygems.org.
- [ ] Version is `0.1.0`, and `allowed_push_host` is set to `https://rubygems.org`.
- [ ] `homepage`, `source_code_uri` and `changelog_uri` set in `spec.metadata`.

It is done when `gem push` would be the only step left.
