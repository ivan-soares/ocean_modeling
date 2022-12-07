########################################################################################

#    write vars on clm & bry files
#
#                                                          by IDS @ TOC, Ctba 2018

############################ *** importing libraries *** ###############################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy as np
import time as tempo
#import netCDF4 as nc
#import subprocess as sp

from my_tools    import *
from datetime    import date
from netCDF4     import Dataset
from romstools   import *
from io_tools_v1 import *

#######################################################################################

print(' ')
print(' +++ PYTHON program to write vars on clim files +++')
print(' ')

# define OBJECT
class Object:
      def __init__(self):
            pass

MASK = Object
OGCM = Object
PARAMS = Object
LONLAT = Object

ndat  = int(sys.argv[1]) 
today = str(sys.argv[2])
ogcm  = str(sys.argv[3])

yr = int(today[0:4])
mm = int(today[4:6])
dd = int(today[6:8])

borders = ['T', 'T', 'T', 'T']
dqdsst = -100


###################### *** ROMS file names *** #########################################

inpfile = str(sys.argv[12])
grdfile = str(sys.argv[13])
clmfile = str(sys.argv[14])
bryfile = str(sys.argv[15])

INP = Dataset(inpfile, 'r')
GRD = Dataset(grdfile, 'r')
CLM = Dataset(clmfile, 'r+')
BRY = Dataset(bryfile, 'r+')

################## *** get sigma params & grid params *** #############################

PARAMS.spheri =   int(sys.argv[4])
PARAMS.vtrans =   int(sys.argv[5])
PARAMS.vstret =   int(sys.argv[6])
PARAMS.thetas = float(sys.argv[7])
PARAMS.thetab = float(sys.argv[8])
PARAMS.tcline =   int(sys.argv[9])
PARAMS.hc     =   int(sys.argv[10])
PARAMS.ns     =   int(sys.argv[11])

nsig = PARAMS.ns

kgrid = 0; [z,PARAMS.sr,PARAMS.cr] = scoord(grdfile, PARAMS, kgrid, 1, 1, 0, 0)
kgrid = 1; [z,PARAMS.sw,PARAMS.cw] = scoord(grdfile, PARAMS, kgrid, 1, 1, 0, 0)

LONLAT = read_roms_grid_vars(grdfile, PARAMS)
MASK = read_roms_masks(grdfile)

h = GRD.variables['h'][:]; ny, nx = h.shape
S = get_sigma_level_depths(h, PARAMS); zw = S.z_w[0]; del S

print(' ... grid size is ' + str(nx) + ' x ' + str(ny))

write_grd_params(clmfile, PARAMS)
write_grd_params(bryfile, PARAMS)

write_clm_lonlat(clmfile, LONLAT)
write_bry_lonlat(bryfile, LONLAT)

CLM.variables['h'] [:] = h
BRY.variables['h'] [:] = h

###################### *** set var names *** ##########################################

if ogcm.lower() in ['glbv','glbu','glby']:
    etaname = 'surf_el'
    temname = 'water_temp'
    salname = 'salinity'
    u3dname = 'water_u'
    v3dname = 'water_v'
elif ogcm.lower() in ['nemo']:
    etaname = 'zos'
    temname = 'thetao'
    salname = 'so'
    u3dname = 'uo'
    v3dname = 'vo'
else:
    print(' ')
    print(' ... wrong domain name ')
    print(' ')

################# *** staggered grid U/V *** ##########################################

u2s = np.zeros([ny,nx-1])
v2s = np.zeros([ny-1,nx])
u3s = np.zeros([nsig,ny,nx-1])
v3s = np.zeros([nsig,ny-1,nx])

########## *** do it: read from clim, write on roms *** ###############################

ndays = (date(yr,mm,dd)-date(2000,1,1)).days
time0 = ndays * 24. * 3600.

time1 = INP.variables['time'][0]



for n in range(ndat):

    inptime = INP.variables['time'][n]
    outtime = (inptime - time1)*3600 + time0
    print(' ... reading time ' + str(inptime))

    eta = INP.variables[etaname] [n, :, :]
    tem = INP.variables[temname] [n, :, :, :]
    sal = INP.variables[salname] [n, :, :, :]
    u3d = INP.variables[u3dname] [n, :, :, :]
    v3d = INP.variables[v3dname] [n, :, :, :]

    # just in cases ...
    eta[np.where(eta < -9.)] = 0.00e+00
    tem[np.where(tem < -9.)] = 0.00e+00
    sal[np.where(sal < -9.)] = 0.00e+00
    u3d[np.where(u3d < -9.)] = 0.00e+00
    v3d[np.where(v3d < -9.)] = 0.00e+00

    eta = eta * MASK.mask_r

    ######### all variables are in the same grid
    ######### need to interpolate U and V before writting to output file

    for k in range(nsig):
        tem[k, :, :] = tem[k, :, :] * MASK.mask_r
        sal[k, :, :] = sal[k, :, :] * MASK.mask_r
        u3d[k, :, :] = u3d[k, :, :] * MASK.mask_r
        v3d[k, :, :] = v3d[k, :, :] * MASK.mask_r

    u2d = np.zeros(MASK.mask_r.shape)
    v2d = np.zeros(MASK.mask_r.shape)

    ### if zw is negative do zw[k] - zw[k+1]
    ### if zw is positive do zw[k+1] - zw[k]

    for k in range(nsig):
        u2d = u2d + (zw[k,:,:] - zw[k+1,:,:])/h[:,:] * np.squeeze(u3d[k, :, :])
        v2d = v2d + (zw[k,:,:] - zw[k+1,:,:])/h[:,:] * np.squeeze(v3d[k, :, :])

    #### interpolate U and V now

    u2s = 0.5 * (u2d[:,0:nx-1] + u2d[:,1:nx]) * MASK.mask_u
    v2s = 0.5 * (v2d[0:ny-1,:] + v2d[1:ny,:]) * MASK.mask_v

    for k in range(nsig):
        u3s[k,:,:] = 0.5 * (u3d[k,:,0:nx-1] + u3d[k,:,1:nx]) * MASK.mask_u
        v3s[k,:,:] = 0.5 * (v3d[k,0:ny-1,:] + v3d[k,1:ny,:]) * MASK.mask_v

    ### write out

    OGCM.zeta = eta
    OGCM.ubar = u2s
    OGCM.vbar = v2s
    OGCM.temp = tem
    OGCM.salt = sal
    OGCM.uvel = u3s
    OGCM.vvel = v3s

    OGCM.nlat_r, OGCM.nlon_r = np.shape(eta)
    OGCM.nlat_u, OGCM.nlon_u = np.shape(u2s)
    OGCM.nlat_v, OGCM.nlon_v = np.shape(v2s)
    OGCM.ns = nsig
    
    write_clm_vars(clmfile, OGCM, n, outtime, 1)
    write_bry_vars(bryfile, OGCM, n, outtime, borders, 1)
    write_sst_vars(clmfile, OGCM, n, outtime, dqdsst, 1)

    print(' ... writting time = ' + str(outtime))

    print(' '); print('               %%%%%%%%%%%%%%%%%%%%%%%%'); print(' ')


GRD.close()
CLM.close()
BRY.close()
INP.close()

print(' '); print(' +++ END OF PROCESSING +++ '); print(' ')

################## *** the end *** ####################################################

