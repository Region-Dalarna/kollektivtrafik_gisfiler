# ============================================================
#  func_data.R
#  Databasuttag och gpkg-generering för kollektivtrafik-nedladdningen.
#
#  Källor (databasen "geodata", kopplas upp med shiny_uppkoppling_las()):
#   - dalatrafik.vy_hallplatslage_avgangar  -- hållplatslägen (kolumn linjetyper)
#   - dalatrafik.vy_linjer_avgangar_alla    -- busslinjer (kolumn klassificering)
#   - dalatrafik.vy_hallplats_avgangar      -- hållplats mittläge (kolumn linjetyper)
#   - dalatrafik.linjeklassificering        -- alla linjeklassificeringar som finns
#   - karta.kommun_lm                       -- kommunpolygoner (kolumn kommunkod)
#
#  Samma tre lager (hallplatslagen/linjer/hallplatsmitt) och samma
#  filtrering på linjetyp som den tidigare, schemalagda processen
#  (skapa_gpkg-filer_fran_gtfs_till_webbsida.R) använde -- bara körd
#  live, per nedladdning, för en enda kommun i taget istället för att
#  loopa över alla och skriva till fil i förväg.
# ============================================================

# Linjetyper som aldrig ska vara med i nedladdningen.
LINJETYPER_UTESLUT <- c("Stängd skoltrafik", "Flextrafik")

# Hämtar vilka av de linjetyps-kombinationer som faktiskt förekommer i
# datat som INTE innehåller någon av de tillåtna linjetyperna -- dvs.
# rader som enbart består av uteslutna typer ska bort.
hamta_linjetypskombinationer_att_ta_bort <- function(con, forekommande_kombinationer) {
  alla_klassificeringar <- DBI::dbGetQuery(
    con, "SELECT DISTINCT klassificering FROM dalatrafik.linjeklassificering"
  )$klassificering

  tillatna <- setdiff(alla_klassificeringar, LINJETYPER_UTESLUT)
  monster  <- paste0(tillatna, collapse = "|")

  forekommande_kombinationer[
    !grepl(monster, forekommande_kombinationer, fixed = FALSE)
  ] |> unique()
}

# Läser en kommunpolygon ur karta.kommun_lm. kommun_kod = NULL -> NULL
# (dvs. ingen avgränsning, används för "Hela Dalarna").
hamta_kommunpolygon <- function(con, kommun_kod) {
  if (is.null(kommun_kod)) return(NULL)
  query <- paste0(
    "SELECT * FROM karta.kommun_lm WHERE kommunkod = ",
    DBI::dbQuoteLiteral(con, kommun_kod)
  )
  sf::st_read(con, query = query, quiet = TRUE)
}

# Avgränsar ett lager till en kommunpolygon (spatial join), eller
# returnerar lagret oförändrat om kommun_polygon är NULL.
avgransa_till_kommun <- function(lager_sf, kommun_polygon) {
  if (is.null(kommun_polygon)) return(lager_sf)
  if (sf::st_crs(lager_sf) != sf::st_crs(kommun_polygon)) {
    kommun_polygon <- sf::st_transform(kommun_polygon, sf::st_crs(lager_sf))
  }
  sf::st_join(lager_sf, kommun_polygon, left = FALSE)
}

#' Bygg en gpkg-fil med kollektivtrafikdata, live från geodatabasen
#'
#' @param kommun_kod Kommunkod (t.ex. "2081"), eller `NULL` för hela Dalarna.
#' @param steg_klar Valfri callback, `function(text)`, anropas efter varje
#'   större steg -- används för att driva en förloppsindikator i UI:t.
#'
#' @return Sökväg till en temporär .gpkg-fil med tre lager: hallplatslagen,
#'   linjer, hallplatsmitt.
bygg_kollektivtrafik_gpkg <- function(kommun_kod = NULL, steg_klar = function(text) NULL) {
  con <- shiny_uppkoppling_las()
  if (is.null(con)) stop("Kunde inte ansluta till geodatabasen.")
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  steg_klar("Hämtar hållplatser …")
  hallplatser_sf <- sf::st_read(con, query = "SELECT * FROM dalatrafik.vy_hallplatslage_avgangar", quiet = TRUE)

  steg_klar("Hämtar linjer …")
  linjer_sf <- sf::st_read(con, query = "SELECT * FROM dalatrafik.vy_linjer_avgangar_alla", quiet = TRUE)

  steg_klar("Hämtar hållplatsmittpunkter …")
  hallplats_mitt_sf <- sf::st_read(con, query = "SELECT * FROM dalatrafik.vy_hallplats_avgangar", quiet = TRUE)

  steg_klar("Filtrerar linjetyper …")
  ta_bort <- hamta_linjetypskombinationer_att_ta_bort(con, unique(hallplatser_sf$linjetyper))

  hallplatser_sf    <- hallplatser_sf[!hallplatser_sf$linjetyper %in% ta_bort, ]
  linjer_sf         <- linjer_sf[!linjer_sf$klassificering %in% ta_bort, ]
  hallplats_mitt_sf <- hallplats_mitt_sf[!hallplats_mitt_sf$linjetyper %in% ta_bort, ]

  steg_klar("Avgränsar till vald kommun …")
  kommun_polygon <- hamta_kommunpolygon(con, kommun_kod)

  hallplatser_export    <- avgransa_till_kommun(hallplatser_sf, kommun_polygon)
  linjer_export         <- avgransa_till_kommun(linjer_sf, kommun_polygon)
  hallplats_mitt_export <- avgransa_till_kommun(hallplats_mitt_sf, kommun_polygon)

  steg_klar("Skriver gpkg-fil …")
  dsn <- tempfile(fileext = ".gpkg")
  sf::st_write(hallplatser_export,    dsn, layer = "hallplatslagen", quiet = TRUE)
  sf::st_write(linjer_export,         dsn, layer = "linjer",         append = TRUE, quiet = TRUE)
  sf::st_write(hallplats_mitt_export, dsn, layer = "hallplatsmitt",  append = TRUE, quiet = TRUE)

  dsn
}
