Port **{{REPO}}** to Ruby GTK4/Libadwaita.

1. `git clone https://github.com/ruby-gtk-project/{{REPO}}`. The default branch `ruby` is the port — it has the dev shell, rubocop config and skills, but no app code yet.
2. The original implementation is on the `{{UPSTREAM}}` branch of that same repo. That is the spec: read it, don't copy it.
3. Port it using the `ruby-gtk` skill in `.claude/skills/`, and check it actually runs with `ruby-gtk-testing`.
4. Push to `ruby`.

This is a full parity port. Nothing is left out: every window, dialog, page, menu item, keyboard shortcut, preference, action, empty state and error state the original has, the port has. Working through the `{{UPSTREAM}}` source file by file is the only way to know you have them all.

It is done when the app does everything the original does.

As you go, have a subagent carry out the parity reports with the parity skills in `.claude/skills/`: `component-identification` and `component-parity` (does the UI match?), `test-parity` (is every upstream test ported?), `translation-parity` (did every msgid survive?), and `accountability-ensurance` (is a gap being excused rather than built?). Each writes its document under `.reports/`. The port is not done while any of them says otherwise. See https://github.com/ruby-gtk-project/skills
