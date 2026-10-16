# Assessment: the `ruby-gtk` skill

An assessment of `port-scaffold/.claude/skills/ruby-gtk`, written after building a comparable
rule set for `async-rest` and watching it fail in the ways this skill prevents.

## 1. It removes the model's discretion at the point where discretion fails

Every rule is a single mechanical placement decision — "margins go in the memoized method's
tap, not in build" — checkable by looking at one place. No rule asks the reader to weigh
anything.

That matters because a skill's reader is, by definition, someone who does not know the domain.
Where there was latitude in the async-rest work, it was used and it was wrong: a claim that
`.get` checks response status, a retry loop placed in the wrapper, and then a second retry loop
put back in the wrapper while "fixing" the first — contradicting a rule agreed two messages
earlier. Each was plausible reasoning from partial knowledge. A rule removes the opportunity.

## 2. The rationale is calibrated to prevent deviation, not to inform

> **Rationale:** Reduces visual noise. Single-line definitions are scannable; multi-line
> signals "there's configuration here."

One sentence. Its job is to stop the reader talking themselves out of the rule, not to teach
theory. Contrast a first draft of the async-rest rules: 40-line examples, three stacked
citations, and a "Consequence" section each. That reads as material to evaluate, which invites
re-derivation — the opposite of what a rule is for.

## 3. It asserts authority over the reader's priors, and over the world

> "These copies are the authoritative style reference; when upstream and these copies disagree,
> these copies win."

This anticipates the precise failure mode: the model finds the upstream originals and
"corrects" toward them. The description closes the same way — "The Ruby GTK bindings have
quirks (especially Adwaita) that make from-memory code unreliable; always consult this skill
first" — telling the model that its own knowledge is the untrustworthy input.

## 4. It separates "cannot be guessed" from "can be derived"

The Adwaita section is pure lookup: `Adwaita::` not `Adw::`; `Adwaita::Application` is broken,
use `Gtk::Application`; `NavigationPage.new(child, title)` is positional only. No reasoning is
offered because none exists — these are facts about a binding.

That distinction had to be learned the hard way in the async-rest work, when §1.2.1 of
Fielding's dissertation turned out to permit something that had been declared an architectural
violation. Facts and derivations need different treatment, and conflating them is how a trap
gets rationalised into a principle.

## 5. It tells the model how to extend itself

> "When a constructor fails: try no-args, then positional args in the order the error message
> shows. **Document new findings in the quirks reference.**"

A procedure for the case the skill does not cover, which keeps judgement inside a channel
instead of letting it loose on the rules. This is the single best idea in the skill. Its
absence elsewhere is costly: a `patterns/middleware.md` in the async-rest skill stated a
pattern that had never been executed, and survived until a human caught it.

## 6. Verification is a rule, with the reason stated

> "A syntax check proves nothing about a widget tree."

> "Widget wiring, dialogs and GAction state all fail silently in ways that `ruby -c` and a
> successful `require` will not show."

This is load-bearing rather than boilerplate. The equivalent rule in the async-rest work caught
three defects in a hand-written example — including a retry that never fired, because the
eager verb it used does not raise on a non-success status.

## 7. It tells the reader what to delete

`planning-methodology.md` is the most unusual thing in the skill: a table of patterns found in
the source application, with a column headed "Do You Need It?" answering "No" four times, and
then:

> **Rule:** If you can't explain why you need something, you don't need it.

With the counterweight that stops it being used to justify breakage:

> **Never remove working functionality when adding features.**

Most guidance says what to add. Giving explicit licence to drop a chunk system, operation
classes and a state machine — named, with reasons — is what stops a port becoming a
transcription.

## What is worth copying

In order: the **self-extension procedure**, the **authority statement over the reader's own
recollection**, and **one-sentence rationales**.

The async-rest rule set already has numbering, wrong/right pairs with usage, and a stricter
citation discipline — it cites numbered sections of the dissertation rather than asserting. Its
weakness by comparison is that nothing tells a reader what to leave out: five client gems sit
in its `refs/` and the rules never say which practices in them are dead. A "Do You Need It?"
table over those gems would be the direct analogue of Step 1.2 here.

## One defect

860 double-encoded `âŒ` / `âœ…` markers across the reference files:

| File | Occurrences |
|---|---|
| `declarative-patterns.md` | 452 |
| `planning-methodology.md` | 361 |
| `style-rules.md` | 41 |
| `adwaita-quirks.md` | 6 |
| `SKILL.md` | 0 |

The bytes are UTF-8 read as Latin-1 and re-encoded: `❌` (`E2 9D 8C`) became
`C3 A2 C2 9D C5 92`. They are concentrated in exactly the wrong/right pairs the method depends
on, so the signal is degraded where it matters most. `SKILL.md` being clean suggests the
references arrived by a different path.

## Two smaller inconsistencies

- `SKILL.md`'s rule table has **13** rules, then describes `style-rules.md` as "the 17 numbered
  rules". The reference does contain 17, so rules 14–17 — ListModel chain,
  SignalListItemFactory, delete-with-undo, entry point — never appear in the table a reviewer
  is told is non-negotiable.
- `style-rules.md` is titled "Ruby GTK4 Declarative Patterns Guide — Additions", differing from
  `declarative-patterns.md`'s title by one word, though `SKILL.md` distinguishes them by
  purpose (pattern catalog vs. review rules). The filenames are clearer than the headings.
