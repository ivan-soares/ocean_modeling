#!/bin/bash
#

	#### S03

	today=$1
	ogcm=$2
	here=$3
	log=$4

	source $here/expt_setup.sh # will load dir names and other info

	#====================================================================================
	echo ; cd $tmpdir; dr=`pwd`; now=$(date "+%Y/%m/%d %T"); echo >> $log
	echo " ... starting download of OGCM $ogcm at $now" >> $log; echo >> $log
	echo " ==> $now HERE I am @ $dr for step 02: download ogcm $ogam data <=="; echo
	#====================================================================================

	outfile="${ogcm}_${domain_ogcm}_${today}.nc"

	echo
	echo " ... today is ${yr}-${mm}-${dd}, ogcm is $ogcm"
	echo " ... will download $ndays day(s), with interval of $dh hours "
	echo " ... will save outputs in file $outfile"
	echo

	nt=1
	ntry=3

	while [ $nt -le $ntry ]; do

	 md=$today      
	 yr=${today:0:4}
	 mm=${today:4:2}
	 dd=${today:6:2}

	 yesterday=`find_yesterday.sh $yr $mm $dd`
	 y1=${yesterday:0:4}
	 m1=${yesterday:4:2}
	 d1=${yesterday:6:2} 

	 echo " ... This is try n. $nt to download ogcm file"; echo

	 if [ "$ogcm" == "nemo" ]; then

		nbytes='141708912'
		n1=1
		n2=$ndays
		n3=0
		n4=0

		if [ $ndays -gt 2 ]; then
		 n1=1
		 n2=2
		 n3=3
		 n4=$ndays
		fi
		  

	      for (( n=$n1; n<=$n2; n+=1)); do
		     echo " ... downloading ${n}th day, date $yr/$mm/$dd"
		     # will download files named nemo_${today}-000000Z.nc
		     get_nemo_3dinst_uvts_one_day.sh $md $wesn_ogcm '$ASD45ui'
		     get_nemo_3dinst_ssh_one_day.sh $md $wesn_ogcm '$ASD45ui'
		     nx=`ncdump -h nemo_ssh_${md}-000000Z.nc | grep "longitude ="  | awk '{print $3}'`
		     ny=`ncdump -h nemo_ssh_${md}-000000Z.nc | grep "latitude ="   | awk '{print $3}'`
		     sed -e "s/NLON/$nx/g" -e "s/NLAT/$ny/g" $here/d-interp/nemo_YYYY-MM-DD.cdf >& cdf.cdf
		     ncgen -k4 cdf.cdf -o nemo_${md}-000000Z.nc; rm cdf.cdf
		     python $here/d-interp/write_nemo_file.py nemo_uvts_${md}-000000Z.nc nemo_ssh_${md}-000000Z.nc nemo_${md}-000000Z.nc
		     #rm nemo_uvts_${md}-000000Z.nc nemo_ssh_${md}-000000Z.nc
		     md=`find_tomorrow.sh $yr $mm $dd`; yr=${md:0:4}; mm=${md:4:2}; dd=${md:6:2}
	      done

	      for (( n=$n3; n<=$n4; n+=1)); do
		     echo " ... downloading ${n}th day, date $yr/$mm/$dd"
		     # will download files named nemo_${today}-120000Z.nc
		     get_nemo_one_day.sh $md $wesn_ogcm '$ASD45ui'
		     md=`find_tomorrow.sh $yr $mm $dd`; yr=${md:0:4}; mm=${md:4:2}; dd=${md:6:2}
	      done

	      echo
	      # get an extra day
	      get_nemo_one_day.sh $md $wesn_ogcm '$ASD45ui'

	 elif [ "$ogcm" == "glbv" -o "$ogcm" == "glbu" -o "$ogcm" == "glby" ]; then

	      nbytes='91079125'

	      for (( n=1; n<=$ndays; n+=1)); do
		     echo " ... downloading ${n}th day, date $yr/$mm/$dd"
		     # will download files named glbv_${mdate}-${hh}0000Z.nc
		     get_hycom_latest.sh $md $nh $dh $ogcm $wesn_ogcm
		     cdo -s --no_warnings mergetime ${ogcm}_${md}-*.nc ${ogcm}_${md}.nc; rm ${ogcm}_${md}-*.nc
		     md=`find_tomorrow.sh $yr $mm $dd`; yr=${md:0:4}; mm=${md:4:2}; dd=${md:6:2}
	      done

	      # the last hour is hour 0 of next day
	      echo ; echo " ... downloading 0 hour of day $yr/$mm/$dd"; echo
	      get_hycom_latest.sh $md 0 $dh $ogcm $wesn_ogcm
	      mv ${ogcm}_${md}-000000Z.nc ${ogcm}_${md}.nc

	 else

	      echo
	      echo " ... ogcm type $ogcm is not valid here, exiting !!!"
	      exit
	      echo

	 fi

	 #### combine the files in one clim file
	 if [ -f $outfile ]; then rm $outfile ; fi
	 echo " ... merge downloaded files into file $outfile"
	 cdo -s --no_warnings mergetime ${ogcm}_20*.nc tmp1
	 mv ${ogcm}_20*.nc $trunk/.

	 #fix longitudes
	 echo " ... fix longitudes"
	 echo " ... include new attributes: _FillValue and missing values"
	 #ncap2 to change longitudes to neg where they are > 180 is done in get_hycom_forecast.sh
	 #ncap2 -O -s 'where(lon>180) lon=lon-360' $outfile tmp ; rm $outfile
	 cdo -setmissval,NaN tmp1 tmp2
	 cdo -setmissval,-9999. tmp2 $outfile
	 rm tmp*

	 echo 
	 echo " ... check integrity of downloaded file "
	 echo

	 ## script check_nemo.sh will create a file named check_status
	 check_nemo.sh $outfile $nbytes $log
	 check=`cat check_status`
	 rm check_status
	 check=0
	 if [ $check == 0 ]; then
	      echo " ... %%%%%% Downloaded file is OK !! %%%%%%"
	      break
	 fi
	 let nt=$nt+1
	done

	echo 
	echo " ... move file to storage "
	echo

	mv $outfile $stodir/$today/.

	#====================================================================================
	echo ; now=$(date "+%Y/%m/%d %T"); echo >> $log
	echo " ... finished download of ogcm at $now" >> $log; echo >> $log
	echo " ==> $now FINISHED downloading of ogcm <=="; echo
	#====================================================================================

	cd $here

################################## *** the end *** ###########################################
