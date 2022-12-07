#!/bin/bash
#
	today=$1
	ndays=$2
 
        nn=1

	echo
	echo " +++ Starting bash sript to do what I say +++ "
	echo


	mdate=$today
              
	yr=${mdate:0:4}
	mm=${mdate:4:2}
	dd=${mdate:6:2}


	while [ $nn -le $ndays ]; do

		echo " ... Do what I say on this date $yr/$mm/$dd"

		mdate=`find_tomorrow.sh $yr $mm $dd`
		yr=${mdate:0:4}
		mm=${mdate:4:2}
		dd=${mdate:6:2}

		let nn=$nn+1

	done


	echo
	echo " +++ End of Script +++ "
	echo

#
#   the end
#
