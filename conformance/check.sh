#!/usr/bin/env bash
# Checks each conformance example against the standard, as its EX item says:
# the conforming one must pass tl check, each broken one must fail for its reason.
set -u
cd "$(dirname "$0")"
fail=0

expect_pass() {  # example, EX item
  if out=$(tl -C "$1" check 2>&1); then
    echo "ok    $2 $1 passes"
  else
    echo "FAIL  $2 $1 should pass"; echo "$out"; fail=1
  fi
}

expect_fail() {  # example, EX item, text the failure must contain
  if out=$(tl -C "$1" check 2>&1); then
    echo "FAIL  $2 $1 should fail with: $3"; echo "$out"; fail=1
  elif grep -qF -- "$3" <<<"$out"; then
    echo "ok    $2 $1 fails: $3"
  else
    echo "FAIL  $2 $1 failed, but not with: $3"; echo "$out"; fail=1
  fi
}

expect_pass full-plan       EX-0001

# EX-0001 also promises that progress recorded on a ratified activity leaves its
# signature standing: ACT-0001 is signed and carries started and remaining, and
# the strict check (where a stale signature is an error) must still pass.
act=full-plan/activities/ACT-0001.yml
if grep -q '^status: ratified' "$act" && grep -q '^  started:' "$act" \
   && grep -q '^  remaining:' "$act" && out=$(tl -C full-plan check --strict 2>&1); then
  echo "ok    EX-0001 full-plan progress on a ratified activity leaves it signed"
else
  echo "FAIL  EX-0001 full-plan progress on ACT-0001 should leave it ratified and not stale"
  echo "${out:-}"; fail=1
fi
expect_fail bad-date        EX-0002 "attribute 'start' is declared date but holds 'next monday'"
expect_fail no-duration     EX-0003 "required attribute 'duration' missing"
expect_fail circular        EX-0004 "circular justification"
expect_fail loose-shift     EX-0005 "needs incoming 'follows' link"
expect_fail unmet-deadline  EX-0006 "deadline has nothing deriving from"
expect_fail wrong-link      EX-0007 "'starts' link must point to a ['activity'] item, not deadline"
expect_fail nested-activity EX-0008 "'part_of' link must point to a ['phase', 'plan'] item, not activity"
exit $fail
