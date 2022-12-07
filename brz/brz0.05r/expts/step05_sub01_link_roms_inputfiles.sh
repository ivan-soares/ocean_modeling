#!/bin/bash
#

	echo
	echo " +++ Starting step05 s.r. 01: make links to ROMS input files +++"
	echo

        if [ -e $romsgrd ]; then
           echo; echo " ... accessing ROMS grid file $romsgrd"; echo
           if [ -e roms_grd.nc ]; then rm roms_grd.nc; fi
           ln -s $romsgrd roms_grd.nc
        else
           echo; echo " ... didnt find ROMS grid file $romsgrd, exiting forecast cycle"
           echo; exit
        fi

        #echo; echo " ... this implementation uses no tides" ; echo

        if [ -e $romstid ]; then
           echo; echo " ... accessing ROMS tide file $romstid"; echo
           if [ -e roms_tid.nc ]; then rm roms_tid.nc; fi
           ln -s $romstid roms_tid.nc
        else
           echo; echo " ... didnt find ROMS tide file $romstid, exiting forecast cycle"
           echo; exit
        fi

	echo; echo " ... this implementation uses no rivers" ; echo

        #if [ -e $romsriv ]; then
        #   echo; echo " ... accessing ROMS river file $romsriv"; echo
        #   if [ -e roms_riv.nc ]; then rm roms_riv.nc; fi
        #   ln -s $romsriv roms_riv.nc
        #else
        #   echo; echo " ... didnt find ROMS river file $romsriv, exiting forecast cycle"
        #   echo; exit
        #fi

        if [ -e $romsnud ]; then
           echo; echo " ... accessing ROMS nudg file $romsnud"; echo
           if [ -e roms_nud.nc ]; then rm roms_nud.nc; fi
           ln -s $romsnud roms_nud.nc
        else
           echo; echo " ... didnt find ROMS nudg file $romsnud, exiting forecast cycle"
           echo; exit
        fi

        ### if a restart file is NOT found, the initial file will be the clm file
	### in this case nrrec and tidal_ramp have to be fixed accordingly !!!

        if [ -e $romsini ]; then
           echo; echo " ... accessing ROMS init file $romsini"; echo
           if [ -e roms_ini.nc ]; then rm roms_ini.nc; fi
           ln -s $romsini roms_ini.nc
        else
           echo; echo " ... didnt find ROMS init file $romsini"
           echo; echo " ... will use file $romsclm"; echo
	   if [ -e roms_ini.nc ]; then rm roms_ini.nc; fi
           ln -s $romsclm roms_ini.nc
	   #ramp_flag='tide_with_ramp'
           nrrec=0
        fi


        file=$romsclm

        if [ -e $file ]; then
           echo; echo " ... accessing ROMS clim file $file"; echo
           if [ -e roms_clm.nc ]; then rm roms_clm.nc; fi
           ln -s $file roms_clm.nc
        else
           echo; echo " ... didnt find ROMS clim file $file, exiting forecast cycle"
           echo; exit
        fi

        file=$romsbry

        if [ -e $file ]; then
           echo; echo " ... accessing ROMS bdry file $file"; echo
           if [ -e roms_bry.nc ]; then rm roms_bry.nc; fi
           ln -s $file roms_bry.nc
        else
           echo; echo " ... didnt find ROMS bdry file $file, exiting forecast cycle"
           echo; exit
        fi

	echo; echo " ... this implementation uses no Q CORR" ; echo

        #file=$romsqcorr

        #if [ -e $file ]; then
        #   echo; echo " ... accessing ROMS QCORR file $file"; echo
        #   if [ -e roms_qcorr.nc ]; then rm roms_qcorr.nc; fi
        #   ln -s $file roms_qcorr.nc
        #else
        #   echo; echo " ... didnt find ROMS QCORR file $file, exiting forecast cycle"
        #   echo; exit
        #fi

        if [ -e $romsfrc ]; then
           echo; echo " ... accessing ROMS force file $romsfrc"; echo
           if [ -e roms_frc.nc ]; then rm roms_frc.nc; fi
           ln -s $romsfrc roms_frc.nc
        else
           echo; echo " ... didnt find ROMS force file $romsfrc, exiting forecast cycle"
           echo; exit
        fi

        ### floats
        if [ "$floats" == "yes" ]; then
             echo " ... will use floats"
             if [ -e $romsflt ]; then
                   echo; echo " ... accessing ROMS floats file $romsflt"; echo
                   if [ -e floats.in ]; then rm floats.in; fi
                   ln -s $romsflt floats.in
              else
                   echo; echo " ... didnt find ROMS floats file $romsflt, exiting forecast cycle"
                   echo; exit
              fi
        fi

        ### station
        if [ "$stations" == "yes" ]; then
             echo " ... will use stations"
             if [ -e $romsstn ]; then
                   echo; echo " ... accessing ROMS stations file $romsstn"; echo
                   if [ -e stations.in ]; then rm stations.in; fi
                   ln -s $romsstn stations.in
              else
                   echo; echo " ... didnt find ROMS stations file $romsstn, exiting forecast cycle"
                   echo; exit
              fi
        fi




	echo
	echo " +++ End of step 05 s.r. 01 +++"
	echo

#
#  the end
#

