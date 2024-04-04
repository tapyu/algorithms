#!/bin/bash

# install dependencies
sudo apt-get install gcc python3-matplotlib python3-tk python3-mpltoolkits.basemap python-mpltoolkits.basemap-data python3-numpy

# fix missing gcc flag in Makefile
awk -i inplace '{ print ($0 ~ /^CXXFLAGS \+= -O3/) ? "CXXFLAGS += -O3 -fno-stack-protector -fcommon" : $0 }' Makefile
