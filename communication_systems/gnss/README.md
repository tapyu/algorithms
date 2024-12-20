# Global Navigation Satellite System (GNSS)

This directory contains a compendium of algorithms for Global Navigation Satellite System (GNSS). Such algorithms focus on the following topics:
- [GNSS Signal Processing](gnss_signal_processing)
- [GNSS Data Processing](gnss_data_processing)

- The algorithms implemented here come from three sources:
   1. [Galileo Masterclass Brazil (GMB) 2022: ​​​​​​From Fundamentals to Signal and Data Processing][2] - taught at Federal University of Ceará, Brazil, by [Professors from group of Astronomy and GEomatics (gAGE)][1], from Universitat Politècnica de Catalunya, UPC; Prof. Dr. Felix Antreich, from Aeronautics Institute of Technology, ITA, Brazil; and Prof. Dr. Antônio Macilio Pereira de Lucena, from National Institute for Space Research, INPE, Brazil. This 7-days course was promoted by the [Galileo Information Centre (GIC)] in Brazil.
  2. The course on "GNSS Data Processing", taught in Barcelona, Spain, by Professors Prof. Dr. [Jaume Sanz Subirana] and [Guillermo Gonzalez Casado] in 2024.1.
  3. The course on "GNSS Signal Processing", taught by Prof. Dr. [Felix Antreich], at Aeronautics Institute of Technology, ITA, Brazil.
  
  The content of both course overlaps with the GMB 2022 webinar contents.

[1]: https://gage.upc.edu/en/personnel/permanent-staff
[2]: https://gage.upc.edu/en/learning-materials/library/gnss-webinars/gic-masterclass-brazil-2022
[Galileo Information Centre (GIC)]: https://gage.upc.edu/en/projects/gage-upc/gic-brazil
[Jaume Sanz Subirana]: https://gage.upc.edu/en/personnel/permanent-staff/jaume.sanz
[Guillermo Gonzalez Casado]: https://gage.upc.edu/en/personnel/permanent-staff/dr-guillermo-gonzalez-casado
[Felix Antreich]: https://ieeexplore.ieee.org/author/37394570200

---

## [Galileo Masterclass Brazil (GMB) 2022 schedule][2]

<p align="center">
  <img src="https://github.com/tapyu/algorithms/assets/22801918/b156f4a7-8b95-4609-8f45-e469fa535eeb" height="700pt" alt="GMB 2022 Programme"/>
</p>


NOTE:
- `Ln` - `n`th lecture presentation.
- `En` - `n`th external presentation.
- The Macilio's presentattion took place during the visit to INPE, and is the presentation code `E07`.

Presentations:
- Monday (29/08/2022):
  - [L01. Multiple Access for GNSS](https://www.youtube.com/watch?v=0ZIiCHdp_TM)
  - [E01. Luis Cuervo - Galileo Information Center Brazil](https://www.youtube.com/watch?v=T219oKb-cQE)
  - [L02. Spread Spectrum Ranging](https://www.youtube.com/watch?v=8sHFMIfiLn8)
- Tuesday (30/08/2022):
  - [L03. Chip pulse shapes and multiplexing](https://www.youtube.com/watch?v=nwR4UFRsr6o)
  - [E02. Matteo Paoni - Galileo Open Service](https://www.youtube.com/watch?v=lw_yj98kp40)
  - [L04. Signal Acquisition](https://www.youtube.com/watch?v=EbbIAJiTG7o)
- Wednesday (31/08/2022):
  - [L05. Propagation Aspects](https://www.youtube.com/watch?v=cjethAsFjgU)
  - [E03. Eric Bouton SAR Galileo a Contribution to CS MEOSAR](https://www.youtube.com/watch?v=PLf_iOxKINk)
  - [L06. Parameter Tracking](https://www.youtube.com/watch?v=VzqzUR2ehSQ)
- Thursday (01/09/2022)
  - [L07. Use of Remote Sensing in Water Resources Management](https://www.youtube.com/watch?v=LWxYjfW971o)
  - [L08. Synergy between GNSS and Remote Sensing Products](https://www.youtube.com/watch?v=ui4-17cNIDw)
  - [E07. Antonio Macilio - Ionosferic Scintillation Effect on GNSS](https://www.youtube.com/watch?v=NZngqyOBPUQ)
- Friday (02/09/2022)
  - [L09. Introduction to GNSS Positioning Techniques](https://www.youtube.com/watch?v=_v1SruojROk)
  - [E04. Werner Enderle Galileo Orbits and Clocks](https://www.youtube.com/watch?v=QPskRHeOOj4)
  - [L10. Satellite Orbits and Clocks](https://www.youtube.com/watch?v=T0Is6bkwGSk)
- Monday (05/09/2022)
  - [L11. Code pseudorange modelling](https://www.youtube.com/watch?v=VG4EgPYViB0)
  - [E05. Javier de Andrés Díaz EGNOS Overview](https://www.youtube.com/watch?v=lPNJy_uzU_M)
  - [L12. Augmentation Systems](https://www.youtube.com/watch?v=pYFFfbxO5ko)
- Tuesday (06/09/2022):
  - [L13. Solving Navigation Equations](https://www.youtube.com/watch?v=Nh2gSxoWLLE)
  - [E06. Ignacio Fernández Galileo High Accuracy Service](https://www.youtube.com/watch?v=Q6RFvlMzZJM)
  - [L14. Precise Point Positioning](https://www.youtube.com/watch?v=BF1VBCxtfVw)

## Extra material

Although these materials are not related to the aforementioned GNSS courses, they are useful for GNSS in general:

- [GNSS-SDR]
- [awesome-gnss]
- [`code`](https://geodesy.noaa.gov/gps-toolbox/) **GPS Toolbox** - GPS Toolbox topical collection of the journal GPS Solutions. It provides a means for distributing the source code and algorithms discussed in the GPS Toolbox topical collection.

For materials specific for either signal or data processing part, see the `## Extra material` in the `README.md` file of their directories.

[awesome-gnss]: https://github.com/barbeau/awesome-gnss
[GNSS-SDR]: https://gnss-sdr.org/
[GPS Toolbox]: https://geodesy.noaa.gov/gps-toolbox/


---

## Important companies (see Trello for saved job description)

- [Trimble Inc.] (United States of America)
- [Hexagon AB] (Sweden)
- [NovAtel Inc.] (Canada)
- [Septentrio] (Belgium)
- [u-blox AG] (Switzerland)
- [Elecnor Deimos] (Portugal)
- [Thales Group] (France)
- [Airbus Defence and Space] (France, Germany, Spain)
- [Rokubun] (Spain - Catalonia). PS: This one seems more like a startup. It contains open [repositories][1] on Github.

[Trimble Inc.]: https://www.trimble.com/en
[Hexagon AB]: https://hexagon.com/
[NovAtel Inc.]: https://novatel.com/
[Septentrio]: https://www.septentrio.com/en
[u-blox AG]: https://www.u-blox.com/en
[Elecnor Deimos]: https://elecnor-deimos.com/
[Thales Group]: https://www.thalesgroup.com/en
[Airbus Defence and Space]: https://www.airbus.com/en/defence
[Rokubun]: https://www.rokubun.cat/
[1]: https://github.com/rokubun
