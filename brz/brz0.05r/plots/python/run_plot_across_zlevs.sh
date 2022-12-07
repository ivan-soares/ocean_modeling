#!/bin/bash
#

	echo
	echo " +++ Starting script to plot across shelf velocities +++"
	echo

	romsdir="/home/ivans/roms/cases/brz/brz0.05r/expts/d-storage/monmean"
	gridfile='grid_brz0.05r_01d.nc'

	for year in 2015 2016 2017 2018 2019; do

		romsfile="$romsdir/roms_monmean_brz0.05r_01d_${year}0101_rotated_zlevs.nc"

		for mon in 1 3 7 9 12; do

			echo; echo " ... doing year $year , month $mon"; echo

			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -11. -37.0 -33. -34.0 1500. -37.25 -3500.
			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -22. -41.5 -34. -39.5  500. -41.00 -3500. 
			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -24. -46.5 -36. -42.5  500. -46.00 -3500.
			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -26. -49.5 -37. -45.0  500. -49.00 -3500.
			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -28. -50.0 -39. -46.0  500. -50.00 -3500.
			python plot_roms_across_shelf_monmean_z_two-layers.py $romsfile $gridfile $mon $year -30. -51.0 -40. -46.0  500. -50.50 -3500.

		done
	done

	echo
	echo " ++= End of script +++"
	echo
