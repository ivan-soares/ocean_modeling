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

        inpdir="hncoda_glbv_npo0.08_167W117W-15N47N_03h"
        outdir="hncoda_glbv_npo0.08_167W117W-15N47N_06h"

        while [ $nn -le $ndays ]; do


		 inpfile="$inpdir/glbv_${mdate}.nc"
		 outfile="$outdir/glbv_npo_${mdate}.nc"

		 echo " ... rewrite file $inpfile"

		 next=`find_tomorrow.sh $yr $mm $dd`
		 inpfile2="$inpdir/glbv_${next}.nc"

                 ### do what i say
		 ncks -d time,0,7,2 $inpfile     tmp1
                 ncks -d time,0     $inpfile2    tmp2
 		 ncrcat -h tmp*     $outfile
		 rm tmp*

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
