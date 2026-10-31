# Conformance examples

Each directory here is a small example plan graph that names this standard as
its schema source. An `EX` item in `../examples/` describes each one and verifies
the rules it shows: a conforming example must pass `tl check`, and a deliberately
broken one must fail it for the reason its item states.

`check.sh` runs every example and is a step of CI's `graph` job.

`bad-date` cannot be written through `tl`, which refuses a value of the wrong
kind on every write; its plan's start was set to a valid date and then edited on
disk. It is the only file here not written by `tl`.
