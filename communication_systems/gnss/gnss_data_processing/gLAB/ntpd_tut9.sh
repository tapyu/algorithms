# TUTORIAL 9: Differential Positioning and
#             Carrier Ambiguity Fixing
#==========================================

# Create the Working directory and copy Programs and Files
# into this directory.

mkdir ./WORK 2> /dev/null
mkdir ./WORK/TUT9
mkdir ./WORK/TUT9/FIG


# Go to the working directory:
cd ./WORK/TUT9


#PROGRAM FILES
#-------------
cp ../../PROG/TUT9/* .
if [[ $(uname -s) =~ "CYGWIN" ]]
then
  cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
fi



#DATA FILES
#----------
cp ../../FILES/TUT9/* .

gzip -df *.gz



# ========================
# PRELIMINARY computations
# ========================



# P.1. Computate the reference values for the receivers coordinates:
#====================================================================

# P.1.1 Using gLAB and precise orbits and clocks, compute the PPP solution 
# ----- for the precise coordinates of the Antenna Phase Centre of receivers
#       PLAN, GARR, INDR1, INDR2, INDR3
#    
#    Files: igs17286.sp3, igs17286.clk, igs08_1719.atx.
#
#          Note: the values of "APPROXIMATE COORDINATES" written in RINEX files
#                correspond to the precise APC of LC coordinates.
#
#    Assume the APC for L1 and LC are the same.
   



# APC coordinates computation
# .........................
#
#   The following procedure can be applied:

./gLAB_linux -input:cfg gLAB_2files_APC.cfg  -input:obs PLAN0540.13O -input:orb igs17286.sp3 -input:clk igs17286.clk -input:ant igs08_1719.atx
grep OUTPUT gLAB.out | tail -1|gawk '{print "PLAN",$6,$7,$8,$15,$16,$17}' >> sta.pos

./gLAB_linux -input:cfg gLAB_2files_APC.cfg  -input:obs GARR0540.13O -input:orb igs17286.sp3 -input:clk igs17286.clk -input:ant igs08_1719.atx
grep OUTPUT gLAB.out | tail -1|gawk '{print "GARR",$6,$7,$8,$15,$16,$17}' >> sta.pos

./gLAB_linux -input:cfg gLAB_2files_APC.cfg  -input:obs IND10540.13O -input:orb igs17286.sp3 -input:clk igs17286.clk -input:ant igs08_1719.atx
grep OUTPUT gLAB.out | tail -1|gawk '{print "IND1",$6,$7,$8,$15,$16,$17}' >> sta.pos

./gLAB_linux -input:cfg gLAB_2files_APC.cfg  -input:obs IND20540.13O -input:orb igs17286.sp3 -input:clk igs17286.clk -input:ant igs08_1719.atx
grep OUTPUT gLAB.out | tail -1|gawk '{print "IND2",$6,$7,$8,$15,$16,$17}' >> sta.pos

./gLAB_linux -input:cfg gLAB_2files_APC.cfg  -input:obs IND30540.13O -input:orb igs17286.sp3 -input:clk igs17286.clk -input:ant igs08_1719.atx
grep OUTPUT gLAB.out | tail -1|gawk '{print "IND3",$6,$7,$8,$15,$16,$17}' >> sta.pos


# Plot the results (North, East, Up errors):


./graph.py -f gLAB.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "Up error" --yn -.5 --yx .5 --xl "time (s)" --yl "error (m)"  -t "PPP" --sv FIG/Tu6_exP1.png



#Results:
#------

more sta.pos

# PLAN 4787328.7916 166086.0719 4197602.8893 41.418528940 1.986956885 320.0721
# GARR 4796983.5170 160309.1774 4187340.3887 41.292941948 1.914040816 634.5682
# IND1 4787678.1496 183409.7131 4196172.3056 41.403026173 2.193853893 109.5681
# IND2 4787678.9809 183402.5915 4196171.6833 41.403018646 2.193768411 109.5751
# IND3 4787689.5146 183392.8859 4196160.1653 41.402880392 2.193647610 109.5743


#    Question:
#    ---------
#     What is the expected accuracy of the computed coordinates?


# P.1.2.- Using octave, compute the baseline length between the different receivers:
# ...........................

########################## OCTAVE or MATLAB ####################
#Execute for instance (you can use either octave or MATLAB):

octave

IND1=[ 4787678.1496 183409.7131 4196172.3056 ]
IND2=[ 4787678.9809 183402.5915 4196171.6833]

norm(IND1-IND2,2)
#ans =  7.1969

exit
###################### END OCTAVE ##############################


# Results:
#--------

# IND1-IND2:     7.197 m
# IND2-IND3:    18.380 m 
# IND1-IND3:    23.658 m 
# PLAN-GARR:  15.228 km
# PLAN-IND1:  17.386 km
# IND1-GARR:  26.424 km





# P.2.- MODEL COMPONENTS COMPUTATION
# ==================================

# The script "ObsFile.scr" generates a data file with the following content

#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 rho Trop Ion elev azim]



# 1.- Run this script for all the receivers:

./ObsFile.scr PLAN0540.13O brdc0540.13n
./ObsFile.scr GARR0540.13O brdc0540.13n
./ObsFile.scr IND10540.13O brdc0540.13n
./ObsFile.scr IND20540.13O brdc0540.13n
./ObsFile.scr IND30540.13O brdc0540.13n

# Merge all files in a single file:

 cat ????.obs > ObsFile.dat


# 2.- Select the satellites with elevation over 10deg within the time interval 
#       [14500:16500]

cat ObsFile.dat|gawk '{if ($4>=14500 && $4<=16500 && $12>10) print $0}' >obs.dat



# 3.- Confirm that the satellite PRN06 is the satellite with the highest 
#       elevation (this satellite will be used as the reference satellite).


# ------------------- obs.dat -----------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 rho Trop Ion elev azim]
# ----------------------------------------------------




#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION A //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

# =========
# SESSION A: Differential positioning between the receivers: IND2- IND3
# =========


# A.1 Double-Differences computation
# ==================================
#
#  Using the previously generated file "obs.dat", compute the Double Differences
#  of measurements between the receivers "IND2" (reference) and IND3, and the satellites
#  PRN06 (reference) and [PRN 03, 07, 11, 16, 18, 19, 21, 22, 30]
#
#
#  The following procedure can be applied:
#
#  The script "DDobs.scr" computes the double differences between receivers and
#   satellites.
#  
#  For instance, the following sentence, generates the file (among other files):
#
#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10    11   12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------
#
#
# Where:
#  The elevation and azimuth correspond to the satellites in view from station 2
#    El1 Az1 are for satellite 1
#    El2 Az2 are for satellite 2



# Compute the double differences between the receivers "IND2" (reference) and IND3# and the satellites PRN06 (reference) and [PRN 03, 07, 11, 16, 18, 19, 21, 22, 30]

./DDobs.scr obs.dat IND2 IND3 06 03
./DDobs.scr obs.dat IND2 IND3 06 07
./DDobs.scr obs.dat IND2 IND3 06 11
./DDobs.scr obs.dat IND2 IND3 06 16
./DDobs.scr obs.dat IND2 IND3 06 18
./DDobs.scr obs.dat IND2 IND3 06 19
./DDobs.scr obs.dat IND2 IND3 06 21
./DDobs.scr obs.dat IND2 IND3 06 22
./DDobs.scr obs.dat IND2 IND3 06 30

# Merge the files in a single file and sort by time:

cat DD_IND2_IND3_06_??.dat|sort -n -k +6 > DD_IND2_IND3_06_ALL.dat


#-----------------------------------------------------------------------------------
#OUTPUT file: 
#
#[IND2 IND3 06 PRN DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                  PRN06   PRNXX
#                                                                 <-- from IND2 -->
#-----------------------------------------------------------------------------------




# A.2 Baseline Estimation (IND2-IND3 receivers)
# =============================================

# Using "octave" and the receiver's coordinates estimated before, compute the 
# baseline vector between IND2 and IND3. Give the results in ENU system.


# Hint:
#------

########################## OCTAVE ##############################
#Execute for instance:

octave

#output_precision(3)
format long
 IND2=[4787678.9809 183402.5915 4196171.6833]
 IND3=[4787689.5146 183392.8859 4196160.1653]

 IND3-IND2
#   [10.5337  -9.7056 -11.5180]

#IND3 (latitude and longitude):
 l=2.193647610*pi/180
 f=41.402880392*pi/180

R=[-sin(l) cos(l) 0; -cos(l)*sin(f) -sin(l)*sin(f) cos(f); cos(l)*cos(f) sin(l)*cos(f) sin(f)]
bsl_enu=R*(IND3-IND2)'

#bsl_enu =[-10.1017 -15.3551 -0.0008]

exit
####################### END OCTAVE ###############################




# A.2.1.- Baseline vector estimation using P1 code measurements:
#-----------------------------------------------------------

# Estimate the baseline vector between IND2 and IND3 receivers using the code 
# measurements of file (DD_IND2_IND3_06_ALL.dat).  
# Use the entire file (i.e. time interval [14500:16500])


# Questions:
# ----------

# 1) Justify that the next sentence allows to build the equations system:

#    [DDP1]=[Los_k-Los_06]*[baseline]

cat DD_IND2_IND3_06_ALL.dat | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$7,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


#  Note: 
#     - The first column of "M.dat" file corresponds to "DDP1" (i.e. to the 
#       measurements DD).
#     - The other three columns correspond to the Geometry matrix 
#       "[Los_k-Los_06]".


# Solve the equations system using octave and assess the estimation error:


#Solution:
#---------
########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
x(1:3)'
# -10.290863988521810  -15.385561719991301   -0.651068411484908

bsl_enu =[-10.1017 -15.3551 -0.0008]

x(1:3)-bsl_enu'
#  -0.1891639885218108
#  -0.0304617199913011
#  -0.6502684114849081

exit
######################### END OCTAVE #############################



# A.2.2  Repeat the previous computation, but using just the two epochs: 14500 
# -----  and 14515.


#Solution:
#---------

# a) Select the two epochs:

cat DD_IND2_IND3_06_ALL.dat|gawk '{if ($6==14500||$6==14515) print $0}' > tmp.dat

# b) Build the navigation system:

cat tmp.dat| gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$7,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
x(1:3)'
#  -10.95246374869830  -14.73629676316433  -1.77796717481061

bsl_enu =[-10.1017 -15.3551 -0.0008]

x(1:3)-bsl_enu'
#  -0.850763748698302
#   0.618803236835673
#  -1.777167174810606

exit
######################## END OCTAVE #############################


# Questions:
# -----------
#
#  1.- What is the level of accuracy?
#  2.- Why does the solution degrade when taking only two epochs?





# A.3. Baseline vector estimation using L1 carrier measurements
# =============================================================

# Estimate the baseline vector between IND2 and IND3 receivers using the 
# L1 carrier measurements of file (DD_IND2_IND3_06_ALL.dat).
# Consider only the two epochs used in the previous exercise: t1=14500s and 
# t2=14515s.


# The following procedure can be applied:

# A.3.1. Compute the Baseline solution:
# ------

# In the previous computation we have not taken into account the correlations
# between the double differences of measurements. This matrix will be used now,
# as the LAMBDA method will be applied to FIX the carrier ambiguities.
#
# a) Show that the covariance matrix of DDL1 is given by:
#
#            [2 1 1 ... 1]
#            [1 2 1 ... 1]
#       Py=  [1 1 2 ... 1]
#            [   .....   ]
#            [1 1 1 ... 2]
#
#
# b) Generate the measurement vectors and matrices for the selected epochs t1,t2
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
#
#    [DDL1]=[Los_k-Los_06]*[baseline] + [ A ]*[lambda1*DDN1]
#
#    for the two required epochs t1=14500 and t2=14515,  using 
#    the input file "DD_IND2_IND3_06_ALL.dat" generated before.
#
#   ============================================================
#   Execute:

      ./MakeL1BslMat.scr DD_IND2_IND3_06_ALL.dat 14500 14515

#   ============================================================
#  
#   The OUTPUT are the files "M1.dat" and "M2.dat" associated with 
#   each epoch.
# 
#     Example: 
#     --------
#
#          [DDL1]    [  Los_k-Los_REF]   [     A     ]
#          ------    --------------------    -------------
#         -3.3762    0.3398 -0.1028 0.0714   1 0 0 0 0 0 0
#         -7.1131    0.1725  0.5972 0.0691   0 1 0 0 0 0 0
#          4.3881   -0.6374  0.0227 0.2725   0 0 1 0 0 0 0         t=t1
#         -5.6982    0.6811 -0.1762 0.3022   0 0 0 1 0 0 0   <===> M1.dat
#          9.4853   -0.6876 -0.2881 0.5093   0 0 0 0 1 0 0
#         -5.2016   -0.4148  0.6119 0.1935   0 0 0 0 0 1 0
#        -16.8894   -0.0264  1.0181 0.4078   0 0 0 0 0 0 1
#
#
#         -3.3709    0.3398 -0.1031 0.0707   1 0 0 0 0 0 0
#         -7.1438    0.1739  0.5982 0.0701   0 1 0 0 0 0 0
#          4.4156   -0.6356  0.0199 0.2729   0 0 1 0 0 0 0         t=t2
#         -5.6819    0.6814 -0.1776 0.3012   0 0 0 1 0 0 0   <===> M2.dat
#          9.4911   -0.6868 -0.2891 0.5109   0 0 0 0 1 0 0
#         -5.1689   -0.4133  0.6090 0.1927   0 0 0 0 0 1 0
#        -16.9101   -0.0248  1.0183 0.4097   0 0 0 0 0 0 1
#  ----------------------------------------------------------------------




# c) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    c.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    c.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    c.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    c.4) Compute the FIXED solution.



# Solution:
# ---------
########################## OCTAVE ##############################
#Execute for instance:

# c.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done)

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
#   -8.946290850626383  -15.910175771706690   -0.786356288049205

bsl_enu =[-10.1017 -15.3551 -0.0008]

x(1:3)-bsl_enu'
#   1.155409149373616
#  -0.555075771706690
#  -0.785556288049205




# c.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied
#      (justify the computations done):

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)
# ans =  3.31968973623500

# 1) Ambiguities fixed from the LS integer
#    search:

 afixed(:,1)'

#   -8   20   -9   -8  -10    0   -8
 
# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#   -8   20   -9   -8  -10    0   -8

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#  -10   21   -4  -11   -4    5   -3


# Save the fixed ambiguities from the LS
# integer search in file "ambL1.dat" to 
# compute the FIXED solution.

amb=lambda1*afixed(:,1);
save ambL1.dat amb

exit
######################## END OCTAVE #############################




# c.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.

# Saving the FIXED ambiguities:
# ------
#
#  Using the previous files "ambL1.dat" and "DD_IND2_IND3_06_ALL.dat",
#  generate a file with the following content:


#----------------------------  DD_IND2_IND3_06_ALL.fix -------------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17     18
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2 lambda*DDN1]
#                                                                     <--- sta2 --->
#------------------------------------------------------------------------------------------------


# Note: This file is identical to file "DD_IND2_IND3_06_30.dat", but with the 
# ambiguities added in the last field #18. 
 

# The following procedure can be applied:

# 1) Generate a file with the satellite PRN number and the ambiguities:

grep -v \# ambL1.dat > na1
cat DD_IND2_IND3_06_ALL.dat | gawk '{print $4}' | sort -nu | gawk '{print $1,NR}' > sat.lst
paste sat.lst na1 > sat.ambL1


# 2) Generate the "DD_IND2_IND3_06_30.fix" file:

cat DD_IND2_IND3_06_ALL.dat |gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL1";A[$1]=$3}}{printf "%s %02i %02i %s %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,A[$4]}' > DD_IND2_IND3_06_ALL.fixL1


# 3) Make the following plots and discuss the results: 

./graph.py -f DD_IND2_IND3_06_ALL.fixL1 -x6 -y'($8-$18-$11)' -so --yn -0.06 --yx 0.06 -l "(DDL1-DDN1)-DDrho" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exA.3.1a.png

./graph.py -f DD_IND2_IND3_06_ALL.fixL1 -x6 -y'($8-$11)' -so --yn -5 --yx 5 -l "(DDL1-DDRho)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exA.3.1b.png

./graph.py -f DD_IND2_IND3_06_ALL.fixL1 -x6 -y'($8-$18)' -so --yn -20 --yx 20 -l "(DDL1-DDN1)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exA.3.1c.png


# Questions:
# ----------
#  Expalin what is the meaning of each plot?



# c.4) Compute the FIXED solution.
# -------------------------------
#
#  Remove the ambiguities on L1 carrier and compute the FIXED SOLUTION:

# 1) Build the equations system:

# [DDL1-Lambda*DDN1]=[Los_k-Los_06]*[baseline]

cat DD_IND2_IND3_06_ALL.fixL1 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$8-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat



# 2) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);
x(1:3)'
#  -1.01144454057522e+01  -1.53615270576494e+01   3.06638285676705e-03

bsl_enu =[-10.1017 -15.3551 -0.0008]

x(1:3)-bsl_enu'
#  -0.01274540575222005
#  -0.00642705764942164
#   0.00386638285676705

exit
######################## END OCTAVE #############################





# A.3.2  Using the DDL1 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 145000< t <165000 with the 
#        program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")
#
#
# The next procedure can be applied:
#
# 1) Generate a file with the following content:
#
#     ["time"  "DDL1-DDRho-Lambda*DDN1"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL1-DDRho-Lambda*DDN1= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_IND2_IND3_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

        cat L1model.dat |./LS > L1fix.pos

# 3) Plot the baseline error: 

#    bsl_enu =[-10.1017 -15.3551 -0.0008]

./graph.py -f L1fix.pos -x1 -y'($2+10.1017)' -s.- -l "North error" -f L1fix.pos -x1 -y'($3+15.3551)' -s.- -l "East error" -f L1fix.pos -x1 -y'($4+0.0008)' -s.- -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "Baseline error: IND2-IND3: 18.38m: L1 ambiguities fixed" --sv FIG/Tu6_exA.3.2.png





# A.3.3  Repeat the previous computation, but using the unsmoothed code 
# -----  measurements.
#
#
# 1) Generate a file with the following content:
#    
#     ["time"  "DDP1-DDRho"  "Los_k-Los_06"]

cat DD_IND2_IND3_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$7-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > P1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

        cat P1model.dat |./LS > P1.pos

# 3) Plot the results:

./graph.py -f P1.pos -x1 -y2 -s.- -l "North error" -f P1.pos -x1 -y3 -s.- -l "East error" -f P1.pos -x1 -y4 -s.- -l "Up error" --yn -5 --yx 5 --xl "time (s)" --yl "error (m)" -t "IND2-IND3: 18.38m: P1 code pseudorange"  --sv FIG/Tu6_exA.3.3.png


# Questions:
# ----------
#  1.- Discuss the results by comparing them with the previous ones computed
#      with DDL1 carrier measurements.
#  2.- Discuss the pattern seen in the plot.






# A.4.  Repeat the computation of exercise A.3, but using the two epochs: 14500 
# =============================================                       and 14600.


# a) The next sentence builds the equations system:
#    [DDP1]=[Los_k-Los_06]*[baseline] + [ A ]*[lambda*DDN1]


     ./MakeL1BslMat.scr DD_IND2_IND3_06_ALL.dat 14500 14600


# b) Solve the equations system using octave and assess the estimation error:

#Solution:
#---------

########################## OCTAVE ##############################
#Execute for instance:

# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied:

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

Py=(diag(ones(1,n))+ones(n))*2*1e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
#   -9.7700067335170075  -15.1862528010743603   -0.0821273504816880

bsl_enu =[-10.1017 -15.3551 -0.0008]

x(1:3)-bsl_enu'
#   0.3316932664829917
#   0.1688471989256399
#  -0.0813273504816880




# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)
# ans = 34.4801936204742

# 1) Ambiguities fixed from the LS integer
#    search
 afixed(:,1)'
#   -8   20   -9   -8  -10    0   -8


# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'
#   -8   20   -9   -8  -10    0   -8


# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'
#   -8   19   -8   -9   -8    0   -9


exit
######################## END OCTAVE #############################

# OPTIONAL:
# Repeat by using the two epochs 14500 and 15000


# Questions:
# ----------
#  1.- Has the accuracy improved?
#  2.- Can the ambiguities be well fixed?
#  3.- Has the reliability improved? Why?







# A.5.- Differential Positioning: Absolute coordinates estimation
# ===============================================================

# Estimate the coordinates of receiver IND3 taking IND2 as a reference station. 
# 
#   Note: assume there is no error in the IND2 coordinates  



# A.5.1 Estimation using P1 code measurements:
# -------------------------------------------

# Estimate the coordinates using the code measurements of file 
# (DD_IND2_IND3_06_ALL.dat). Use the entire file (i.e., time interval 
# [14500:16500])

#----------------------------  DD_IND2_IND3_06_30.dat ------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17  
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2
#                                                                     <--- sta2 --->
#-----------------------------------------------------------------------------------


# Questions:
# ----------
#
# 1) Justify that the next sentence allows to build the equations system:
#
#    [DDP1-DDRho]=[Los_k-Los_06]*[dx]

cat DD_IND2_IND3_06_ALL.dat | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$7-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


# 2) Solve the equations system using octave and assess the estimation error:


# Solution:
#---------

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
x(1:3)'
#  -0.1892084058110140  -0.0304516682557553  -0.6504447633705878


# Taking into account that the "a priori" coordinates of IND3 are:

 IND3=[4787689.5146 183392.8859 4196160.1653]

# thence, the estimated absolute coordinates of IND3 are:

   IND3+ x(1:3)'

#     [4787689.3254  183392.8554  4196159.5149]

exit
######################### END OCTAVE #############################





# A.5.2 Repeat the previous computation, but using just the two epochs: 14500 
# ------                                                            and 14515.

#Solution:
#---------

# a) Select the two epochs:

cat DD_IND2_IND3_06_ALL.dat|gawk '{if ($6==14500||$6==14515) print $0}' >tmp.dat

# b) Build the navigation equations system:

cat tmp.dat| gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;printf "%14.4f %8.4f %8.4f %8.4f \n",$7-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
x'
#  -0.850914928283142   0.619002781048194  -1.778309021185260

# Taking into account that the "a priori" coordinates of IND3 are:

 IND3=[4787689.5146 183392.8859 4196160.1653]

# thence, the estimated absolute coordinates of IND3 are:

   IND3+ x'

#     [4787688.6637  183393.5049 4196158.3870]



exit
######################## END OCTAVE #############################

# Questions:
# ----------
#
#  1.- What is the level of accuracy?
#  2.- Why does the solution degrade when taking only two epochs?





# A.6- Estimation using L1 carrier measurements:
# ==============================================

# Estimate the IND3 using the L1 carrier measurements of file 
# (DD_IND2_IND3_06_ALL.dat). Consider only the two epochs used in the previous
# example: t1= 14500 and t2=14515.


# A.6.1. Compute the floated solution:
# ------

# Note that, as in the previous case (with the baseline vector estimation),
#       we have to take into account that the covariance matrix of DDL1 is given by:
#
#            [2 1 1 ... 1]
#            [1 2 1 ... 1]
#       Py=  [1 1 2 ... 1]
#            [   .....   ]
#            [1 1 1 ... 2]


# The following procedure can be applied:


# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:
#
#    [DDP1-DDRho]=[Los_k-Los_06]*dx + [ A ]*[lambda*DDN1]
#
#
#    Indeed, as in the previous case, it generates the measurement 
#    vectors and matrices for each one of the selected epochs:
#
#    y1:=y[t1]   G1:=G[t1]   Py
#    y2:=y[t2]   G2:=G[t2]   Py
#
#    Merge the two vectors and matrices into a common system and show
#    that the solution is given by:
#
#     P=inv(G1'*W*G1+G2'*W*G2);
#     x=P*(G1'*W*y1+G2'*W*y2)
#
#     where: w=inv(Py)



#     The script "MakeL1DifMat.scr" builds the equations system 
#     to estimate coordinates of a receiver regarding to a 
#     reference station, using the double differenced L1 measurements.
# 
#      [DDL1-DDRho]=[Los_k-Los_06]*[dx] + [ A ]*[lambda1*DDN1]
#
#     for the two epochs required t1=14500 and t2=14515,  using 
#     the input file "DD_IND2_IND3_06_ALL.dat" generated before.
#
#     ===========================================================
#     Execute:

      ./MakeL1DifMat.scr DD_IND2_IND3_06_ALL.dat 14500 14515

#     ===========================================================
#
#     Only observations of "two epochs" are considered. The output
#     are the files M1.dat and M2.dat associated with each epoch.
#      
# 
#     Example: 
#     --------
#
#    [DDL1-DDRho] [  Los_k-Los_REF]       [    A     ]
#         ------  --------------------    -------------
#        -1.5228  0.3398 -0.1028  0.0714   1 0 0 0 0 0 0
#        -4.0023  0.1725  0.5972  0.0691   0 1 0 0 0 0 0
#        -1.7016 -0.6374  0.0227  0.2725   0 0 1 0 0 0 0        t=t1
#        -1.5234  0.6811 -0.1762  0.3022   0 0 0 1 0 0 0  <===> M1.dat
#        -1.8847 -0.6876 -0.2881  0.5093   0 0 0 0 1 0 0
#         0.0045 -0.4148  0.6119  0.1935   0 0 0 0 0 1 0
#        -1.5229 -0.0264  1.0181  0.4078   0 0 0 0 0 0 1
#
#        -1.5215  0.3398 -0.1031  0.0707   1 0 0 0 0 0 0
#        -4.0029  0.1739  0.5982  0.0701   0 1 0 0 0 0 0
#        -1.6996 -0.6356  0.0199  0.2729   0 0 1 0 0 0 0        t=t2
#        -1.5258  0.6814 -0.1776  0.3012   0 0 0 1 0 0 0  <===> M2.dat
#        -1.8860 -0.6868 -0.2891  0.5109   0 0 0 0 1 0 0
#         0.0073 -0.4133  0.6090  0.1927   0 0 0 0 0 1 0
#        -1.5252 -0.0248  1.0183  0.4097   0 0 0 0 0 0 1 
#
#  -----------------------


# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.



# Solution:
# ---------
########################## OCTAVE ##############################
#Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals)

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
#   0.948357327146866  -0.329868752234546  -0.899617318639869

# Taking into account that the "a priori" coordinates of IND3 are:

 IND3=[4787689.5146 183392.8859 4196160.1653]

# thence, the absolute estimated coordinates of IND3 are:

   IND3+ x(1:3)'

#     [4787690.4630   183392.5560  4196159.2657]



# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied
#      (justify the computations done):

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)

# ans = 4.43344394778937

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#   -8   20   -9   -8  -10    0   -8
 
# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#   -8   20   -9   -8  -10    0   -8

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#  -10   20   -4  -10   -5    4   -4

exit
######################## END OCTAVE #############################

# Questions:
# ----------

#  1.- Can the ambiguities be well fixed?
#  2.- Has the reliability improved? Why?
#  3.- The values found for the ambiguities are the same than in the previous cases?


# b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#      ambiguities and plot the results to analyse the data.


#  The ambiguities do no change. Thence, the file "DD_IND2_IND3_06_ALL.fixL1"
#  generated in the previous exercise can be used here.




# b.4) Compute the FIXED solution.
# -------------------------------
#
#  Remove the ambiguities on L1 carrier and compute the FIXED SOLUTION:

#    Note: As the same values of the ambiguities do no change, the file 
#          "DD_IND2_IND3_06_ALL.fix" generated in the previous exercise 
#           can be used here.

# 1) Build the equations system:

# [DDL1-DDRho-Lambda*DDN1]=[Los_k-Los_06]*dx

cat DD_IND2_IND3_06_ALL.fixL1 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$8-$11-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat



# 2) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);

x
#  -0.01278982304138015
#  -0.00641700591386930
#   0.00369003097108713

# Taking into account that the "a priori" coordinates of IND3 are:

 IND3=[4787689.5146 183392.8859 4196160.1653]

# thence, the absolute estimated coordinates of IND3 are:

   IND3+ x'

#     [4787689.5018  183392.8795  4196160.1690]

exit
######################## END OCTAVE #############################

# Questions:
# ----------

#  Is the accuracy similar to that in the previous case, when estimating the 
#  baseline vector?



# A.6.2  Using the DDL1 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 145000< t <165000 with the 
#        program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")


# The next procedure can be applied:

# 1) Generate a file with the following content:
#
#     ["time"  "DDL1-DDRho-Lambda*DDN1"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL1-DDRho-Lambda*DDN1= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_IND2_IND3_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat L1model.dat |./LS > L1fix.pos

# 3) Plot the results:

./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y4 -s.- -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "IND2-IND3: 18.38m: L1 ambiguities fixed" --sv FIG/Tu6_exA.6.2.png



# Question:
# ---------

# Compare this plot with that obtained previously when estimating the baseline
# for the time tagged measurements. Are the errors similar? 





#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION B //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

 

# ========
# SESSION B: Differential positioning between the receivers: IND1- IND2
# =========


# B.1 Using the previous generated obs.dat file, compute the Double Differences 
#     of measurements between the receivers "IND1" (reference) and IND2, and 
#     the satellites PRN06 (reference) and [PRN 03, 07, 11, 16, 18, 19, 21, 22, 30]


# ------------------- obs.dat -----------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 rho Trop Ion elev azim]
# ----------------------------------------------------


./DDobs.scr obs.dat IND1 IND2 06 03
./DDobs.scr obs.dat IND1 IND2 06 07
./DDobs.scr obs.dat IND1 IND2 06 11
./DDobs.scr obs.dat IND1 IND2 06 16
./DDobs.scr obs.dat IND1 IND2 06 18
./DDobs.scr obs.dat IND1 IND2 06 19
./DDobs.scr obs.dat IND1 IND2 06 21
./DDobs.scr obs.dat IND1 IND2 06 22
./DDobs.scr obs.dat IND1 IND2 06 30

cat DD_IND1_IND2_06_??.dat | sort -n -k +6 > DD_IND1_IND2_06_ALL.dat



#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10   11    12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------


# Where the elevation and azimuth correspond to the satellites in view from station 2
#   El1 Az1 are for satellite 1
#   El2 Az2 are for satellite 2




# B.2. Baseline Estimation  (IND1-IND2 receivers)
# ===============================================

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
IND1 =[4787678.1496 183409.7131 4196172.3056]
IND2 =[4787678.9809 183402.5915 4196171.6833]

 IND2-IND1

#   [0.8313  -7.1216 -0.6223]

# IND2

l= 2.193768411*pi/180
f=41.403018646*pi/180

R=[-sin(l) cos(l) 0; -cos(l)*sin(f) -sin(l)*sin(f) cos(f); cos(l)*cos(f) sin(l)*cos(f) sin(f)]
bsl_enu=R*(IND2-IND1)'

bsl_enu 

#  -7.14820191547364026
#  -0.83586080226970338
#   0.00704514602203794

bsl_enu=[-7.1482 -0.8359 0.0070]

exit
####################### END OCTAVE ###############################



# B.3  Baseline vector estimation using L1 carrier measurements:
# ==============================================================
#
# Estimate the baseline vector between IND1 and IND2 receivers using the 
# L1 carrier measurements of file (DD_IND2_IND3_06_ALL.dat).
# Consider only the next two epochs: t= 14500 and 14515.

# Apply the same procedure as in the previous exercises:


# B.3.1. Compute the floated solution:
# ------

# a) Generate the measurement vectors and matrices for the selected epochs t1,t2
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


#    As in the previous cases, the next sentence builds the equations system:
#    [DDL1]=[Los_k-Los_06]*[baseline] + [ A ]*[lambda*DDN1]


#   ===========================================================
#   Execute:

      ./MakeL1BslMat.scr DD_IND1_IND2_06_ALL.dat 14500 14515

#   ===========================================================


# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.



# Solution:
# ---------

########################## OCTAVE ##############################
#Execute for instance:

# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2*1e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'

#  -8.88829839000042  -2.21873539816317   2.49984694674982

bsl_enu=[-7.1482 -0.8359 0.0070]

x(1:3)-bsl_enu'

#  -1.74009839000042
#  -1.38283539816317
#   2.49284694674982


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied

 c=299792458;
 f0=10.23e+6;
 f1=154*f0;
 lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)

# ans = 1.61389475957901

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#    17   -5   -2    4  -26    0   13

# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#    7  -22   16  -18   -3    1   -8
# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#   10  -11   13  -10   -8    7   10

exit
######################## END OCTAVE #############################

# Questions:
# ----------

# 1.- Can the ambiguities be fixed? 
# 2.- Give a possible explanation about why the ambiguities cannot be fixed.



# B.3.2. Repeat the previous exercise, but taking the two epochs t=14500, 14530
#--------

# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:

#   Execute:

      ./MakeL1BslMat.scr DD_IND1_IND2_06_ALL.dat 14500 15530



# b) Solve the equations system using octave and assess the estimation error:

# Solution:
# ---------
########################## OCTAVE ##############################
#Execute for instance:

# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

Py=(diag(ones(1,n))+ones(n))*2*1e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'
#  -6.786796092683265  -0.779435044890027  -0.243417394430031

bsl_enu=[-7.1482 -0.8359 0.0070]

x(1:3)-bsl_enu'

#   0.3614039073167348
#   0.0564649551099727
#  -0.2504173944300306


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied

 c=299792458;
 f0=10.23e+6;
 f1=154*f0;
 lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)

# ans=  1.10192131979339
# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#   9  -16   22  -10    7    9    9

# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#   8  -17   24  -12    9   10    8

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#  8  -17   24  -12    9   10    9

exit
######################## END OCTAVE #############################

# Questions:
# ----------

# 1.- Can the ambiguities be fixed? 
# 2.- Give a possible explanation about why the ambiguities cannot be fixed.




# B.3.3  Repeat the computation 3.3.2, but using the two epochs 14500 and 15000.
# ------

# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:
#
#   Execute:

      ./MakeL1BslMat.scr DD_IND1_IND2_06_ALL.dat 14500 15000


# b) Solve the equations system using octave and assess the estimation error:

# Solution:
# ---------
########################## OCTAVE ##############################
#Execute for instance:

# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

Py=(diag(ones(1,n))+ones(n))*2*1e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2)

x(1:3)'
#  -6.764000261578562  -0.744123708435019  -0.225573230582042

bsl_enu=[-7.1482 -0.8359 0.0070]

x(1:3)-bsl_enu'
#   0.3841997384214384
#   0.0917762915649808
#  -0.2325732305820420


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)

# ans = 1.36905617725904

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#    9  -16   22  -10    7    9    9

# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#    7  -18   26  -14   12   11    8

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#    8  -17   24  -12    9   10    9

exit
######################## END OCTAVE #############################

# OPTIONAL:
# Repeat considering 14500 and 17000


# Questions:
# ----------
# 1.- Have the results improved?
# 2.- Has the reliability improved?
# 3.- Why is not possible to fix the ambiguities?


# Hint:
# -----
# Check possible synchronism error between the receivers' time tags.

# For instance, use the following sentence to compute the receiver clocks of 
#  IND1, IND2 and IND3 receivers with gLAB (the last field is the receiver 
#  clock offset):

./gLAB_linux -input:obs IND10540.13O -input:nav brdc0540.13n -pre:dec 1 | grep FILTER | more
./gLAB_linux -input:obs IND20540.13O -input:nav brdc0540.13n -pre:dec 1 | grep FILTER | more
./gLAB_linux -input:obs IND30540.13O -input:nav brdc0540.13n -pre:dec 1 | grep FILTER | more


# Questions:
# ----------
#
# Discuss how the relative receiver clock offset can affect the baseline 
# estimation.






# B.4 Differential Positioning: Absolute coordinates estimation
# =============================================================

# Estimate the coordinates of receiver IND2 taking IND1 as a reference station.
#
#   Note: assume there is no error in the IND1 coordinates


#  Estimate the coordinates using the code measurements of file 
#  (DD_IND2_IND3_06_ALL.dat).

#----------------------------  DD_IND1_IND2_06_30.dat ------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2
#                                                                     <--- sta2 --->
#-----------------------------------------------------------------------------------


# Applying the same procedure as in the previous cases, estimate the IND2 
# coordinates using the L1 carrier measurements of file (DD_IND1_IND2_06_ALL.dat).
# Consider only the two epochs: t1= 14500 and t2=14530.



# B.4.1. Compute the FLOATED and the FIXED solutions:
# ------
#
#
# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:
#
#    [DDP1-DDRho]=[Los_k-Los_06]*dx + [ A ]*[lambda*DDN1]

#   The following procedure can be applied:
#
#    As in the previous exercise,
#     The script "MakeL1DifMat.scr" builds the equations system 
#     to estimate coordinates of a receiver regarding to to a 
#     reference station, using the double differenced L1 measurements.
# 
#      [DDL1-DDRho]=[Los_k-Los_06]*[dx] + [ A ]*[lambda1*DDN1]
#
#     for the two epochs required t1=14500 and t2=14530, using 
#     the input file "DD_IND2_IND3_06_ALL.dat" generated before.
#
#     Note: Now the "DDRho" is subtracted to the DDL1.
#
#     =====================================================
#     Execute:

      ./MakeL1DifMat.scr DD_IND1_IND2_06_ALL.dat 14500 14530

#     =====================================================


# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.


#  Solution:
#  ---------
########################## OCTAVE ##############################
#Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:11);

y2=M2(:,1);
G2=M2(:,2:11);

n=7;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'

#  0.313158166944191  -0.264769042330002   0.623703284458336

# Taking into account that the "a priori" coordinates of IND2 are:

IND2=[ 4787678.9809 183402.5915 4196171.6833]

# thence, the absolute estimated coordinates of IND2 are:

   IND2 + x(1:3)'

#     [4787679.2940  183402.3267  4196172.3070]


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#       Compare the results with the solution obtained by
#       rounding the floated solution.
#      The following procedure can be applied:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:10)/lambda1;
 Q=P(4:10,4:10);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans =  2.25895684415922

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#  9  -17   22  -10    6   10    7

# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

#  9  -17   22  -10    6   10    7

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#   8  -17   22  -12    5   11    7


# Save the fixed ambiguities from the LS
# integer search in file "ambL1.dat" to 
# compute the FIXED solution next.

 amb=lambda1*afixed(:,1);
 save ambL1.dat amb

exit
######################## END OCTAVE #############################


# Questions:
# ----------
# 1.- Can the ambiguities be fixed now? Why?
# 2.- Discuss how the synchronism errors affect the two differential 
#     positioning implementations.




# b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#      ambiguities and plot the results to analyse the data.

# Save the FIXED ambiguities:
# ------
#
#  Using the previous files "sat.ambL1" and "DD_IND1_IND2_06_ALL.dat",
#  generate a file with the following content:
#
#

#----------------------------  DD_IND1_IND2_06_ALL.fixL1 -------------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17     18
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2 lambda*DDN1]
#                                                                     <--- sta2 --->
#------------------------------------------------------------------------------------------------

# Note: This file is identical to file "DD_IND1_IND2_06_ALL.dat", but with the 
#       ambiguities added in the last field #18.


# The following procedure can be applied:

# 1) Generate a file with the satellite PRN number and the ambiguities:

grep -v \# ambL1.dat > na1
cat DD_IND1_IND2_06_ALL.dat | gawk '{print $4}' | sort -nu | gawk '{print $1,NR}' > sat.lst
paste sat.lst na1 > sat.ambL1

# 2) Generate the "DD_IND2_IND3_06_30.fix" file.

cat DD_IND1_IND2_06_ALL.dat |gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL1";A[$1]=$3}}{printf "%s %02i %02i %s %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,A[$4]}' > DD_IND1_IND2_06_ALL.fixL1


# 3) Make the following plots and discuss the results.

./graph.py -f DD_IND1_IND2_06_ALL.fixL1 -x6 -y'($8-$18-$11)' -so --yn -0.06 --yx 0.06 -l "(DDL1-DDN1)-DDrho" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exB.4.1a.png

./graph.py -f DD_IND1_IND2_06_ALL.fixL1 -x6 -y'($8-$11)' -so --yn -5 --yx 5 -l "(DDL1-DDRho)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exB.4.1b.png

./graph.py -f DD_IND1_IND2_06_ALL.fixL1 -x6 -y'($8-$18)' -so --yn -10 --yx 10 -l "(DDL1-DDN1)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exB.4.1c.png


# Questions:
# ----------
#
# Explain what is the meaning of each plot?




# b.4) Compute the FIXED solution.
# -------------------------------
#
#  Remove the ambiguities on L1 carrier and compute the FIXED SOLUTION:

# 1) Build the equations system:

# [DDL1-DDRho-Lambda*DDN1]=[Los_k-Los_06]*[dx]

cat DD_IND1_IND2_06_ALL.fixL1 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$8-$11-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat



# 2) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);
x(1:3)'
#  0.01182339916366036   0.00164435938676216  -0.00799007795850631

# Taking into account that the "a priori" coordinates of IND2 are:

IND2=[ 4787678.9809 183402.5915 4196171.6833]

# thence, the absolute estimated coordinates of IND2 are:

   IND2+ x(1:3)'

#  [ 4787678.9927 183402.5931 4196171.6753]

exit
######################## END OCTAVE #############################


# Question:
# --------

# Is the accuracy similar than in the previous case, when estimating the 
# baseline vector? Why?


# B.4.2  Using the DDL1 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 14500< t <16500 with the 
#        program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")
#
# The next procedure can be applied:

# 1) Generate a file with the following content:
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

cat DD_IND1_IND2_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat L1model.dat |./LS > L1fix.pos

# 3) Plot the results:

./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y4 -s.- -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "IND1-IND2: 7.20m: L1 ambiguities fixed" --sv FIG/Tu6_exB.4.2.png


# Question:
# ---------

# Discuss the accuracy achieved and the possible error sources that
# could affect this result (e.g. Antenna Phase Centres...)



# B.4.3  Repeat the previous computation, but using the P1 code 
# -----  measurements:

# 1) Generate a file with the following content:
#
#     ["time"  "DDP1-DDRho"  "Los_k-Los_06"]

cat DD_IND1_IND2_06_ALL.dat | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$7-$11,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > P1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

        cat P1model.dat |./LS > P1.pos

# 3) Plot the results:

./graph.py -f P1.pos -x1 -y2 -s.- -l "North error" -f P1.pos -x1 -y3 -s.- -l "East error" -f P1.pos -x1 -y4 -s.- -l "Up error" --yn -5 --yx 5 --xl "time (s)" --yl "error (m)" -t "IND1-IND2: 7.20m: P1 code pseudorange"  --sv FIG/Tu6_exB.4.3.png

# Question:
# ---------

# Discuss the results by comparing them with the previous ones 
# with the DDL1 carrier in the relative positioning implementation.





# B.4.4  Repeat the previous computation, for the Baseline vector (after 
# -----  removing the carrier ambiguities):


# 1) Generate a file with the following content:
#
#     ["time"  "DDL1-lambda1*DDDN1"  "Los_k-Los_06"]

cat DD_IND1_IND2_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$18,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

        cat L1model.dat |./LS > L1fix.pos

# 3) Plot the results:

# bsl_enu=[-7.1482 -0.8359 0.0070]

./graph.py -f L1fix.pos -x1 -y'($2+7.1482)' -s.- -l "North error" -f L1fix.pos -x1 -y'($3+0.8359)' -s.- -l "East error" -f L1fix.pos -x1 -y'($4-0.0070)' -s.- -l "Up error" --yn -.4 --yx .4 --xl "time (s)" --yl "error (m)" -t "Baseline error: IND1-IND2: 7.20m: L1 ambiguities fixed: synchronism errors" --sv FIG/Tu6_exB.4.4.png


# Questions:
# ----------
#
# Discuss why does the accuracy degrade, respect to to the previous case.
# Why this large error appears?










#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION C //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

# =========
# SESSION C: Differential positioning between the receivers: PLAN-GARR
# =========


# C.1 Double-Differences computation
# ==================================

#  Using the previous generated obs.dat file, compute the Double Differences 
#  of measurements between the receivers "PLAN" (reference) and GARR, and the satellites 
#  PRN06 (reference) and [PRN 03, 07, 11, 16, 18, 19, 21, 22, 30]


# -------------------- obs.dat -----------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 rho Trop Ion elev azim]
# ----------------------------------------------------


./DDobs.scr obs.dat PLAN GARR 06 03
./DDobs.scr obs.dat PLAN GARR 06 07
./DDobs.scr obs.dat PLAN GARR 06 11
./DDobs.scr obs.dat PLAN GARR 06 16
./DDobs.scr obs.dat PLAN GARR 06 18
./DDobs.scr obs.dat PLAN GARR 06 19
./DDobs.scr obs.dat PLAN GARR 06 21
./DDobs.scr obs.dat PLAN GARR 06 22
./DDobs.scr obs.dat PLAN GARR 06 30

cat DD_PLAN_GARR_06_??.dat | sort -n -k +6 > DD_PLAN_GARR_06_ALL.dat



#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10   11    12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------


# Where:
#  The elevation and azimuth correspond to the satellites in view from station 2
#    El1 Az1 are for satellite 1
#    El2 Az2 are for satellite 2



# C.2. Differential Positioning: Absolute coordinates estimation
# ==============================================================


# Estimate the coordinates of receiver GARR taking PLAN as a reference station.
#
# Note: assume there is no error in the PLAN coordinates


# Estimate the coordinates using the code measurements of file (DD_GARR_IND3_06_ALL.dat).

#----------------------------  DD_PLAN_GARR_06_30.dat ------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2
#                                                                     <--- sta2 --->
#-----------------------------------------------------------------------------------


# Applying the same procedure as in the previous cases, estimate the 
# coordinates of GARR receiver using the L1 carrier measurements of file 
# (DD_PLAN_GARR_06_ALL.dat).
# Consider only the two epochs: t1= 14500 and t2=14590.



# C.2.1.  Compute the FLOATED and TRYING TO FIX ambiguities:
# ------

# The following procedure can be applied:

# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:
#
#    [DDP1-DDRho]=[Los_k-Los_06]*dx + [ A ]*[lambda*DDN1]

#   The following procedure can be applied:
#
#    As in the previous exercise,
#     The script "MakeL1DifMat.scr" builds the equations system 
#     to estimate coordinates of a receiver regarding to a 
#     reference station, using the double differenced L1 measurements.
# 
#      [DDL1-DDRho]=[Los_k-Los_06]*[dx] + [ A ]*[lambda1*DDN1]
#
#     for the two epochs required t1=14500 and t2=14590, using 
#     the input file "DD_PLAN_GARR_06_ALL.dat" generated before.
#
#     =======================================================
#     Execute:

      ./MakeL1DifMat.scr DD_PLAN_GARR_06_ALL.dat 14500 14590

#     =======================================================

# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to TRY TO FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#

#  Solution:
#  ---------

########################## OCTAVE ##############################
# Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:13);

y2=M2(:,1);
G2=M2(:,2:13);

n=9;

# Take sigma=2cm for the DDL1 carrier measurement noise.
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'

#   0.687906906707212  -0.271200072020292  -0.792354869190603

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#  [4796984.2049 160308.9062  4187339.5963]


# b.2) Apply the LAMBDA method to TRY TO FIX the ambiguities. 
#      Compare the results with the solution obtained by
#      rounding the floated solution.
#      The following procedure can be applied:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:12)/lambda1;
 Q=P(4:12,4:12);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans =  1.19278115892607 

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

# -19337   130765326    -1759092    -1498083   130765325   130765316   130765339   122888034   130765336


# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

# -19337   130765326    -1759092    -1498083   130765325   130765316   130765339   122888034   130765336


# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

# -19334   130765336    -1759082    -1498083   130765322   130765322   130765338   122888031   130765336

exit
######################## END OCTAVE #############################

# Questions:
# ----------
#
# 1.- Can the ambiguities be fixed with a certain degree of confidence?
# 2.- Repeat the computations taking: t= 14500 and 14900.
# 3.- Repeat the computations taking: t= 14500 and 15900.
# 4.- Discuss why the ambiguities cannot be fixed.


# Hint:
# ====

# Plot the differential Tropospheric and Ionospheric delays (from the gLAB model) and discuss their potential impact on the ambiguity fixing.

./graph.py -f DD_PLAN_GARR_06_ALL.dat -x6 -y'13' -so --cl g --yn -0.06 --yx 0.06 -l "DDIono" -f DD_PLAN_GARR_06_ALL.dat -x6 -y'12' -so --cl r --yn -0.06 --yx 0.06 -l "DDTropo" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exC.2.1.png





# C.3.- Repeat the previous exercise, but correcting the measurements with 
# ==================================  the tropospheric correction model.


# C.3.1. Compute the FLOATED and the FIXED solutions:
# ------
#
#
# a) Generate the measurement vectors and matrices for each one of 
#    the selected epochs to build the navigation equations system:
#
#    [DDP1-DDRho-DDTropo]=[Los_k-Los_06]*dx + [ A ]*[lambda*DDN1]
#
#   NOTE: Now we are using the DD Tropospheric corrections (the nominal 
#         value for the hydrostatic component) to correct the DD measurements.
#
#   The following procedure can be applied:
#
#    As in the previous exercise,
#     The script "MakeL1DifTrpMat.scr" builds the equations system 
#     to estimate coordinates of a receiver regarding to to a 
#     reference station, using the double differenced L1 measurements.
# 
#      [DDL1-DDRho-DDTropo]=[Los_k-Los_06]*[dx] + [ A ]*[lambda1*DDN1]
#
#     for the two epochs required t1=14500 and t2=14530, using 
#     the input file "DD_PLAN_GARR_06_ALL.dat" generated before.
#
#     ========================================================
#     Execute:

      ./MakeL1DifTrpMat.scr DD_PLAN_GARR_06_ALL.dat 14500 14590

#     ========================================================
#
#       NOTE: this new script applies the tropospheric corrections!!
            

# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.


#  Solution:
#  ---------
########################## OCTAVE ##############################
# Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

octave

format long
load M1.dat
load M2.dat

y1=M1(:,1);
G1=M1(:,2:13);

y2=M2(:,1);
G2=M2(:,2:13);

n=9;

# Take sigma=2cm for the DDL1 carrier measurement noise
# (actually, the prefit residuals).

Py=(diag(ones(1,n))+ones(n))*2e-4;
W=inv(Py);

P=inv(G1'*W*G1+G2'*W*G2);
x=P*(G1'*W*y1+G2'*W*y2);

x(1:3)'

# 0.213969991309568  -0.173162326216698   0.153515531681478

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#  [4796983.7310 160309.0042 4187340.5422]


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#       Compare the results with the solution obtained by
#       rounding the floated solution.
#      The following procedure can be applied

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:12)/lambda1;
 Q=P(4:12,4:12);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans =  2.47022808203678

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

#      -19333   130765338    -1759080    -1498083   130765319   130765324   130765334   122888028   130765333


# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

# -19333   130765338    -1759080    -1498083   130765319   130765324   130765334   122888028   130765333


# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

#  -19334   130765336    -1759081    -1498083   130765320   130765323   130765334   122888029   130765334


 amb=lambda1*afixed(:,1);
 save ambL1.dat amb

exit
######################## END OCTAVE #############################

# Questions:
# ----------
# Can the ambiguities be fixed now? Why?



# b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.

# Save the FIXED ambiguities:
# ------
#
#  Using the previous files "sat.ambL1" and "DD_PLAN_GARR_06_ALL.dat",
#  generate a file with the following content:
#
#

#----------------------------  DD_PLAN_GARR_06_ALL.fixL1 -----------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17     18
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2 lambda*DDN1]
#                                                                     <--- sta2 --->
#------------------------------------------------------------------------------------------------

# Note: This file is identical to file "DD_PLAN_GARR_06_30.dat", but with the 
# ambiguities added in the last field #18.


# The following procedure can be applied:

# 1) Generate a file with the satellite PRN number and the ambiguities:

grep -v \# ambL1.dat > na1
cat DD_PLAN_GARR_06_ALL.dat | gawk '{print $4}' | sort -nu | gawk '{print $1,NR}' > sat.lst
paste sat.lst na1 > sat.ambL1

# 2) Generate the "DD_GARR_PLAN_06_ALL.fixL1" file.

cat DD_PLAN_GARR_06_ALL.dat |gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL1";A[$1]=$3}}{printf "%s %02i %02i %s %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,A[$4]}' > DD_PLAN_GARR_06_ALL.fixL1


# 3) Make the following plots and discuss the results.
#    What is the meaning of each plot?

./graph.py -f DD_PLAN_GARR_06_ALL.fixL1 -x6 -y'($8-$18-$11)' -so --yn -0.6 --yx 0.6 -so -l "(DDL1-DDN1)-DDrho" --xl "time (s)" --yl "metres" -t "PLAN-GARR 15.2 km" --sv FIG/Tu6_exC.3.1a.png

./graph.py -f DD_PLAN_GARR_06_ALL.fixL1 -x6 -y'($8-$18-$11-$12)' -so --yn -0.6 --yx 0.6 -l "(DDL1-DDN1)-DDrho-DDTropo" --xl "time (s)" --yl "metres" -t "PLAN-GARR 15.2 km" --sv FIG/Tu6_exC.3.1b.png

./graph.py -f DD_PLAN_GARR_06_ALL.fixL1 -x6 -y'($8-$18-$11-$12)' -so --yn -0.06 --yx 0.06 -l "(DDL1-DDN1)-DDrho-DDTropo" --xl "time (s)" --yl "metres" -t "PLAN-GARR 15.2 km" --sv FIG/Tu6_exC.3.1c.png

./graph.py -f DD_PLAN_GARR_06_ALL.fixL1 -x6 -y'($8-$18)' -so --yn -15000 --yx 15000 -l "(DDL1-DDN1)" --xl "time (s)" --yl "metres" -t "PLAN-GARR 15.2 km"  --sv FIG/Tu6_exC.3.1d.png



# Question:
# ---------

# Explain the meaning of the different plots done.





# b.4) Compute the FIXED solution.
# -------------------------------

#  Remove the ambiguities on L1 carrier and compute the FIXED SOLUTION:

# 1) Build the equations system:

# [DDL1-DDRho-Lambda*DDN1-DDTropo]=[Los_k-Los_06]*[dx]

cat DD_PLAN_GARR_06_ALL.fixL1 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$8-$11-$18-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat



# 2) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);
x'

#  -0.00290189178833524   0.00354027112026342   0.04277612243282228

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#  [4796983.5141 160309.1809 4187340.4315]


exit
######################## END OCTAVE #############################




# C.3.2  Using the DDL1 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 145000< t <165000 with the 
#        program LS.f.
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")
#
# The next procedure can be applied:

# 1) Generate a file with the following content:
#    
#     ["time"  "DDL1-DDRho-Lambda*DDN1-DDTropo"  "Los_k-Los_06"] 
#
#    where:
#            time= second of day
#            DDL1-DDRho-Lambda*DDN1-DDTropo= Prefit residuals 
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_06= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_PLAN_GARR_06_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) Compute the Least Squares solution for the epochs given in the file:

cat L1model.dat |./LS > L1fix.pos

# 3) Plot the results:

./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y4 -s.- -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L1 ambiguities fixed: No wet tropo estim." --sv FIG/Tu6_exC.3.2a.png



# C.3.3 Antenna Phase Centre (APC) offset between L1 and LC
#----------------------------------------------------

# The reference coordinates used right now are relative to the APC of the
# ionosphere free combination (LC).

# Questions:
# ---------
# Taking into account the following parameters of the PLAN and GARR 
# antennas, calculate the relative error introduced by the difference
# between the L1 and LC APC of both receivers in the differential 
# positioning:
#
# ------------------------------------------------
# According to the RINEX and ANTEX files, we have:
#   GARR: TRM41249.00 (millimetres)
#         G01  0.28  0.49 55.91  NORTH / EAST / UP
#         G02  0.15  0.46 58.00
#
#   PLAN: TRM55971.00 (millimetres)
#         G01  1.29 -0.19 66.73  NORTH / EAST / UP
#         G02  0.38  0.61 57.69
#-------------------------------------------------

# Solution:
# --------

# GARR:
#======
# dL1=5.591 cm
# dL2=5.800 cm
# g=(77/60)^2
# dLC=1/(g-1)*(g*dL1-dL2)=5.3cm

# Then
# dL1=dLC+0.3 cm

# PLAN:
#======
# dL1=6.673 cm
# dL2=5.769 cm
# dLC=1/(g-1)*(g*dL1-dL2)= 8.1 cm

# Then:
# dL1=dLC-1.4 cm


# Finally the relative error is:

# DL1(PLAN-GARR)=+1.7 cm

#                                     x L1 (GARR)
#                                     ^
#                                     | 0.3 cm
#                                     |
#    LC (PLAN) *-------- // --------- * LC (GARR)
#              |
#              |
#              | -1.4 cm
#              |
#              v
#    L1 (PLAN) x
#
#


# Repeat the positioning plot, but correctinf for te relative Antenna Phase Centre (APC):

./graph.py -f L1fix.pos -x1 -y2 -s.- -l "North error" -f L1fix.pos -x1 -y3 -s.- -l "East error" -f L1fix.pos -x1 -y'($4-0.017)' -s.- -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L1 amb. fixed: -1.7 cm dAPC_L1: No wet tropo estim." --sv FIG/Tu6_exC.3.2b.png



# Question:
# ---------

# Discuss the remaining sources which could explain the error bias found in the
# vertical component.





# C.3.3 Repeat the previous computation, but using the P1 code
# ----- measurements.

# 1) Generate a file with the following content:
#
#     ["time"  "DDP1-DDRho-DDTropo"  "Los_k-Los_06"]

cat DD_PLAN_GARR_06_ALL.dat | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$7-$11-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > P1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat P1model.dat |./LS > P1.pos

# 3) Plot the results:

./graph.py -f P1.pos -x1 -y2 -s.- -l "North error" -f P1.pos -x1 -y3 -s.- -l "East error" -f P1.pos -x1 -y4 -s.- -l "Up error" --yn -5 --yx 5 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: P1 code pseudorange"  --sv FIG/Tu6_exC.3.3.png



# Question:
# ---------

# Discuss the results comparing them with the previous ones with
# DDL1 carrier.









#////////////////////////////////////////////////////////////////////////////
#/////////////////////////// SESSION D //////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////

#============
# SESSION D
#============

# D.1 Selecting measurements
# ==========================

# D.1.1 Using the previously generated ObsFile.dat file, select the time interval 
# ----- [39000 41300]. Exclude the satellites PRN01 and PRN31 in order to have 
#       the same satellites over the whole interval.
#    
#   Note: This time interval corresponds to day-time and it is expected to find 
#         larger differential ionospheric delays than in the previous exercise
#         (done on a night time interval).

cat ObsFile.dat | gawk '{if ($4>=39000 && $4<=41300 && $2!=31 && $2!=1) print $0}' > obs.dat


# D.1.2 Confirm that the satellite PRN13 is the satellite with the highest 
# ----- elevation (this satellite will be used as the reference satellite).


# ------------------- obs.dat -----------------------
#   1   2   3   4   5  6  7  8  9   10   11  12   13
# [sta sat DoY sec P1 L1 P2 L2 rho Trop Ion elev azim]
# ----------------------------------------------------



# D.2 Double-Differences computation
# ==================================

#  Using the obs.dat  file, compute the Double Differences of measurements 
#  between the receivers "PLAN" (reference) and GARR, and the satellites PRN13 
#  (reference) and [PRN 02, 04, 07, 10, 11, 17, 20, 23, 32].


./DDobs.scr obs.dat PLAN GARR 13 02
./DDobs.scr obs.dat PLAN GARR 13 04
./DDobs.scr obs.dat PLAN GARR 13 07
./DDobs.scr obs.dat PLAN GARR 13 10
./DDobs.scr obs.dat PLAN GARR 13 17
./DDobs.scr obs.dat PLAN GARR 13 20
./DDobs.scr obs.dat PLAN GARR 13 23
./DDobs.scr obs.dat PLAN GARR 13 32

cat DD_PLAN_GARR_13_??.dat | sort -n -k +6 > DD_PLAN_GARR_13_ALL.dat



#     -------------------  DD_${sta1}_${sta2}_${sat1}_${sat2}.dat -------------------------
#
#         1    2    3    4   5   6    7    8    9   10   11    12    13    14  15  16  17
#     [sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2]
#                                                                          <--- sta2 --->
#     -------------------------------------------------------------------------------------


# Where:
#  The elevation and azimuth correspond to the satellites in view from station 2
#    El1 Az1 are for satellite 1
#    El2 Az2 are for satellite 2



# D.3.- Differential Positioning: Absolute coordinates estimation
# ===============================================================

#  Estimate the L1 carrier ambiguities and compute the navigation solution 
#  with the ambiguities fixed:

#   Note: assume there is no error in the IND2 coordinates  


# D.3.1. Compute the floated solution:
# ------


# a) As in the previous exercise, use the script "MakeL1DifTrpMat.scr"
#    to build the equations system fro the two epochs: t=39000s and t=40500s.
#
#    [DDL1-DDRho-DDTropo]=[Los_k-Los_06]*dx + [ A ]*[lambda1*DDN1]
#
#
#    ============================================================
#    Execute:

      ./MakeL1DifTrpMat.scr DD_PLAN_GARR_13_ALL.dat 39000 40500

#    ============================================================
#       NOTE: this new script applies the tropospheric corrections!!



# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.


#  Solution:
#  ---------
########################## OCTAVE ##############################
# Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

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

#  -0.3261745184136089   0.0268168982165662   0.0901880923083809

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#  [4796983.1908 160309.2042 4187340.4789]


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#       Compare the results with the solution obtained by
#       rounding the floated solution.
#      The following procedure can be applied:

c=299792458;
f0=10.23e+6;
f1=154*f0;
lambda1=c/f1
 a=x(4:11)/lambda1;
 Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed;
 sqnorm(2)/sqnorm(1)

# ans =  3.54169992923790

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

# -1372641   1731966   2313787    592316   -878242   -401400   -475026   1855925


# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

# -1372641   1731966   2313787    592316   -878242   -401400   -475026   1855925

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

# -1372640   1731967   2313786    592317   -878241   -401401   -475027   1855923



# Save the fixed ambiguities from the LS
# integer search in file "ambL1.dat" to 
# compute the FIXED solution next.

 amb1=lambda1*afixed(:,1);
 save ambL1.dat amb1

exit
######################## END OCTAVE #############################



# b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#      ambiguities and plot the results to analyse the data.

# Saving the FIXED ambiguities:
# ------
#
#  Using the previous files "ambL1.dat" and "DD_PLAN_GARR_13_ALL.dat",
#  generate a file with the following content:



#----------------------------  DD_PLAN_GARR_13_ALL.fixL1 -------------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17     18
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2 lambda1*DDN1]
#                                                                     <--- sta2 --->
#------------------------------------------------------------------------------------------------

# Note: This file is identical to file "DD_PLAN_GARR_13_ALL.dat", but with the 
#       ambiguities added in the last field #18.

# The following procedure can be applied:

# 1) Generate a file with the satellite PRN number and the ambiguities:

grep -v \# ambL1.dat > na1
cat DD_PLAN_GARR_13_ALL.dat | gawk '{print $4}' | sort -nu | gawk '{print $1,NR}' > sat.lst
paste sat.lst na1 > sat.ambL1

# 2) Generate the "DD_GARR_IND3_13_30.L1fix" file.

cat DD_PLAN_GARR_13_ALL.dat | gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL1";A[$1]=$3}}{printf "%s %s %02i %02i %03i %8.2f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,A[$4]}' > DD_PLAN_GARR_13_ALL.fixL1


# 3) Make the following plots and discuss the results.

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1 -x6 -y'($8-$18-$11)' -so --yn -0.6 --yx 0.6 -so -l "(DDL1-DDN1)-DDrho" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.3.1a.png

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1 -x6 -y'($8-$18-$11-$12)' -so --yn -0.6 --yx 0.6 -l "(DDL1-DDN1)-DDrho-DDTropo" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.3.1b.png

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1 -x6 -y'($8-$18-$11-$12)' -so --yn -0.06 --yx 0.16 -l "(DDL1-DDN1)-DDrho-DDTropo" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.3.1c.png


./graph.py -f DD_PLAN_GARR_13_ALL.fixL1 -x6 -y'($8-$18)' -so --yn -15000 --yx 15000 -l "(DDL1-DDN1)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.3.1d.png



# Question:
# --------
# Explain what is the meaning of the different plots done.





# b.4) Compute the FIXED solution.
# -------------------------------
#
#  Remove the ambiguities on L1 carrier and compute the FIXED SOLUTION:

# 1) Build the equations system:


#  [DDL1-DDRho-Lambda*DDN1-DDTropo]=[Los_k-Los_06]*[dx]

cat DD_PLAN_GARR_13_ALL.fixL1 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$8-$11-$18-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


# 2) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);
x'

#  0.00224133050672853   0.00948643658103340   0.04065938792819074

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#   [4796983.5192 160309.1869 4187340.4294]

exit
######################## END OCTAVE #############################



# D.3.2  Using the DDL1 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 39000< t <41300 with the 
#        program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")

# The next procedure can be applied:

# 1) Generate a file with the following content:
#
#     ["time"  "DDL1-DDRho-Lambda*DDN1-DDTropo"  "Los_k-Los_06"]
#
#    where:
#         time= second of day
#          DDL1-DDRho-Lambda*DDN1-DDTropo= Prefit residulas
#                                  (i.e., "y" values in program LS.f)
#          Los_k-Los_13= the three components of the geometry matrix
#                                  (i.e., matrix "a" in program LS.f).
#

cat DD_PLAN_GARR_13_ALL.fixL1 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18-$12-$13,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat L1model.dat |./LS > L1fix.pos

# 3) Plot the results:

./graph.py -f L1fix.pos -x1 -y2 -so -l "North error" -f L1fix.pos -x1 -y3 -so -l "East error" -f L1fix.pos -x1 -y4 -so -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L1 ambiguities fixed: No wet tropo estim." --sv FIG/Tu6_exD.3.2.png



# Question:
# ---------

# Discuss on the remaining error sources which could explain the error found
# in the North, East and Vertical components.





# D.4 Differential positioning with DDL2 carrier measurements.
# ===========================================================
#
#  Estimate the L2 carrier ambiguities and compute the navigation solution 
#  with the ambiguities FIXED:


# D.4.1. Compute the floated solution:
# ------

# a) As in the previous exercise, use the script "MakeL2DifTrpMat.scr"
#    to build the equations system for the two epochs: t=39000s and t=40500s.
#
#    [DDL2-DDRho-DDTropo]=[Los_k-Los_06]*dx + [ A ]*[lambda2*DDN2]
#

#    =============================================================
#    Execute:

      ./MakeL2DifTrpMat.scr DD_PLAN_GARR_13_ALL.dat 39000 40500

#    =============================================================
#       NOTE: This new script applies the tropospheric corrections!!
#             This new script uses DDL2 instead of DDL1 !!!




# b) Solve the equations system using octave and apply the LAMBDA 
#    method to FIX the ambiguities. 
#
#    b.1) Compute the FLOATED solution, solving the equations system 
#         with octave. Assess the accuracy of the floated solution.
# 
#    b.2) Apply the LAMBDA method to FIX the ambiguities. 
#         Compare the results with the solution obtained by
#         rounding directly the floated solution and by rounding 
#         the solution after decorrelation.
#
#    b.3) Repair the DDL1 carrier measurements with the DDN1 FIXED 
#         ambiguities and plot the results to analyse the data.
#
#    b.4) Compute the FIXED solution.


#  Solution:
#  ---------
########################## OCTAVE ##############################
# Execute for instance:
# b.1) Compute the FLOATED solution, solving the equations system. 
#      The following procedure can be applied
#      (justify the computations done):

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

#  -0.2948598623188445   0.0163193172556930   0.0567334788474909

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#   [4796983.2221 160309.1937 4187340.4454]


# b.2) Apply the LAMBDA method to FIX the ambiguities. 
#       Compare the results with the solution obtained by
#       rounding the floated solution.
#      The following procedure can be applied

#  NOTE: we are working now with L2 !!

c=299792458;
f0=10.23e+6;
f2=120*f0;
lambda2=c/f2
 a=x(4:11)/lambda2;
 Q=P(4:11,4:11);

 [Qz,Zt,Lz,Dz,az,iZ] = decorrel (Q,a);
 [azfixed,sqnorm] = lsearch (az,Lz,Dz,2);
 afixed=iZ*azfixed
 sqnorm(2)/sqnorm(1)

#ans =  15.3627929427384

# 1) Ambiguities fixed from the LS integer
#    search

 afixed(:,1)'

# -1075655   1343160    938718    468181   -675593   -313616   -356299   1439836

# 2) Ambiguities fixed by rounding the
#    decorrelated floated solution:

 afix=iZ*round(az);
 afix'

# -1075655   1343160    938718    468181   -675593   -313616   -356299   1439836

# 3) Ambiguities fixed by rounding directly the
#    floated solution: 

 round(a)'

# -1075654   1343161    938718    468182   -675592   -313617   -356299   1439835


# Save the fixed ambiguities from the LS
# integer search in file "ambL2.dat" to 
# compute the FIXED solution next.

 amb=lambda2*afixed(:,1);
 save ambL2.dat amb

exit
######################## END OCTAVE #############################



# b.3) Repair the DDL2 carrier measurements with the DDN2 FIXED 
#         ambiguities and plot the results to analyse the data.

# Saving the FIXED ambiguities:
# ------
#
#  Using the previous files "ambL2.dat" and "DD_PLAN_GARR_13_ALL.fixL1",
#  generate a file with the following content:



#  Using the previous files "ambL2.dat" and "DD_PLAN_GARR_06_30.fixL1",
#  generate a file with the following content:

#----------------------------  DD_PLAN_GARR_13_30.fixL1L2 -------------------------------------------
#
#    1    2    3    4   5   6    7  8     9   10    11    12    13    14  15  16 17       18          19
#[sta1 sta2 sat1 sat2 DoY sec DDP1 DDL1 DDP2 DDL2 DDrho DDTrop DDIon El1 Az1 El2 Az2 lambda1*DDN1 lambda2*DDN2]
#                                                                     <--- sta2 --->
#------------------------------------------------------------------------------------------------

# Note: This file is identical to file "DD_PLAN_GARR_06_30.fixL1", but with the 
# ambiguities added in the last field #19.


# The following procedure can be applied:

# 1) Generate a file with the satellite PRN number and the DDL2 ambiguities:

grep -v \# ambL2.dat > na2
cat DD_PLAN_GARR_13_ALL.dat | gawk '{print $4}' | sort -nu | gawk '{print $1,NR}' > sat.lst
paste sat.lst na2 > sat.ambL2

# 2) Generate the "DD_GARR_IND3_13_30.fixL1L2" file.

cat DD_PLAN_GARR_13_ALL.fixL1 |gawk 'BEGIN{for (i=1;i<1000;i++) {getline <"sat.ambL2";A[$1]=$3}}{printf "%s %s %02i %02i %03i %8.2f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f %14.4f \n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,A[$4]}' > DD_PLAN_GARR_13_ALL.fixL1L2


# 2) Make the following plots and discuss the results.

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'($10-$19-$11)' -so --yn -0.6 --yx 0.6 -so -l "(DDL2-DDN2)-DDrho" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD4.1a.png

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'($10-$19-$11-$12)' -so --yn -0.6 --yx 0.6 -l "(DDL2-DDN2)-DDrho-DDTropo" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.4.1b.png

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'($10-$19-$11-$12)' -so --yn -0.06 --yx 0.16 -l "(DDL2-DDN2)-DDrho-DDTropo" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.4.1c.png

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'($10-$19)' -so --yn -15000 --yx 15000 -l "(DDL2-DDN2)" --xl "time (s)" --yl "metres" --sv FIG/Tu6_exD.4.1d.png


# Question:
# --------
# Explain what is the meaning of the different plots done.




# b.4) Compute the FIXED solution.
# -------------------------------
#

# Remove the ambiguities on L2 carrier and compute the FIXED SOLUTION:

# 1) Build the equations system:

# [DDL2-DDRho-Lambda2*DDN2-DDTropo]=[Los_k-Los_06]*[dx]

cat DD_PLAN_GARR_13_ALL.fixL1L2 |gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%14.4f %8.4f %8.4f %8.4f \n",$10-$11-$19-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > M.dat


# 1) Solve the equations system using octave:

########################## OCTAVE ##############################
#Execute for instance:

octave

format long
load M.dat
y=M(:,1);
G=M(:,2:4);
x=inv(G'*G)*G'*y
P=inv(G'*G);
x'

#  0.00312473328403573   0.01680339170230549   0.06303852755939099

# Taking into account the the coordinates of GARR are:

  GARR=[4796983.5170 160309.1774 4187340.3887]

# thence, the absolute coordinates of GARR are:

   GARR+ x(1:3)'

#   [4796983.5201  160309.1942  4187340.4517]

exit
######################## END OCTAVE #############################


# Question:
# ---------

# Is the accuracy similar to that in the previous case, when 
# estimating the baseline vector?





# D.4.2  Using the DDL2 carrier with the ambiguities FIXED, compute the single 
# -----  epoch solution for the whole interval 39000< t <41300 with the 
#        program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")
#
# The next procedure can be applied:

# i) Generate a file with the following content:
#
#     ["time"  "DDL2-DDRho-Lambda*DDN1-DDTropo"  "Los_k-Los_06"]
#
#    where:
#            time= second of day
#            DDL2-DDRho-Lambda2*DDN2-DDTropo= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_13= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_PLAN_GARR_13_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$10-$11-$19-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L2model.dat

# ii) compute the Least Squares solution for the epochs given in the file:

cat L2model.dat |./LS > L2fix.pos

# ii) Plot the results:

 ./graph.py -f L2fix.pos -x1 -y2 -so -l "North error" -f L2fix.pos -x1 -y3 -so -l "East error" -f L2fix.pos -x1 -y4 -so -l "Up error" --yn -.05 --yx .15 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L2 ambiguities fixed: No wet tropo estim." --sv FIG/Tu6_exD4.2.png


# Question:
# ---------

# Discuss the possible error sources explaining the errors found
# in the East, North and Vertical components.




# D.5 Differential positioning with DDL1 carrier measurements.
# ===========================================================
#
#  Compute the navigation solution with the ambiguities FIXED
#  and correcting from tropo. and Klobuchar iono.

# a.- Plot the DDL1 from Klobuchar model:

# - As a function of time:

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y13 -so --cl g -l "DDIon (Klobuchar Iono Model)" --xl "time (s)" --yl "m (L1 delay)" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: Double Difference Slant TEC (DDSTEC)" --sv FIG/Tu6_exD5a1.png


# Question:
# ---------
# Discuss the plot.


# - As a function of the satellite elevation:
./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x16 -y13 -so --cl g -l "DDIon (Klobuchar Iono Model)" --xl "elevation (degrees)" --yl "m (L1 delay)" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: Double Difference Slant TEC (DDSTEC)" --sv FIG/Tu6_exD5a2.png


# Question:
# ---------
# Why a larger dispersion is found at low elevation?


# b. Plot the prefit residuals after correcting from tropo. 
#    and Klobuchar iono. :
#
#      Prefit= DDL1-DDRho-DDTropo+DDION-Lambda1*DDN1 

# - As a function of time:

    ./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'$8-$11-$12+$13-$18' -so -l "Prefit DDL1" --xl "time (s)" --yl "metres" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: DDL1-DDRho-DDTropo+DDIon-Lambda1*DDN1"  --sv FIG/Tu6_exD5b1.png

# Question:
# ---------
# Discuss the noise seen in the plot.
     
# - As a function of the satellite elevation:

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x16 -y'$8-$11-$12+$13-$18' -so -l "Prefit DDL1" --xl "elevation (degrees)" --yl "metres" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: DDL1-DDRho-DDTropo+DDIon-Lambda1*DDN1" --sv FIG/Tu6_exD5b2.png


# Question:
# ---------
# Why do we have an elevation-deppendent pattern?


# D.5.1. Compute the fixed solution using both troposphere and 
#        Klobuchar ionosphere model.
# ------

# 1) Generate a file with the following content:
#
#   ["time"  "DDL1-DDRho-Lambda1*DDN1-DDTropo+alpha1*STEC"  "Los_k-Los_06"]
#
#              alpha1=1.546
#    where:
#            time= second of day
#            DDL1-DDRho-DDTropo+DDION = Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_13= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_PLAN_GARR_13_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;STEC1=$13;printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18-$12+STEC1,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' | ./LS > L1FixKlob.pos

 ./graph.py -f L1FixKlob.pos -x1 -y2 -so -l "North error" -f L1FixKlob.pos -x1 -y3 -so -l "East error" -f L1FixKlob.pos -x1 -y4 -so -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L1 ambiguities fixed + Tropo + Klobuchar" --sv FIG/Tu6_exD5.1.png


# Question:
# ---------
# Discuss the results by comparing with the previous ones.











# D.6 Differential positioning with L1 ambiguities fixed and removing DDSTEC. 
# ===========================================================================


# a.- Using DDL1, DDL2 and the fixed ambiguities DDN1 and DDN2, compute and 
#     plot the unambiguous DDSTEC:

# - As a function of time:

 ./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'1.546*($8-$18-$10+$19)' -so --cl g -l "DDL1-Amb1-(DDL2-Amb2)" --xl "time (s)" --yl "m (L1 delay)" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: Actual Double Difference Slant TEC (DDSTEC)" --sv FIG/Tu6_exD6a1.png


# Question:
# ---------
# Discuss the noise seen in the plot.

# - As a function of the satellite elevation:

 ./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x16 -y'1.546*($8-$18-$10+$19)' -so --cl g -l "DDL1-Amb1-(DDL2-Amb2)" --xl "elevation (degrees)" --yl "m (L1 delay)" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: Actual Double Difference Slant TEC (DDSTEC)" --sv FIG/Tu6_exD6a2.png


# Question:
# ---------
# Why do we have an elevation-deppendent pattern?


# b. Plot the prefit residuals:
#      Prefit= DDL1-DDRho-Lambda1*DDN1-DDTropo+alpha1*STEC:

# - As a function of time:

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x6 -y'$8-$11-$12+1.546*($8-$18-$10+$19)-$18' -so -l "Prefit DDL1" --xl "time (s)" --yl "metres" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: DDL1-DDRho-DDTropo+alpha1*STEC-Lambda1*DDN1"  --sv FIG/Tu6_exD6b1.png

# Question:
# ---------
# Discuss the noise seen in the plot.
 


# - As a function of the satellite elevation:

./graph.py -f DD_PLAN_GARR_13_ALL.fixL1L2 -x16 -y'$8-$11-$18-$12+1.546*($8-$18-$10+$19)' -so -l "Prefit DDL1" --xl "elevation (degrees)" --yl "metres" --yn -.15 --yx .15  -t "PLAN-GARR: 15.2 km: DDL1-DDRho-DDTropo+alpha1*STEC-Lambda1*DDN1" --sv FIG/Tu6_exD6b2.png


# Question:
# ---------
# Why do we have an elevation-deppendent pattern?


# D.6.1  Using the DDL1 carrier with the ambiguities FIXED, 
# -----  corrected with the modeled troposphere, 
#        and removing the ionosphere using the unambiguous DDSTEC,
#        compute the single  epoch solution for the whole interval 
#        39000 < t < 41300 with the program LS.f
#
#        Note: The program "LS.f" computes the Least Square solution for each
#              measurement epoch of the input file (see the FORTRAN code "LS.f")
#
# The next procedure can be applied:

# 1) Generate a file with the following content:
#
#   ["time"  "DDL1-DDRho-Lambda1*DDN1-DDTropo+alpha1*STEC"  "Los_k-Los_06"]
#
#              alpha1=1.546
#    where:
#            time= second of day
#            DDL1-DDRho-Lambda1*DDN1-DDTropo+alpha1*STEC= Prefit residuals
#                                   (i.e., "y" values in program LS.f)
#            Los_k-Los_13= the three components of the geometry matrix
#                                   (i.e., matrix "a" in program LS.f).
#

cat DD_PLAN_GARR_13_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;STEC1=1.546*($8-$18-$10+$19);printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,$8-$11-$18-$12+STEC1,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > L1model_stec.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat L1model_stec.dat |./LS > L1FixStec.pos

# 3) Plot the results:

./graph.py -f L1FixStec.pos -x1 -y2 -so -l "North error" -f L1FixStec.pos -x1 -y3 -so -l "East error" -f L1FixStec.pos -x1 -y4 -so -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: L1 ambiguities fixed + Tropo + DDSTEC" --sv FIG/Tu6_exD6.1.png


# Question:
# ---------

# Is any bias expected due to the L1-LC APCs, when removing the ionosphere
# using the unambiguous DDSTEC?





# D.7 Differential positioning with LC combination and ambiguities fixed
# =======================================================================

# 1) Generate a file with the following content:
#
#     ["time"  "DD(LC-Amb)-DDRho-DDTropo"  "Los_k-Los_06"]
#

cat DD_PLAN_GARR_13_ALL.fixL1L2 | gawk 'BEGIN{g2r=atan2(1,1)/45}{e1=$14*g2r;a1=$15*g2r;e2=$16*g2r;a2=$17*g2r;g=(77/60)**2;L1=$8-$18;L2=$10-$19;LC=(g*L1-L2)/(g-1);printf "%s %14.4f %8.4f %8.4f %8.4f \n",$6,LC-$11-$12,-cos(e2)*sin(a2)+cos(e1)*sin(a1),-cos(e2)*cos(a2)+cos(e1)*cos(a1),-sin(e2)+sin(e1)}' > LCmodel.dat

# 2) compute the Least Squares solution for the epochs given in the file:

cat LCmodel.dat |./LS > LCFix.pos

# 3) Plot the results:

./graph.py -f LCFix.pos -x1 -y2 -so -l "North error" -f LCFix.pos -x1 -y3 -so -l "East error" -f LCFix.pos -x1 -y4 -so -l "Up error" --yn -.1 --yx .1 --xl "time (s)" --yl "error (m)" -t "PLAN-GARR: 15.2 km: LC ambiguities FIXED + Tropo" --sv FIG/Tu6_exD.7.png



# Question:
#----------

# Compare this plot with that obtained with DDL1, removing the
# ionosphere using the unambiguous DDSTEC. Are the results 
# the same? Why?



