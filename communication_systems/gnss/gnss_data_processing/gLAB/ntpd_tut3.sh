#!/bin/bash
# TUTORIAL 3: GNSS Data Processing Lab Exercises.
#             Navigation & measurements modelling
#================================================

# Create the Working directory and copy Programs and Files
# into this directory.


mkdir ./WORK 2> /dev/null
mkdir ./WORK/TUT3
mkdir ./WORK/TUT3/FIG

cd ./WORK/TUT3


#PROGRAM FILES
#-------------
cp ../../PROG/TUT3/* .
if [[ "$(uname -s)" =~ "CYGWIN" ]]
then
	cp -d /bin/gLAB_linux /bin/gLAB_GUI /bin/graph.py .
	cp /usr/bin/out2sp3 .
fi

#DATA FILES
#----------
cp ../../FILES/TUT3/* .

gzip -df *.gz

#============================================================


#Exercise 1: 
#-----------

#a) FULL model [gLAB.out]
./gLAB_linux -input:cfg gLAB_Ex1a.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB_full1.out

./graph.py -f gLAB_full1.out -x4 -y18 -s.- -c '($1=="OUTPUT")'  -l "North error"  -f gLAB_full1.out -x4 -y19 -s.- -c '($1=="OUTPUT")'  -l "East error"  -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")'  -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)"  -t "NEU positioning error [SPP]: Full model" --sv FIG/Ex1a1.png


# b) No ionospheric corrections

./graph.py -f gLAB_full1.out -x4 -y25 -s. -c '($1=="MODEL") & ($7=="C1C")' --xl "time (s)" --yl "metres" -t "Model: Iono. corrections [SPP]" --sv FIG/Ex1b1.png

./gLAB_linux -input:cfg gLAB_Ex1b.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1b.out

./graph.py -f gLAB1b.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1b.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1b.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No Iono. corr.: January 1st 2004" --sv FIG/Ex1b2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1b.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Iono. corr." --cl r  --yn -40 --yx 40 --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1b3.png

./graph.py  -f gLAB1b.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Iono. corr." --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -20 --xx 20 --yn -20 --yx 20 --sv FIG/Ex1b4.png


#c) No Tropospheric corrections
./graph.py -f gLAB_full1.out -x4 -y24 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Tropo corrections [SPP]" --sv FIG/Ex1c1.png

./gLAB_linux -input:cfg gLAB_Ex1c.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1c.out

./graph.py -f gLAB1c.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1c.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1c.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No Tropo. corr.: January 1st 2004" --sv FIG/Ex1c2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1c.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Tropo. corr." --cl r --yn -40 --yx 40  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1c3.png

./graph.py -f gLAB1c.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Tropo. corr." --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -20 --xx 20 --yn -20 --yx 20 --sv FIG/Ex1c4.png



#d) No Relativistic clock correction

./graph.py -f gLAB_full1.out -x4 -y22 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Relativistic clock correction (orb. excent) [SPP]" --sv FIG/Ex1d1.png

./gLAB_linux -input:cfg gLAB_Ex1d.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1d.out

./graph.py -f gLAB1d.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1d.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1d.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No Rel. Clock: January 1st 2004" --sv FIG/Ex1d2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1d.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No relat. corr." --cl r  --yn -40 --yx 40  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1d3.png

./graph.py  -f gLAB1d.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No relat. corr." --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b   --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -20 --xx 20 --yn -20 --yx 20 --sv FIG/Ex1d4.png


#e) No Total Group Delay correction

./graph.py -f gLAB_full1.out -x4 -y27 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Total Group Delay (TGD) [SPP]" --sv FIG/Ex1e1.png

./gLAB_linux -input:cfg gLAB_Ex1e.cfg  -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1e.out

./graph.py -f gLAB1e.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1e.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1e.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No TGD corr.: January 1st 2004" --sv FIG/Ex1e2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1e.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No TGD corr." --cl r  --yn -40 --yx 40 --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1e3.png

./graph.py -f gLAB1e.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No TGD corr." --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -20 --xx 20 --yn -20 --yx 20 --sv FIG/Ex1e4.png



#f) No Satellite clock offset correction

./graph.py -f gLAB_full1.out -x4 -y18 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Satellite clock offset [SPP]" --sv FIG/Ex1f1.png

./gLAB_linux -input:cfg gLAB_Ex1f.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1f.out

./graph.py -f gLAB1f.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1f.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1f.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -1e6 --yx 1e6 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No Sat clocks.: January 1st 2004" --sv FIG/Ex1f2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1f.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Sat clocks" --cl r  --yn -1e6 --yx 1e6 -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' --cl b  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1f3.png

./graph.py  -f gLAB1f.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Sat clocks" --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -5e5 --xx 5e5 --yn -5e5 --yx 5e5 --sv FIG/Ex1f4.png



#g) Effect of taking the satellite coordinates in reception time instead of emission time:
#-----------------------------------------------------------------------------------------

# Both are unset:
#  - Satellite movement during the signal flight time
#  and
#  - Earth rotation during the signal flight time.

./gLAB_linux -input:cfg gLAB_Ex1g.cfg  -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1g.out

cat gLAB_full1.out gLAB1g.out|gawk '{if ($1=="MODEL") print $4,$6,$17}' > tmp.dat
cat tmp.dat|gawk '{i=$1" "$2;if(length(r[i])!=0){dr[i]=r[i]-$3} else {r[i]=$3}} END{for (i in dr) print i,dr[i]}' >dr_sat.dat #mind that "i" contains two fields

./graph.py -f dr_sat.dat -x1 -y3 -s.  --xl "time (s)" --yl "metres" -t "Model: Sat. cood. in reception time instead of emission [SPP]" --sv FIG/Ex1g1.png


./graph.py -f gLAB1g.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1g.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1g.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -150 --yx 150 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: Coordinates in reception time vs. emission: January 1st 2004" --sv FIG/Ex1g2.png


./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1g.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Sat. coord. in recept. time instead of emission." --cl r  --yn -150 --yx 150 --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1g3.png

./graph.py -f gLAB1g.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "Sat. coord. in recept. time instead of emission." --cl r -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -100 --xx 100 --yn -100 --yx 100 --sv FIG/Ex1g4.png


#h) Earth rotation (flight time)

./gLAB_linux -input:cfg gLAB_Ex1h.cfg -input:obs chpi0010.04o -input:nav brdc0010.04n  -input:snx igs03P1251.snx -output:file gLAB1h.out

cat gLAB_full1.out gLAB1h.out |gawk '{if ($1=="MODEL") print $4,$6,$17}' > tmp.dat
cat tmp.dat|gawk '{i=$1" "$2;if(length(r[i])!=0){dr[i]=r[i]-$3} else {r[i]=$3}} END{for (i in dr) print i,dr[i]}' >dr_earth.dat

./graph.py -f dr_earth.dat -x1 -y3 -s. --xl "time (s)" --yl "metres" -t "Model: Earth rotation during signal flight time [SPP]" --sv FIG/Ex1h1.png

./graph.py -f gLAB1h.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB1h.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB1h.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --yn -40 --yx 40 --xl "time (s)" --yl "error (m)" -t "NEU error [SPP]: No Earth rot.: January 1st 2004" --sv FIG/Ex1h2.png

./graph.py -f gLAB_full1.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB1h.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Earth rot." --cl r --yn -40 --yx 40  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [SPP]" --sv FIG/Ex1h3.png

./graph.py -f gLAB1h.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Earth rot." --cl r  -f gLAB_full1.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model"  --cl b  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [SPP]" --xn -10 --xx 40 --yn -20 --yx 20 --sv FIG/Ex1h4.png



# Exercise 2: 
# ----------

#a) Full model

./gLAB_linux -input:cfg gLAB_Ex2a.cfg -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB_full2.out

./graph.py -f gLAB_full2.out -x4 -y18 -s.- -c '($1=="OUTPUT")' -l "North error" -f gLAB_full2.out -x4 -y19 -s.- -c '($1=="OUTPUT")' -l "East error" -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "UP error" --xl "time (s)" --yl "error (m)" --yn -0.4 --yx 0.4 -t "NEU positioning error [Kinem PPP]" --sv FIG/Ex2a1.png

./graph.py -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")' --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --xn -0.4 --xx 0.4 --yn -0.4 --yx 0.4 --sv FIG/Ex2a2.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Troposphere" --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49 -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2a3.png


#b)  No Solid Tides corrections

./graph.py -f gLAB_full2.out -x4 -y28 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "2b: Model: Solid Tides [Kinem PPP]" --sv FIG/Ex2b1.png

./gLAB_linux -input:cfg gLAB_Ex2b.cfg  -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB2b.out

./graph.py -f gLAB2b.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No Solid Tides corr." --cl r -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model" --cl b --xn -0.4 --xx 0.4 --yn -0.4 --yx 0.4  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --sv FIG/Ex2b2.png

./graph.py -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB2b.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No Solid Tides corr." --cl r --yn -0.4 --yx 0.4 --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [Kinem PPP]" --sv FIG/Ex2b3.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Full model" -f gLAB2b.out -x4 -y9 -s.- -c '($1=="FILTER")'  -l "No Solid Tides corr." --cl r --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49  -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2b4.png


#c) No Receiver antenna phase center correction

./graph.py -f gLAB_full2.out -x4 -y20 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Receiveir  APC to ARP offset [Kinem PPP]" --sv FIG/Ex2c1.png

./gLAB_linux -input:cfg gLAB_Ex2c.cfg  -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB2c.out

./graph.py -f gLAB2c.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No receiver APC correction" --cl r -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model" --cl b --xn -0.4 --xx 0.4 --yn -0.4 --yx 0.4  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --sv FIG/Ex2c2.png

./graph.py -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB2c.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No receiver APC correction" --cl r  --yn -0.4 --yx 0.4  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [Kinem PPP]" --sv FIG/Ex2c3.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Full model" -f gLAB2c.out -x4 -y9 -s.- -c '($1=="FILTER")'  -l "No receiver APC correction" --cl r --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49  -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2c4.png



#d) No Satellite Mass center to antenna phase center correction

./graph.py -f gLAB_full2.out -x4 -y19 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Satellite MC to APC offset [Kinem PPP]" --sv FIG/Ex2d1.png

./gLAB_linux -input:cfg gLAB_Ex2d.cfg  -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB2d.out

./graph.py -f gLAB2d.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No satellite APC correction" --cl r -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model" --cl b --xn -0.4 --xx 0.4 --yn -0.4 --yx 0.4  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --sv FIG/Ex2d2.png

./graph.py -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB2d.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No satellite APC correction" --cl r  --yn -0.4 --yx 0.4  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [Kinem PPP]" --sv FIG/Ex2d3.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Full model" -f gLAB2d.out -x4 -y9 -s.- -c '($1=="FILTER")'  -l "No satellite APC correction" --cl r --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49  -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2d4.png



#e) No Wind_up correction

./graph.py -f gLAB_full2.out  -x4 -y23 -s. -c '(($1=="MODEL") & ($7=="L1P"))' --xl "time (s)" --yl "metres" -t "Model: Carrier phase wind-up correction" --sv FIG/Ex2e1.png

./gLAB_linux -input:cfg gLAB_Ex2e.cfg  -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB2e.out

./graph.py -f gLAB2e.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No wind-up corr." --cl r -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model" --cl b --xn -0.4 --xx 0.4 --yn -0.4 --yx 0.4  --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --sv FIG/Ex2e2.png

./graph.py -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB2e.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No wind-up corr." --cl r  --xl "Time (s)" --yl "Up error (m)" --yn -0.4 --yx 0.4  -t "Vertical positioning error [Kinem PPP]" --sv FIG/Ex2e3.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Full model" -f gLAB2e.out -x4 -y9 -s.- -c '($1=="FILTER")'  -l "No wind-up corr." --cl r --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49  -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2e4.png


#f) Relativistic Path range correction
./graph.py -f gLAB_full2.out -x4 -y26 -s. -c '($1=="MODEL")' --xl "time (s)" --yl "metres" -t "Model: Relativistic path range effect [Kinem PPP]" --sv FIG/Ex2f1.png

./gLAB_linux -input:cfg gLAB_Ex2f.cfg  -input:obs chpi0010.04o -input:sp3 igs12514.sp3  -input:ant igs_pre1400.atx -input:snx igs03P1251.snx -output:file gLAB2f.out

./graph.py -f gLAB2f.out -x19 -y18 -so -c '($1=="OUTPUT")' -l "No rel. path corr." --cl r -f gLAB_full2.out -x19 -y18 -so -c '($1=="OUTPUT")'  -l "Full model" --cl b --xn -0.05 --xx 0.05 --yn -0.05 --yx 0.05 --xl "East error (m)" --yl "North error (m)" -t "Horizontal positioning error [Kinem PPP]" --sv FIG/Ex2f2.png

./graph.py -f gLAB_full2.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "Full model" -f gLAB2f.out -x4 -y20 -s.- -c '($1=="OUTPUT")' -l "No rel. path corr." --cl r  --yn -0.1 --yx 0.1  --xl "Time (s)" --yl "Up error (m)" -t "Vertical positioning error [Kinem PPP]" --sv FIG/Ex2f3.png

./graph.py -f gLAB_full2.out -x4 -y9 -s.- -c '($1=="FILTER")' -l "Full model" -f gLAB2f.out -x4 -y9 -s.- -c '($1=="FILTER")'  -l "No rel. path corr." --cl r --xl "time (s)" --yl "error (m)" --yn 2.38 --yx 2.49  -t "Tropospheric delay [Kinem PPP]"  --sv FIG/Ex2f4.png

# Cleaning temporary files in the directory:
#rm gLAB_full.out gLAB_full2.out dr.dat tmp.dat
