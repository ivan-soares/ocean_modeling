############################ *** importing libraries *** ##########################################

#!/usr/bin/python

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy as np
import time as tempo

from netCDF4 import Dataset

############################ *** introdu *** ######################################################

print(' ')
print(' +++> STARTING python program to rewrite roms file <+++ ')
print(' ')

start_time = tempo.time()

############################ *** file names *** ###################################################

inp = str(sys.argv[1])
out = str(sys.argv[2])

inpfile = Dataset(inp,'r')
outfile = Dataset(out,'r+')

######################### *** get var sizes *** ###################################################

nt, nz, nlat, nlon = inpfile.variables['temp'].shape

print(' ')
print(' ... n. times = ' + str(nt))
print(' ... n. depths = ' + str(nz))
print(' ... n. lats = ' + str(nlat))
print(' ... n. lons = ' + str(nlon))
print(' ')

###################### *** read & write vars *** ##################################################



outfile.variables['time'][:] = inpfile.variables['ocean_time'][:]

outfile.variables['lat'][:]  = inpfile.variables['lon_rho'] [:]
outfile.variables['lon'][:]  = inpfile.variables['lat_rho'] [:]
outfile.variables['mask'][:] = inpfile.variables['mask_rho'] [:]
outfile.variables['angle'][:] = inpfile.variables['angle'] [:]
outfile.variables['h'][:]     = inpfile.variables['h'] [:]

outfile.variables['depth'][:] = inpfile.variables['depth'][0,:,0,0]

outfile.variables['zeta'][:] = inpfile.variables['zeta'] [:]
outfile.variables['temp'][:] = inpfile.variables['temp'] [:]
outfile.variables['salt'][:] = inpfile.variables['salt'] [:]

outfile.variables['u'][:] = inpfile.variables['u'] [:]
outfile.variables['v'][:] = inpfile.variables['v'] [:]

inpfile.close()
outfile.close()

print(' ')
print(' +++> END of python program <+++ ')
print(' ')



#####################################################################################################



