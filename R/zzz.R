.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath("shinyhighcharts", system.file("www", package = "ShinyHighCharts"))
}

.onAttach <- function(libname, pkgname) {
  require(shiny)
}