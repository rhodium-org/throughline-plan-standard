# Plan format standard

A [throughline](https://github.com/rhodium-org/throughline) graph that states the
model a plan is written in: the kinds of item a plan holds (activities, milestones,
deadlines, shifts), their attributes and kinds, the one link that orders them, how
a plan breaks down, and what signing a plan means.

It is a standard, not a tool and not a plan. It holds no plan and says nothing
about how a plan is drawn: a Gantt chart, a board or a list can all read the same
plan graph.

## The shape of a plan

- **One link orders a plan:** "this follows that". A lag is a *shift* item with a
  positive duration placed in the chain between two items; a lead is a shift with a
  negative one. No link carries an attribute.
- **Every dependency kind is that same link.** An activity's start or finish can be
  named as a milestone, so start-to-start and finish-to-finish are links to those.
- **What can be worked out is never stored:** early and late dates, slack, the
  critical path and a summary's span are computed by whoever reads the plan.
- **A ratified plan is the baseline.** Progress is recorded without touching what
  was signed; changing a duration or a link shows as drift from the baseline.
- Durations are in working days. Calendars and resource levelling are left for a
  later edition.

## Following the standard

```toml
[[sources]]
namespace = "plan"
url = "https://github.com/rhodium-org/throughline-plan-standard"
ref = "v1.0.0"
schema = true
```

The plan graph is then checked by this standard's item types, attributes, links,
statuses, transitions, grounding and coverage rules, plus its own additions. It may
add, but never redefine anything declared here. This needs throughline 4.4.0 or
later. Everything in this graph's `throughline.toml` is inherited, including the
types the standard uses for its own items, which are inert in a plan.

## What is in this graph

| Register | Holds |
|---|---|
| `vision/` (INT) | why the standard exists |
| `constraints/` (CON) | obligations on the standard itself |
| `rules/` (RULE) | what a conforming plan must do or may hold; every declaration in `throughline.toml` names its rule |
| `examples/` (EX) | the example plan graphs in `conformance/`, and the rules each verifies |
| `non-goals/` (NG) | what the standard leaves out on purpose |

## Editions

The standard is released as tagged editions that a plan pins. A change that would
make a conforming plan fail is a new major edition, and its notes say what a plan
must change.
