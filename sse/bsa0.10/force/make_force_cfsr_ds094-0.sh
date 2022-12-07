#!/bin/bash
#
	echo
	echo " ... Starting script to make force file for ROMS ..."
	echo

	today=20180101
	year=${today:0:4}
	let next=$year+1
	#ddir1='ds094.0_GLB_2011-2015_0.5x0.5'
	#ddir2='ds094.0_GLB_2011-2015_0.5x0.5'
	ddir1='ds094.0_GLB_2016-2020_0.5x0.5'
	ddir2='ds094.0_GLB_2016-2020_0.5x0.5'

	lon1=193.; W=-167.
	lon2=243.; E=-117.

	lat1=15.; S=15.
	lat2=47.; N=47.

	outfile="force_npo0.50_${year}_cfsr.nc"

	for var in airtmp_02m humdty_02m pprate_00m premsl_00m radflx_00m wndspd_10m; do

		echo " ... make a list of file names for $var"

		if [ -e list_$var ]; then rm list_$var; fi
		ls -1 $HOME/storage01/environment/atmos_cfsr/$ddir1/$var/cdas1.${year}* >& list_$var
		ls -1 $HOME/storage01/environment/atmos_cfsr/$ddir2/$var/cdas1.${next}0101* >> list_$var

		a=0
		while read line; do

		      echo " ... accessing file $line"

		      a=$(($a+1));
		      n=$(printf "%3.3d" $a)

		      n1=`echo $line | wc -L`
		      let n2=$n1-2; let n3=$n1-3                 
		      ext="${line:$n2:2}"; #echo $ext

		      if [ $ext == 'gz' ]; then  # the file is compressed; have to unzip it
			   echo " ... file is compressed"
			   if [ -e $line ]; then
			      gunzip $line
			      file=${line:0:$n3}; echo $file 
			      ncks -d lat,$lat1,$lat2 -d lon,$lon1,$lon2 $file file_$n.nc
			      gzip $file
			   fi
		      else                       # the file is not compressed;
			   echo " ... file is NOT compressed"
			   if [ -e $line ]; then
			      ncks -d lat,$lat1,$lat2 -d lon,$lon1,$lon2 $line file_$n.nc
			      gzip $line
			   fi
		      fi

		done < list_$var

		echo
		echo " ... finished accessing $a files";
		echo

		if [ -e cfsr_${var}_${year}.nc ]; then
		 rm cfsr_${var}_${year}.nc
		fi

		echo; echo " ... concatenate daily files ..." ; echo 
		ncrcat -h file_*.nc cfsr_${var}_${year}.nc
		rm file_*.nc

		echo; echo " ... concatenate var files ..." ; echo
		ncks -h -A cfsr_${var}_${year}.nc cfsr_${year}.nc


	done

	#### merge all files in one force file

	echo 
	echo " ... fix force file to be in accordance with ROMS patterns"
	echo

	fix_cfsr4roms.sh cfsr_${year}.nc $outfile $today $W $E $S $N

	#ncap2 -O -h -s "frc_time(0)=frc_time(1)-7." force.nc $outfile
	#rm force.nc

	echo
	echo " ... End of script ..."
	echo

