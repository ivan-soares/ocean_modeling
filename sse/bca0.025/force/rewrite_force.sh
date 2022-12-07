#!/bin/bash
#
	inpfile=$1
	outfile=$2

	varlist01="lon,lat,frc_time,Tair,Qair,Pair,rain,Uwind,Vwind,lwrad,swrad"

	ncks -v $varlist01 $inpfile $outfile


#  the end
