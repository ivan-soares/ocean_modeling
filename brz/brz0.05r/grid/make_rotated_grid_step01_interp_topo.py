################################################################################

#   program make_rotated_grid.py : 

#    makes a regular lon/lat grid rotated at an angle of 'ang'
#
#                          by IDS @ ADAC/Atlantech, Floripa 2020

##################### *** importing libraries *** ###############################

import os, gc, sys
sys.path.append('/home/ivans/scripts/python/')

import numpy as np
from netCDF4 import Dataset
from math import sin, cos
from scipy.interpolate import interp1d, interp2d, griddata

########################################################################################

print(' ')
print(' +++ MAKE GRID STEP 01: PYTHON program to interpolate ETOPO to ROMS grid  +++')
print(' ')

########################################################################################

file1 = str(sys.argv[1])
grid = Dataset(file1,'r+')

file2 = str(sys.argv[2])
etopo = Dataset(file2,'r')


lon1 = float(sys.argv[3]) # -56.25
lon2 = float(sys.argv[4])
lat1 = float(sys.argv[5]) # -34.25
lat2 = float(sys.argv[6])
dlon = float(sys.argv[7]) 
dlat = float(sys.argv[8]) 
ang = float(sys.argv[9])

lon_range = abs(lon2-lon1)
lat_range = abs(lat2-lat1)

lon = np.arange(0.,lon_range,dlon); nlon = len(lon)
lat = np.arange(0.,lat_range,dlat); nlat = len(lat)

print (' ... nlon is ' + str(nlon))
print (' ... nlat is ' + str(nlat))
print(' ')

LON, LAT = np.meshgrid(lon, lat)
del lon, lat

ang = ang*np.pi/180.
lon = +LON*cos(ang) + LAT*sin(ang)  +  lon1
lat = -LON*sin(ang) + LAT*cos(ang)  +  lat1

################### *** INTERP ETOPO *** ########################################

elon = etopo.variables['lon'][:]
elat = etopo.variables['lat'][:]
eprf = etopo.variables['z'][:]
etopo.close()

elon, elat = np.meshgrid(elon,elat)

prf = griddata(np.column_stack((elon.ravel(), elat.ravel())), eprf.ravel(), 
      (lon.ravel(), lat.ravel()), method='linear').reshape(nlat, nlon)

################## *** make grid masks *** ######################################

prf = -prf
prf[np.where(prf <= 0.)] = 0.01 

# always keep <= 0. since thre was one grid point where prf = 0.0

msk = np.ones([nlat, nlon])
msk[np.where(prf < 0.1)] = 0


################### *** staggered grid vars *** #################################

lon_psi = 0.25 * (lon[0:nlat-1,0:nlon-1] + lon[0:nlat-1,1:nlon+0] + \
                  lon[1:nlat+0,0:nlon-1] + lon[1:nlat+0,1:nlon+0])

lat_psi = 0.25 * (lat[0:nlat-1,0:nlon-1] + lat[0:nlat-1,1:nlon+0] + \
                  lat[1:nlat+0,0:nlon-1] + lat[1:nlat+0,1:nlon+0])

lon_u = 0.5 * (lon[:,0:nlon-1] + lon[:,1:nlon])
lat_u = 0.5 * (lat[:,0:nlon-1] + lat[:,1:nlon])

lon_v = 0.5 * (lon[0:nlat-1,:] + lon[1:nlat,:])
lat_v = 0.5 * (lat[0:nlat-1,:] + lat[1:nlat,:])


msk_psi = msk[0:nlat-1,0:nlon-1] * msk[0:nlat-1,1:nlon+0] * \
          msk[1:nlat+0,0:nlon-1] * msk[1:nlat+0,1:nlon+0]

msk_u = msk[:,0:nlon-1] * msk[:,1:nlon]
msk_v = msk[0:nlat-1,:] * msk[1:nlat,:]

prf_psi = 0.25 * (prf[0:nlat-1,0:nlon-1] + prf[0:nlat-1,1:nlon+0] + \
                  prf[1:nlat+0,0:nlon-1] + prf[1:nlat+0,1:nlon+0]) * msk_psi \
                  + 0.01

prf_u = 0.5 * (prf[:,0:nlon-1] + prf[:,1:nlon]) * msk_u + 0.01
prf_v = 0.5 * (prf[0:nlat-1,:] + prf[1:nlat,:]) * msk_v + 0.01


################### *** write out vars *** ######################################

grid.variables['h'] [:] = prf [:]
grid.variables['hraw'] [0,:,:] = prf [:]

grid.variables['mask_rho'] [:] = msk [:]
grid.variables['lon_rho'] [:] = lon [:]
grid.variables['lat_rho'] [:] = lat [:]
grid.variables['h_rho'] [:] = prf [:]

grid.variables['mask_u'] [:] = msk_u [:]
grid.variables['lon_u'] [:] = lon_u [:]
grid.variables['lat_u'] [:] = lat_u [:]
grid.variables['h_u'] [:] = prf_u [:]

grid.variables['mask_v'] [:] = msk_v [:]
grid.variables['lon_v'] [:] = lon_v [:]
grid.variables['lat_v'] [:] = lon_v [:]
grid.variables['h_v'] [:] = prf_v [:]

grid.variables['mask_psi'] [:] = msk_psi [:]
grid.variables['lon_psi'] [:] = lon_psi [:]
grid.variables['lat_psi'] [:] = lat_psi [:]
grid.variables['h_psi'] [:] = prf_psi [:]

grid.close()

print(' ')
print(' +++ END of STEP 01 +++')
print(' ')

#################### *** the end *** #############################################
