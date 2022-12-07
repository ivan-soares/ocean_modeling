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
print(' +++> STARTING python program to rewrite roms vars in a rotated coord system <+++ ')
print(' ')

start_time = tempo.time()

############################ *** file names *** ###################################################

inp = str(sys.argv[1])
out = str(sys.argv[2])

inpfile = Dataset(inp,'r')
outfile = Dataset(out,'r+')

######################### *** get var sizes *** ###################################################

nt, nz, nlat, nlon = inpfile.variables['temp'].shape

nt, nz, nlat_u, nlon_u = inpfile.variables['u'].shape
nt, nz, nlat_v, nlon_v = inpfile.variables['v'].shape

print(' ')
print(' ... n. times = ' + str(nt))
print(' ... n. depths = ' + str(nz))
print(' ... n. lats = ' + str(nlat))
print(' ... n. lons = ' + str(nlon))
print(' ')

################### *** read angle and rotate velocities *** ######################################

ang = -1.0 * inpfile.variables['angle'] [:]

u = inpfile.variables['u'] [:]
v = inpfile.variables['v'] [:]

ur = np.zeros((nt,nz,nlat,nlon))
vr = np.zeros((nt,nz,nlat,nlon))

for n in range(nt):
    for d in range(nz):
        tmp_u = 0.5 * (u[n,d,:,0:nlon_u-1] + u[n,d,:,1:nlon_u])
        tmp_v = 0.5 * (v[n,d,0:nlat_v-1,:] + v[n,d,1:nlat_v,:])
        col0 = np.zeros((tmp_u.shape[0],1))
        row0 = np.zeros((1,tmp_v.shape[1]))
        tmp_u = np.hstack((col0,tmp_u,col0))
        tmp_v = np.vstack([row0,tmp_v,row0])
        ur [n,d,:,:] = +tmp_u*np.cos(ang) + tmp_v*np.sin(ang)
        vr [n,d,:,:] = -tmp_u*np.sin(ang) + tmp_v*np.cos(ang)




outfile.variables['ocean_time'][:] = inpfile.variables['ocean_time'][:]

outfile.variables['lat_rho'][:]  = inpfile.variables['lon_rho'] [:]
outfile.variables['lon_rho'][:]  = inpfile.variables['lat_rho'] [:]
outfile.variables['mask_rho'][:] = inpfile.variables['mask_rho'] [:]
outfile.variables['s_rho'][:]    = inpfile.variables['s_rho'] [:]
outfile.variables['angle'][:]    = inpfile.variables['angle'] [:]
outfile.variables['h'][:]        = inpfile.variables['h'] [:]

outfile.variables['zeta'][:] = inpfile.variables['zeta'] [:]
outfile.variables['temp'][:] = inpfile.variables['temp'] [:]
outfile.variables['salt'][:] = inpfile.variables['salt'] [:]

outfile.variables['u'][:] = ur
outfile.variables['v'][:] = vr

inpfile.close()
outfile.close()

print(' ')
print(' +++> END of python program <+++ ')
print(' ')



#####################################################################################################



