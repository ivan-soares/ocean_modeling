#!/bin/bash

	today=20200730
	ndays=3
	nn=1

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

	echo
	echo " +++ Starting script to run roms many days +++"
	echo

	while [ $nn -le $ndays ]; do

	    echo " ... running forecast for day $today"

	    if [ ! -e d-storage/$today ]; then mkdir d-storage/$today ; fi

	    ./run_7days.sh $today 'glby' 1345

	    today=`find_tomorrow.sh $yr $mm $dd`
	    yr=${today:0:4}
	    mm=${today:4:2}
	    dd=${today:6:2}

	    let nn=$nn+1

	done	

	echo
	echo " +++ End of script +++"
	echo

#
#  the end
#
