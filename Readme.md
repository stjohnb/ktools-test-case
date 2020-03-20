### KTools issue test case

This repository contains code to reproduce a segfault it the KTools `summarycalc` executable.

The segfault appears to only happen on Linux systems rather than OS X.

`run.sh` can be used to test the issue on your host operating system. For me this exits cleanly on OS X but generates a segfault on linux:

```bash
linux-os% ./run.sh 
FATAL: summarycalc: Segment fault at address: 0x55a4e68d9150
```

```bash
MacBook-Pro% ./run.sh 
Successfully wrote summary_out.csv
```

`dockerRun.sh` can be used reproduce the segfault on an Ubuntu docker image
