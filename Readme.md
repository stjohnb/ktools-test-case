### KTools issue test case

This repository contains code to reproduce a segfault it the KTools `summarycalc` executable.

The segfault appears to only happen on Linux systems rather than OS X.

`run.sh` can be used to test the issue on your host operating system. For me this exits cleanly on OS X but generates a `FATAL: summarycalc: Segment fault at address: 0x56133b00d120` on linux

`dockerRun.sh` can be used reproduce the segfault on an Ubuntu docker image
