#!/bin/bash

for i in `ls -1 ./artifacts/*.ear`; do
	./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-ee-optimal/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-ee-optimal

	sudo find /tmp -amin +10 -exec rm -rf {} +
done

find reports-ee-optimal -name 'AllIssues.csv' | xargs cat > report-ee-optimal.csv

rsync -a --delete empty_dir/ reports-ee-optimal