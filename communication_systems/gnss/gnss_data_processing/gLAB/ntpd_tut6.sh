#!/bin/bash
# TUTORIAL 6: Kinematic Orbit Estimation of a LEO satellite
#================================================

# Create the Working directory and copy Programs and Files
# into this directory.


mkdir ./WORK 2> /dev/null
mkdir ./WORK/TUT6
mkdir ./WORK/TUT6/FIG

cd ./WORK/TUT6


#PROGRAM FILES
#-------------
cp ../../PROG/TUT6/* .
if [[ "$(uname -s)" =~ "CYGWIN" ]]
then
	cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
fi

#DATA FILES
#----------
cp ../../FILES/TUT6/* .

gzip -df *.gz

#================================================

# Mode1 [C1]:
#------------
./gLAB_linux -input:cfg  gLAB_LWP_M1.cfg -input:obs graa0800.07o -input:nav brdc0800.07n -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3

./graph.py -f dif.out -x4 -y9  --yn -0 --yx 40 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [C1]: 3D error"  --sv FIG/LWP_M1a.png
./graph.py -f dif.out -x4 -y11 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [C1]: Radial error"  --sv FIG/LWP_M1b.png
./graph.py -f dif.out -x4 -y12 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [C1]: Along Track error"  --sv FIG/LWP_M1c.png
./graph.py -f dif.out -x4 -y13 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [C1]: Cross Track error"  --sv FIG/LWP_M1d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [C1]" --sv FIG/LWP_M1e.png


# HW2:
./graph.py -f dif.out -x4 -y9 -s- -l "3D error (m)" -f gLAB.out -c '($1=="OUTPUT")' -x4 -y5 -s- --cl r -l "3D formal error (m)" -f gLAB.out -c '($1=="EPOCHSAT")' -x4 -y6 -s- --cl g -l "N. satellites used" --yn 0 --yx 20 --xl "time (s)" --sv  FIG/LWP_HW2a.png

./graph.py  -f dif.out -x4 -y9 -s.- -l "3D error (m)" -f gLAB.out -c '($1=="OUTPUT")' -x4 -y5 -s.- --cl r -l "3D formal error (m)" -f gLAB.out -c '($1=="EPOCHSAT")' -x4 -y6 -s.- --cl g -l "N. satellites used" --xn 43000 --xx 67000 --yn 0 --yx 20 --xl "time (s)" --sv FIG/LWP_HW2b.png



# Mode2 [PC]:
#-----------
./gLAB_linux -input:cfg  gLAB_LWP_M2.cfg -input:obs graa0800.07o -input:nav brdc0800.07n -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3

./graph.py -f dif.out -x4 -y9  --yn -0 --yx 40 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [PC]: 3D error"  --sv FIG/LWP_M2a.png
./graph.py -f dif.out -x4 -y11 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [PC]: Radial error"  --sv FIG/LWP_M2b.png
./graph.py -f dif.out -x4 -y12 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [PC]: Along Track error"  --sv FIG/LWP_M2c.png
./graph.py -f dif.out -x4 -y13 --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [PC]: Cross Track error"  --sv FIG/LWP_M2d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -20 --yx 20 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [PC]" --sv FIG/LWP_M2e.png


# Mode3 [LCPC]:
#-------------
./gLAB_linux -input:cfg gLAB_LWP_M3.cfg -input:obs graa0800.07o -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3


./graph.py -f dif.out -x4 -y9  --yn -0 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [LCPC]: 3D error"  --sv FIG/LWP_M3a.png
./graph.py -f dif.out -x4 -y11 --yn -2 --yx 2 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [LCPC]: Radial error"  --sv FIG/LWP_M3b.png
./graph.py -f dif.out -x4 -y12 --yn -2 --yx 2 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [LCPC]: Along Track error"  --sv FIG/LWP_M3c.png
./graph.py -f dif.out -x4 -y13 --yn -2 --yx 2 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [LCPC]: Cross Track error"  --sv FIG/LWP_M3d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -2 --yx 2 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [LCPC]" --sv FIG/LWP_M3e.png




# Mode4 [GRAPHIC]:
#-----------------
./gLAB_linux -input:cfg gLAB_LWP_M4.cfg -input:obs graa0800.07o -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3


./graph.py -f dif.out -x4 -y9  --yn -0 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [GRAPHIC]: 3D error"  --sv FIG/LWP_M4a.png
./graph.py -f dif.out -x4 -y11 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [GRAPHIC]: Radial error"  --sv FIG/LWP_M4b.png
./graph.py -f dif.out -x4 -y12 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [GRAPHIC]: Along Track error"  --sv FIG/LWP_M4c.png
./graph.py -f dif.out -x4 -y13 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [GRAPHIC]: Cross Track error"  --sv FIG/LWP_M4d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [GRAPHIC]" --sv FIG/LWP_M4e.png



# Mode5 [P1L1]:
#-------------
./gLAB_linux -input:cfg gLAB_LWP_M5.cfg -input:obs graa0800.07o -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx -input:dcb brdc0800.07n -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3


#./graph.py -f dif.out -x4 -y9  --yn -0 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]: 3D error"  --sv FIG/LWP_M5a.png
./graph.py -f dif.out -x4 -y11 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]: Radial error"  --sv FIG/LWP_M5b.png
./graph.py -f dif.out -x4 -y12 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]: Along Track error"  --sv FIG/LWP_M5c.png
./graph.py -f dif.out -x4 -y13 --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]: Cross Track error"  --sv FIG/LWP_M5d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -4 --yx 4 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]" --sv FIG/LWP_M5e.png




#===================

# HOME-WORK:
#===========

#HW1:
#---

# a)
./gLAB_linux -input:cfg gLAB_LWP_HW1.cfg -input:obs graa0800.07o -input:nav brdc0800.07n

./graph.py -f gLAB.out -c '($1=="INPUT")' -x4 -y'($11-$12)' -l "ALL"  -f gLAB.out -c '($1=="INPUT")&($6==16)' -x4 -y'($10-$9)' -so -l "PRN16 P2-P1"  -f gLAB.out -c '($1=="INPUT")&($6==16)' -x4 -y'($11-$12)' -so -l "PRN16 L1-L2"  --xn 43000 --xx 67000  --yn -10 --yx 15  --xl "time (s)" --yl "STEC (metres of L1-L2 delay)" -t "Ionospheric delay" --sv FIG/LWP_HW1a.png


# b)

#[MEAS YY Doy sec GPS PRN el Az N. list C1C L1C C1P L1P C2P L2P]
#  1    2  3   4   5   6   7  8 9   10   11 xx  13  14  15  16]

./gLAB_linux -input:cfg meas.cfg -input:obs  graa0800.07o >  meas.txt
gawk '{print $6,$4,($11-$14)/2}' meas.txt > I1.txt

./graph.py -f I1.txt -x2 -y3 -s. --cl y -l "ALL" -f I1.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16" -f I1.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21" --xn 43000 --xx 67000 --yn -10 --yx 10 --xl "time (s)" --yl "STEC (metres of L1 delay)" -t "Ionospheric delay"  --sv FIG/LWP_HW1b.png


# c)
grep MODEL  gLAB.out |grep C1P|gawk '{print $6,$4,$25-3}' > klob.txt

./graph.py -f klob.txt -c '($1==16)' -x2 -y3 -so --cl b -l "PRN16: Klob (shifted)" -f klob.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21: Klob (shifted)"  -f I1.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16 1/2(C1-L1)" -f I1.txt -c '($1==21)' -x2 -y3 -so --cl m -l "PRN21 1/2(C1-L1)" --xn 43000 --xx 67000 --yn -5 --yx 10 --xl "time (s)" --yl "STEC (metres of L1 delay)" -t "Ionospheric delay" --sv FIG/LWP_HW1c.png



# HW2:
#-----
# As in Mode 1, but including "Print Epochsat" in output:
#
./gLAB_linux -input:cfg  gLAB_LWP_HW2.cfg -input:obs graa0800.07o -input:nav brdc0800.07n -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3

./graph.py -f dif.out -x4 -y9 -s- -l "3D error (m)" -f gLAB.out -c '($1=="OUTPUT")' -x4 -y'($5*5)' -s- --cl r -l '5 * 3D formal error (m)' -f gLAB.out -c '($1=="EPOCHSAT")' -x4 -y6 -s- --cl g -l "N. satellites used" --yn 0 --yx 20 --xl "time (s)" --sv  FIG/LWP_HW2a.png
./graph.py  -f dif.out -x4 -y9 -s.- -l "3D error (m)" -f gLAB.out -c '($1=="OUTPUT")' -x4 -y'($5*5)' -s.- --cl r -l '5 * 3D formal error (m)' -f gLAB.out -c '($1=="EPOCHSAT")' -x4 -y6 -s.- --cl g -l "N. satellites used" --xn 43000 --xx 67000 --yn 0 --yx 20 --xl "time (s)" --sv FIG/LWP_HW2b.png


# HW3:
#-----

#[MEAS YY Doy sec GPS PRN el Az N. list C1C L1C C1P L1P C2P L2P]
#  1    2  3   4   5   6   7  8 9   10   11 xx  13  14  15  16]


./gLAB_linux -input:cfg meas.cfg -input:obs  graa0800.07o >  meas.txt

# C1
gawk 'BEGIN{g12=(77/60)^2} {print $6,$4,$11-$14-2/(g12-1)*($14-$16)}' meas.txt > C1.txt
./graph.py -f C1.txt -x2 -y3 -s. --cl y -l "ALL" -f C1.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16" -f C1.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21" --xn 43000 --xx 67000 --yn 8 --yx 28 --xl "time (s)" --yl "metres" -t "C1 code measurement noise and multipath" --sv FIG/LWP_HW3a.png

# P1
gawk 'BEGIN{g12=(77/60)^2} {print $6,$4,$13-$14-2/(g12-1)*($14-$16)}' meas.txt > P1.txt

./graph.py -f P1.txt -x2 -y3 -s. --cl y -l "ALL" -f P1.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16" -f P1.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21" --xn 43000 --xx 67000 --yn 8 --yx 28 --xl "time (s)" --yl "metres" -t "P1 code measurement noise and multipath"  --sv FIG/LWP_HW3b.png

# P2
gawk 'BEGIN{g12=(77/60)^2} {print $6,$4,$15-$16-2*g12/(g12-1)*($14-$16)}' meas.txt > P2.txt

./graph.py -f P2.txt -x2 -y3 -s. --cl y -l "ALL" -f P2.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16" -f P2.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21" --xn 43000 --xx 67000 --yn 15 --yx 35 --xl "time (s)" --yl "metres" -t "P2 code measurement noise and multipath" --sv FIG/LWP_HW3c.png

# PC
gawk 'BEGIN{g12=(77/60)^2} {print $6,$4,(g12*($13-$14)-($15-$16))/(g12-1)}' meas.txt > PC.txt

./graph.py -f  PC.txt -x2 -y3 -s. --cl y -l "ALL" -f  PC.txt -c '($1==16)' -x2 -y3 -so --cl r -l "PRN16" -f  PC.txt -c '($1==21)' -x2 -y3 -so --cl g -l "PRN21" --xn 43000 --xx 67000 --yn -10 --yx 10 --xl "time (s)" --yl "metres" -t "Ionosphere free combination measurement noise PC-LC"   --sv FIG/LWP_HW3d.png


# HW4:
#-----

# 1) IGS-APC:

./gLAB_linux -input:nav  brdc0800.07n  -input:SP3 cod14193.sp3  -input:ant igs05_1402.atx > dif.tmp
grep SATDIFF dif.tmp > dif.out

./graph.py -f dif.out -x4 -y11 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y11 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Radial error" --sv FIG/LWP_HW4a1.png
./graph.py -f dif.out -x4 -y12 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y12 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Along Track error" --sv FIG/LWP_HW4b1.png
./graph.py -f dif.out -x4 -y13 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y13 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Cross Track eerror" --sv FIG/LWP_HW4c1.png
./graph.py -f dif.out -x4 -y10 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y10 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: Clock error" --cl r --sv FIG/LWP_HW4d1.png

./graph.py -f dif.out -x4 -y7 -s. --cl g -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y7 --yn 0 --yx 10 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [IGS APC]: SISRE" --cl r --sv FIG/LWP_HW4e1.png


# 2) BRD-APC:

./gLAB_linux -input:nav  brdc0800.07n  -input:SP3 cod14193.sp3  -input:ant gps_brd.atx > dif.tmp
grep SATDIFF dif.tmp > dif.out

./graph.py -f dif.out -x4 -y11 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y11 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Radial error" --sv FIG/LWP_HW4a2.png
./graph.py -f dif.out -x4 -y12 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y12 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Along Track error" --sv FIG/LWP_HW4b2.png
./graph.py -f dif.out -x4 -y13 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y13 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Cross Track eerror" --sv FIG/LWP_HW4c2.png
./graph.py -f dif.out -x4 -y10 -s.  -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y10 --yn -5 --yx 5 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: Clock error" --cl r --sv FIG/LWP_HW4d2.png

./graph.py -f dif.out -x4 -y7 -s. --cl g -l "ALL" -f dif.out -c '($6==16)' -so --cl r -l "PRN16" -x4 -y7 --yn 0 --yx 10 --xl "time (s)" --yl "metres" -t "GPS Broadcast - Precise [BRD APC]: SISRE" --cl r --sv FIG/LWP_HW4e2.png



# HW5:
#-----

./gLAB_linux -input:cfg gLAB_LWP_HW5.cfg -input:obs graa0800.07o  -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx
grep POSTFIT gLAB.out | gawk '{i=$6" "$4;a[i]=$13}END{for (i in a) print i,a[i]}' | sort -n > amb.out

./graph.py -f amb.out -x2 -y3 -f amb.out -x2 -y3 -c '($1==16)' -l "PRN16" -f amb.out -x2 -y3 -c '($1==21)' -l "PRN21" -t "Carrier phase ambiguities estimations" --xl "time (s)" --yl "metres" --yn -10 --yx 10 --sv FIG/LWP_HW5a.png
./graph.py -f amb.out -x2 -y3 -f amb.out -x2 -y3 -c '($1==16)' -l "PRN16" -f amb.out -x2 -y3 -c '($1==21)' -l "PRN21" -t "Carrier phase ambiguities estimations" --xl "time (s)" --yl "metres" --xn 36800 --xx 44000 --yn -10 --yx 10 --sv FIG/LWP_HW5b.png
./graph.py -f amb.out -x2 -y3 -f amb.out -x2 -y3 -c '($1==16)' -l "PRN16" -f amb.out -x2 -y3 -c '($1==21)' -l "PRN21" -t "Carrier phase ambiguities estimations" --xl "time (s)" --yl "metres" --xn 66800 --xx 74000 --yn -10 --yx 10 --sv FIG/LWP_HW5c.png
./graph.py -f amb.out -x2 -y3 -f amb.out -x2 -y3 -c '($1==16)' -l "PRN16" -f amb.out -x2 -y3 -c '($1==21)' -l "PRN21" -t "Carrier phase ambiguities estimations" --xl "time (s)" --yl "metres" --xn 40000 --xx 70000 --yn -10 --yx 10 --sv FIG/LWP_HW5d.png


# HW6:
#-----
./gLAB_linux -input:cfg gLAB_LWP_HW6.cfg -input:obs graa0800.07o -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx -input:dcb brdc0800.07n  -input:klb brdc0800.07n -output:sp3 gLAB.sp3
./gLAB_linux -input:cfg dif.cfg -input:SP3 GRAA_07_080.sp3 -input:SP3 gLAB.sp3


./graph.py -f dif.out -x4 -y9  --yn -0 --yx 16 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1] + Klob: 3D error"  --sv FIG/LWP_HW6a.png
./graph.py -f dif.out -x4 -y11 --yn -8 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1] + Klob: Radial error"  --sv FIG/LWP_HW6b.png
./graph.py -f dif.out -x4 -y12 --yn -8 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1] + Klob: Along Track error"  --sv FIG/LWP_HW6c.png
./graph.py -f dif.out -x4 -y13 --yn -8 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1] + Klob: Cross Track error"  --sv FIG/LWP_HW6d.png
./graph.py -f dif.out -x4 -y11 -l "Radial"  -f dif.out -x4 -y12 -l "Along Track"  -f dif.out -x4 -y13 -l "Cross Track" --xn 43000 --xx 67000  --yn -8 --yx 8 --xl "time (s)" --yl "metres" -t "GRACE-A Broadcast positioning [P1L1]+ Klob" --sv FIG/LWP_HW6e.png



# HW7:
#-----

#Option A:
./gLAB_linux -input:cfg gLAB_LWP_HW6.cfg -input:obs graa0800.07o -input:orb cod14193.sp3 -input:clk cod14193.clk -input:ant igs05_1402.atx -input:dcb brdc0800.07n  -input:klb brdc0800.07n -output:kml track.kml

# Option B:
#cat Prefix.kml > track.kml
#grep OUTPUT gLAB.out | gawk 'BEGIN{OFS=", "}{print $16,$15,$17}' >> track.kml
#cat Postfix.kml >> track.kml


# Cleaning temporary files in the directory:
rm I1.txt    C1.txt  PC.txt   gLAB.sp3  track.kml klob.txt  P1.txt  dif.tmp  dif.out   gLAB.out meas.txt  P2.txt  amb.out

