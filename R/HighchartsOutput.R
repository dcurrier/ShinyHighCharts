#' Highcharts Heatmap Output
#'
#' Render a renderHighHeatmap within an application page.
#'
#' @rdname highchartsOutput
#'
#' @param inputId
#' @param width
#' @param height
#' @param type A character vector indicating the type of highchart to output
#'
#' @family shinyhighcharts elements
#'
#' @export
highchartsOutput <- function(inputId, width="100%", height="400px", type=c("heatmap", "column", "boxplot") ) {

  # Get the ouput plot type
  type = match.arg(type)

  # heatmaps
  if(type == "heatmap"){
    JS = singleton(tags$head(
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/data.js", type="text/javascript"),
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/heatmap.src.js", type="text/javascript"),
      tags$script(src="shinyhighcharts/heatmap-bindings.js", type="text/javascript")
    ))

    divClass = "shiny-bound-output highcharts-heatmap"
  }

  # column charts
  if(type == "column"){
    JS = singleton(tags$head(
      tags$script(src="shinyhighcharts/column-bindings.js", type="text/javascript")
    ))

    divClass = "shiny-bound-output highcharts-column"
  }

  # Boxplots
  if(type == "boxplot"){
    JS = singleton(tags$head(
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts-more.js", type="text/javascript"),
      tags$script(src="shinyhighcharts/boxplot-bindings.js", type="text/javascript")
    ))

    divClass = "shiny-bound-output highcharts-boxplot"
  }


  # Return html
  tagList(
    # Import the Highcharts library files
    singleton(tags$head(
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/exporting.js", type="text/javascript"),
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts.js", type="text/javascript"),
      tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/no-data-to-display.js"))
    ),
    JS,


    # make the container div
    div(id=inputId, class=divClass,
        style=paste0("width: ", width, "; height: ", height, "; margin: 0 auto;"), list())

  )

}