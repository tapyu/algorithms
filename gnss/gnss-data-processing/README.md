# GNSS Data Processing

This directory contains algorithm solutions for computational exercises on GNSS Data Processing.

- These algorithms were developed during two events:
  - Galileo Masterclass Brazil (GMB) 2022.
  - The course "GNSS Data Processing", taught by Prof. Dr. [Jaume Sanz Subirana] and Prof. Dr. [Guillermo Gonzalez Casado], at Universitat Politècnica de Catalunya, UPC, Spain.
- The [gLAB] software is used during this course for the laboratory exercises.
- The [algorithms] cover the following topics:
  - Model Component Analysis.
  - Navigation equation solution.

## References
Main:
- [GNSS DATA PROCESSING Volume I: Fundamentals and Algorithms][4]. J. Sanz Subirana, J.M. Juan Zornoza and M. Hernández-Pajares. European Space Agency
- [GNSS DATA PROCESSING Volume II: Laboratory Exercises][4]. J. Sanz Subirana, J.M. Juan Zornoza and M. Hernández-Pajares. European Space Agency.

Others:
- [Jaume's course slides on "GNSS Data Processing"][1].
- [GMB 2022 slides][3].
- [GPS data processing - code and phase Algorithms, Techniques and Recipes][2] (?)

## Other resources

- [GNSS Format Descriptions]: RINEX, ANTEX, IONEX, etc.
- [The Receiver Independent Exchange Format - Rinex]
- [GNSS Format Descriptions (gFD) Quiz prepared by gAGE][5]
- [GNSS Tutorials][6]
- [gLAB]
  - **Caveat**: The gLAB installation process is not an easy task. On the one hand, the GUI part of [the gLAB version availabe along with the GNSS tutorial material (v5.2.0)][1] didn't work on Linux, but it contains the computational homeworks. On the other hand, the latest version of gLAB at the time of writing it (v5.5.1) worked perfectly on Linux, but it didn't have the computational homeworks, only the source code. Moreover, the directory structure of both versions is completely different. You can find the download link for all gLAB versions [here][6].
  
    Therefore, in order to create a straightfoward path to use gLAB with the computation homeworks, I've created a git submodule at `./gLAB/`, which contains both the version v5.5.1 for Linux and the tutorial material. In the future, newer versions may be easier to install it and `./gLAB/` will no longer be necessary.

[Jaume Sanz Subirana]: https://gage.upc.edu/en/personnel/permanent-staff/jaume.sanz
[Guillermo Gonzalez Casado]: https://gage.upc.edu/en/personnel/permanent-staff/dr-guillermo-gonzalez-casado
[algorithms]: https://server.gage.upc.edu/TEACHING_MATERIAL/GMB2022/SOFTWARE/
[1]: https://gage.upc.edu/486/gage/en/en/learning-materials/software-tools/glab-tool-suite-links/glab-tutorials/gnss-tutorials
[2]: https://gage.upc.edu/en/learning-materials/library/gnss-books/gps-data-processing-code-and-phase-algorithms-techniques-and-recipes
[3]: https://gage.upc.edu/en/learning-materials/library/gnss-webinars/gic-masterclass-brazil-2022
[4]: https://gage.upc.edu/en/learning-materials/library/gnss-books/gnss-data-processing-book
[GNSS Format Descriptions]: https://gage.upc.edu/en/learning-materials/library/gnss-format-descriptions
[5]: https://server.gage.upc.edu/gLAB/HTML/GNSS_standard_format_files.pdf
[6]: https://gage.upc.edu/en/learning-materials/software-tools/glab-tool-suite-links/glab-download
[gLAB]: https://gage.upc.edu/en/learning-materials/software-tools/glab-tool-suite
[The Receiver Independent Exchange Format - Rinex]: https://files.igs.org/pub/data/format/rinex_4.00.pdf?_ga=2.189936815.567175650.1708691301-1982200360.1707403568
