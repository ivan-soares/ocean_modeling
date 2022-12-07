#!/bin/bash
#

# limit maximum h to 2500


    ncap2 -O -s 'where(h>2500)     h=2500' \
             -s 'where(h_u>2500)   h_u=2500' \
             -s 'where(h_v>2500)   h_v=2500' \
             -s 'where(h_rho>2500) h_rho=2500' \
             -s 'where(h_psi>2500) h_psi=2500' \
             -s 'where(hraw>2500)  hraw=2500' \
             grid_bsa0.02_reg.nc  grid_bsa0.02_reg_2500.nc


### the end    
