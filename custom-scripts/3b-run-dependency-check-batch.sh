#!/bin/bash

sudo find /tmp -amin +10 -exec rm -rf {} +

#!/bin/bash
for i in `ls -1 ./artifacts/*.ear`; do
	if [ ! -s "./reports-dependency-check/${i/.\/artifacts\//}/dependency-check-report.csv" ]; then

		echo "Running dependency check to create report for: ${i/.\/artifacts\//}"

		until ./dependency-check/bin/dependency-check.sh -s "$i" -o ./reports-dependency-check/${i/.\/artifacts\//} --format ALL --proxyserver 127.0.0.1 --proxyport 3128 -ossIndexUsername "soelmanm@gmail.com" -ossIndexPassword "-S%|5<p>H4Nt"
		do
			echo "An error occured while analyzing ${i/.\/artifacts\//}"
			sleep 5
		done
		
		sudo find /tmp -amin +10 -exec rm -rf {} +
	
	else
		echo "Report already created, skipping analysis for: ${i/.\/artifacts\//}"
	fi
done

sudo chmod -R 777 ./reports-dependency-check

find reports-dependency-check -name 'dependency-check-report.csv' | xargs cat > report-security.csv

rsync -a --delete empty_dir/ reports-dependency-check