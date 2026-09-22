## Globala inställningar för Shinyappen: kollektivtrafik_gisfiler

# Ladda nödvändiga paket
library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)
library(sf)

# ---- Delade hjälpfunktioner för Samhällsanalys Shiny-appar -----------------
# Standardrad för Region Dalarnas Shiny-appar (direkt under library()).
source("https://raw.githubusercontent.com/Region-Dalarna/funktioner/main/func_shinyappar.R", encoding = "utf-8", echo = FALSE)

telemetry <- skapa_telemetry("kollektivtrafik_gisfiler")

# ---- Lokala filer ------------------------------------------------------
# Hjälp- och modulfiler i R/ laddas AUTOMATISKT av Shiny (>= 1.5.0), i
# bokstavsordning och efter denna fil. Inga source()-rader behövs här.
#   R/def_geografi.R     kommuner i Dalarna (kommunkod, namn, filnamn)
#   R/func_data.R        databasuttag och gpkg-generering (schema dalatrafik/karta, db geodata)
#   R/mod_nedladdning.R  modul: flik Nedladdning

# Allmänna options - TRUE = visa inte R-felmeddelanden i appen,
# FALSE = visa felmeddelanden från R på webben
options(shiny.sanitize.errors = FALSE)
