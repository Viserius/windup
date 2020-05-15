#!/bin/bash
for i in `ls -1 ./artifacts/*.ear`; do
	./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-classifier/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-classifier

	sudo find /tmp -amin +10 -exec rm -rf {} +
done

find reports-classifier -name 'AllIssues.csv' | xargs cat > report-classifier.csv

rsync -a --delete empty_dir/ reports-classifier
