#!/bin/bash
# TUTORIAL 7: Differential Positioning with 
#             Code Measurements.
#==========================================

# Create the Working directory and copy Programs and Files
# into this directory.


mkdir ./WORK  2> /dev/null
mkdir ./WORK/TUT7
mkdir ./WORK/TUT7/FIG

cd ./WORK/TUT7


#PROGRAM FILES
#-------------
cp ../../PROG/TUT7/* .
if [[ $(uname -s) =~ "CYGWIN" ]]
then
  cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
fi


#DATA FILES
#----------
cp ../../FILES/TUT7/* .

gzip -df *.gz

#============================================================


 

# ==============================
# Session A: Atmospheric effects
# ==============================

# A.1 Differential positioning of EBRE-CREU receivers (Long baseline 288 km)
# ==========================================================================

# A.1.1. computing model components:
# -------------------------------

./ObsFile1.scr CREU0770.10o brdc0770.10n
./ObsFile1.scr EBRE0770.10o brdc0770.10n

# ------------------- obs.dat -------------------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13   14
# [sta sat DoY sec C1 L1 P2 L2 rho Trop Ion elev azim prefit]
# -----------------------------------------------------------



# A.1.2.- Absolute positioning
# ------------------------

# EBRE receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of EBRE receiver:

cat EBRE.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > EBRE.mod

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat EBRE.mod | ./kalman > EBRE.pos

# 3. Plot the results:

./graph.py -f EBRE.pos -x1 -y2 -s.-  -l "North error"  -f EBRE.pos -x1 -y3 -s.-  -l "East error"  -f EBRE.pos -x1 -y4 -s.-  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8  -t "EBRE: Standard Point Positioning" --sv FIG/Tu3_exA1.2a.png


# CREU receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of CREU receiver:

cat CREU.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > CREU.mod

# 2. Computing the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat CREU.mod | ./kalman > CREU.pos

# 3. Plot the results:

./graph.py -f CREU.pos -x1 -y2 -s.-  -l "North error"  -f CREU.pos -x1 -y3 -s.-  -l "East error"  -f CREU.pos -x1 -y4 -s.-  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8  -t "CREU: Standard Point Positioning" --sv FIG/Tu3_exA1.2b.png



# A.1.3.- Differential positioning EBRE-CREU
# ------------------------------------------

# A.1.3.1.- Differential positioning EBRE-CREU: FULL MODELLING.
# ---------

# 1.- Compute the single differences of measurements:

./Dobs.scr EBRE.obs CREU.obs

# OUTPUT file
# ------------------- D_EBRE_CREU.obs  ---------------------------------
#    1   2   3   4   5   6   7   8   9    10     11   12   13     14    
# [sta2 sat DoY sec DC1 DL1 DP2 DL2 DRho DTrop DIon elev2 azim2 DPrefit]
# ----------------------------------------------------------------------


# 2.- Build the Navigation Equations system for differential positioning of CREU (user)
#     relative to EBRE (reference station):

cat D_EBRE_CREU.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_EBRE_CREU.mod


# 3. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posK
./graph.py -f EBRE_CREU.posK -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posK -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "CREU-EBRE: 288 km. Differential Positioning" --sv FIG/Tu3_exA1.3.1a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posS
./graph.py -f EBRE_CREU.posS -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posS -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "CREU-EBRE: 288 km. Differential Positioning" --sv FIG/Tu3_exA1.3.1b.png



# A.1.3.2.- Differential positioning EBRE-CREU: No IONOSPHERIC corrections.
# ---------

# Plot the Klobuchar differential ionospheric correction:

./graph.py -f D_EBRE_CREU.obs -x4 -y'11' --yn -0.8 --yx 0.8 -t "CREU-EBRE: 288 km: Nominal diff Iono (Klob)" --xl "time (s)" --yl "metres" --sv FIG/Tu3_exA1.3.2.png


# 1.- Build the Navigation Equations system for differential positioning of CREU (user)
#     relative to EBRE (reference station), but WITHOUT IONOSPHERIC CORRECTIONS:

cat D_EBRE_CREU.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_EBRE_CREU.mod


# 2. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posK
./graph.py -f EBRE_CREU.posK -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posK -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "CREU-EBRE: 288 km: No IONO corrections" --sv FIG/Tu3_exA1.3.2a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posS
./graph.py -f EBRE_CREU.posS -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posS -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "CREU-EBRE: 288 km: No IONO corrections" --sv FIG/Tu3_exA1.3.2b.png



# A.1.3.3.- Differential positioning EBRE-CREU: No TROPOSPHERIC corrections.
# ---------

# Plot the differential Nominal Tropospheric correction:

./graph.py -f D_EBRE_CREU.obs -x4 -y'10' --yn -8 --yx 8  -t "CREU-EBRE: 288 km: Nominal diff Tropo" --xl "time (s)" --yl "metres" --sv FIG/Tu3_exA1.3.3.png


# 1.- Build the Navigation Equations system for differential positioning of CREU (user)
#     relative to EBRE (reference station), but WITHOUT TROPOSPHERIC CORRECTIONS:

cat D_EBRE_CREU.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_EBRE_CREU.mod


# 2. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posK
./graph.py -f EBRE_CREU.posK -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posK -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "CREU-EBRE: 288 km: No TROPO corrections" --sv FIG/Tu3_exA1.3.3a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_EBRE_CREU.mod | ./kalman > EBRE_CREU.posS
./graph.py -f EBRE_CREU.posS -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posS -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "CREU-EBRE: 288 km: No TROPO corrections" --sv FIG/Tu3_exA1.3.3b.png


 
# A.2 Differential positioning of GARR-MATA receivers (Short baseline 51km)
# =========================================================================

# A.2.1. computing model components:
# -------------------------------

./ObsFile1.scr MATA0770.10o brdc0770.10n
./ObsFile1.scr GARR0770.10o brdc0770.10n

# ------------------- obs.dat -------------------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13   14
# [sta sat DoY sec C1 L1 P2 L2 rho Trop Ion elev azim prefit]
# -----------------------------------------------------------



# A.2.2.- Absolute positioning
# ------------------------

# GARR receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of GARR receiver:

cat GARR.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > GARR.mod

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat GARR.mod | ./kalman > GARR.pos

# 3. Plot the results:

./graph.py -f GARR.pos -x1 -y2 -s.-  -l "North error"  -f GARR.pos -x1 -y3 -s.-  -l "East error"  -f GARR.pos -x1 -y4 -s.-  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8  -t "GARR: Standard Point Positioning" --sv FIG/Tu3_exA2.2a.png


# MATA receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of MATA receiver:

cat MATA.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > MATA.mod

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat MATA.mod | ./kalman > MATA.pos

# 3. Plot the results:

./graph.py -f MATA.pos -x1 -y2 -s.-  -l "North error"  -f MATA.pos -x1 -y3 -s.-  -l "East error"  -f MATA.pos -x1 -y4 -s.-  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8  -t "MATA: Standard Point Positioning" --sv FIG/Tu3_exA2.2b.png



# A.2.3.- Differential positioning GARR-MATA
# ------------------------------------------

# A.2.3.1.- Differential positioning GARR-MATA: FULL MODELLING.
# ---------

# 1.- Compute the single differences of measurements:

./Dobs.scr GARR.obs MATA.obs

# OUTPUT file
# ------------------- D_GARR_MATA.obs  ---------------------------------
#    1   2   3   4   5   6   7   8   9    10     11   12   13     14    
# [sta2 sat DoY sec DC1 DL1 DP2 DL2 DRho DTrop DIon elev2 azim2 DPrefit]
# ----------------------------------------------------------------------


# 2.- Build the Navigation Equations system for differential positioning of MATA (user)
#     relative to GARR (reference station):

cat D_GARR_MATA.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_GARR_MATA.mod


# 3. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posK
./graph.py -f GARR_MATA.posK -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posK -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "MATA-GARR: 51 km. Differential Positioning" --sv FIG/Tu3_exA2.3.1a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posS
./graph.py -f GARR_MATA.posS -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posS -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "MATA-GARR: 51 km. Differential Positioning" --sv FIG/Tu3_exA2.3.1b.png



# A.2.3.2.- Differential positioning GARR-MATA: No IONOSPHERIC corrections.
# ---------

# Plot the Klobuchar differential ionospheric correction:

./graph.py -f D_GARR_MATA.obs -x4 -y'11' --yn -0.8 --yx 0.8 -t "GARR-MATA: 51 km: Nominal diff Iono (Klob)" --xl "time (s)" --yl "metres" --sv FIG/Tu3_exA2.3.2.png


# 1.- Build the Navigation Equations system for differential positioning of MATA (user)
#     relative to GARR (reference station), but WITHOUT IONOSPHERIC CORRECTIONS:

cat D_GARR_MATA.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_GARR_MATA.mod


# 2. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posK
./graph.py -f GARR_MATA.posK -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posK -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "MATA-GARR: 51 km: No IONO corrections" --sv FIG/Tu3_exA2.3.2a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posS
./graph.py -f GARR_MATA.posS -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posS -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "MATA-GARR: 51 km: No IONO corrections" --sv FIG/Tu3_exA2.3.2b.png



# A.2.3.3.- Differential positioning GARR-MATA: No TROPOSPHERIC corrections.
# ---------

# Plot the differential Nominal Tropospheric correction:

./graph.py -f D_GARR_MATA.obs -x4 -y'10' --yn -8 --yx 8  -t "GARR-MATA: 51 km: Nominal diff Tropo" --xl "time (s)" --yl "metres" --sv FIG/Tu3_exA2.3.3.png


# 1.- Build the Navigation Equations system for differential positioning of MATA (user)
#     relative to GARR (reference station), but WITHOUT TROPOSPHERIC CORRECTIONS:

cat D_GARR_MATA.obs | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_GARR_MATA.mod


# 2. Compute the user solution:

# In kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posK
./graph.py -f GARR_MATA.posK -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posK -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posK -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -8 --yx 8 -t "MATA-GARR: 51 km: No TROPO corrections" --sv FIG/Tu3_exA2.3.3a.png


# In static mode (i.e. coordinates as constants):

cp kalman.nml_ctt kalman.nml
cat D_GARR_MATA.mod | ./kalman > GARR_MATA.posS
./graph.py -f GARR_MATA.posS -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posS -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posS -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)"  --yn -1.5 --yx 2   -t "MATA-GARR: 51 km: No TROPO corrections" --sv FIG/Tu3_exA2.3.3b.png





# ====================================
# Session B: Differential Orbit Errors
# ====================================

# B.1 Orbit error: Differential positioning of EBRE-CREU receivers (Long baseline 288km)
# ======================================================================================


# Using the UNIX command "diff" compare the broadcast files: CREU0770.10o 
# brdc0770.10nERR.
# Execute:
#     diff brdc0770.10n brdc0770.10nERR


# B.1.1 Repeat the computation of the absolute positioning of receivers EBRE and CREU,
#       but using the corrupted ephemeris file:  brdc0770.10nERR
# -------------------------------

# * Compute the model components for EBRE and CREU receivers:
# -----------

./ObsFile1.scr EBRE0770.10o brdc0770.10nERR
mv EBRE.obs EBRE.obsERR

./ObsFile1.scr CREU0770.10o brdc0770.10nERR
mv CREU.obs CREU.obsERR

# ------------------- obs.dat --------------------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13   14
# [sta sat DoY sec C1 L1 P2 L2 rho Trop Ion elev azim prefit]
# ------------------------------------------------------------



# * Compute the Absolute positioning of EBRE and CREU receivers:
# ----------

# EBRE receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of EBRE receiver:

cat EBRE.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > EBRE.modERR

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat EBRE.modERR | ./kalman > EBRE.posERR

# 3. Plot the results:

./graph.py -f EBRE.posERR -x1 -y2 -s.- -l "North error"  -f EBRE.posERR -x1 -y3 -s.- -l "East error"  -f EBRE.posERR -x1 -y4 -s.- -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -300 --yx 300  -t "EBRE: SPP. 2000m Along-Track Orbit error" --sv FIG/Tu3_exB1.1a.png


# CREU receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of CREU receiver:

cat CREU.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > CREU.modERR

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat CREU.modERR | ./kalman > CREU.posERR

# 3. Plot the results:

./graph.py -f CREU.posERR -x1 -y2 -s.- -l "North error"  -f CREU.posERR -x1 -y3 -s.- -l "East error"  -f CREU.posERR -x1 -y4 -s.- -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -300 --yx 300  -t "CREU: SPP. Along-Track orbit error" --sv FIG/Tu3_exB1.1b.png




# B.1.2.- Differential positioning EBRE-CREU: Orbit error 
# -------------------------------------------------------

# 1.- Compute the single differences of measurements:

./Dobs.scr EBRE.obsERR CREU.obsERR
mv D_EBRE_CREU.obs D_EBRE_CREU.obsERR

# OUTPUT file
# ------------------- D_EBRE_CREU.obs  ---------------------------------
#    1   2   3   4   5   6   7   8   9    10     11   12   13     14    
# [sta2 sat DoY sec DC1 DL1 DP2 DL2 DRho DTrop DIon elev2 azim2 DPrefit]
# ----------------------------------------------------------------------


# 2.- Build the Navigation Equations system for differential positioning of CREU (user)
#     relative to EBRE (reference station):

cat D_EBRE_CREU.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_EBRE_CREU.modERR


# 3. Compute the user solution in kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_EBRE_CREU.modERR | ./kalman > EBRE_CREU.posKERR
./graph.py -f EBRE_CREU.posKERR -x1 -y2 -s.  -l "North error"  -f EBRE_CREU.posKERR -x1 -y3 -s.  -l "East error"  -f EBRE_CREU.posKERR -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -15 --yx 15 -t "CREU-EBRE: 288 km: SPP. 2000m Along-Track orbit error" --sv FIG/Tu3_exB1.2.png



# B.2 Orbit error: Differential positioning of GARR-MATA receivers (Short baseline 51km)
# ======================================================================================


# B.2.1 Repeat the computation of the absolute positioning of receivers GARR and MATA,
#       but using the corrupted ephemeris file:  brdc0770.10nERR
# -------------------------------

# * Compute the model components for GARR and MATA receivers:
# -----------

./ObsFile1.scr GARR0770.10o brdc0770.10nERR
mv GARR.obs GARR.obsERR

./ObsFile1.scr MATA0770.10o brdc0770.10nERR
mv MATA.obs MATA.obsERR

# ------------------- obs.dat -------------------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13   14
# [sta sat DoY sec C1 L1 P2 L2 rho Trop Ion elev azim prefit]
# -----------------------------------------------------------



# * Compute the Absolute positioning of GARR and MATA receivers:
# ----------

# GARR receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of GARR receiver:

cat GARR.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > GARR.modERR

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat GARR.modERR | ./kalman > GARR.posERR

# 3. Plot the results:

./graph.py -f GARR.posERR -x1 -y2 -s.- -l "North error"  -f GARR.posERR -x1 -y3 -s.- -l "East error"  -f GARR.posERR -x1 -y4 -s.- -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -300 --yx 300  -t "GARR: SPP. 2000m Along-Track Orbit error" --sv FIG/Tu3_exB2.1a.png


# MATA receiver:
# --------------
# 1. Build the Navigation equations system for absolute positioning of MATA receiver:

cat MATA.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$14,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > MATA.modERR

# 2. Compute the user solution for absolute positioning:

cp kalman.nml_wn kalman.nml
cat MATA.modERR | ./kalman > MATA.posERR

# 3. Plot the results:

./graph.py -f MATA.posERR -x1 -y2 -s.- -l "North error"  -f MATA.posERR -x1 -y3 -s.- -l "East error"  -f MATA.posERR -x1 -y4 -s.- -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -300 --yx 300  -t "MATA: SPP. Along-Track orbit error" --sv FIG/Tu3_exB2.1b.png



# B.2.2.- Differential positioning GARR-MATA: Orbit error 
# -------------------------------------------------------

# 1.- Compute the single differences of measurements:

./Dobs.scr GARR.obsERR MATA.obsERR
mv D_GARR_MATA.obs D_GARR_MATA.obsERR

# OUTPUT file
# ------------------- D_GARR_MATA.obs  ---------------------------------
#    1   2   3   4   5   6   7   8   9    10     11   12   13     14    
# [sta2 sat DoY sec DC1 DL1 DP2 DL2 DRho DTrop DIon elev2 azim2 DPrefit]
# ----------------------------------------------------------------------


# 2.- Build the Navigation Equations system for differential positioning of MATA (user)
#     relative to GARR (reference station):

cat D_GARR_MATA.obsERR | gawk 'BEGIN{g2r=atan2(1,1)/45}{e=$12*g2r;a=$13*g2r;printf "%8.2f %8.4f %8.4f %8.4f %8.4f %1i \n",$4,$5-$9-$10-$11,-cos(e)*sin(a),-cos(e)*cos(a),-sin(e),1}' > D_GARR_MATA.modERR


# 3. Compute the user solution in kinematic mode (i.e. coordinates as White Noise):

cp kalman.nml_wn kalman.nml
cat D_GARR_MATA.modERR | ./kalman > GARR_MATA.posKERR
./graph.py -f GARR_MATA.posKERR -x1 -y2 -s.  -l "North error"  -f GARR_MATA.posKERR -x1 -y3 -s.  -l "East error"  -f GARR_MATA.posKERR -x1 -y4 -s.  -l "UP error"  --xl "time (s)" --yl "error (m)" --yn -15 --yx 15 -t "MATA-GARR: 51 km: SPP. 2000m Along-Track orbit error" --sv FIG/Tu3_exB2.2.png




# B.3 Range Domain Orbit error
# ============================

# Analyse the orbit error of PRN17 in the Range Domain:


# B.3.1 Absolute Error computation for satellite PRN17:
# -----------------------------------------------------

# - Compute the discrepancy between the satellite coordinates predicted from 
#   brdc0770.10n and brdc0770.10nERR files:

./gLAB_linux -input:nav brdc0770.10n -input:nav brdc0770.10nERR -pre:dec 30 |grep SATDIFF > dif.sel


# - Plot the results:

./graph.py -f dif.sel -x4 -y11 -so -c '($6==17)' --cl y -l "Rad" -f dif.sel -x4 -y12 -s. -c '($6==17)' --cl r -l "Alon" -f dif.sel -x4 -y13 -s. -c '($6==17)' --cl g -l "Cross" --xn 55000  --xl "GPS seconds of day" --yl "metres" -t "PRN17: Orbit error" --sv FIG/Tu3_exB3.1.png



# B.3.2 Absolute RANGE Error computation for satellite PRN17:
# ----------------------------------------------------------

# EBRE=[4833520.1197 41537.2015 4147461.6263]
# ----

# 1. Using the original orbits brdc0770.10n, compute the geometric range between EBRE
#    and the satellite PRN17:

#    1.1 Compute the satellite coordinates with the original orbits:

./gLAB_linux -input:nav brdc0770.10n -pre:dec 30 | grep SATPVT | gawk '{if ($6==17) print $4,$7,$8,$9}'  > xyz.brdc

#    1.2 Using the coordinates of EBRE receiver (EBRE=[4833520.1197 41537.2015 
#        4147461.6263]), compute the geometric range between EBRE and the satellite 
#        PRN17:

cat xyz.brdc | gawk 'BEGIN{x0=4833520.1197;y0=41537.2015;z0=4147461.6263}{dx=$2-x0;dy=$3-y0;dz=$4-z0;rho=sqrt(dx**2+dy**2+dz**2);printf "%s %16.6f \n", $1,rho}' > rang.ebre

# 2. Repeat the previous computation using the corrupted orbits file:

./gLAB_linux -input:nav brdc0770.10nERR -pre:dec 30 |grep SATPVT | gawk '{if ($6==17) print $4,$7,$8,$9}' > xyz.brdcERR

cat xyz.brdcERR| gawk 'BEGIN{x0=4833520.1197;y0=41537.2015;z0=4147461.6263}{dx=$2-x0;dy=$3-y0;dz=$4-z0;rho=sqrt(dx**2+dy**2+dz**2);printf "%s %16.6f \n", $1,rho}' > rang.ebreERR


# 3. Calculate the discrepancy between the geometric ranges computed with the original 
#    and the corrupted orbits:

cat rang.ebre rang.ebreERR | gawk '{i=$1*1;if (length(r[i])==0) {r[i]=$2}else{print i,$2-r[i]}}' > drang.ebre


# 4. Plot the results:

./graph.py -f drang.ebre  -x1 -y2 -l"EBRE" --xl "time (s)" --yl "error (m)" -t"PRN17: 2000m Along-Track Orbit Range Error: EBRE" --yx 600  --sv FIG/Tu3_exB3.2a.png



# ==> Repeat the previous computations for the receiver CREU: 

# CREU=[4715420.3054 273177.8809 4271946.7957]
# ----

# 1. Using the original orbits brdc0770.10n, compute the geometric range between CREU 
#    and the satellite PRN17:

#    1.1 Compute the satellite coordinates with the original orbits:

./gLAB_linux -input:nav brdc0770.10n -pre:dec 30 | grep SATPVT | gawk '{if ($6==17) print $4,$7,$8,$9}'  > xyz.brdc

#    1.2 Using the coordinates of CREU receiver (CREU=[4715420.3054 273177.8809 
#        4271946.7957]) compute the geometric range between CREU and the satellite PRN17:

cat xyz.brdc | gawk 'BEGIN{x0=4715420.3054;y0=273177.8809;z0=4271946.7957}{dx=$2-x0;dy=$3-y0;dz=$4-z0;rho=sqrt(dx**2+dy**2+dz**2);printf "%s %16.6f \n", $1,rho}' > rang.creu


# 2. Repeat the previous computation using the corrupted orbits file:

./gLAB_linux -input:nav brdc0770.10nERR -pre:dec 30 |grep SATPVT | gawk '{if ($6==17) print $4,$7,$8,$9}' > xyz.brdcERR

cat xyz.brdcERR| gawk 'BEGIN{x0=4715420.3054;y0=273177.8809;z0=4271946.7957}{dx=$2-x0;dy=$3-y0;dz=$4-z0;rho=sqrt(dx**2+dy**2+dz**2);printf "%s %16.6f \n", $1,rho}' > rang.creuERR


# 3. Calculate the discrepancy between the geometric ranges computed with the original 
#    and the corrupted orbits:

cat rang.creu rang.creuERR | gawk '{i=$1*1;if (length(r[i])==0) {r[i]=$2}else{print i,$2-r[i]}}' > drang.creu


# 4. Plot the results:

./graph.py -f drang.creu  -x1 -y2 -l"CREU" --xl "time (s)" --yl "error (m)" -t"PRN17: 2000m Along-Track Orbit Range Error: CREU" --yx 600  --sv FIG/Tu3_exB3.2b.png


# ==> Show the results of EBRE and CREU in the same plot:

./graph.py -f drang.creu  -x1 -y2  -l"CREU" -f drang.ebre  -x1 -y2 -l"EBRE" --xl "time (s)" --yl "error (m)" -t"PRN17: 2000m Along-Track Orbit Range Error" --yx 600  --sv FIG/Tu3_exB3.2c.png




# B.3.3. Differential range error computation:
# --------------------------------------------

cat drang.ebre drang.creu | gawk '{i=$1*1;if (length(r[i])==0) {r[i]=$2}else{printf "%s %16.6f \n", i,$2-r[i]}}' > ddrang.creu_ebre

./graph.py -f ddrang.creu_ebre  -x1 -y2 -s. --cl r --yn -10 --yx 35 --xl "time (s)" --yl "error (m)" -t"PRN17: 2000m AT orbit error PRN17: EBRE-CREU: Diff Range Error" --sv FIG/Tu3_exB3.3.png



# B.3.4 Prediction of the Differential range Error:
# --------------------------------------------------

# Reference station: EBRE: xa=4833520.1197; ya=41537.2015;  za= 4147461.6263 
#              User: CREU: xb=4715420.3054; yb=273177.8809; zb= 4271946.7957


# 1.- Compute the absolute orbit error vector from the original and corrupted broadcast 
#     files:

./gLAB_linux -input:nav brdc0770.10n -pre:dec 30 |grep SATPVT|gawk '{if ($6==17) print $4,$7,$8,$9}' > xyz.brdc0
./gLAB_linux -input:nav brdc0770.10nERR -pre:dec 30 |grep SATPVT |gawk '{if ($6==17) print $4,$7,$8,$9}'> xyz.brdc1


# 2.- Generate a file with the (XYZ) Orbit error vector and LoS vector (from CREU 
#     receiver):

cat xyz.brdc0 xyz.brdc1 |gawk 'BEGIN{xb=4715420.3054;yb=273177.8809;zb=4271946.7957}{i=$1*1;dx=$2-xb;dy=$3-yb;dz=$4-zb;rho=sqrt(dx**2+dy**2+dz**2); if (length(x[i])==0){x[i]=$2;y[i]=$3;z[i]=$4}else{printf "%6i %16.6f %16.6f %16.6f %16.6f %16.6f %16.6f %16.6f \n", i,$2-x[i],$3-y[i],$4-z[i],dx,dy,dz,rho}}' |sort -n -k +1> err.dat

     #   1    2   3    4     5     6     7     8
     # [sec Er_x Er_y Er_z rho_x rho_y rho_z, rho] (note: LoS is taken from CREU (i.e. user receiver))

# 3.- Compute the predicted differential Range Error:

cat err.dat|gawk 'BEGIN{xa=4833520.1197;ya=41537.2015;za= 4147461.6263;xb=4715420.3054;yb=273177.8809;zb= 4271946.7957;bx=xb-xa;by=yb-ya;bz=zb-za; b=sqrt(bx*bx+by*by+bz*bz)}{rtc=($5*bx+$6*by+$7*bz)/$8/b;ux=bx/b-$5/$8*rtc;uy=by/b-$6/$8*rtc;uz=bz/b-$7/$8*rtc;dr=-b/$8*($2*ux+$3*uy+$4*uz); printf "%6i %16.6f \n", $1,dr}' > rang.err

./graph.py -f ddrang.creu_ebre -x1 -y2 -so --cl r -l "Observed" -f rang.err -x1 -y2  -l "Predicted" --xl "time (s)" --yl "error (m)" -t"PRN17: 2000m AT orbit error PRN17: EBRE-CREU: Diff Range Error" --yn -10 --yx 35 --sv FIG/Tu3_exB3.4.png


# Cleaning temporary files in the directory:
rm EBRE.mod EBRE.pos CREU.mod CREU.pos D_EBRE_CREU.mod EBRE_CREU.posK EBRE_CREU.posS GARR.mod GARR.pos MATA.mod MATA.pos D_GARR_MATA.mod GARR_MATA.posK GARR_MATA.posS EBRE.obsERR CREU.obsERR EBRE.modERR EBRE.posERR CREU.modERR CREU.posERR D_EBRE_CREU.obsERR D_EBRE_CREU.modERR EBRE_CREU.posKERR GARR.obsERR MATA.obsERR GARR.modERR GARR.posERR MATA.modERR MATA.posERR D_GARR_MATA.obsERR kalman.nml D_GARR_MATA.modERR GARR_MATA.posKERR dif.sel rang.ebre rang.ebreERR drang.ebre xyz.brdc rang.creu xyz.brdcERR rang.creuERR drang.creu ddrang.creu_ebre xyz.brdc0 xyz.brdc1 err.dat rang.err

