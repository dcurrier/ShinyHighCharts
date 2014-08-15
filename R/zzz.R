.onLoad <- function(libname, pkgname) {
  require(shiny)
  addResourcePath("shinyhighcharts", system.file("www", package = "ShinyHighCharts"))
}

.onAttach <- function(libname, pkgname) {
  require(shiny)
}