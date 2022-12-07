#!/bin/bash
#

#	expt 93.0 from 01-jan-2018 to 18-feb-2020
#	expt 92.9 from 01-oct-2017 to 31-dec-2017
#	expt 57.7 from 01-jun-2017 to 30-sep-2017
#	expt 92.8 from 01-feb-2017 to 31-may-2017
#	expt 57.2 from 01-may-2016 to 31-jan-2017
#	expt 56.3 from 01-jul-2014 to 30-apr-2016

	today='20200601'
	ndays=30
	nn=1

	ogcm="glby"
        expt="expt_93.0"

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

	mdate=${today}

	echo
	echo " +++ Stating download +++"
	echo

	while [ $nn -le $ndays ]; do

		echo " ... downloading file for date $yr/$mm/$dd"
		./download_ogcm_npo.sh $mdate 1 $ogcm $expt ; wait

		mdate=`find_tomorrow.sh $yr $mm $dd`
		yr=${mdate:0:4}
		mm=${mdate:4:2}
		dd=${mdate:6:2}

		let nn=$nn+1

	done

        echo
        echo " +++ End of download +++"
        echo

########################################################################
