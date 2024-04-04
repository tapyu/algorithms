#!/bin/bash
# TUTORIAL 2: Measurement Analysis and error budget
# =================================================

# Create the Working directory and copy Programs and Files
# into this directory.


mkdir ./WORK 2> /dev/null
mkdir ./WORK/TUT2
mkdir ./WORK/TUT2/FIG

cd ./WORK/TUT2


#PROGRAM FILES
#-------------
cp ../../PROG/TUT2/* .
if [[ $(uname -s) =~ "CYGWIN" ]]
then
  cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
fi



#DATA FILES
#----------
cp ../../FILES/TUT2/* .

gzip -df *.Z *.gz

#============================================================

# =================================================
# A) Test cases on Atmospheric propagation effects
# =================================================



# Exercise 1: Zenith Tropospheric Delay (ZTD) estimation
# ======================================================

#a) Compute the PPP solution:
#----------------------------

./gLAB_linux -input:cfg gLAB_PPP.cfg -input:obs roap1810.09o -input:sp3 igs15382.sp3 -input:ant igs05_1525.atx -input:snx igs09P1538.snx

./graph.py -f gLAB.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "UP error" --yn -0.2 --yx 0.2 --xl "time (s)" --yl "error (m)"  -t "NEU positioning error [Static PPP]" --sv FIG/TUT2_Ex1a.png


#b) Comparison with the IGS solution:
#-----------------------------------

grep ROAP roap1810.09zpd |gawk -F\: '{print $3}'| gawk '{print $1,$2/1000}' > roap_igs.trp

# Note: the ZTD of roap1810.09zpd are in millimetres of delay
./graph.py -f gLAB.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "gLAB with PPP" -f roap_igs.trp -s.-  -l "IGS" --xl "time (s)" --yl "metres" --yn 2.40 --yx 2.55 -t "Zenith Tropospheric Delay Estimation" --sv FIG/TUT2_Ex1b.png





# Exercise 2: Ionospheric delay Analysis
# ======================================

./gLAB_linux -input:cfg meas.cfg -input:obs coco0090.97o -input:nav brdc0090.97n > coco.meas

#              1    2  3   4   5   6   7  8 9   10   11  12  13  14  15  16
#coco.meas = [MEAS YY Doy sec GPS PRN el Az N. list C1C  L1C C1P L1P C2P L2P]
#                                        x           x    x   x    

gawk '{print $6,$4,$15-$11,($15-$16)/5.09,($11-$14)/3.09,$14-$16,$7/10}'  coco.meas > obs.txt

#            1   2    3       4             5         6      7  
# obs.txt= [PRN,sec,P2-P1,(P2-L2)/5.09,(P1-L1)/3.09,L1-L2,Elev/10]


./graph.py -f obs.txt -c'($1==1)' -x2 -y3 -l "P2-P1"  -f obs.txt -c'($1==1)' -x2 -y4 -l "(P2-L2)/5.09"  -f obs.txt -c'($1==1)' -x2 -y5 -l "(P1-L1)/3.09" --cl c  -f obs.txt -c'($1==1)' -x2 -y6 -l "L1-L2" --cl r  -f obs.txt -c'($1==1)' -x2 -y7 -l "Elev/10" --cl k --yn -10 --yx 15 --xl "time (s)" --yl "metres of L1-L2 delay" -t "Ionospheric Refraction: code and carrier phase"   --sv FIG/TUT2_Ex2a.png


./graph.py -f obs.txt -c'($1==1)' -x2 -y3 -l "P2-P1" -f obs.txt -c'($1==1)' -x2 -y4  -l "(P2-L2)/5.09" -f obs.txt -c'($1==1)' -x2 -y5  -l "(P1-L1)/3.09" --cl c -f obs.txt -c'($1==1)' -x2 -y6 -s- -l "L1-L2" --cl r --xn 12000 --xx 30000 --yn -7 --yx 15 --xl "time (s)" --yl "metres of L1-L2 delay" -t "Zoom: Ionospheric Refraction: code and carrier phase"  --sv FIG/TUT2_Ex2b.png




# Exercise 3: Halloween's Ionospheric Storm: October 2003
# =======================================================


# Exercise 3.1: Solar-Flare: October 28, 2003
# -------------------------------------------

# a) Read the RINEX files and generate the MEAS files:

./gLAB_linux -input:cfg meas.cfg -input:obs ankr3010.03o > ankr3010.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs asc13010.03o > asc13010.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs kour3010.03o > kour3010.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs qaq13010.03o > qaq13010.03.meas


# b) Plot the results:

./graph.py -f ankr3010.03.meas  -x4 -y'($14-$16)' -l "ankr" -f asc13010.03.meas  -x4 -y'($14-$16)' -l "asc1" -f kour3010.03.meas -x4 -y'($14-$16)' -l "kour" -f qaq13010.03.meas  -x4 -y'($14-$16)' -l "qaq1"  --xl "time (s)" --yl "metres of L1-L2"  --xn 38500 --xx 40500 --yn -20 --yx 20  -t "28 Oct 2003 Solar flare"  --sv FIG/TUT2_Ex3.1.png



# Exercise 3.2: Halloween storm analysis
# --------------------------------------

# a) Read the RINEX files and generate the MEAS files:

./gLAB_linux -input:cfg meas.cfg -input:obs amc23030.03o -input:nav brdc3030.03n > amc23030.03.meas

# b) Compute the ionospheric combination of codes PI=P2-P1, and generate
#    the file PI.txt with the following content: [PRN, hour, PI=P2-P1, elevation]:

gawk '{print $6, $4/3600, $15-$13, $7, $8}' amc23030.03.meas > PI.txt


# b) Plot the results:

./graph.py -f PI.txt -x2 -y3 -l "ALL" -f PI.txt -c'($1==28)' -x2 -y3 -so -l "28:P2-P1" -f PI.txt -c'($1==28)' -x2 -y4 -l "29:ELEV" -f PI.txt -c'($1==29)' -x2 -y3 -so -l "29:P2-P1" -f PI.txt -c'($1==29)' -x2 -y4 -l "29:ELEV" -f PI.txt -c'($1==13)' -x2 -y3 -so -l "13:P2-P1" -f PI.txt -c'($1==13)' -x2 -y4 -l "13:ELEV" --xn 15 --xx 25 --yn 0 --yx 85 --xl "time (s)" --yl "metres of L1-L2 delay" -t "IONO: Halloween storm 2003/10/30: amc2" --sv FIG/TUT2_Ex3.2b.png





# Exercise 3.3: Halloween storm evolution: From October 28th to November 2nd 2003
# ----------------------------------------
 
# a) Read the RINEX files and generate the MEAS files [North America: USA]:
# -----------------------------------------------------------

./gLAB_linux -input:cfg meas.cfg -input:obs garl3010.03o -input:nav brdc3010.03n > garl3010.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs garl3020.03o -input:nav brdc3020.03n > garl3020.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs garl3030.03o -input:nav brdc3030.03n > garl3030.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs garl3040.03o -input:nav brdc3040.03n > garl3040.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs garl3050.03o -input:nav brdc3050.03n > garl3050.03.meas
./gLAB_linux -input:cfg meas.cfg -input:obs garl3060.03o -input:nav brdc3060.03n > garl3060.03.meas


# b) Merge files and refer all the data to 0h of October 28th: Doy0301.
#    Compute the ionospheric combination of codes PI=P2-P1, and generate
#    the file PI.txt with the following  content: [PRN, hour, PI=P2-P1, elevation]
# ------------------------------------------------------------

cat garl30?0.03.meas |gawk '{d=($3-301)*86400;$4=$4+d;$4=$4/3600;print $0}' > garl.meas


# c) Plot the results:
# --------------------

./graph.py -f garl.meas -x4 -y'($15-$11)' -l "ALL: P2-P1" -f garl.meas -c'($6==4)' -x4 -y7 -l "PRN04: ELEV" -f garl.meas -c'($6==4)' -x4 -y'($15-$11)' -so -l "PRN04: P2-P1" --xn 0 --xx 144 --yn -10 --yx 70 --xl "Hours from (2003 Oct 28th 0h GPS time)" --yl "metres of L1-L2 delay" -t "IONO: Halloween Storm: 28Oct-02Nov: garl (Lat:40,Lon:-119)" --sv FIG/TUT2_Ex3.3c.png


# d) Zoom: Plot the time interval from 2003 Oct 30th to 31st:
# -----------------------------------------------------------

./graph.py -f garl.meas -x4 -y'($15-$11)' -l "ALL: P2-P1" -f garl.meas -c'($6==4)' -x4 -y7 -l "PRN04: ELEV" -f garl.meas -c'($6==4)' -x4 -y'($15-$11)' -so -l "PRN04: P2-P1" --xn 70 --xx 78 --yn -10 --yx 70 --xl "Hours from (2003 Oct 28th 0h GPS time)" --yl "metres of L1-L2 delay" -t "IONO: Halloween Storm: 28Oct-02Nov: garl (Lat:40,Lon:-119)" --sv FIG/TUT2_Ex3.3d.png




# Exercise 3.4: Assessing Ionospheric effects on single frequency positioning
# =========================================================================

# -------------------------------------------------------------------------
# Note: This exercise can be done by executing from gLAB Graphic User 
#       Interface (gLAB_GUI.py), as in the previous Example 1, or using 
#       command line instructions. 
#       The command line instructions are provided in this Notepad to
#       help on writing the sentences.
# -------------------------------------------------------------------------


# 1) Single freq.: Full model  (P1): ===> OUTPUT file: gLAB.out
# -------------------------------------------------------------

# Processing with gLAB [Full model: Klobuchar]:
./gLAB_linux -input:cfg gLAB_p1_Full.cfg -input:obs amc23030.03o -input:nav brdc3030.03n


# NSE: North/East/Up plot [Full model: Klobuchar]:
./graph.py -f gLAB.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "UP error" --yn -40 --yx 70 --xl "time (s)" --yl "error (m)"  -t "NEU positioning error [SPP]: Full model" --sv FIG/TUT2_Ex3.4.1a.png

# HPS: North/East plot [Full model: Klobuchar]:
./graph.py -f gLAB.out -x19 -y18 -so --cl r -c '($1=="OUTPUT")' --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -40 --xx 40 --yn -40 --yx 40 --sv FIG/TUT2_Ex3.4.1b.png




# 2) Single freq.: without iono. corrections (P1):  ===> OUTPUT file: gLAB1.out
# -----------------------------------------------------------------------------

# Processing with gLAB (Ionospheric correction and P1-P2 correction DISABLED):
./gLAB_linux -input:cfg gLAB_p1_NoIono.cfg -input:obs amc23030.03o -input:nav brdc3030.03n


# NSE: North/East/Up plot [No iono]:
./graph.py -f gLAB1.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB1.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB1.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "UP error" --yn -20 --yx 90 --xl "time (s)" --yl "error (m)"  -t "NEU positioning error [SPP]: No Iono" --sv FIG/TUT2_Ex3.4.2a.png

# HPS: North/East plot [No iono]:
./graph.py -f gLAB1.out -x19 -y18 -so --cl r -c '($1=="OUTPUT")' --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -40 --xx 40 --yn -40 --yx 40 --sv FIG/TUT2_Ex3.4.2b.png

# Vertical Position Error [Full model v.s. No iono]:
./graph.py -f gLAB.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Iono. corr." --cl r  --yn -40 --yx 90 --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/TUT2_Ex3.4.2c.png

# Horizontal Position Error [Full model v.s. No iono]:
./graph.py  -f gLAB1.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Iono. corr." --cl r  -f gLAB.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -40 --xx 40 --yn -40 --yx 40 --sv FIG/TUT2_Ex3.4.2d.png

# Ionospheric model (Klobuchar):
./graph.py -f gLAB.out -x4 -y25 -s. -c '($1=="MODEL")' --yn 0 --yx 40 --xl "time (s)" --yl "metres" -t "Model: Iono. corrections [SPP]" --sv FIG/TUT2_Ex3.4.2e.png


# Klobuchar v.s. Measurement (P2-P1):
./graph.py -f gLAB.out -x4 -y'($10-$9+4)' -s. -c '($1=="INPUT")' -l "PI=P2-P1 (shiifted +4m)" -f gLAB.out -x4 -y25 -s. -c '($1=="MODEL") & ($7=="C1C")' -l "Klobuchar: STEC" --cl r --xl "time (s)" --yl "metres" -t "Ionospheric Combination" --yn -5 --yx 80 --sv FIG/TUT2_Ex3.4.2f.png



# 3) Dual freq.: Ionosphere-free combination [PC]:  ===> OUTPUT file: gLAB2.out
# -----------------------------------------------------------------------------

# Processing with gLAB (Dual freq.: Ionosphere-free combination [PC]):
./gLAB_linux -input:cfg gLAB_pc_IFree.cfg -input:obs amc23030.03o -input:nav brdc3030.03n


# NSE: North/East/Up plot: [PC]:
./graph.py -f gLAB2.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB2.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB2.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "UP error" --yn -40 --yx 70 --xl "time (s)" --yl "error (m)"  -t "NEU positioning error [2-freq. Iono-free]" --sv FIG/TUT2_Ex3.4.3a.png

# Horizontal Position Error: [PC]
./graph.py -f gLAB2.out -x19 -y18 -so --cl r -c '($1=="OUTPUT")' --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [2-freq. Iono-free]" --xn -40 --xx 40 --yn -40 --yx 40 --sv FIG/TUT2_Ex3.4.3b.png





# =================================================
# B) Test cases on Measurement noise and Multipath
# =================================================



# Exercise 4: Code Multipath
# ==========================


# Exercise 4.1 PC Code Multipah
# -----------------------------

# 1.- Read the RINEX files and generate the MEAS files:
# -----------------

./gLAB_linux -input:cfg meas.cfg -input:obs UPC33600.08O -input:nav BRD3600.08N > upc3360.meas
./gLAB_linux -input:cfg meas.cfg -input:obs UPC33610.08O -input:nav BRD3610.08N > upc3361.meas
./gLAB_linux -input:cfg meas.cfg -input:obs UPC33620.08O -input:nav BRD3620.08N > upc3362.meas


# 2.- Verify the following content in the generated "upc3360.meas" file:
# -------------
#  1    2  3   4   5   6   7  8 9   10   11  12  13  14  15  16
#[MEAS YY DoY sec GPS PRN el Az N. list C1C L1C C1P L1P C2P L2P]
#


# 3.- Compute the difference of code and carrier ionosphere free combinations
#    (see LC and PC in equations (4.15), Volume I). Select the time
#    interval [66000: 69000] to avoid managing large data files:
# --------------

gawk 'BEGIN{g12=(154/120)^2} {if ($4>66000 && $4< 69000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' upc3360.meas > upc3360.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>66000 && $4< 69000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' upc3361.meas > upc3361.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>66000 && $4< 69000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' upc3362.meas > upc3362.LcPc


# 4.- Plot the results:
# ---------------------

# a) Compare the plots corresponding to the three days:

./graph.py -f upc3360.LcPc -c '($1==20)' -x2 -y3 -s- -l "DoY 360" -f upc3361.LcPc -c '($1==20)' -x2 -y3 -s- -l "DoY 361" -f upc3362.LcPc -c '($1==20)' -x2 -y '($3-20)' --xn 67000 --xx 68000 --yn -60 --yx 60 -s- -l "DoY 362" -f upc3360.LcPc -c '($1==20)' -x2 -y4  -l "Elev (deg.)" --xl "time (s)" --yl "metres" -t "PC code multipath: upc3: PRN20"  --sv FIG/TUT2_Ex4.1a.png



# b) Repeat the same plots, but shifting 3m 56s = 236s the plot of the
#  second day, and 2*(3m 56s)= 472s the plot of the third day:

./graph.py -f upc3360.LcPc -c '($1==20)' -x2 -y3 -s- -l "DoY 360 (t)    " -f upc3361.LcPc -c '($1==20)' -x'($2+236)' -y3 -s- -l "DoY 361 (t+236)" -f upc3362.LcPc -c '($1==20)' -x'($2+472)' -y'($3-20)' --xn 67000 --xx 68000 --yn -60 --yx 60 -s- -l "DoY 362 (t+472)" -f upc3360.LcPc -c '($1==20)' -x2 -y4  -l "Elev (deg.)" --xl "time (s)" --yl "metres" -t "PC code multipath: upc3: PRN20"  --sv FIG/TUT2_Ex4.1b.png


# 5- Repeat the previous plots for satellite PRN25:
# -------------------------------------------------

./graph.py -f upc3360.LcPc -c '($1==25)' -x2 -y'($3+10)' -s- -l "DoY 360 (t)    " -f upc3361.LcPc -c '($1==25)' -x'($2+236)' -y'($3-10)' -s- -l "DoY 361 (t+236)" -f upc3362.LcPc -c '($1==25)' -x'($2+472)' -y3 --xn 67000 --xx 68000 --yn -60 --yx 60 -s- -l "DoY 362 (t+472)" -f upc3360.LcPc -c '($1==25)' -x2 -y4  -l "Elev (Deg.)" --xl "time (s)" --yl "metres" -t "PC code multipath: upc3: PRN25"  --sv FIG/TUT2_Ex4.1.5.png




# 6.- Repeat the previous analysis using HTV1 receiver, for PC multipath to satellite 
#     PRN03 in time interval 42000 < t < 65000:
# ---------------------

./gLAB_linux -input:cfg meas.cfg -input:obs htv13450.04o -input:nav brdc3450.04n > htv13450.meas
./gLAB_linux -input:cfg meas.cfg -input:obs htv13460.04o -input:nav brdc3460.04n > htv13460.meas
./gLAB_linux -input:cfg meas.cfg -input:obs htv13470.04o -input:nav brdc3470.04n > htv13470.meas

gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' htv13450.meas > htv13450.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' htv13460.meas > htv13460.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$13-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' htv13470.meas > htv13470.LcPc


./graph.py -f htv13450.LcPc -c '($1==3)' -x2 -y'($3)' -s- -l "345" -f htv13460.LcPc -c '($1==3)' -x2 -y'($3+3)' --yn -10 --yx 10 -s- -l "346" -f htv13470.LcPc -c '($1==3)' -x2 -y'($3+1)' -s- -l "347" -f htv13450.LcPc -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)" --xn 46000 --xx 63000 --yn -10 --yx 10 --xl "time (s)" --yl "metres" -t "PC code multipath: htv1: PRN03" --sv FIG/TUT2_Ex4.1.6a.png


./graph.py -f htv13450.LcPc -c '($1==3)' -x2 -y'($3)' -s- -l "345 (t)   " -f htv13460.LcPc -c '($1==3)' -x'($2+236)' -y'($3+3)' --yn -10 --yx 10 -s- -l "346 (t+236)" -f htv13470.LcPc -c '($1==3)' -x'($2+472)' -y'($3+1)' -s- -l "347 (t+472)" -f htv13450.LcPc -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)"  --xn 46000 --xx 63000 --yn -10 --yx 10 --xl "time (s)" --yl "metres" -t "PC code multipath: htv1: PRN03" --sv FIG/TUT2_Ex4.1.6b.png




# 7.- Repeat the previous analysis using GALB receiver, for PC multipath to satellite 
#     PRN03 in time interval 42000 < t < 65000:
# ------------

./gLAB_linux -input:cfg meas.cfg -input:obs galb3450.04o -input:nav brdc3450.04n > galb3450.meas
./gLAB_linux -input:cfg meas.cfg -input:obs galb3460.04o -input:nav brdc3460.04n > galb3460.meas
./gLAB_linux -input:cfg meas.cfg -input:obs galb3470.04o -input:nav brdc3470.04n > galb3470.meas


gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$11-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' galb3450.meas > galb3450.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$11-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' galb3460.meas > galb3460.LcPc
gawk 'BEGIN{g12=(154/120)^2} {if ($4>42000 && $4< 65000) print $6,$4,(g12*$11-$15)/(g12-1)-(g12*$14-$16)/(g12-1),$7}' galb3470.meas > galb3470.LcPc

./graph.py -f galb3450.LcPc -c '($1==3)' -x2 -y'($3)' -s- -l "345" -f galb3460.LcPc -c '($1==3)' -x2 -y'($3+2.3)' --yx 10 -s- -l "346" -f galb3470.LcPc -c '($1==3)' -x2 -y'($3+1.6)' -s- -l "347" -f galb3450.LcPc -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)" --xn 46000 --xx 63000 --yn 2 --yx 7 --xl "time (s)" --yl "metres" -t "PC code multipath: galb: PRN03" --sv FIG/TUT2_Ex4.1.7a.png


./graph.py -f galb3450.LcPc -c '($1==3)' -x2 -y'($3)' -s- -l "345 (t)    " -f galb3460.LcPc -c '($1==3)' -x'($2+236)' -y'($3+2.3)' -s- -l "346 (t+236)" -f galb3470.LcPc -c '($1==3)' -x'($2+472)' -y'($3+1.6)' -s- -l "347 (t+472)" -f galb3450.LcPc -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)" --xn 46000 --xx 63000 --yn 2 --yx 7 --xl "time (s)" --yl "metres" -t "PC code multipath: galb: PRN03" --sv FIG/TUT2_Ex4.1.7b.png




# Exercise 4.2 Melbourne Wubbena Multipath
# ---------------------------------------

# Repeat the previous analysis for Melbourne-Wubbena (MB) multipath to satellite 
# PRN03 in time interval 46000 < t < 63000:

# - HTV1 Receiver:
# ----------------

./gLAB_linux -input:cfg meas.cfg -input:obs htv13450.04o -input:nav brdc3450.04n > htv13450.meas
./gLAB_linux -input:cfg meas.cfg -input:obs htv13460.04o -input:nav brdc3460.04n > htv13460.meas
./gLAB_linux -input:cfg meas.cfg -input:obs htv13470.04o -input:nav brdc3470.04n > htv13470.meas

gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' htv13450.meas > htv13450.MB
gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' htv13460.meas > htv13460.MB
gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' htv13470.meas > htv13470.MB

./graph.py -f htv13450.MB -c '($1==3)' -x2 -y'($3+32)'  -s- -l "345 (t)    " -f htv13460.MB -c '($1==3)' -x'($2+236)' -y'($3+25)' -s- -l "346 (t+236)" -f htv13470.MB -c '($1==3)' -x'($2+472)' -y'($3+29)' -s- -l "347 (t+472)" -f htv13450.MB -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)" -s- --xn 46000 --xx 63000  --yn 0 --yx 8 --xl "time (s)" --yl "metres" -t "Melbourne-Wubbena multipath: htv1: PRN03" --sv FIG/TUT2_Ex4.2a.png

./graph.py -f htv13450.MB -c '($1==3)' -x2 -y'($3+32)'  -s- -l "345 (t)    " -f htv13460.MB -c '($1==3)' -x'($2+236)' -y'($3+24)' -s- -l "346 (t+236)" -f htv13470.MB -c '($1==3)' -x'($2+472)' -y'($3+29)' -s- -l "347 (t+472)" -f htv13450.MB -c '($1==3)' -x2 -y'($4/10)' -l "Elev/10 (deg.)" -s- --xn 46000 --xx 63000  --yn 0 --yx 8 --xl "time (s)" --yl "metres" -t "Melbourne-Wubbena multipath: htv1: PRN03" --sv FIG/TUT2_Ex4.2a.png


# - GALB receiver:
# ----------------

./gLAB_linux -input:cfg meas.cfg -input:obs galb3450.04o -input:nav brdc3450.04n > galb3450.meas
./gLAB_linux -input:cfg meas.cfg -input:obs galb3460.04o -input:nav brdc3460.04n > galb3460.meas
./gLAB_linux -input:cfg meas.cfg -input:obs galb3470.04o -input:nav brdc3470.04n > galb3470.meas


gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' galb3450.meas > galb3450.MB
gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' galb3460.meas > galb3460.MB
gawk 'BEGIN{s12=154/120} {print $6,$4,(s12*$14-$16)/(s12-1)-(s12*$13+$15)/(s12+1),$7}' galb3470.meas > galb3470.MB

./graph.py -f galb3450.MB -c '($1==3)' -x2 -y'($3+16.8)' -s- -l "345 (t)    " -f galb3460.MB -c '($1==3)' -x'($2+236)' -y'($3+11.6)' -s- -l "346 (t+236)" -f galb3470.MB -c '($1==3)' -x'($2+472)' -y'($3+12.4)' -s- -l "347 (t+472)" -f galb3450.MB -c '($1==3)' -x2 -y'($4/100)' -l "Elev/100 (deg.)" -s- --xn 46000 --xx 63000 --yn 0 --yx 1 --xl "time (s)" --yl "metres" -t "Melbourne-Wubbena multipath: galb: PRN03" --sv FIG/TUT2_Ex4.2b.png



# Exercise 4.3 C1 Code Multipah
# -----------------------------

#- Read the RINEX files and generate the MEAS files:

./gLAB_linux -input:cfg meas.cfg -input:obs gage2710.98o --pre:cs:li --pre:cs:bw > gage271.meas
./gLAB_linux -input:cfg meas.cfg -input:obs gage2720.98o --pre:cs:li --pre:cs:bw > gage272.meas
./gLAB_linux -input:cfg meas.cfg -input:obs gage2730.98o --pre:cs:li --pre:cs:bw > gage273.meas

#a) Plot the C1 Multipath:
# ------------------------

./graph.py -f gage271.meas -c '($6==14)' -x4 -y'($11-$14)' -l "DoY 271 (t)" -f gage272.meas -c '($6==14)' -x4 -y'($11-$14)' -l "DoY 272 (t)"  -f gage273.meas -c '($6==14)' -x4 -y'($11-$14)' -l "DoY 273 (t)"  --xl "time (s)" --yl "metres" -t "C1 Code multipath: PRN14"  --sv FIG/TUT2_Ex4.3a.png


# b) Repeat the plots, but shifting 3m 56s = 236s the plot of the
#    second day, and 2*(3m 56s) = 472s the plot of the third day:
# ---------------------------------------------------------------

./graph.py -f gage271.meas -c '($6==14)' -x4 -y'($11-$14)' -l "DoY 271 (t)    " -f gage272.meas -c '($6==14)' -x'($4+236)' -y'($11-$14)' -l "DoY 272 (t+236)"  -f gage273.meas -c '($6==14)' -x'($4+472)' -y'($11-$14+2)' -l "DoY 273 (t+472)"  --xl "time (s)" --yl "metres" -t "C1 Code multipath: PRN14"  --sv FIG/TUT2_Ex4.3b.png







# ===============================================================
# C) Test cases on Carrier Smoothed Code: Code-carrier divergence
# ===============================================================



# Exercise 5: Ionosphere Divergence on smoothing
# ==============================================


# Exercise 5.1: Ionosphere Divergence on smoothing
# -------------------------------------------------


# 1) Multipath and measurement noise assessment on raw code measurements
#  ------------

# 1a) Read the RINEX file and generate the MEAS file:

./gLAB_linux -input:cfg meas.cfg -input:obs UPC33510.08O |gawk '{if ($6==3) print $0}'  > upc3.meas

#  1    2  3   4   5   6   7  8 9   10   11  12  13  14  15  16
#[MEAS YY Doy sec GPS PRN el Az N. list C1C  xx C1P L1P C2P L2P]


# 1b) Compute the C1 code multipath:

# "C1-L12"
gawk '{print $4,$11-$14-3.09*($14-$16)-21.3}' upc3.meas > upc3.C1


# 1c) Plot the raw (unsmoothed) measurements for PRN03:

./graph.py -f upc3.C1 -s- -l "C1 Raw" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN03, C1 Raw: unsmoothed measurement noise and multipath"  --sv FIG/TUT2_Ex5.1.png




# 2) Apply the Hatch filter to smooth the code using a filter length of 
#    N=100 samples (as the measurements are at 1Hz, this means 100 seconds 
#    smoothing). Thence, as in the previous case, depict the multipath and noise 
#    of the smoothed code
# -----------

#  2a) Generate the smoothed code (T=100sec):

gawk 'BEGIN{Ts=100}{if (NR>Ts){n=Ts}else{n=NR};C1s=$11/n+(n-1)/n*(C1s+($14-L1p));L1p=$14; print $4,C1s-$14-3.09*($14-$16)-21.3}' upc3.meas > upc3.C1s100


#  2b) Plot the raw (unsmoothed) measurements for PRN03:

./graph.py -f upc3.C1 -s- -l "C1 Raw" -f upc3.C1s100 -s.- --cl r -l "C1 SF smoothed (100s)" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN03: C1 100s smoothing and divergence of ionosphere"  --sv FIG/TUT2_Ex5.1.2.png



# 3) Remove the ionospheric refraction of C1 code and L1 carrier measurements 
#    and apply the Hatch filter to compute the DFree smoothed code: 
# ------------

# 3a) Apply the Hatch filter to compute the DFree smoothed code  (T=100sec):

gawk 'BEGIN{Ts=100}{if (NR>Ts){n=Ts}else{n=NR};C1f=$11;L1f=$14+2*1.55*($14-$16);C1fs=C1f/n+(n-1)/n*(C1fs+(L1f-L1p));L1p=L1f; print $4,C1fs-L1f-21.3}' upc3.meas  > upc3.C1DFs100


# 3b) Plot the previous results (comparing Row, SF and DFree smoothing):

./graph.py -f upc3.C1 -s- -l "C1 Raw" -f upc3.C1s100 -s.- --cl r -l "C1 SF smoothed (100s)" -f upc3.C1DFs100 -s.- --cl g -l "C1 DFree smoothed (100s)" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN03: C1 100s smoothing and divergence of ionosphere"  --sv FIG/TUT2_Ex5.1.3.png



# 4) Generate the ionosphere-free combinations of code and carrier measurements 
#    to compute the Ionosphere Free (IFree) smoothed code: 
# -------------

# 4a) Compute the unsmoothed PC code:
gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1); lc=(g*$14-$16)/(g-1);print  $4,pc-lc-3.5}' upc3.meas > upc3.PC

# 4b) Apply the Hatch filter to compute the IFree smoothed code: 

gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1);lc=(g*$14-$16)/(g-1);if (NR>100){n=100}else{n=NR};ps=1/n*pc+((n-1)/n*(ps+lc-lcp));lcp=lc;print $4,ps-lc-3.5}' upc3.meas > upc3.PCs100

# 4c) Plot the results: compare the unsmoothed PC with the smoothed 100s PC:

./graph.py -f upc3.PC -s- -l "IFree raw"  --cl y -f upc3.PCs100 -s.- --cl black -l "IFree smth (100s)" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "Ionosphere-Free combination smoothing: 100 seconds"  --sv FIG/TUT2_Ex5.1.4.png


# 5) Repeat the previous plots but using: N=360, N=3600 and compare the results. 
#    Also, plot the ionospheric delay (from L1-L2):
# -----------
 
# 5a) Smooth with T=360 seconds filter length:

# Single-Freq (360 sec)
gawk 'BEGIN{Ts=360}{if (NR>Ts){n=Ts}else{n=NR};C1s=$11/n+(n-1)/n*(C1s+($14-L1p));L1p=$14; print $4,C1s-$14-3.09*($14-$16)-21.3}' upc3.meas > upc3.C1s360


# DFree (360 sec)
gawk 'BEGIN{Ts=360}{if (NR>Ts){n=Ts}else{n=NR};C1f=$11;L1f=$14+2*1.55*($14-$16);C1fs=C1f/n+(n-1)/n*(C1fs+(L1f-L1p));L1p=L1f; print $4,C1fs-L1f-21.3}' upc3.meas  > upc3.C1DFs360

./graph.py -f upc3.C1 -s- -l "C1 Raw"  -f upc3.C1s360 -s.- --cl r -l "C1 SF smoothed (360)"  -f upc3.C1DFs360 -s.- --cl g -l "C1 DFree smoothed (360)" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN03: C1 360s smoothing and divergence of ionosphere"  --sv FIG/TUT2_Ex5.1.5a1.png


# IFree (360 sec)
gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1); lc=(g*$14-$16)/(g-1);print  $4,pc-lc-3.5}' upc3.meas > upc3.pc

gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1);lc=(g*$14-$16)/(g-1);if (NR>360){n=360}else{n=NR};ps=1/n*pc+((n-1)/n*(ps+lc-lcp));lcp=lc;print $4,ps-lc-3.5}' upc3.meas > upc3.PCs360

./graph.py -f upc3.pc -s- --cl y -l "IFree raw"  -f upc3.PCs360 -s.- --cl black -l "IFree smth (360s)" --xn 35000 --xx 40000 --yn -15 --yx 15  --xl "time (s)" --yl "metres" -t  "Ionosphere-Free combination smoothing: 360 seconds"  --sv FIG/TUT2_Ex5.1.5a2.png


# 5b) Smooth with T=3600 seconds filter length:

# Single-Freq (3600 sec)
gawk 'BEGIN{Ts=3600}{if (NR>Ts){n=Ts}else{n=NR};C1s=$11/n+(n-1)/n*(C1s+($14-L1p));L1p=$14; print $4,C1s-$14-3.09*($14-$16)-21.3}' upc3.meas > upc3.C1s3600


# DFree (3600 sec)"
gawk 'BEGIN{Ts=3600}{if (NR>Ts){n=Ts}else{n=NR};C1f=$11;L1f=$14+2*1.55*($14-$16);C1fs=C1f/n+(n-1)/n*(C1fs+(L1f-L1p));L1p=L1f; print $4,C1fs-L1f-21.3}' upc3.meas  > upc3.C1DFs3600


./graph.py -f upc3.C1 -s- -l "C1 Raw"  -f upc3.C1s3600 -s.- --cl r -l "C1 SF smoothed (3600)"  -f upc3.C1DFs3600 -s.- --cl g -l "C1 DFree smoothed (3600)" --xn 35000 --xx 40000 --yn -5 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN03: C1 3600s smoothing and divergence of ionosphere"  --sv FIG/TUT2_Ex5.1.5b1.png


# IFree (3600 sec)
gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1); lc=(g*$14-$16)/(g-1);print  $4,pc-lc-3.5}' upc3.meas > upc3.pc

gawk 'BEGIN{g=(77/60)**2}{pc=(g*$13-$15)/(g-1);lc=(g*$14-$16)/(g-1);if (NR>3600){n=3600}else{n=NR};ps=1/n*pc+((n-1)/n*(ps+lc-lcp));lcp=lc;print $4,ps-lc-3.5}' upc3.meas > upc3.PCs3600

./graph.py -f upc3.pc -s- --cl y -l "IFree raw"  -f upc3.PCs3600 -s.- --cl black -l "IFree smth (3600s)" --xn 35000 --xx 40000 --yn -15 --yx 15  --xl "time (s)" --yl "metres" -t  "Ionosphere-Free combination smoothing: 3600 seconds"  --sv FIG/TUT2_Ex5.1.5b2.png


# 5c) Plot the STEC for PRN13:

./graph.py -f upc3.meas -x4 -y'1.545*($14-$16)+12.5' -s.- --cl r -l "1.546*(L1-L2)" --xn 35000 --xx 40000 --yn 1 --yx 3 --xl "time (s)" --yl "metres of L1 delay" -t "STEC PRN03 (shifted)" --sv FIG/TUT2_Ex5.1.5c.png






# Exercise 5.2  Assessment in Halloween Storm:
# --------------------------------------------


# Repeat the previous exercise using the RINEX file amc23030.03o_1Hz 
# collected for the station amc2 during the Halloween storm. 
# Take N=100 (i.e, filter smoothing time constant t=100 sec).

# a) Read the RINEX file and generate the MEAS file and select the satellite PRN 13:
#-----------------------------------------------------------------------------------

./gLAB_linux -input:cfg meas.cfg -input:obs amc23030.03o_1Hz |gawk '{if ($4>56500 && $6==13) print $0}'  > amc2.meas

#  1    2  3   4   5   6   7  8 9   10   11  12  13  14  15  16
#[MEAS YY Doy sec GPS PRN el Az N. list C1C  xx C1P L1P C2P L2P]


# b) Compute the C1 code multipath:
# -------------------------------

# "C1-L12"
gawk '{print $4,$11-$14-3.09*($14-$16)+2.0}' amc2.meas > amc2.C1



# c) Apply the Hatch filter to smooth the code, using a filter length of 
#     n=100 samples. Thence, repeating the detrending again.
# ---------------------------------------------------------------------

gawk 'BEGIN{Ts=100}{if (NR>Ts){n=Ts}else{n=NR};C1s=$11/n+(n-1)/n*(C1s+($14-L1p));L1p=$14; print $4,C1s-$14-3.09*($14-$16)+2.0}' amc2.meas > amc2.C1s100



# d) Remove the ionospheric refraction of code and carrier measurements (DFree):
#-------------------------------------------------------------------------

gawk 'BEGIN{Ts=100}{if (NR>Ts){n=Ts}else{n=NR};C1f=$11;L1f=$14+2*1.55*($14-$16);C1fs=C1f/n+(n-1)/n*(C1fs+(L1f-L1p));L1p=L1f; print $4,C1fs-L1f+2.0}' amc2.meas  > amc2.C1DFs100



# f) Plot the results:
# ---------------------

./graph.py -f amc2.C1 -s- -l "C1 Raw" -f amc2.C1s100 -s.- --cl r -l "C1 SF smoothed" -f amc2.C1DFs100 -s.- --cl g -l "C1 DFree smoothed" --xn 56500 --xx 78160 --yn -8 --yx 5  --xl "time (s)" --yl "metres" -t  "PRN13, C1 100s smoothing and divergence of ionosphere"  --sv FIG/TUT2_Ex5.2f.png

                                                                                      
# g) Plot the STEC for PRN13:
# -------------------------------

./graph.py -f amc2.meas -x4 -y'1.545*($14-$16)' -s.- --cl r -l "1.546*(L1-L2)" --xn 56500 --xx 78160 --yn 0 --yx 120 --xl "time (s)" --yl "metres of L1 delay" -t  "STEC PRN13 (shifted)" --sv FIG/TUT2_Ex5.2g.png







# =====================================================
# D) Test cases on Broadcast Orbits and Clocks Accuracy
# =====================================================



# Exercise 6: Broadcast orbits and clocks accuracy assessment using the
#             IGS precise products as the accurate reference
# ---------------------------------------------------------------------

# 1) Assessment of using the "igs05_1402.atx" files with the Antenna Phase Centres 
#    of IGS.
# ------------- 

./gLAB_linux -input:nav  brdc0800.07n  -input:SP3 cod14193.sp3  -input:ant igs05_1402.atx > dif.tmp
grep SATDIFF dif.tmp > dif.out

./graph.py -f dif.out -x4 -y11 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y11 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Radial error" --sv FIG/TUT2_Ex6.1a.png

./graph.py -f dif.out -x4 -y12 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y12 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Along Track error" --sv FIG/TUT2_Ex6.1b.png

./graph.py -f dif.out -x4 -y13 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y13 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Cross Track eerror" --sv FIG/TUT2_Ex6.1c.png

./graph.py -f dif.out -x4 -y10 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y10 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Clock error" --cl r --sv FIG/TUT2_Ex6.1d.png

./graph.py -f dif.out -x4 -y7 -s. --cl g -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y7 --yn 0 --yx 10 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: SISRE" --cl r --sv FIG/TUT2_Ex6.1e.png





# 2) Assessment of using the "igs05_1402.atx" files with the Antenna Phase Centres 
#    of GPS Control Segment.
# ------------------------- 


./gLAB_linux -input:nav  brdc0800.07n  -input:SP3 cod14193.sp3  -input:ant gps_brd.atx > dif.tmp
grep SATDIFF dif.tmp > dif.out

./graph.py -f dif.out -x4 -y11 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y11 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Radial error" --sv FIG/TUT2_Ex6.2a.png

./graph.py -f dif.out -x4 -y12 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y12 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Along Track error" --sv FIG/TUT2_Ex6.2b.png

./graph.py -f dif.out -x4 -y13 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y13 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Cross Track eerror" --sv FIG/TUT2_Ex6.2c.png

./graph.py -f dif.out -x4 -y10 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y10 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Clock error" --cl r --sv FIG/TUT2_Ex6.2d.png

./graph.py -f dif.out -x4 -y7 -s. --cl g -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y7 --yn 0 --yx 10 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: SISRE" --cl r --sv FIG/TUT2_Ex6.2e.png


# Cleaning temporary files in the directory:
rm roap_igs.trp coco.meas obs.txt ankr3010.03.meas asc13010.03.meas kour3010.03.meas qaq13010.03.meas amc23030.03.meas PI.txt garl3010.03.meas garl3020.03.meas garl3030.03.meas garl3040.03.meas garl3050.03.meas garl3060.03.meas garl.meas gLAB.out gLAB1.out gLAB2.out upc3360.meas upc3361.meas upc3362.meas upc3360.LcPc upc3361.LcPc upc3362.LcPc htv13450.LcPc htv13460.LcPc htv13470.LcPc galb3450.LcPc galb3460.LcPc galb3470.LcPc htv13450.meas htv13460.meas htv13470.meas htv13450.MB htv13460.MB htv13470.MB galb3450.meas galb3460.meas galb3470.meas galb3450.MB galb3460.MB galb3470.MB gage271.meas gage272.meas gage273.meas upc3.meas upc3.C1 upc3.C1s100 upc3.C1DFs100 upc3.PC upc3.PCs100 upc3.C1s360 upc3.C1DFs360 upc3.PCs360 upc3.C1s3600 upc3.C1DFs3600 upc3.pc upc3.PCs3600 amc2.meas amc2.C1 amc2.C1s100 amc2.C1DFs100 dif.tmp dif.out
