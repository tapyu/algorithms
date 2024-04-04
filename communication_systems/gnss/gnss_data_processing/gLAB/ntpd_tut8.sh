# TUTORIAL 8: Carrier Ambiguity Fixing
#=====================================

# Create the Working directory and copy Programs and Files
# into this directory.

mkdir ./WORK 2> /dev/null
mkdir ./WORK/TUT8
mkdir ./WORK/TUT8/FIG


# Go to the working directory:
cd ./WORK/TUT8


#PROGRAM FILES
#-------------
cp ../../PROG/TUT8/* .
if [[ $(uname -s) =~ "CYGWIN" ]]
then
  cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
fi



#DATA FILES
#----------
cp ../../FILES/TUT8/* .

gzip -df *.gz



# ========================
# PRELIMINARY computations
# ========================

# P1.- MODEL COMPONENTS COMPUTATION
# ==================================

# The script "ObsFile.scr" generates a data file with the following content

#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 Rho Trop Ion elev azim]



# - Run this script for all the receivers:

./ObsFile.scr UPC10770.11o brdc0770.11n
./ObsFile.scr UPC20770.11o brdc0770.11n

# Merge all files in a single file:

 cat ????.obs > ObsFile.dat


# - Select the satellites with elevation over 10deg within the time interval 
#       [18000:19900]

cat ObsFile.dat|gawk '{if ($4>=18000 && $4<=19900 && $12>10) print $0}' >obs.dat



# - Confirm that the satellite PRN06 is the satellite with the highest 
#       elevation (this satellite will be used as the reference satellite).


# ------------------- obs.dat -----------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 Rho Trop Ion elev azim]
# ----------------------------------------------------



# P2 Double-Differences computation
# ==================================
#
#  Using the previously generated file "obs.dat", compute the Double Differences
#  of measurements between the receivers "UPC2" (reference) and UPC3, and the 
#  satellites:
#  PRN06 (reference) and [PRN 03, 07, 16, 18, 19, 21, 22, 24]
#
#
#  The following procedure can be applied:
#
#  The script "DDobs.scr" computes the double differences between receivers and
#   satellites.
#  
#  For instance, the following sentence, generates the file (among other files):
#
#   -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10    11   12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------
#
#
# Where:
#  The elevation and azimuth correspond to the satellites in view from station 2
#    El1 Az1 are for satellite 1
#    El2 Az2 are for satellite 2



# Compute double differences between the receivers "UPC2" (reference) and UPC3
# and the satellites PRN06 (reference) and [PRN 03, 07, 16, 18, 19, 21, 22, 24]

./DDobs.scr obs.dat UPC1 UPC2 06 03
./DDobs.scr obs.dat UPC1 UPC2 06 07
./DDobs.scr obs.dat UPC1 UPC2 06 16
./DDobs.scr obs.dat UPC1 UPC2 06 18
./DDobs.scr obs.dat UPC1 UPC2 06 19
./DDobs.scr obs.dat UPC1 UPC2 06 21
./DDobs.scr obs.dat UPC1 UPC2 06 22
./DDobs.scr obs.dat UPC1 UPC2 06 24

# Merge the files in a single file and sort by time:

cat DD_UPC1_UPC2_06_??.dat|sort -n -k +6 > DD_UPC1_UPC2_06_ALL.dat


#-----------------------------------------------------------------------------------
#OUTPUT file: 
#
#[UPC1 UPC2 06 PRN DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                  PRN06   PRNXX
#                                                                 <-- from UPC1 -->
#-----------------------------------------------------------------------------------



#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION A //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

# ===========================================
# SESSION A: FIXING AMBIGUITIES  ON AT A TIME
# ===========================================


#-----------------------------------------------------------------------------------
#OUTPUT file:
#  1    2    3  4   5   6    7    8    9   10    11    12     13   14  15  16  17
#[UPC1 UPC2 06 PRN DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                  PRN06   PRNXX
#                                                                 <-- from UPC1 -->
#-----------------------------------------------------------------------------------




# A1.- Trying to fix ambiguities in Single frequency
# ===================================================


# -------------  Reference values ------------
# Satelites = [ 03  07 16  18  19  21  22  24]
# True DDN1 = [  2   1  2  -1   4   7   1   4]
# True DDN2 = [ -1   1 -1   2   2  -1   1   0]
# --------------------------------------------



# A1.1 Fixing N1 and N2 independently:
# ------------------------------------

#  Estimate graphically values of DDN1 and DDN2 (i.e. try to identify 
#  the true ambiguity from the plot).
#  ...............................................

#  a) From file "DD_UPC1_UPC2_06_ALL.dat", generate the file "DDN1N2.dat" 
#     with the following content:
#
#  DDN1N2.dat=[PRN sec DDN1 nint(DDN1) DDN2 nint(DDN2)]
#
#  where:
#       DDN1= [DDL1 -DDP1]/lambda1; DDN2= [DDL2 -DDP2]/lambda2
#
#       ...................................................
#       Be careful: "int" in awk:
#               nint(x) must be generated as: 
#                       nint(x):=int(x+0.5*sign(x))
#       ...................................................

gawk 'BEGIN{c=299792458;f0=10.23e+6;l1=c/(154*f0);l2=c/(120*f0)}{A1=($8-$7)/l1;A2=($10-$9)/l2;if (A1!=0){signA1=A1/sqrt(A1*A1)}else{signA1=0};if (A2!=0) {signA2=A2/sqrt(A2*A2)}else{signA2=0};print $4,$6,A1,int(A1+0.5*signA1),A2,int(A2+0.5*signA2)}' DD_UPC1_UPC2_06_ALL.dat > DDN1N2.dat

# b) Plot DDN1 and DDN2 for the different satellites and discuss if the ambiguity
#    DDN1 and DDN2 can be fixed:

#                1   2    3        4      5      6
#   DDN1N2.dat=[PRN sec DDN1 nint(DDN1) DDN2 nint(DDN2)]



./graph.py -f DDN1N2.dat -x2 -y3 -c '($1==16)' -s. -f DDN1N2.dat -x2 -y4 -c '($1==16)' -sx --cl r --yn -4 --yx 10 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN16" --sv FIG/Tu4_exA1.1.1a.png

./graph.py -f DDN1N2.dat -x2 -y5 -c '($1==16)' -s. -f DDN1N2.dat -x2 -y6 -c '($1==16)' -sx --cl r --yn -8 --yx 6 --xl "time (s)" --yl "cycles L2" -t "DDN2 ambiguity: PRN16" --sv FIG/Tu4_exA1.1.1b.png


# Questions:
# ----------

# 1.- Explain what is the meaning of this plot.
# 2.- Is it possible to identify the integer ambiguity?
# 3.- How reliability can be improved?



# c) Make plots to analyse the DDP1 and DDP2 code noise: 
# .......................................................

#  From file "DD_UPC1_UPC2_06_ALL.dat", generate the file "P1P2noise.dat" with 
#  the following content:
#
#  P1P2noise.dat=[PRN sec DDP1-DDRho DDP2-DDRho]


 gawk '{print $4,$6,$7-$11,$9-$11}' DD_UPC1_UPC2_06_ALL.dat > P1P2noise.dat
 
./graph.py -f P1P2noise.dat -x2 -y3 -c '($1==16)' -so --yn -2 --yx 1.5 --xl "time (s)" --yl "metres" -t "DDP1 noise: PRN16" --sv FIG/Tu4_exA1.1.2a.png

./graph.py -f P1P2noise.dat -x2 -y4 -c '($1==16)' -so --yn -2 --yx 1.5 --xl "time (s)" --yl "metres" -t "DDP2 noise: PRN16" --sv FIG/Tu4_exA1.1.2b.png


# Questions:
#-----------
# Discuss why the ambiguities cannot be fixed by rounding-off
# the expression DDN1=[DDL1 -DDP1]/λ1 or DDN2=[DDL2 -DDP2]/λ2




# d) Make plots to depict the DDL1 and DDL2 carrier noise:
# ...........................................................

#  From file "DD_UPC1_UPC2_06_ALL.dat", generate the file "P1P2noise.dat" with 
#  the following content:
#
#  P1P2noise.dat=[PRN sec DDL1-DDRho DDL2-DDRho]


 gawk '{print $4,$6,$8-$11,$10-$11}' DD_UPC1_UPC2_06_ALL.dat > L1L2noise.dat

./graph.py -f L1L2noise.dat -x2 -y3 -c '($1==16)' -so --yn 0.38 --yx 0.40 --xl "time (s)" --yl "metres" -t "DDL1 noise: PRN16"   --sv FIG/Tu4_exA1.1.3a.png

./graph.py -f L1L2noise.dat -x2 -y4 -c '($1==16)' -so --yn -0.24 --yx -0.22 --xl "time (s)" --yl "metres" -t "DDL2 noise: PRN16" --sv FIG/Tu4_exA1.1.3b.png


# Questions:
#-----------
# - Discuss the plot. What is the level of noise?
# - Compare the noise of DDL1 with the wavelength λ1=19.0cm.
# - Compare the noise of DD21 with the wavelength λ2=24.4cm.





# A2.- DUAL FREQUENCY
# -------------------

# A2.1 Fixing Wide-lane ambiguity (DDNw)
# ......................................

#
#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10   11    12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------



# Estimate graphically values of DDNw (i.e. try to identify 
# the true ambiguity from the plot).
# ..........................................

# 
# a) From file "DD_UPC1_UPC2_06_ALL.dat", generate the file "DDNw.dat" with the
#    following content:
#
#  DDNw.dat=[PRN sec DDNw nint(DDNw)]


cat DD_UPC1_UPC2_06_ALL.dat| gawk 'BEGIN{s12=154/120} {mw=(s12*$8-$10)/(s12-1)-(s12*$7+$9)/(s12+1);if (mw!=0){sign=mw/sqrt(mw*mw)}else{sign=0};printf "%02i %i %14.4f %i \n", $4,$6, mw/0.862, int(mw/0.862+0.5*sign)}' > DDNw.dat


# b) Plot DDNw for the different satellites and discuss if the ambiguity DDNw
#     can be fixed:

#            1    2   3      4      
# DDNw.dat=[PRN  sec DDNw nint(DDNw)]


./graph.py -f DDNw.dat -x2 -y3 -c '($1==03)' -s. -f DDNw.dat -x2 -y4 -c '($1==03)' -sx --cl r  --yn -1 --yx 7 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN03" --sv FIG/Tu4_exA2.1.1a.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==07)' -s. -f DDNw.dat -x2 -y4 -c '($1==07)' -sx --cl r  --yn -4 --yx 4 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN07" --sv FIG/Tu4_exA2.1.1b.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==16)' -s. -f DDNw.dat -x2 -y4 -c '($1==16)' -sx --cl r  --yn -1 --yx 7 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN16" --sv FIG/Tu4_exA2.1.1c.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==18)' -s. -f DDNw.dat -x2 -y4 -c '($1==18)' -sx --cl r  --yn -7 --yx 1 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN18" --sv FIG/Tu4_exA2.1.1d.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==19)' -s. -f DDNw.dat -x2 -y4 -c '($1==19)' -sx --cl r  --yn -2 --yx 6 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN19" --sv FIG/Tu4_exA2.1.1e.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==21)' -s. -f DDNw.dat -x2 -y4 -c '($1==21)' -sx --cl r  --yn 4 --yx 12 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN21" --sv FIG/Tu4_exA2.1.1f.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==22)' -s. -f DDNw.dat -x2 -y4 -c '($1==22)' -sx --cl r  --yn -4 --yx 4 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN22" --sv FIG/Tu4_exA2.1.1g.png

./graph.py -f DDNw.dat -x2 -y3 -c '($1==24)' -s. -f DDNw.dat -x2 -y4 -c '($1==24)' -sx --cl r  --yn 0 --yx 8 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN24" --sv FIG/Tu4_exA2.1.1h.png


# A.2.2 Smoothing the DDNw:
#--------------------------
# Smooth the DDNw with a 300 seconds sliding window, in order to improve the
#  ambiguity fixing.

# Hint:
# From file "DDNw.dat", generate the file "DDNws.dat" with the following content
#               1   2    3    4        5          6
# DDNws.dat =[PRN sec DDNw DDNws nint(DDNw) nint(DDNws)]


# - Execute, for instance (to smooth the DDNw):

cat DDNw.dat | gawk '{dt=300;for (j=0;j<dt;j++) {t=j+dt/2+int(($2-j)/dt)*dt;ind=$1" "t;n[ind]++;v[ind]=$3;m[ind]=m[ind]+$3}}END{for (i in n) {if (n[i]!=0) {;if(n[i]>1) {val=v[i];mean=m[i]/n[i]; print i,val,mean}}}}'|  sort -n -k+1 > DDNws.tmp

#              1   2    3    4    
# DDNws.tmp =[PRN sec DDNw DDNws]


# - Estimate again the ambiguity from the raw DDNw and smoothed DDNws. Compare results:

cat DDNws.tmp | gawk '{sign3=$3/sqrt($3*$3);sign4=$4/sqrt($4*$4);print $1,$2,$3,$4,int($3+0.5*sign3),int($4+0.5*sign4)}' > DDNws.dat



# b) Plot DDNw and DDNws for the different satellites and discuss if
#    the ambiguity DDNw can be fixed:

#               1   2    3    4        5          6
# DDNws.dat =[PRN sec DDNw DDNws nint(DDNw) nint(DDNws)]



./graph.py -f DDNws.dat -x2 -y3 -c '($1==03)' -s. -f DDNws.dat -x2 -y5 -c '($1==03)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==03)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==03)' -sx --cl m  --yn 0 --yx 6 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN03" --sv FIG/Tu4_exA2.1.2a.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==07)' -s. -f DDNws.dat -x2 -y5 -c '($1==07)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==07)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==07)' -sx --cl m  --yn -3 --yx 3 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN07" --sv FIG/Tu4_exA2.1.2b.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==16)' -s. -f DDNws.dat -x2 -y5 -c '($1==16)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==16)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==16)' -sx --cl m  --yn 0 --yx 6 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN16" --sv FIG/Tu4_exA2.1.2c.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==18)' -s. -f DDNws.dat -x2 -y5 -c '($1==18)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==18)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==18)' -sx --cl m  --yn -6 --yx 0 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN18" --sv FIG/Tu4_exA2.1.2d.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==19)' -s. -f DDNws.dat -x2 -y5 -c '($1==19)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==19)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==19)' -sx --cl m  --yn -1 --yx 5 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN19" --sv FIG/Tu4_exA2.1.2e.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==21)' -s. -f DDNws.dat -x2 -y5 -c '($1==21)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==21)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==21)' -sx --cl m  --yn 5 --yx 11 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN21" --sv FIG/Tu4_exA2.1.2f.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==22)' -s. -f DDNws.dat -x2 -y5 -c '($1==22)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==22)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==22)' -sx --cl m  --yn -3 --yx 3 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN22" --sv FIG/Tu4_exA2.1.2g.png

./graph.py -f DDNws.dat -x2 -y3 -c '($1==24)' -s. -f DDNws.dat -x2 -y5 -c '($1==24)' -sx  --cl r -f DDNws.dat  -x2 -y4 -c '($1==24)' -s. --cl g -f DDNws.dat -x2 -y6 -c '($1==24)' -sx --cl m  --yn 0 --yx 6 --xl "time (s)" --yl "cycles Lw" -t "DDNw ambiguity: PRN24" --sv FIG/Tu4_exA2.1.2h.png



# PRN = [ 03  07 16  18  19  21  22  24]
# DDNw= [  3   0  3  -3   2   8   0   4]


# A2.2 Fixing DDN1 from DDNw and DDL1, DDL2
#
#   Using the previous DDNw fixed values, estimate graphically the DDN1
#   ambiguity (i.e. try to identify the true ambiguity from the plot).
# ...................................................................


#
#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10   11    12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------


# Hint:
#  From file "DD_UPC1_UPC2_06_ALL.dat", (using the DDNw ambiguities fixed) 
#  generate the file "DDN1.dat" with the following content:
#
#  DDNw.dat=[PRN sec DDN1 nint(DDN1)]
#
#  where:
#       DDN1=(DDL1-DDL2-lambda2*DDNw)/(lambda1-lambda2)


# Execute, for instance for PRN24 (with DDNw=4):

gawk 'BEGIN{c=299792458;f0=10.23e+6;f1=154*f0;f2=120*f0;l1=c/f1;l2=c/f2}{Nw=4;if ($4==24) {amb=($8-$10-l2*Nw)/(l1-l2);print $4,$6,amb,int(amb+0.5*amb/sqrt(amb*amb))}}' DD_UPC1_UPC2_06_ALL.dat > DDN1_PRN24

./graph.py -f DDN1_PRN24 -x2 -y3 -c '($1==24)' -s. -f DDN1_PRN24 -x2 -y4 -c '($1==24)' -sx --cl r --yn 1 --yx 6 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN24" --sv  FIG/Tu4_exA2.2.png 


# ==> Other possibility is to execute the following sentence 
#     to generate the file for all satellites:


# Edit the file: 
# .. sat.ambNw ...
#  03  3
#  07  0
#  16  3
#  18 -3
#  19  2
#  21  8
#  22  0
#  24  4
#................


# Compute the DDN1 (for all satellites):
# ----------------

gawk 'BEGIN{for (i=0;i<100;i++) {getline <"sat.ambNw";Nw[$1*1]=$2}} {c=299792458;f0=10.23e+6;f1=154*f0;f2=120*f0;l1=c/f1;l2=c/f2}{amb=($8-$10-l2*Nw[$4*1])/(l1-l2);if (amb!=0){sign=amb/sqrt(amb*amb)}else{sign=0};print $4,$6,amb,int(amb+0.5*sign)}' DD_UPC1_UPC2_06_ALL.dat > DDN1.dat


# Plot results:
# -------------
./graph.py -f DDN1.dat -x2 -y3 -c '($1==03)' -s. -f DDN1.dat -x2 -y4 -c '($1==03)' -sx --cl r --yn -1 --yx 4 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN03" --sv FIG/Tu4_exA2.2.a.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==07)' -s. -f DDN1.dat -x2 -y4 -c '($1==07)' -sx --cl r --yn -2 --yx 3 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN07" --sv FIG/Tu4_exA2.2.b.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==16)' -s. -f DDN1.dat -x2 -y4 -c '($1==16)' -sx --cl r --yn -1 --yx 4 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN16" --sv FIG/Tu4_exA2.2.c.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==18)' -s. -f DDN1.dat -x2 -y4 -c '($1==18)' -sx --cl r --yn -4 --yx 1 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN18" --sv FIG/Tu4_exA2.2.d.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==19)' -s. -f DDN1.dat -x2 -y4 -c '($1==19)' -sx --cl r --yn 1 --yx 6 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN19" --sv FIG/Tu4_exA2.2.e.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==21)' -s. -f DDN1.dat -x2 -y4 -c '($1==21)' -sx --cl r --yn 4 --yx 9 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN21" --sv FIG/Tu4_exA2.2.f.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==22)' -s. -f DDN1.dat -x2 -y4 -c '($1==22)' -sx --cl r --yn -2 --yx 3 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN22" --sv FIG/Tu4_exA2.2.g.png

./graph.py -f DDN1.dat -x2 -y3 -c '($1==24)' -s. -f DDN1.dat -x2 -y4 -c '($1==24)' -sx --cl r --yn 1 --yx 6 --xl "time (s)" --yl "cycles L1" -t "DDN1 ambiguity: PRN24" --sv FIG/Tu4_exA2.2.h.png


# Summary:
#--------
# PRN = [ 03  07 16  18  19  21  22  24]
# DDNw= [  3   0  3  -3   2   8   0   4]
# DDN1= [  2   1  2  -1   4   7   1   4]



# A2.3: Fixing DDN2
#   Using the previous DDNw and DDN1 ambiguities fixed, fix the
#   DDN2 ambiguity:
# ................................................................

# Hint:
#  The DDN2 can be easily computed by:
#           DDN2= DDN1-DDNw


# N2  = [ -1   1 -1   2   2  -1   1   0]







#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION B //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

# ========================================================
# SESSION B: ASSESSING THE FIXED AMBIGUITIES IN NAVIGATION
# ========================================================

# B Repairing the DDL1 and DDL2 carriers with the ambiguities fixed
# ===================================================================

# B1. Repair the DDL1 and DDl2 carrier measurements with the FIXED
#         ambiguities and plot the results to analyse the data.


# - Edit the file: "N1N2.dat" with the following content: [PRN DDN1 DDN2]
#   ---------------------------------------------------------------------

# ... N1N2.dat...
#   03  2 -1
#   07  1  1
#   16  2 -1
#   18 -1  2
#   19  4  2 
#   21  7 -1
#   22  1  1
#   24  4  0
#................

# a) From previous file N1N2.dat, generate a the file "sat.ambL1L2"  with the following 
#    content: [PRN DDN1 DDN2 lambda1*DDN1 lambda2*DDN2]

gawk 'BEGIN{c=299792458;f0=10.23e+6;l1=c/(154*f0);l2=c/(120*f0)}{printf "%02i %3i %3i %14.4f %14.4f \n", $1,$2,$3,$2*l1,$3*l2}' N1N2.dat > sat.ambL1L2 



# b) Generate the "DD_UPC1_UPC2_06_30.fixL1L2" file:
   
#  The following procedure can be applied:
#  -----
#  Using the previous files "sat.ambL1L2" and "DD_UPC1_UPC2_06_ALL.dat",
#  generate a file with the following content:

#----------------------------  DD_UPC1_UPC2_06_ALL.fixL1L2 -----------------------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17       18           19
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDRho DDTrop DDIon El1 Az1 El2 Az2 lambda1*DDN1  lambda2*DDN2]
#                                                                     <--- sta2 --->
#---------------------------------------------------------------------------------------------------------------
# Note: This file is identical to file "DD_UPC1_UPC2_06_ALL.dat", but with the
# ambiguities added in the last fields #18 and #19.


cat DD_UPC1_UPC2_06_ALL.dat |gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL1L2";A1[$1]=$4;A2[$1]=$5}}{printf "%s %02i %02i %s %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,A1[$4],A2[$4]}' > DD_UPC1_UPC2_06_ALL.fixL1L2


# c) Make and discuss the following plots for DDL1 

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($8-$18-$11)' -so --yn -0.06 --yx 0.06 -l "(DDL1-DDN1)-DDRho" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1a.png

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($8-$11)' -so --yn -5 --yx 5 -l "(DDL1-DDRho)" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1b.png

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($8-$18)' -so --yn -20 --yx 20 -l "(DDL1-DDN1)" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1c.png


# Questions:
# ----------
# Explain what is the meaning of previous plots.
# Why a trend and a discontinuity appears in the "DDL1-DDN1" plot?


# d) Make and discuss the following plots for DDL2

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($10-$19-$11)' -so --yn -0.06 --yx 0.06 -l "(DDL2-DDN2)-DDRho" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1d.png

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($10-$11)' -so --yn -5 --yx 5 -l "(DDL2-DDRho)" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1f.png

./graph.py -f DD_UPC1_UPC2_06_ALL.fixL1L2 -x6 -y'($10-$19)' -so --yn -20 --yx 20 -l "(DDL2-DDN2)" --xl "time (s)" --yl "metres" --sv FIG/Tu4_exB1.1g.png

# Questions:
# ----------
# Explain what is the meaning of previous plots.
# Why a trend and a discontinuity appears in the "DDL1-DDN1" plot?




# B2 Assessing the fixed ambiguities in navigation
# ================================================


# B2.1 UPC1-UPC2 Baseline vector estimation with L1 carrier
# (using the time-tagged reference station measurements)
# ---------------------------------------------------------


#  Using the DDL1 carrier with the ambiguities FIXED in the previous exercise, 
#  compute the single epoch solution for the whole interval 180000< t <199000 
#  with the program LS.f
#
#         Note: The program "LS.f" computes the Least Square solution for each
#               measurement epoch of the input file (see the FORTRAN code "LS.f")
#
#
# The next procedure can be applied:
#
# a) Generate a file with the following content:
#
#     ["time"  "DDL1-Lambda1*DDN1"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL1-Lambda1*DDN1= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_UPC1_UPC2_06_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# b) compute the Least Squares solution for the epochs given in the file:

        cat L1model.dat |./LS > L1fix.pos

# c) Plot the baseline error:

# Note: Use as a reference the next accurate estimation of baseline vector:
# bsl_enu =[-27.4170 -26.2341 -0.0304]

./graph.py -f L1fix.pos -x1 -y'($2+27.4170)' -s.- -l "North error" -f L1fix.pos -x1 -y'($3+26.2341)' -s.- -l "East error" -f L1fix.pos -x1 -y'($4-0.0304)' -s.- -l "UP error" --yn -2 --yx 2 --xl "time (s)" --yl "error (m)" -t "Baseline error: UPC1-UPC2: 37.95m: L1 ambiguities fixed" --sv FIG/Tu4_exB2.1.png


# Questions:
# ----------
#
# 1.- What is the expected accuracy when positioning
#      with carrier after fixing ambiguities?
#
# 2.- Discuss why a trend and a discontinuity appears?




# B2.2. UPC1-UPC2 differential positioning with L1 carrier
#  (using the computed differential corrections)
# --------------------------------------------------------


# Repite the previous positioning, but using the computed differential 
# corrections instead the time-tagged measurements.

# The next procedure can be applied:
#
# a) Generate a file with the following content:
#
#     ["time"  "DDL1-DDRho-Lambda1*DDN1"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL1-DDRho-Lambda1*DDN1= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#


cat DD_UPC1_UPC2_06_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# b) compute the Least Squares solution for the epochs given in the file:

        cat L1model.dat |./LS > L1fix.pos

# c) Plot the Absolute coordinates error:


./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y4 -s.- -l "UP error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "Absolute coordinates error: UPC1-UPC2: 37.95m: L1 ambiguities fixed" --sv FIG/Tu4_exB2.2.png


# Question:
# ---------
#
#  Discuss why the results have improved now, achieving centimetre level
#  of accuracy navigation.
#



# B2.3. UPC1-UPC2 differential positioning with L2 carrier
# (using the computed differential corrections)
# --------------------------------------------------------

# Repite the previous positioning, but using using the DDL2 carrier.

# Note: we skep the relative navigation with DDL2 (i.e using the time.tagged 
#       mesurements) because the same problems as with DDL1 will appear.


# The next procedure can be applied:
#
# a) Generate a file with the following content:
#
#     ["time"  "DDL2-DDRho-Lambda2*DDN2"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL2-DDRho-Lambda2*DDN2= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#


cat DD_UPC1_UPC2_06_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$10-$19-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L2model.dat

# b) compute the Least Squares solution for the epochs given in the file:

        cat L2model.dat |./LS > L2fix.pos

# c) Plot the absolute positioning error:

./graph.py -f L2fix.pos -x1 -y2 -s.- -l "North error" -f L2fix.pos -x1 -y3 -s.- -l "East error" -f L2fix.pos -x1 -y4 -s.- -l "UP error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "Absolute coordinates error: UPC1-UPC2: 37.95m: L2 ambiguities fixed" --sv FIG/Tu4_exB2.3.png



# Question:
# ---------
# 
# Compare the results with the previous ones computed from DDL1.





# B2.4 Error due to a wrong fix:
# UPC1-UPC2 differential positioning with L1 carrier
# (using the computed differential corrections)
# --------------------------------------------------


# Simulate an error of 1 cycle in DDN1 for satellite PRN07 and recompute the 
# navigation solution:

# a) generate a file with the navigation equations system (having the simulated error):

cat DD_UPC1_UPC2_06_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{if ($4==07){$18=$18+0.19029}; e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$18-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# b) compute the Least Squares solution for the epochs given in the file:

        cat L1model.dat |./LS > L1fix.pos

# c) Plot the Absolute coordinates error:

./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y4 -s.- -l "UP error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "Absolute coordinates error: UPC1-UPC2: 37.95m: L1 ambiguities fixed" --sv FIG/Tu4_exB2.4.png


# Question:
# ---------
#
# Discuss the results. What is the effect of the wrong fix?






#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION C //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

# ==============================================
# SESSION C: AMBIGUITY FIXING with LAMBDA METHOD
# ==============================================

# Apply the LAMBDA method to fix the ambiguities in the previous problem.

# -----------------------------------------------------------------------
# Note: to avoid the synchonization issues, consider the Differential 
#       Positioning using the computed differential corrections, instead 
#       of the time-tagged measurements.
#
#   That is, to solve the following navigation equations system:
#
#     1.- Navigating with L1 carrier, to fix DDN1:
# 
#        [DDL1-DDRho]=[Los_k-Los_06]*dr + [ A ]*[lambda1*DDN1]
#
#     2.- Navigating with L2 carrier, to fix DDN2:
#
#        [DDL2-DDRho]=[Los_k-Los_06]*dr + [ A ]*[lambda2*DDN2]
# ----------------------------------------------------------------------




# C1. DDN1 ambiguity fixing: Differential positioning using computed
#                 differential corrections from a reference receiver.
# ==================================================================
#
# Estimate the coordinates of receiver UPC2 taking UPC1 as a reference station.
# Use only the carrier measurements for the two epochs t1=18000 and t2=18015. 
#
#
#  The following procedure can be applied:


# 1) Build-up the navigation system.
# ..................................
#
#   Generate the measurement vectors and matrices for the selected epochs t1,t2
#    y1:=y[t1]   G1:=G[t1]   Py
#    y2:=y[t2]   G2:=G[t2]   Py
#
#    Merge the two vectors and matrices into a common system and show
#    that the solution is given by:
#
#     P=inv(G1'*W*G1+G2'*W*G2);
#     x=P*(G1'*W*y1+G2'*W*y2)
#
#     where: W=inv(Py)
#
#   The following procedure can be applied:
#
#     The script "MakeL1DifMat.scr" builds the equations system
#     to estimate coordinates of a receiver regarding to to a
#     reference station, using the double differenced L1 measurements.
#
#      [DDL1-DDRho]=[Los_k-Los_06]*[dx] + [ A ]*[lambda1*DDN1]
#
#     for the two epochs required t1=18000 and t2=18015, using
#     the input file "DD_IND2_IND3_06_ALL.dat" generated before.
#
#
#     ======================================================
#     Execute:

      ./MakeL1DifMat.scr DD_UPC1_UPC2_06_ALL.dat 18000 18015

#     ======================================================




#  2) Compute the FLOATED solution, solving the equations system
#     with octave. 
#    .............................................................
#

########################## OCTAVE ##############################
octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:12);

y2=M2(:,1);
G2=M2(:,2:12);

n=8;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
# 1.421625881600363  -0.605838385613900   0.403540962934336




#  3) Apply the LAMBDA method to FIX the ambiguities.
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding
#         the solution after decorrelation.
#
#      The following procedure can be applied:

# .........................................
# 3.1) Ambiguities fixed by rounding directly 
#    the floated solution:

 round(a)'

#  0  -6   6   6  -1  12   8   9

# ........................................
# 3.2) Ambiguities fixed by rounding the
#     decorrelated floated solution:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
a=x(4:11)/lambda1;
Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);

 afix=iZ*round(az);
 afix'

#  2   1   2  -1   4   7   1   4
# ........................................

# 3.3) Ambiguities fixed from the LS integer
#      search

 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans = 3.10696822814451

 afixed(:,1)'

#  2   1   2  -1   4   7   1   4
# .......................................

exit

######################## END OCTAVE #############################


#  Questions:
#  ----------
# 1.- Can the ambiguities be well fixed?
# 2.- Is the test resolutive.
# 3.- Compare the fixed ambiguities with those obtained
#     in the previous exercises when fixing the ambiguities
#     one at a time. Are the same results found?
# 4.- What is the elapsed time to needed fix the
#     ambiguities? And in the previous exercise when
#     fixing the ambiguities one at a time?
# 5.- The values found for the ambiguities are the same
#     than in the previous case?






# C2. Checking the Z-transform Matrix:
# ====================================


###########################  OCTAVE #############################
#Execute for instance:

octave

# a) Using the Octave/MATLAB program sentence "imagesc"
#    display the covariance mantrix of ambiguities before 
#    and after the decorrelation with the Z-matrix.

      imagesc(Q)
      imagesc(Qz)

# b) Show the content of the integer matrix Z:
#    
#    Note: The previous routines computes its transpose (Zt).
#          then:  Z=Zt'.

       Z=Zt'

#  Z =

#      3  -5  -4  -5   6   7   4  -2
#      3   2  -7  -6  -5  -4   9   3
#     -4  -0  -5   8   3  -4   1  -3
#      1  -5   1  -8   4  -1   1   8
#     -0   1   2   7  -1  -8  -4   3
#      8  -3  -1   4   2  -6  -1   4
#     -5  -1   1  -6   1   0   1   4
#     -5  -3  -0  -0   5  -2  -1   3


# c) Compute by hand the transformed covariance matrix Qz:

       Z * Q * Z'

# d) Compute the Decorrelated ambiguities az:

        Z*a


#   67.19877600816902
#  -27.00815309344809
#  -52.80792522348074
#   49.18410614456196
#  -53.87737144457776
#  -11.70730035212100
#   18.08081880749826
#    4.09968790147667



# e) Roundoff the decorrelated ambiguities:

      Nz=round(Z*a)

#   67
#  -27
#  -53
#   49
#  -54
#  -12
#   18
#    4


# f) Apply the inverse transform to the previous values:

 format short

      inv(Z)* Nz

#   2.00000
#   1.00000
#   2.00000
#  -1.00000
#   4.00000
#   7.00000
#   1.00000
#   4.00000


#  g) Compare the previous results with the direct rounding
#     of the initial ambiguities "a"

       round(a)

#    0
#   -6
#    6
#    6
#   -1
#   12
#    8
#    9


exit
######################## END OCTAVE #############################


# Questions:
# ..........

# 1.- The fixed ambiguities are the same as with 
#     afixed=iZ*azfixed?
#
# 2.- Compare the ambiguities fixed using and without using LAMBDA 
#     with those obtained in previous exercises when fixing the 
#     ambiguities one at a time. Discuss the results.






# C3. DDN2 ambiguity fixing: Differential positioning using computed
#                 differential corrections from a reference receiver.
# ==================================================================
#
# Estimate the coordinates of receiver UPC2 taking UPC1 as a reference station.
# Use only the carrier measurements for the two epochs t1=18000 and t2=18015.
#
#
#  The following procedure can be applied:
#
# 1) Build-up the navigation system.
# ..................................
#
#   Generate the measurement vectors and matrices for the selected epochs t1,t2
#    y1:=y[t1]   G1:=G[t1]   Py
#    y2:=y[t2]   G2:=G[t2]   Py
#
#    Merge the two vectors and matrices into a common system and show
#    that the solution is given by:
#
#     P=inv(G1'*W*G1+G2'*W*G2);
#     x=P*(G1'*W*y1+G2'*W*y2)
#
#     where: W=inv(Py)
#
#   The following procedure can be applied:
#
#    As in the previous exercise,
#     The script "MakeL2DifMat.scr" builds the equations system
#     to estimate coordinates of a receiver regarding to to a
#     reference station, using the double differenced L1 measurements.
#
#      [DDL2-DDRho]=[Los_k-Los_06]*[dx] + [ A ]*[lambda2*DDN2]
#
#     for the two epochs required t1=18000 and t2=18015, using
#     the input file "DD_IND2_IND3_06_ALL.dat" generated before.
#
#     ======================================================
#     Execute:

      ./MakeL2DifMat.scr DD_UPC1_UPC2_06_ALL.dat 18000 18015

#     ======================================================

#  2) Compute the FLOATED solution, solving the equations system
#        with octave.
#    ............................................................
#

########################## OCTAVE ##############################
octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:12);

y2=M2(:,1);
G2=M2(:,2:12);

n=8;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'

# 0.144170579833670  -0.515370795365087   0.556836219978397



#  3) Apply the LAMBDA method to FIX the ambiguities.
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding
#         the solution after decorrelation.
#
#      The following procedure can be applied:
# .........................................
# 3.1) Ambiguities fixed by rounding directly 
#      the floated solution:

 round(a)'

# -1  -2   1   2   1  -2   3  -1

# ........................................
# 3.2) Ambiguities fixed by rounding the
#      decorrelated floated solution:

c=299792458;
f0=10.23e+6;
f2=120*f0;
lambda2=c/f2
a=x(4:11)/lambda2;
Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);

 afix=iZ*round(az);
 afix'

# -1   1  -1   2   2  -1   1   0

# ........................................

# 3.3) Ambiguities fixed from the LS integer
#      search

 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans = 3.54056715815950

 afixed(:,1)'

# -1   1  -1   2   2  -1   1   0
# .......................................

exit

######################## END OCTAVE #############################


#  Questions:
#  ----------

# 1.- Can the ambiguities be well fixed?
# 2.- Is the test resolutive.
# 3.- Compare the fixed ambiguities with those obtained
#     in the previous exercises when fixing the ambiguities
#     one at a time. Are the same results found?
# 4.- What is the elapsed time to needed fix the
#     ambiguities? And in the previous exercise when
#     fixing the ambiguities one at a time?
# 5.- The values found for the ambiguities are the same
#     than in the previous case?





# C4. DDN1 ambiguity fixing, BUT USING THE TIME TAGGED MEASUREMENTS
#     instead of the computed differential corrections:
# =================================================================

# Estimate the baseline vector between UPC1 and UPC2 receivers using the
# L1 carrier measurements of file (DD_UPC1_UPC2_06_ALL.dat).
# Consider only the next two epochs: t= 18000 and 18015.
#
# Apply the same procedure as in the previous exercises:


# 1) Build-up the navigation system.
# ..................................
#
#    Generate the measurement vectors and matrices for the selected epochs t1,t2
#    y1:=y[t1]   G1:=G[t1]   Py
#    y2:=y[t2]   G2:=G[t2]   Py
#
#    Merge the two vectors and matrices into a common system and show
#    that the solution is given by:
#
#     P=inv(G1'*W*G1+G2'*W*G2);
#     x=P*(G1'*W*y1+G2'*W*y2)
#
#     where: W=inv(Py)
#
#
#    The script "MakeL1BslMat.scr" builds the equations system 
#    to estimate the baseline vector combining the time-tagged 
#    L1 measurements of a reference station with those of the 
#    user receiver.
#
#    [DDL1]=[Los_k-Los_06]*[baseline] + [ A ]*[lambda*DDN1]
#
#
#   ========================================================
#   Execute:

      ./MakeL1BslMat.scr DD_UPC1_UPC2_06_ALL.dat 18000 18015

#   ========================================================
#
#

#  2) Compute the FLOATED solution, solving the equations system
#        with octave.
#    .............................................................
#

########################## OCTAVE ##############################
octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:12);

y2=M2(:,1);
G2=M2(:,2:12);

n=8;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
# -24.57351702552842  -27.11208416228988    3.00208285593817

# bsl_enu =[-27.4170 -26.2341 -0.0304]

x(1:3)-bsl_enu'

#   2.843482974471584
#  -0.877984162289874
#   3.032482855938170





#  3) Apply the LAMBDA method to FIX the ambiguities.
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding
#         the solution after decorrelation.
#
#      The following procedure can be applied:

# .........................................
# 3.1) Ambiguities fixed by rounding directly
#      the floated solution:

 round(a)'

# -4 -20  13  11 -14  19  10  16

# ........................................
# 3.2) Ambiguities fixed by rounding the
#      decorrelated floated solution:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
a=x(4:11)/lambda1;
Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);

 afix=iZ*round(az);
 afix'

# -1 -12  18   2  -4   8   9   4
# ........................................

# 3.3) Ambiguities fixed from the LS integer
#      search

 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans = 1.22717645070483

 afixed(:,1)'

# -1 -12  18   2  -4   8   9   4
# .......................................

exit

######################## END OCTAVE #############################

#  Questions:
#  ----------
#
# 1.- Can the ambiguities be well fixed?
# 2.- Is the test resolutive.
# 3.- Compare the fixed ambiguities with those obtained
#     in the previous exercises when fixing the ambiguities
#     one at a time. Are the same results found?
# 4.- What is the elapsed time to needed fix the
#     ambiguities? And in the previous exercise when
#     fixing the ambiguities one at a time?
# 5.- The values found for the ambiguities are the same
#     than in the previous case?






# C5. DDN2 ambiguity fixing, BUT USING THE TIME TAGGED MEASUREMENTS
#     instead of the computed differential corrections:
# =================================================================

# Estimate the baseline vector between UPC1 and UPC2 receivers using the
# L2 carrier measurements of file (DD_UPC1_UPC2_06_ALL.dat).
# Consider only the next two epochs: t= 18000 and 18015.
#
#  Repeat the previous exercise but for the ambiguties DDN2


# 1) Build-up the navigation system.
# ..................................
#
#   Generate the measurement vectors and matrices for the selected epochs t1,t2
#    y1:=y[t1]   G1:=G[t1]   Py
#    y2:=y[t2]   G2:=G[t2]   Py
#
#    Merge the two vectors and matrices into a common system and show
#    that the solution is given by:
#
#     P=inv(G1'*W*G1+G2'*W*G2);
#     x=P*(G1'*W*y1+G2'*W*y2)
#
#     where: W=inv(Py)
#
#
#    The script "MakeL2BslMat.scr" builds the equations system
#    to estimate the baseline vector combining the time-tagged
#    L2 measurements of a reference station with those of the 
#    user receiver.
#
#    As in the previous cases, the next sentence builds the equations system:
#    [DDL2]=[Los_k-Los_06]*[baseline] + [ A ]*[lambda2*DDN2]
#
#
#   ========================================================
#   Execute:

      ./MakeL2BslMat.scr DD_UPC1_UPC2_06_ALL.dat 18000 18015

#   ========================================================
#




#  2) Compute the FLOATED solution, solving the equations system
#        with octave.
#    .............................................................
#

########################## OCTAVE ##############################
octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:12);

y2=M2(:,1);
G2=M2(:,2:12);

n=8;

# Take sigma=2cm for the DDL2 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
#  -25.85097231271811  -27.02161657198621    3.15537810987280

# bsl_enu =[-27.4170 -26.2341 -0.0304]

x(1:3)-bsl_enu'
#   1.566027687281888
#  -0.787516571986213
#   3.185778109872800



#  3) Apply the LAMBDA method to FIX the ambiguities.
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding
#         the solution after decorrelation.
#
#      The following procedure can be applied:

# .........................................
# 3.1) Ambiguities fixed by rounding directly
#    the floated solution:

 round(a)'

# -5 -13   6   7  -9   4   4   4
# ........................................

# 3.2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

c=299792458;
f0=10.23e+6;
f2=120*f0;
lambda2=c/f2
a=x(4:11)/lambda2;
Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);

 afix=iZ*round(az);
 afix'

#  3   2   9 -27  13 -32 -13 -35
# ........................................

# 3.3) Ambiguities fixed from the LS integer
#    search

 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans = 1.00508811343751

 afixed(:,1)'

# -3   7  -6  13  -3  19  -3  24
# .......................................

exit

######################## END OCTAVE #############################

#  Questions:
#  ----------
#
# 1.- Can the ambiguities be well fixed?
# 2.- Is the test resolutive.
# 3.- Compare the fixed ambiguities with those obtained
#     in the previous exercises when fixing the ambiguities
#     one at a time. Are the same results found?
# 4.- What is the elapsed time to needed fix the
#     ambiguities? And in the previous exercise when
#     fixing the ambiguities one at a time?
# 5.- The values found for the ambiguities are the same
#     than in the previous case?


# Cleaning temporary files in the directory:
rm M2.dat DD_UPC1_UPC2_06_ALL.fixL1L2  L1L2noise.dat DD_UPC1_UPC2_06_19.dat  UPC2.obs M1.dat  sat.ambL1L2 P1P2noise.dat DD_UPC1_UPC2_06_18.dat  UPC1.obs DDN1.dat DDN1N2.dat DD_UPC1_UPC2_06_16.dat L1fix.pos DD_UPC1_UPC2_06_ALL.dat  DD_UPC1_UPC2_06_07.dat L1model.dat  DDNws.dat DD_UPC1_UPC2_06_24.dat DD_UPC1_UPC2_06_03.dat L2fix.pos DDNws.tmp DD_UPC1_UPC2_06_22.dat obs.dat L2model.dat  DDNw.dat DD_UPC1_UPC2_06_21.dat ObsFile.dat DDN1_PRN24
