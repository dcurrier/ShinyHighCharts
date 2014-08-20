#' Render Highcharts Column Chart
#'
#' Creates a Highcharts column chart output from a matrix of dataframe.
#'
#' @rdname renderHighColumnChart
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
renderHighColumnChart <- function(expr, env=parent.frame(), quoted=FALSE){
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
    if( dim(data)[2] < 1 ) stop("'data' must have at least 1 columns")

    # Remove incomplete rows
    data = na.omit(data)
    if( dim(data)[1] < 1) stop("'data' does not contain any values")

    # Get Column names
    if( !is.null(names(data)) ) {
      colNames=names(data)
      unname(data)
    }else{
      colNames=vector()
      for(i in 1:dim(data)[2]){
        colNames=c(colNames, paste0("Series ", i))
      }
    }

    # Get row names
    if( !is.null(row.names(data)) ) {
      rowNames=row.names(data)
    }else{
      rowNames=vector()
      for(i in 1:dim(data)[1]){
        rowNames=c(rowNames, paste0("Catagory ", i))
      }
    }

    # Generate list version
    JSONdata = mapply(function(col, name){

      list(name=name, data=as.numeric(col))

    }, data, colNames, SIMPLIFY=F, USE.NAMES=F)

    #### Plot Options ####
    supportedOptions = c( "topMargin","rightMargin","bottomMargin", "leftMargin",
                          "xAxisCatagories","invertYAxis",
                          "invertXAxis","yTitle","xTitle","yOpposite","xOpposite",
                          "titleMargin","title","subtitle","groupPadding", "pointPadding",
                          "legendEnabled", "xLabelRotation", "yLabelRotation", "xMin", "xMax")

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

        # verify that the label rotation is numberic and less than 360
        if( opt %in% c("xLabelRotation", "yLabelRotation") ){
          value = as.numeric(value)
          if( value > 360 ) value = 0
          if( value < 0 ) value = 0
        }

        # return value
        value

      }else{
        if( opt %in% c("invertXAxis", "yOpposite", "xOpposite", "invertYAxis") ){
          # Return FALSE
          FALSE
        }else if( opt %in% c("legendEnabled")){
          TRUE
        }else if( opt == "xAxisCatagories"){
          # Set default x axis catagories to values of data column 2
          rowNames
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





