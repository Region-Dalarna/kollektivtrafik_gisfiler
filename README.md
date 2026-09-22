# kollektivtrafik_gisfiler

Detta repository innehåller en Shinyapplikation (`kollektivtrafik_gisfiler`) för
Samhällsanalys, Region Dalarna. Appen låter användare ladda ner hållplatser och
busslinjer för en kommun, eller för hela Dalarna, som en Geopackage-fil
(.gpkg). Filen byggs **live vid varje nedladdning**, direkt från Region
Dalarnas geodatabas (schema `dalatrafik`/`karta` i databasen `geodata`) — inga
statiska gpkg-filer lagras längre i repot.

Ersätter den tidigare, schemalagda processen som byggde gpkg-filer från GTFS
en gång i veckan och committade dem till `gis-filer/`.

## Struktur

Appfilerna ligger **direkt i repo-roten** (så att Shiny Server kör appen utan omväg):

- `ui.R`, `server.R`, `global.R`
- `www/` för favicon, logotyp, CSS (`regiondalarna_ruf.css` + `app.css`) och `fonts/`
- `R/` för hjälpfunktioner:
  - `def_geografi.R` – kommuner i Dalarna (kommunkod, namn, filnamn)
  - `func_data.R` – databasuttag och gpkg-generering
  - `mod_nedladdning.R` – flik: kommunväljare + nedladdningsknapp

- `_dependencies.R` i root listar alla paket appen använder (läses av `renv::dependencies()`, körs aldrig)
- `_publicering_till_server.yml` i root styr vilken Shiny-server som är default för `shinyapp_publicera()` (satt till `intern`)
- `renv.lock` + `renv/` + `.Rprofile` styr paketversioner. Kör `renv::restore()` efter klon för att få samma paket som senast snapshot:ades. Vid nya paket: `renv::install(...)` följt av `renv::snapshot()`.

- Deployment sker via GitHub Actions:
  - `.github/workflows/deploy.yml` – publicerar vid push till `publicera-publik` eller `publicera-intern`
  - `.github/workflows/avpublicera.yml` – tar bort appen från vald server (manuell trigger)

  Appmapp på servern: `/srv/shiny-server/kollektivtrafik_gisfiler`.

## Databas

Appen kopplar upp mot databasen `geodata` med `shiny_uppkoppling_las()`
(läsbehörighet). Tabeller/vyer som används:

- `dalatrafik.vy_hallplatslage_avgangar` – hållplatslägen (kolumn `linjetyper`)
- `dalatrafik.vy_linjer_avgangar_alla` – busslinjer (kolumn `klassificering`)
- `dalatrafik.vy_hallplats_avgangar` – hållplatsers mittläge (kolumn `linjetyper`)
- `dalatrafik.linjeklassificering` – styr vilka linjetyper som filtreras bort (idag "Stängd skoltrafik" och "Flextrafik")
- `karta.kommun_lm` – kommunpolygoner (kolumn `kommunkod`), används för att avgränsa till vald kommun
