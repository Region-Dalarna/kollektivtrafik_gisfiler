# ============================================================
#  def_geografi.R – kommuner i Dalarna, för kommunväljaren i
#  Nedladdning-fliken.
#
#  kommun_fil används som filnamnsdel (svenska tecken utbytta) och
#  matchar namngivningen i de gamla, statiska gpkg-filerna
#  (gis-filer/Kollektivtrafik_<kommun_fil>.gpkg) så att GIS-användare
#  känner igen filnamnen.
# ============================================================

DALARNA_KOMMUNER <- tibble::tribble(
  ~kommun_kod, ~kommun_namn,   ~kommun_fil,
  "2021",      "Vansbro",      "Vansbro",
  "2023",      "Malung-Sälen", "Malung-Salen",
  "2026",      "Gagnef",       "Gagnef",
  "2029",      "Leksand",      "Leksand",
  "2031",      "Rättvik",      "Rattvik",
  "2034",      "Orsa",         "Orsa",
  "2039",      "Älvdalen",     "Alvdalen",
  "2061",      "Smedjebacken", "Smedjebacken",
  "2062",      "Mora",         "Mora",
  "2080",      "Falun",        "Falun",
  "2081",      "Borlänge",     "Borlange",
  "2082",      "Säter",        "Sater",
  "2083",      "Hedemora",     "Hedemora",
  "2084",      "Avesta",       "Avesta",
  "2085",      "Ludvika",      "Ludvika"
)

LAN_KOD_DALARNA <- "20"
