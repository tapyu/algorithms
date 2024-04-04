# gLAB

Interactive educational multipurpose package to process and analyse GNSS data, i.e., a GNSS positioning simulator.

**Context**: any version of the gLAB software can be downloaded [here][6]. However, in none of these links you will obtain the tutorial datafiles. Such a material is packaged in the [GNSS tutoral link][1], together with the gLAB source code in a tarball file (see `Software and Data Files [Linux]` for Linux). On the one hand, at the time I am writing it (April 2024) , the gLAB source code packaged in this tarball is the version 5.2, which didn't work on Linux. On the other hand, the latest version of gLAB at the time of writing it (v5.5.1) worked perfectly on Linux.

Therefore, in order to create a straightfoward path to use any gLAB version with the computation homeworks, I've created this repository, which contains both the version v5.5.1 for Linux and the tutorial material.

## Branches

- `source-code-v5.5.1`: contains the source code for gLAB version v5.5.1, but with a minor correction in the `Makefile` (see its `README.md`)
- `tutorials`: contains the computational homeworks that were retreived in previous version of gLAB.
- `main`: contains both contents plus `install.sh`, which is used to install it seamlessly.

## Installing and usage

- To install `glab`, run `./install.sh`. It should generate `gLAB_linux` and `gLAB_linux_multithread`. If it doesn't work, see `README_install.txt`.
- Use `gLAB_GUI_64` for gLAB with GUI (on a 64-bits computer architecture) or `gLAB_linux` for the command line approach.

## Directory structure

- `FILES/`: Contains the backup gzip files for each tutorial in `TUTX/`. You should not remove these files as `ntpd_tutX.sh` decompresses them to create new `WORK/TUTX/` directories with the simulation results.
- `PROG/`:
  - Each `TUTX/` directory just contains configuration plus symlink to gLAB executable.
- `WORK/`: Contains the unzipped files and the simulation results for each tutorial in `TUTX`. This directory is ignored by git as it contains large files that are result of simulation. Possible file types that you might find in each `TUTX/` dir:
  - RINEX -> `<sta><Doy>0.<yy><type>`
    - `<sta>`: Station name.
    - `<Doy>`: Day of year.
    - `<yy>`: Year.
    - `<type>`: `o` -> observation RINEX file; `n` -> navigation RINEX file
    Example: `amc3030.03o` is the observation RINEX file for the `amc` station, on October 30th, 2003.
  - precise orbits & clocks -> `.sp3` extension
  - Antenna Phase Center (APC) -> `.atx.`
  - Precise receiver coordinates -> `.snx.`
- `ntpd_tutX.sh`: Unix Shell script to run tutorial X. It basically creates `WORK/TUTX/`, and copies the config files from `PROG/TUTX/` and data files from `FILES/TUTX/` to it.

[here]: https://gage.upc.edu/en/learning-materials/software-tools/glab-tool-suite-links/glab-download
[1]: https://gage.upc.edu/486/gage/en/en/learning-materials/software-tools/glab-tool-suite-links/glab-tutorials/gnss-tutorials
[6]: https://gage.upc.edu/en/learning-materials/software-tools/glab-tool-suite-links/glab-download
