# ktools-test-case Overview

## Purpose

This repository is a minimal reproducible test case for a segmentation fault in the [KTools](https://github.com/OasisLMF/ktools) `summarycalc` executable. The bug manifests on Linux but not on macOS. It exists to help KTools developers reproduce and diagnose the issue.

## Architecture

```
.
├── input/              # Per-run simulation input data (CSV)
│   ├── events.csv
│   ├── items.csv
│   ├── coverages.csv
│   └── gulsummaryxref.csv
├── static/             # Model static data (CSV)
│   ├── damage_bin_dict.csv
│   ├── footprint.csv   (~40k rows)
│   └── vulnerability.csv (~2.3k rows)
├── run.sh              # Host-native reproduction script
├── dockerRun.sh        # Docker-based reproduction script (Ubuntu)
└── Dockerfile          # Builds Ubuntu image with ktools from source
```

### Data flow in `run.sh`

1. **CSV → binary conversion** — KTools tools (`evetobin`, `itemtobin`, `coveragetobin`, `gulsummaryxreftobin`, `damagebintobin`, `footprinttobin`, `vulnerabilitytobin`) convert all CSV inputs to binary format under `input/` and `static/`.
2. **Simulation pipeline** — a Unix pipe runs the core computation:
   ```
   eve 1 1 | getmodel > tmp/cdf.csv
   gulcalc < tmp/cdf.csv -S10 -c - | summarycalc -g -1 - > summary_out.csv
   ```
   - `eve` generates event data
   - `getmodel` produces cumulative distribution functions (CDFs)
   - `gulcalc` runs the Ground-Up Loss calculation with 10 samples (`-S10`)
   - `summarycalc` aggregates losses — **this is where the segfault occurs on Linux**

## Key Patterns

- All KTools binaries must be installed on the host (or inside Docker) before running `run.sh`.
- Binary files produced by the conversion step are written back into `input/` and `static/` alongside the source CSVs.
- `run.sh` uses `set -e`, so it will abort on any non-zero exit code before reaching `summarycalc` if earlier steps fail.
- `dockerRun.sh` mounts the repo directory into the container as `/ktools-test` and runs `run.sh` inside it, so the same CSV/binary data is shared.

## Configuration

| Item | Details |
|------|---------|
| `gulcalc -S10` | Number of GUL samples; hardcoded in `run.sh` |
| Docker base image | `ubuntu:19.10` (EOL; chosen to match a known-failing environment) |
| KTools source | Cloned from `https://github.com/OasisLMF/ktools` at build time (latest HEAD) |

## Reproducing the Bug

**On host (Linux expected to segfault, macOS expected to succeed):**
```bash
./run.sh
```

**In Docker (Ubuntu, always reproduces the segfault):**
```bash
./dockerRun.sh
```

Expected failure output on Linux:
```
FATAL: summarycalc: Segment fault at address: 0x...
```

Expected success output on macOS:
```
Successfully wrote summary_out.csv
```
