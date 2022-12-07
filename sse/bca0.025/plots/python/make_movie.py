#!/usr/bin/env python
#
# python make an animation of snap shots
#

from plot_snap_shot import *
import sys

####################################################

inpfile='/home/ivans/roms_results/brz/brz0.04/2013-12/brz_avg.nc'

var = 'temp'
nyr = 2012
layer = 20
frame = 0

inpdir  = '/home/ivans/roms_results/brz/brz0.04/'
inpfile = inpdir + str(nyear) + '/' + str(2013) + '-' + str(mon) + '/brz_avg.nc'

if isinstance(inpfile, str):
   inp = Dataset(inpfile, 'r+')

snap_shot(inp,frame,layer,varname,nyear)


