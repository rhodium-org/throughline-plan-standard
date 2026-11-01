# Plan format standard

A [throughline](https://github.com/rhodium-org/throughline) graph that states the
model a plan is written in: the kinds of item a plan holds (phases, activities,
milestones, shifts, deadlines), their attributes and kinds, the one link that orders them, how
a plan breaks down, and what signing a plan means.

It is a standard, not a tool and not a plan. It holds no plan and says nothing
about how a plan is drawn: a Gantt chart, a board or a list can all read the same
plan graph.

## The shape of a plan

| Kind | What it is | Records |
|---|---|---|
| `plan` | the plan itself, one per graph | `start`, the first working day |
| `phase` | a group of activities, milestones and phases | nothing of its own; its span is worked out |
| `activity` | work that takes time | `duration`, `optimistic`, `pessimistic`; `who`, `started`, `finished`, `remaining` |
| `milestone` | a moment that takes no time | `reached` |
| `shift` | a lag (positive) or lead (negative) in a chain | `by` |
| `deadline` | a date set from outside the plan | `date`, `set_by` |

| Link | From | To | Means |
|---|---|---|---|
| `follows` | activity, milestone, phase, shift | the same | may begin once that has finished |
| `part_of` | activity, milestone, phase | plan, phase | the breakdown |
| `starts` / `finishes` | milestone | activity | the milestone is the activity's start or finish |
| `meets` | milestone | deadline | the plan expects to reach it by that date |

- **One link orders a plan:** "this follows that". A lag is a *shift* item placed in
  the chain between two items; a lead is a shift with a negative `by`. No link
  carries an attribute.
- **Every dependency kind is that same link.** Name an activity's start or finish as
  a milestone and link to it: start-to-start, finish-to-finish and start-to-finish
  need no link types of their own.
- **What can be worked out is never stored:** early and late dates, slack, the
  critical path and a phase's span are computed by whoever reads the plan.
- **A ratified plan is the baseline.** Durations, estimates, shifts and deadlines are
  what a signature covers; `who`, `started`, `finished`, `remaining` and `reached`
  are not, so recording progress never moves the baseline.
- **Time is in working days**, Monday to Friday, and may be fractional. Calendars,
  resources and fixed dates on activities are left for a later edition.
- A circular order fails the check, a shift must sit between two items, every
  phase, activity and milestone is part of something, and a deadline nothing meets
  is reported.

## Following the standard

```toml
[[sources]]
namespace = "plan"
url = "https://github.com/rhodium-org/throughline-plan-standard"
ref = "v2.0.0"
schema = true
```

The plan graph is then checked against this standard's declarations: the registers,
attributes, links and link types it declares as items, plus the statuses,
transitions, grounding and coverage rules in its `throughline.toml`. Anything a plan
holds that no declaration names is an error. A plan may declare its own additions
(`scope = "this-graph"`), but never redefine one declared here. This needs throughline
4.6.1 or later, and `tl init --from-schema` creates every register declared here.

## What is in this graph

| Register | Holds |
|---|---|
| `vision/` (INT) | why the standard exists |
| `registers/` (REG) | the registers a plan holds (PLN, exactly one; PH, ACT, MS, SH, DL), and this graph's own |
| `types/` (TYPE) | working days, calendar date, text |
| `attributes/` (ATTR) | each register's attributes, required or not, signed or not |
| `links/` (LINK), `link-types/` (LT) | follows, part_of, starts, finishes, meets: which registers each joins |
| `constraints/` (CON) | obligations on the standard itself |
| `rules/` (RULE) | the prose each declaration takes as its rationale |
| `examples/` (EX) | the example plan graphs in `conformance/`, and the rules each verifies |
| `non-goals/` (NG) | what the standard leaves out on purpose |

The standard follows the throughline meta-standard
([throughline-standard-standard](https://github.com/rhodium-org/throughline-standard-standard)),
which fixes what a declaration is.

The prose registers (CON, RULE, EX, NG) are on their way out: a standard holds only
declarations. 24 rules already live on as the rationale of a declaration; the other
7 (RULE-0007, -0020, -0021, -0027, -0028, -0029, -0030) are to become declarations or
the rationale of the configuration they explain, and then the four registers go.

## Editions

The standard is released as tagged editions that a plan pins. A change that would
make a conforming plan fail is a new major edition, and its notes say what a plan
must change.
