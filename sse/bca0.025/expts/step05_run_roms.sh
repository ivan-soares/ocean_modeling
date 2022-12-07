#!/bin/bash
#

        #### S05

	today=$1
	ogcm=$2
	here=$3
	log=$4

	source $here/expt_setup.sh # will load dir names and other info

        #====================================================================================
        echo ; cd $tmpdir; dr=`pwd`; now=$(date "+%Y/%m/%d %T"); echo >> $log
        echo " ... starting ROMS forecast expt at $now" >> $log; echo >> $log
        echo " ==> $now HERE I am @ $dr for step 05: run ROMS <=="; echo
        #====================================================================================

	echo
	echo " ... today is ${yr}-${mm}-${dd}"
	echo 
	echo " ... roms grid size is $nx x $ny x $nsig" 
	echo " ... roms grid limits are: x1,x2 = $x1,$x2, y1,y2 = $y1,$y2"
	echo " ... roms grid resolution is regular: $incr x $incr"
	echo
	echo " ... will store outputs in folder $stodir"
	echo
	echo " ... start day is $today"
	echo " ... the expt is $expt"
	echo " ... will run for $ndays day(s)"
	echo
	echo " ... the grid  file is $romsgrd"
        echo " ... the force file is $romsfrc"
	echo " ... the nudg  file is $romsnud"
	echo " ... will not use tide"
	echo

	############################### *** set inputs/outputs *** ##################################################################

	inpdir="$tmpdir/roms_in"
	outdir="$tmpdir/roms_out"

	echo
	echo " ... will read roms input files from $inpdir"
	echo " ... will output roms results to $outdir"
	echo

	if [ -d $inpdir ]; then
	     echo " ... $inpdir exists, will use it"
	else
	     echo " ... $inpdir DOES NOT exist, will create it"
	     mkdir $inpdir
	fi

	if [ -d $outdir ]; then
	     echo " ... $outdir exists, will use it"
	else
	     echo " ... $outdir DOES NOT exist, will create it"
	     mkdir $outdir
	fi

	rm $outdir/*
	rm $inpdir/*

	cd $inpdir

	################ ***  make links to input files: grid, tides. nudge, clim, bdry *** #########################################

	source $here/step05_sub01_link_roms_inputfiles.sh
	wait

	######### *** make ocean.in file: will create a file named $inpdir/ocean_${expt}.in *** #####################################

	source $here/step05_sub02_create_ocean-in.sh
	wait

	cd $outdir

	################################## *** run the model *** ####################################################################

	export LD_LIBRARY_PATH="$HOME/apps/netcdf-c-4.8.0/lib"
	export LD_LIBRARY_PATH="$HOME/apps/openmpi-4.1.1/lib/":$LD_LIBRARY_PATH

	if    [ $ramp_flag == 'tide_with_ramp' ];  then echo " ... will use tide ramp"
	elif  [ $ramp_flag == 'tide_no_ramp'   ];  then echo " ... will NOT use tide ramp"
	elif  [ $ramp_flag == 'no_tide'   ];  then echo " ... will NOT use the tides at all !!!"
	else    echo " ... ERROR, wrong ramp choice, exiting "; exit 1
	fi

	if    [ $nudge_flag == 'ananudge'      ]; then echo " ... will use anannudge"
	elif  [ $nudge_flag == 'nudge_by_user' ]; then echo " ... will use nudge built by user"
	else    echo " ... ERROR, wrong nudge choice, exiting "; exit 1
	fi

	if    [ $avg_flag == 'avg'    ]; then echo " ... will compute daily averages"
	elif  [ $avg_flag == 'avg_no_dqdsst' ]; then echo " ... will compute daily averages"
	elif  [ $avg_flag == 'no_avg' ]; then echo " ... will NOT compute daily averages"
	else    echo " ... ERROR, wrong avg choice, exiting "; exit 1
	fi

	roms_exec="$roms_codedir/romsMY25_bca_${ramp_flag}_${nudge_flag}_${avg_flag}"

	echo
	echo " ... roms executable code is $roms_exec"
	echo

	if [ ! -e $roms_exec ]; then
	       echo " ... ERROR, ROMS executable $roms_exec was not found"
	       echo " ... exiting"; exit; echo
	fi

	now=$(date "+%Y/%m/%d %T")

	echo
	echo " ... starting the model at $now"
	echo

	let ntiles=$ntile_i*$ntile_j

	$HOME/apps/openmpi-4.1.1/bin/mpirun -np $ntiles $roms_exec $inpdir/ocean_${expt}.in >& roms.log &
	#nice -n +19 $HOME/apps/openmpi-4.1.1/bin/mpirun -np $ntiles $roms_exec $inpdir/ocean_${expt}.in >& roms.log &
	#srun -n 60 --mpi=pmi2 $roms_codedir/$roms_exec $inpdir/ocean_${expt}.in >& roms.log &
	wait

	now=$(date "+%Y/%m/%d %T")

	echo
	echo " ... end of simulation at $now"
	echo

	################################## *** check outputs *** #####################################################################

	echo
	echo " ... now we check that history file exists and has $nhrs_roms time steps"
	echo

	romshis="roms_his.nc"
	expt="${domain_roms}_${version}_${today}"
	expt2="${domain_roms}_${version}_${tomorrow}"

	if [ -e $romshis ]; then

	      echo " ... found file $romshis"
	      npassos=`ncdump -h $romshis | grep "ocean_time = UNLIMITED" | sed -e 's/(//g' | awk '{print $6}'`
	      echo " ... the # of time steps in the file is $npassos"
	      echo " ... the # of expected time steps is $nhrs_roms"

	      if [ $npassos -eq $nhrs_roms ]; then

		     echo 
		     echo " ... all is fine, roms history file $romshis has $npassos steps"
		     echo " ... move output files to storage"
		     echo

		     mv roms.log        $stodir/$today/logfile_${expt}.log
		     mv roms_his.nc     $stodir/$today/roms_his_${expt}.nc
		     mv roms_rst.nc     $stodir/$today/roms_rst_${expt2}.nc

		     if [ -e roms_avg.nc ]; then mv roms_avg.nc  $stodir/$today/roms_avg_${expt}.nc; fi
                     if [ -e roms_flt.nc ]; then mv roms_flt.nc  $stodir/$today/roms_flt_${expt}.nc; fi
		     if [ -e roms_stn.nc ]; then mv roms_stn.nc  $stodir/$today/roms_stn_${expt}.nc; fi

		     cp $inpdir/ocean_${expt}.in $stodir/$today/.

	      else

		     echo                
		     echo " ... roms history is not OK, it has $npassos steps"
		     echo

	      fi
	else

	      echo
	      echo " ... roms history was NOT found"
	      echo

	fi

	cd $tmpdir

	########################## *** convert outputs from sigma to z levels *** ####################################################

	#source $here/step05_sub03_convert_sig2z.sh
	#wait

	####################### finish

	#====================================================================================
	echo ; now=$(date "+%Y/%m/%d %T"); echo >> $log
	echo " ... finished ROMS forecast at $now" >> $log; echo >> $log
	echo " ==> $now FINISHED running ROMS <=="; echo
	#====================================================================================

	cd $here

##################################   ***  the end  *** ##############################################################################
