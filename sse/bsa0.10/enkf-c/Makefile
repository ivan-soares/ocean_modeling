NP_CALC = 20 
NP_UPDATE = 20
MDATE = 20210101

export LD_LIBRARY_PATH=/home/ivans/Dropbox/apps/netcdf-c-4.8.0/lib/

enkf: clean enkf-prep enkf-calc enkf-update

enoi: clean enoi-prep enoi-calc enoi-update

stats: clean stats-prep stats-calc

singleob: clean singleob-calc singleob-update

pointlogs: pointlogs-calc pointlogs-update

global: clean enkf-prep enkf-calc-global enkf-update-global

hybrid: clean hybrid-prep hybrid-calc hybrid-update

enkf-prep: enkf_prep d-grids d-obs enkf.prm
	./enkf_prep enkf.prm 2>&1 | tee prep.out

enkf-calc: enkf_calc observations.nc d-grids d-ensemble/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc enkf.prm 2>&1 | tee calc.out

enkf-update: enkf_update transforms-0.nc transforms-1.nc transforms-2.nc d-grids d-ensemble/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --calculate-spread --write-inflation --calculate-vertical-correlations --output-increment enkf.prm 2>&1 | tee update.out

enoi-prep: enkf_prep d-grids d-obs enoi.prm
	./enkf_prep enoi.prm 2>&1 | tee prep.out

enoi-calc: enkf_calc observations.nc d-grids d-background/$(MDATE) d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc enoi.prm 2>&1 | tee calc.out

enoi-update: enkf_update transforms-0.nc transforms-1.nc transforms-2.nc d-grids d-background/$(MDATE) d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --calculate-spread  enoi.prm 2>&1 | tee update.out

stats-prep: enkf_prep d-grids d-obs stats.prm
	./enkf_prep stats.prm 2>&1 | tee prep.out

stats-calc: enkf_calc observations.nc d-grids d-background/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc --forecast-stats-only stats.prm 2>&1 | tee calc.out

singleob-calc: enkf_calc d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc --single-observation-ijk 35 55 0 SST 0.5 0.5 singleob.prm 2>&1 | tee calc.out

singleob-update: enkf_update d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --output-increment singleob.prm 2>&1 | tee update.out

pointlogs-calc: enkf_calc observations.nc d-grids d-ensemble/$(MDATE) transforms.nc
	cp enkf.prm pointlogs.prm
	echo "POINTLOG -49 -25" >> pointlogs.prm
	echo "POINTLOG -49 -27" >> pointlogs.prm
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc --point-logs-only pointlogs.prm 2>&1 | tee calc-pointlogs.out

pointlogs-update: enkf_update transforms-0.nc transforms-1.nc transforms-2.nc d-grids d-ensemble/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --no-fields-write pointlogs.prm 2>&1 | tee update-pointlogs.out

enkf-calc-global: enkf_calc observations.nc d-grids d-ensemble/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc enkf-global.prm 2>&1 | tee calc.out

enkf-update-global: enkf_update transforms-0.nc transforms-1.nc transforms-2.nc d-grids d-ensemble/$(MDATE)
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --calculate-spread --write-inflation --output-increment enkf-global.prm 2>&1 | tee update.out
	rm -f ensemble_$(MDATE)/mem*_*-???.nc

hybrid-prep: enkf_prep conf d-obs hybrid.prm
	./enkf_prep enkf.prm 2>&1 | tee prep.out

hybrid-calc: enkf_calc observations.nc d-grids d-ensemble/$(MDATE) d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_CALC) ./enkf_calc hybrid.prm 2>&1 | tee calc.out

hybrid-update: enkf_update transforms-0.nc transforms-1.nc transforms-2.nc d-grids d-ensemble/$(MDATE) d-ensemble/static
	nice -n +19 /home/ivans/apps/openmpi-4.1.1/bin/mpirun -np $(NP_UPDATE) ./enkf_update --calculate-spread --write-inflation --calculate-vertical-correlations --output-increment hybrid.prm 2>&1 | tee update.out

enkf_prep:
	cp d-code/bin/enkf_prep .

enkf_calc:
	cp d-code/bin/enkf_calc .

enkf_update:
	cp d-code/bin/enkf_update .

store_enoi:
	@mv transforms*.nc   d-outputs/$(MDATE)/.
	@mv enkf_diag*.nc    d-outputs/$(MDATE)/.
	@mv observations*.nc d-outputs/$(MDATE)/.
	@mv spread.nc        d-outputs/$(MDATE)/.
	@mv point*.nc        d-outputs/$(MDATE)/.
	@mv prep.out         d-outputs/$(MDATE)/.
	@mv calc.out         d-outputs/$(MDATE)/.
	@mv update.out       d-outputs/$(MDATE)/.


clean:
	@rm -f transforms*.nc w*.nc enkf_diag*.nc badbatches.txt observations*.nc *.out d-ensemble/$(MDATE)/*.analysis* d-ensemble/$(MDATE)/*.increment* d-background/$(MDATE)/*.analysis* d-background/$(MDATE)/*.increment* *.nc enkf_* pointlogs.prm
	@rm -rf .enkftmp

