# ============================================================
#  def_geografi.R – geografisk avgränsning för Dalarna.
#
#  Kommunlistan (kod, namn, ascii-filnamn) hämtas numera live ur
#  karta.kommun_lm (se func_data.R::hamta_dalarna_kommuner()) istället
#  för att hårdkodas här -- LAN_KOD_DALARNA styr vilket län som filtreras
#  fram.
# ============================================================

LAN_KOD_DALARNA <- "20"
