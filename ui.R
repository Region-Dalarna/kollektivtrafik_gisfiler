source("global.R")

shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    tags$head(
      tags$link(rel = "icon", type = "image/x-icon", href = "favicon.ico"),
      tags$link(rel = "stylesheet", type = "text/css", href = "regiondalarna_ruf.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "app.css"),
      telemetri_ui(telemetry)
    ),

    # ---- Header (matchar .rd-header i regiondalarna_ruf.css) --------------
    tags$div(
      class = "rd-header",
      tags$div(class = "rd-header__title", "Kollektivtrafik – GIS-filer"),
      tags$a(
        class  = "rd-header__right",
        href   = "https://www.regiondalarna.se",
        target = "_blank",
        tags$img(src = "logo_liggande_fri_vit.png", alt = "Region Dalarna"),
        tags$span("Samhällsanalys")
      )
    ),

    # ---- Innehåll -----------------------------------------------------
    div(
      style = "padding: 8px 24px 24px;",
      tabsetPanel(
        id = "flikval",
        tabPanel("Nedladdning", mod_nedladdning_ui("nedladdning")),
        tabPanel(
          "Källa",
          div(
            class = "rd-card",
            h2("Källa"),
            p(
              "Den geodata som tillgängliggörs här är hämtad från ",
              tags$a(href = "https://www.trafiklab.se/sv/", target = "_blank", "Trafiklab"),
              ", som drivs av Samtrafiken. Samtrafiken ägs i sin tur av de regionala ",
              "kollektivtrafikmyndigheterna samt många av de kommersiella trafikoperatörerna ",
              "med nationell trafik i Sverige. Geodata hos Trafiklab erbjuds i GTFS-formatet ",
              "(General Transit Feed Specification), ett öppet, standardiserat format för ",
              "kollektivtrafikdata som används av kollektivtrafikmyndigheter och trafikoperatörer ",
              "över hela världen."
            ),
            p(
              "GTFS-formatet är väldigt bra på många sätt men kan vara lite snårigt att förstå ",
              "då data är uppdelat i olika dataset som kopplas ihop med id-nummer på operatörer, ",
              "linjer, turer etc. För de som enkelt vill ha geodata över busslinjer och hållplatser ",
              "för sin kommun eller för hela Dalarna erbjuder Samhällsanalys denna sida, som skapar ",
              "Geopackage-filer direkt från Region Dalarnas geodatabas vid varje nedladdning."
            ),
            div(
              class = "rd-info",
              tags$strong("OBS: "),
              "Geodatabasen uppdateras löpande från Trafiklab i en separat process. Eftersom ",
              "filerna på den här sidan alltid byggs live vid nedladdning är de alltid lika ",
              "aktuella som databasens senaste uppdatering."
            )
          )
        )
      )
    ),

    # ---- Footer (matchar .rd-footer i regiondalarna_ruf.css) --------------
    tags$div(
      class = "rd-footer",
      "Samhällsanalys, Region Dalarna · ",
      tags$a(
        href = "mailto:samhallsanalys@regiondalarna.se",
        "samhallsanalys@regiondalarna.se"
      )
    )
  )
)
