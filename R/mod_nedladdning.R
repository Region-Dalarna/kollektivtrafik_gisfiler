# =====================================================================
#  mod_nedladdning.R – flik: Nedladdning
#
#  Kommunväljare + nedladdningsknapp. gpkg-filen byggs live vid varje
#  klick (se func_data.R::bygg_kollektivtrafik_gpkg()), med en
#  förloppsindikator medan databasuttaget och skrivningen pågår.
# =====================================================================

mod_nedladdning_ui <- function(id) {
  ns <- NS(id)

  div(class = "rd-app",

      div(class = "rd-sidebar",
          h3("Välj område"),

          div(class = "rd-field",
              selectInput(
                ns("omrade_val"), "Kommun",
                choices = c(
                  "Hela Dalarna" = "",
                  stats::setNames(DALARNA_KOMMUNER$kommun_kod, DALARNA_KOMMUNER$kommun_namn)
                )
              )),

          downloadButton(ns("ladda_ner"), "Ladda ner gpkg-fil", class = "rd-btn rd-btn--primary"),

          div(style = "margin-top: 14px;", uiOutput(ns("status"))),

          div(class = "rd-info", style = "margin-top: 18px;",
              tags$strong("OBS: "),
              "Filen byggs live från geodatabasen vid varje nedladdning, så det kan ta någon eller några sekunder innan den är klar.")
      ),

      div(class = "rd-main",
          div(class = "rd-card",
              h2("Geodata för kollektivtrafik i Dalarna"),
              p("Ladda ner hållplatser och busslinjer som en Geopackage-fil (.gpkg), ",
                "antingen för en enskild kommun eller för hela Dalarna. Filen kan öppnas ",
                "direkt i GIS-programvaror som ",
                tags$a(href = "https://www.qgis.org", target = "_blank", "QGIS"), "."),
              tags$ul(
                tags$li(tags$strong("hallplatslagen"), " – hållplatslägen"),
                tags$li(tags$strong("linjer"), " – busslinjer"),
                tags$li(tags$strong("hallplatsmitt"), " – hållplatsers mittläge")
              )
          )
      )
  )
}

mod_nedladdning_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$ladda_ner <- downloadHandler(
      filename = function() {
        kommun_namn <- if (identical(input$omrade_val, "")) {
          "Dalarna"
        } else {
          DALARNA_KOMMUNER$kommun_fil[DALARNA_KOMMUNER$kommun_kod == input$omrade_val]
        }
        paste0("Kollektivtrafik_", kommun_namn, ".gpkg")
      },
      contentType = "application/geopackage+sqlite3",
      content = function(file) {
        kommun_kod <- if (identical(input$omrade_val, "")) NULL else input$omrade_val

        shiny::withProgress(message = "Skapar gpkg-fil", value = 0, {
          steg <- 0
          dsn <- bygg_kollektivtrafik_gpkg(
            kommun_kod = kommun_kod,
            steg_klar  = function(text) {
              steg <<- steg + 1
              shiny::setProgress(value = steg / 6, detail = text)
            }
          )
          file.copy(dsn, file, overwrite = TRUE)
        })
      }
    )
  })
}
