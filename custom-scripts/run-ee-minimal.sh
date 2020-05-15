#!/bin/bash

for i in `ls -1 ./artifacts/*.ear`; do
	./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-ee-minimal/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-ee-minimal

	sudo find /tmp -amin +10 -exec rm -rf {} +
done

find reports-ee-minimal -name 'AllIssues.csv' | xargs cat > report-ee-minimal.csv

rsync -a --delete empty_dir/ reports-ee-minimal