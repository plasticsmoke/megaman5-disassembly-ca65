# Mega Man 5 — Data Reference

Addresses, table formats, and IDs for ROM hackers, as established by
the annotated disassembly. `$XX:YYYY` = PRG bank `$XX` at CPU address
`$YYYY`. File offset of a byte = `16 + bank*$2000 + (addr - base)`
where `base` is the bank's mapped address (`$8000`, `$A000`, or
`$C000` — see `cfg/nes.cfg`). See ENGINE.md for how these systems
work.

**SKELETON** — sections below are placeholders, filled in as the
disassembly establishes each table and format.

## Table of Contents

1. Quick Reference
2. Bank Map
3. Zero Page
4. RAM Map
5. Entity Arrays
6. Entity Type Catalog
7. Stages and Bosses
8. Player States and Sub-types
9. Weapons
10. Damage Tables
11. Stage Data Format
12. Spawn Lists
13. CHR-RAM Streaming Data
14. Animation and Sprite Data
15. Sound Engine Reference
16. Password System
17. Fixed-Bank Tables
18. Fixed-Bank API

*(All sections TBD.)*
