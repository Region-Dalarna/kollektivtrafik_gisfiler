# ============================================================
#  def_geografi.R – kommuner i Dalarna, för kommunväljaren i
#  Nedladdning-fliken. Ordnade i svensk bokstavsordning (å/ä/ö sist),
#  så att kommunväljaren inte behöver sortera om det vid varje anrop.
#
#  kommun_fil används som filnamnsdel (svenska tecken utbytta) och
#  matchar namngivningen i de gamla, statiska gpkg-filerna
#  (gis-filer/Kollektivtrafik_<kommun_fil>.gpkg) så att GIS-användare
#  känner igen filnamnen.
# ============================================================

DALARNA_KOMMUNER <- tibble::tribble(
  ~kommun_kod, ~kommun_namn,   ~kommun_fil,
  "2084",      "Avesta",       "Avesta",
  "2081",      "Borlänge",     "Borlange",
  "2080",      "Falun",        "Falun",
  "2026",      "Gagnef",       "Gagnef",
  "2083",      "Hedemora",     "Hedemora",
  "2029",      "Leksand",      "Leksand",
  "2085",      "Ludvika",      "Ludvika",
  "2023",      "Malung-Sälen", "Malung-Salen",
  "2062",      "Mora",         "Mora",
  "2034",      "Orsa",         "Orsa",
  "2031",      "Rättvik",      "Rattvik",
  "2061",      "Smedjebacken", "Smedjebacken",
  "2082",      "Säter",        "Sater",
  "2021",      "Vansbro",      "Vansbro",
  "2039",      "Älvdalen",     "Alvdalen"
)

LAN_KOD_DALARNA <- "20"
