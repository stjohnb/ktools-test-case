#!/usr/bin/env bash

set -e

evetobin < input/events.csv > input/events.bin
itemtobin < input/items.csv > input/items.bin
coveragetobin < input/coverages.csv > input/coverages.bin
gulsummaryxreftobin < input/gulsummaryxref.csv > input/gulsummaryxref.bin
damagebintobin < static/damage_bin_dict.csv > static/damage_bin_dict.bin

footprinttobin -i $(tail -n+2 static/footprint.csv | awk 'BEGIN { max=0 } $3 > max { max=$3 } END { print max }' FS=",") < static/footprint.csv
mv footprint.bin static/
mv footprint.idx static/

vulnerabilitytobin -d $(tail -n+2 static/vulnerability.csv | awk 'BEGIN { max=0 } $3 > max { max=$3 } END { print max }' FS=",") < static/vulnerability.csv > static/vulnerability.bin

eve 1 1| getmodel > cdf.csv
gulcalc < cdf.csv -S10 -c - | summarycalc -g -1 - > summary_out.csv