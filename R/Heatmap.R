#' Render Highcharts Heatmap
#'
#' Creates a Highcharts heatmap output from a matrix of dataframe.
#'
#' @rdname renderHighHeatmap
#'
#' @param expr An expression that evaluates to a matrix or dataframe object
#'   with three columns.  The first column is the y axis value, the second
#'   is the x axis value, and the third column is the color value for the
#'   quadrant.
#' @param env
#' @param quoted
#'
#' @family shinyhighcharts elements
#'
#' @export
renderHighHeatmap <- function(expr, env=parent.frame(), quoted=FALSE){
  # This piece of boilerplate converts the expression `expr` into a
  # function called `func`. It's needed for the RStudio IDE's built-in
  # debugger to work properly on the expression.
  installExprFunction(expr, "func", env, quoted)


  function(){
    list = func()


    #### Data Processing ####
    data = list$data

    # Data validation
    if( is.null(data) ) return(NULL)
    if( !(is.matrix(data) || is.data.frame(data)) ) stop("'data' must be of type matrix or data.frame.")
    if( dim(data)[2] < 3 ) stop("'data' must have at least 3 columns")
    if( dim(data)[2] > 3) {
      data = data[, 1:3]
      warning("Ignoring extra columns in 'data'")
    }

    # Remove incomplete rows
    data = na.omit(data)
    if( dim(data)[1] < 1) stop("'data' does not contain any values")

    # Remove names
    if( !is.null(names(data)) ) unname(data)

    # Convert columns 1 and 2 to integer
    data[, 1] = as.integer(data[, 1])
    data[, 2] = as.integer(data[, 2])

    # Register columns 1 and 2 with a zero minimum
    if( min(data[, 1]) > 0 ) {
      data[, 1] = data[, 1] - min(data[, 1])
    }
    if( min(data[, 2]) > 0 ) {
      data[, 2] = data[, 2] - min(data[, 2])
    }


    # Generate list version
    JSONdata = mapply(function(row){

      list(y=data[row, 1], x=data[row, 2], value=data[row, 3])

      }, 1:dim(data)[1], SIMPLIFY=F, USE.NAMES=F)

    #### Plot Options ####
    supportedOptions = c( "topMargin","rightMargin","bottomMargin", "leftMargin",
                          "xAxisCatagories","yAxisCatagories","invertYAxis",
                          "invertXAxis","yTitle","xTitle","yOpposite","xOpposite",
                          "titleMargin","title","subtitle","seriesName","colRange",
                          "dataMin" )

    #### Argument Validation ####
    args = mapply(function(opt){
      if( !is.null( eval(parse(text=paste0("list$", opt))) ) ){
        # Get set value
        value = eval(parse(text=paste0("list$", opt)))

        # Check Booleans
        if( opt %in% c("invertYAxis","invertXAxis", "yOpposite", "xOpposite") ){
          if( !is.logical(value) ) stop(paste0("'",opt,"' must be boolean"))
        }

        # Coerce to character
        if( opt %in% c("yTitle","xTitle","title","subtitle") ){
          value = as.character(value)
        }

        # Verify that colRange is has two colors
        if( opt == "colRange" ){
          if( length(value) < 2 ) value = c("#FFFFFF", value)
          if( length(value) > 2 ) value = value[1:2]
        }

        # return value
        value

      }else{
        if( opt %in% c("invertXAxis", "yOpposite") ){
          # Return FALSE
          FALSE
        }else if( opt %in% c("xOpposite", "invertYAxis") ){
          # Return TRUE
          TRUE
        }else if( opt == "xAxisCatagories"){
          # Set default x axis catagories to values of data column 2
          unique(as.character(data[, 2]))
        }else if( opt == "yAxisCatagories"){
          # Set default y axis catagories to values of data column 1
          unique(as.character(data[, 1]))
        }else if( opt == "seriesName"){
          if( !is.null(list$title) ) list$title else NULL
        }else{
          # Return NULL for all others
          NULL
        }
      }
    }, supportedOptions, SIMPLIFY=F, USE.NAMES=T)


    #### Return Data ####

    args$data = JSONdata

    return(args)


  }
}






