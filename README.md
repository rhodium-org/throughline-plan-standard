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
