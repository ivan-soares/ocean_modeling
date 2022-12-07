########################################################################################

#    inpaint nans on OGCM data
#
#                                                          by IDS @ TOC, Ctba 2018

################ *** importing libraries *** ###########################################


import os, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy   as np

from math import cos, sin

from netCDF4  import Dataset
from my_tools import inpaint_nans
from datetime import date

#from inpaint_nans3  import inpaint_nans

##################### *** introdu *** ##################################################

print(' ')
print(' +++ Python program to inpaint nans on donor OGCM +++')
print(' ')

today = str(sys.argv[1])
ogcm = str(sys.argv[2])
ang = float(sys.argv[3])

ntimes = int(sys.argv[4])
ndeps = int(sys.argv[5])
dh = float(sys.argv[6])

yr = today[0:4]
mm = today[4:6]
dd = today[6:8]

sdate = yr + '/' + mm + '/' + dd

print(' '); 
print(' ... ogcm is ' + ogcm)
print(' ... ntimes is ' + str(ntimes))
print(' ... storage interval is ' + str(dh))
print(' ... start date is ' +  sdate)
print(' ')

######################### *** files names *** ##########################################

file1 = str(sys.argv[7])
file2 = str(sys.argv[8])

grdfile = Dataset(file1 ,'r')
inpfile = Dataset(file2 + '.nc','r')
outfile = Dataset(file2 + '_nonans.nc','r+')

ogcm_nan = getattr(inpfile.variables['surf_el'], 'missing_value')

print(' ')
print(' ... ogcm NaN is ' + str(ogcm_nan))
print(' ')

######################### *** land mask *** ##########################################

msk = grdfile.variables['mask_rho'] [:]

######################### *** SSH, T, S *** ##########################################


initime = (date(2020,1,1) - date(2000,1,1)).days*24*3600

lon = inpfile.variables['lon'] [:]; nlon = lon.shape[1]
lat = inpfile.variables['lat'] [:]; nlat = lat.shape[0]

temp = np.zeros([ndeps,nlat,nlon])
saln = np.zeros([ndeps,nlat,nlon])
uvel = np.zeros([ndeps,nlat,nlon])
vvel = np.zeros([ndeps,nlat,nlon])

for nt in range(ntimes):

    time = initime + float(nt)*dh*3600.

    ssh = inpfile.variables['surf_el']    [nt,:,:]
    tpt = inpfile.variables['water_temp'] [nt,:,:,:]
    sal = inpfile.variables['salinity']   [nt,:,:,:]
    u3d = inpfile.variables['water_u']    [nt,:,:,:]
    v3d = inpfile.variables['water_v']    [nt,:,:,:]

    ssh[np.where(ssh.mask == True)] = np.nan
    tpt[np.where(tpt.mask == True)] = np.nan
    sal[np.where(sal.mask == True)] = np.nan
    u3d[np.where(u3d.mask == True)] = np.nan
    v3d[np.where(v3d.mask == True)] = np.nan

    ssh = inpaint_nans(ssh) * msk[:,:]

    for k in range(ndeps):
        temp[k,:,:] = inpaint_nans(tpt[k,:,:]) * msk[:,:]
        saln[k,:,:] = inpaint_nans(sal[k,:,:]) * msk[:,:]

    for k in range(ndeps):
        u = inpaint_nans(u3d[k,:,:]) * msk[:,:]
        v = inpaint_nans(v3d[k,:,:]) * msk[:,:]
        uvel[k,:,:] = +u*cos(ang) + v*sin(ang)
        vvel[k,:,:] = -u*sin(ang) + v*cos(ang) 

    outfile.variables['water_u'][nt,:,:,:] = uvel
    outfile.variables['water_v'][nt,:,:,:] = vvel
    outfile.variables['water_temp'][nt,:,:,:] = temp
    outfile.variables['salinity'][nt,:,:,:] = saln
    outfile.variables['surf_el'][nt,:,:] = ssh

outfile.close()

print(' ')
print(' +++ END of Python program to inpaint nans on donor OGCM +++')
print(' ')

############################ the end ###############################################
