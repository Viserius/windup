#!/bin/bash
shopt -s extglob

for i in `ls -1 ./artifacts/*.ear`; do

	if [ ! -s "./reports-ee-minimal/${i/.\/artifacts\//}/AllIssues.csv" ]; then

		echo "Running analyzer to create report for: ${i/.\/artifacts\//}"

		until ./rhamt-mark/bin/rhamt-cli --input "$i" --output "./reports-ee-minimal/${i/.\/artifacts\//}" --archives . --source duo --target duo --packages nl --exportCSV --keepWorkDirs --batchMode --overwrite --userRulesDirectory ./rules-ee-minimal
		do
			echo "An error occured while analyzing ${i/.\/artifacts\//}"
			sleep 5
		done
		
		sudo find /tmp -amin +10 -exec rm -rf {} +

	else
		echo "Report already created, skipping: ${i/.\/artifacts\//}"
	fi

	find ./reports-ee-minimal/${i/.\/artifacts\//}/ -mindepth 1 ! -name 'AllIssues.csv' -type d -exec rm -rv {} +
	find ./reports-ee-minimal/${i/.\/artifacts\//}/ -mindepth 1 ! -name 'AllIssues.csv' -type f -delete
done

sudo chmod -R 777 reports-ee-minimal

find reports-ee-minimal -name 'AllIssues.csv' | xargs cat > report-ee-minimal.csv

rsync -a --delete empty_dir/ reports-ee-minimal