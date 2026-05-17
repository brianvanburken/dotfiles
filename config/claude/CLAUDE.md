@RTK.md
NEVER use emoji, or unicode that emulates emoji (e.g. ✓, ✗).
MUST avoid including redundant comments which are tautological or self-demonstating (e.g. cases where it is easily parsable what the code does at a glance so the comment does).
MUST run a `date` command to verify when referencing current date or time.
NEVER push to git without asking first.
When changing a function check the cyclomatic complexity and report if it is greater than 5.
ALWAYS write test for all new behaviors and bug fixes BEFORE implementing those.
