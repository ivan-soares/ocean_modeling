#!/bin/bash

#  directory with bash scripts

   domain=$1
   version=$2

   grid="grid_${domain}_${version}.nc"

   type1='exp_medium'
   type2='newlin_11lines'

   nlon=`cdo -s --no_warnings griddes $grid  | grep xsize | head -1 | awk '{print $3}'`
   nlat=`cdo -s --no_warnings griddes $grid  | grep ysize | head -1 | awk '{print $3}'`
   nsig=30

#  create file   
   create_ncfile_nudge.sh $nlon $nlat $nsig
   mv nudge.nc nudge_${domain}_${version}_${type1}.nc

#  again for the other type
   create_ncfile_nudge.sh $nlon $nlat $nsig
   mv nudge.nc nudge_${domain}_${version}_${type2}.nc

