#!/bin/bash
#
        today=$1
        ndays=$2
        nn=1

        echo
        echo " +++ Starting script to do what I say +++"
        echo

        mdate=$today

        yr=${today:0:4}
        mm=${today:4:2}
        dd=${today:6:2}

        inpdir="$HOME/oper/pacific_npo/forecast/d-storage"
        outdir="gfsanl_glo0.50_2021_03h"

        while [ $nn -le $ndays ]; do


		 inpfile="$inpdir/${mdate}/gfs_${mdate}.nc"
		 outfile="$outdir/gfs_${mdate}.nc"

		 echo " ... rewrite file $inpfile"

                 ### do what i say
		 mv $inpfile $outfile

                 mdate=`find_tomorrow.sh $yr $mm $dd`

                 yr=${mdate:0:4}
                 mm=${mdate:4:2}
                 dd=${mdate:6:2}

                 let nn=$nn+1

        done

        echo
        echo " +++ End of script"
        echo


#
#   the end
#
