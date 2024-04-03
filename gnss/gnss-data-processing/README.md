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
  - **Caveat**: Any version of the gLAB software can be downloaded [here][6]. However, in none of these links you will obtain the tutorial datafiles. Such a material is packaged in the [GNSS tutoral link][1], together with the gLAB source code in a tarball file (see `Software and Data Files [Linux]` for Linux). On the one hand, at the time I am writing it (April 2024) , the gLAB source code packaged in this tarball is the version 5.2, which didn't work on Linux. On the other hand, the latest version of gLAB at the time of writing it (v5.5.1) worked perfectly on Linux.
  
    Therefore, in order to create a straightfoward path to use any gLAB version with the computation homeworks, I've created a git submodule at `./gLAB/`, which contains both the version v5.5.1 for Linux and the tutorial material.

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
