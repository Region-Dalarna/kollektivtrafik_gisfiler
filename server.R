shinyServer(function(input, output, session) {
  telemetri_server(telemetry, navigation_id = "flikval", forsta_flik = "Nedladdning")

  mod_nedladdning_server("nedladdning")
})
