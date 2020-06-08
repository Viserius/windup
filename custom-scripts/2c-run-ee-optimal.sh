#!/bin/bash
shopt -s extglob

for i in `ls -1 ./artifacts/*.ear`; do

	if [ ! -s "./reports-ee-optimal/${i/.\/artifacts\//}/AllIssues.csv" ]; then

		echo "Running analyzer to create report for: ${i/.\/artifacts\//}"

		until ./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-ee-optimal/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-ee-optimal
		do
			echo "An error occured while analyzing ${i/.\/artifacts\//}"
			sleep 5
		done

		sudo find /tmp -amin +10 -exec rm -rf {} +
	else
		echo "Report already created, skipping: ${i/.\/artifacts\//}"
	fi

	find ./reports-ee-optimal/${i/.\/artifacts\//}/ -mindepth 1 ! -name 'AllIssues.csv' -type d -exec rm -rv {} +
	find ./reports-ee-optimal/${i/.\/artifacts\//}/ -mindepth 1 ! -name 'AllIssues.csv' -type f -delete
done

sudo chmod -R 777 reports-ee-optimal

find reports-ee-optimal -name 'AllIssues.csv' | xargs cat > report-ee-optimal.csv

rsync -a --delete empty_dir/ reports-ee-optimal