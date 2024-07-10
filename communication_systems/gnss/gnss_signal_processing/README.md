# GNSS Signal Processing

This directory contains algorithm solutions for computational exercises on GNSS Signal Processing.

These algorithms were developed during the [Galileo Masterclass Brazil (GMB) 2022][2] (see files [here][1]), in the GNSS Signal Processing lectures, taught by Prof. Dr. [Felix Antreich]. The algorithms cover the following topics:
- Code and correlation.
- Signal Acquisition.
- Parameter tracking.

## References

- Felix's course slides on "GNSS Signal Processing" (private).
- [GMB 2022 lectures][2].

## Extra material

- Observable simulator: generates the code pseudorange, carrier pseudorange, Doppler measurements, C/N_0 estimates, and navigation message. It basically performs the tasks of the GNSS signal processing part and generates the RINEX file, which is used in the GNSS data processing part. You can use any GNSS positioning simulator to process such a RINEX file.
  - [SiGOG]

[Felix Antreich]: https://ieeexplore.ieee.org/author/37394570200
[1]: https://server.gage.upc.edu/TEACHING_MATERIAL/GMB2022/SOFTWARE/
[2]: https://gage.upc.edu/en/learning-materials/library/gnss-webinars/gic-masterclass-brazil-2022
[SiGOG]: https://geodesy.noaa.gov/gps-toolbox/Mohino.htm
