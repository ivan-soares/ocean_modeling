#!/bin/bash
#

    etopo="$HOME/data/etopo/ETOPO-GLOBAL+REMO_BR.nc"

    ncks -d lon,-57.,-20. -d lat,-47.,5.0 $etopo etopo_cut.nc



#   the end
