#' Get Highcharts Default Colors
#'
#' Creates a vector of the default Highcharts colors
#' as of v4.0.3
#'
#' @rdname getHighchartsColors
#'
#' @family shinyhighcharts elements
#'
#' @export
getHighchartsColors = function() {
  return(c( '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
            '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1' ))
}







#' Convert a Data Frame into a JSON Object
#'
#' Converts the rows of a data frame into a list of vectors.
#' Optionally, include names for each element.
#'
#' @rdname JSONify
#'
#' @param df A data frame from which the JSON object will be created.  For
#'  each row in 'df' an array will be added to the JSON object.
#'
#' @family shinyhighcharts elements
#'
#' @export
JSONify = function(df, element.names=NULL) {

  # Error if element.names does not have the same number of elements as columns in df
  if( !is.null(element.names) && length(element.names) != dim(df)[2] ) {
    stop("Argument 'element.names' must have the same number of elements as columns in 'df'.")
  }

  mapply(function(r){
    if( is.null(element.names) ) {
      unlist(unname(df[r, ]))
    }else{
      t=list()
      for(i in 1:length(element.names) ){
        t[[element.names[i]]] = unname(df[r, i])
      }
      t
    }
  }, 1:dim(df)[1], SIMPLIFY=F, USE.NAMES=F)

}





#' Make javascript compatible functions
#'
#' Remove newline characters and exessive whitespace.
#'
#' @rdname jsFunction
#'
#' @param s A character vector representing a Javascript
#' function.
#'
#' @family shinyhighcharts elements
#'
#' @export
jsFunction = function(s){
  if( length(grep('function()', s)) > 0 ){
    r = gsub("/\\*(.|$)*?\\*/|(//.*)", "", s, perl = TRUE)
    r = gsub("[[:space:]]{2,}", "", r)
  }else{
    r = s
  }
  return(r)
}







#' Render Highcharts
#'
#' Creates a Highcharts output
#'
#' @rdname renderHighcharts
#'
#' @param expr An expression that evaluates to a list that can
#'   be converted to a JSON object for direct injection into a
#'   highcharts function call.
#'   See http://api.highcharts.com/highcharts for details on how
#'   to specify highcharts arguments.
#' @param env
#' @param quoted
#'
#' @family shinyhighcharts elements
#'
#' @export
renderHighcharts <- function(expr, env=parent.frame(), quoted=FALSE){
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  installExprFunction(expr, "func", env, quoted)

  # Call the function
  function(){
    l <- func()
    if( !is.null(l) && typeof(l) == 'list' ){
      l <- rapply(l, jsFunction, class="character", how="replace")
    }
    return(l)
  }
}









#' Highcharts Output
#'
#' Render a Highcharts output within an application page.
#'
#' @rdname highchartsOutput
#'
#' @param inputId
#' @param width
#' @param height
#' @param include A vector indicating the highcharts source
#'  files to include in the page header.  See the Highcharts
#'  API reference for more information about the necessary
#'  source files for the chart types available.
#'
#' @family shinyhighcharts elements
#'
#' @export
highchartsOutput <- function(inputId, width="100%", height="400px",
                             include=c("base", "more", "3d", "all", "canvas-tools",
                                       "data", "drilldown", "exporting", "funnel",
                                       "heatmap", "no-data", "solid-gauge", "map") ) {

  # Get the ouput plot type
  include = match.arg(include, several.ok=T)

  JS = list()
  #### Build script tags ####
  if( "base" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts.js", type="text/javascript")))
                )
  }

  if( "more" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts-more.js", type="text/javascript")))
    )
  }

  if( "3d" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts-3d.js", type="text/javascript")))
    )
  }

  if( "all" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/highcharts-all.js", type="text/javascript")))
    )
  }

  if( "canvas-tools" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/canvas-tools.js", type="text/javascript")))
    )
  }

  if( "data" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/data.js", type="text/javascript")))
    )
  }

  if( "drilldown" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/drilldown.js", type="text/javascript")))
    )
  }

  if( "exporting" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/exporting.js", type="text/javascript")))
    )
  }

  if( "funnel" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/funnel.js", type="text/javascript")))
    )
  }

  if( "heatmap" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highmaps-1.0.1/js/modules/heatmap.js", type="text/javascript")))
    )
  }

  if( "no-data" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/no-data-to-display.js", type="text/javascript")))
    )
  }

  if( "solid-gauge" %in% include ) {
    JS = append(JS,
                 tagList(singleton(tags$script(src="shinyhighcharts/Highcharts-4.0.3/js/modules/solid-gauge.js", type="text/javascript")))
    )
  }

  if( "map" %in% include ) {
    JS = append(JS,
                tagList(singleton(tags$script(src="shinyhighcharts/Highmaps-1.0.1/js/modules/map.js", type="text/javascript")))
    )
  }

  if( "dim-on-hover" %in% include ) {
    JS = append(JS,
                tagList(singleton(tags$script(src="shinyhighcharts/Custom-Add-Ons/dim-on-hover.js", type="text/javascript")))
    )
  }




  tagList(
    tags$head(JS,
              singleton(tags$script(src="shinyhighcharts/generic-bindings.js", type="text/javascript")),
              singleton(tags$script(src="shinyhighcharts/deepCopy.js", type="text/javascript")),
              singleton(tags$script(src="shinyhighcharts/helpers.js", type="text/javascript"))),

    # make the container div
    div(id=inputId, class="shiny-bound-output highcharts",
        style=paste0("width: ", width, "; height: ", height, "; margin: 0 auto;"), list())

  )

}