#!/bin/bash
for i in `ls -1 ./artifacts/*.ear`; do

	if [ ! -s "./reports-classifier/${i/.\/artifacts\//}/AllIssues.csv" ]; then

		echo "Running analyzer to create report for: ${i/.\/artifacts\//}"

		until ./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-classifier/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-classifier
		do
			echo "An error occured while analyzing ${i/.\/artifacts\//}"
			sleep 5
		done
		
		sudo find /tmp -amin +10 -exec rm -rf {} +
	
	else
		echo "Report already created, skipping: ${i/.\/artifacts\//}"
	fi
done

sudo chmod -R 777 reports-classifier

find reports-classifier -name 'AllIssues.csv' | xargs cat > report-classifier.csv

rsync -a --delete empty_dir/ reports-classifier
