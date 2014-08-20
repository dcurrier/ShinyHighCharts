#' Render Highcharts Boxplot
#'
#' Creates a Highcharts boxplot output from a matrix of dataframe.
#'
#' @rdname renderHighBoxplot
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
renderHighBoxplot <- function(expr, env=parent.frame(), quoted=FALSE){
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



    #### Plot Options ####
    supportedOptions = c( "topMargin","rightMargin","bottomMargin", "leftMargin",
                          "xAxisCatagories","invertYAxis",
                          "invertXAxis","yTitle","xTitle","yOpposite","xOpposite",
                          "titleMargin","title","subtitle","groupPadding", "pointPadding",
                          "legendEnabled", "markerFillColor", "markerLineWidth", "markerLineColor",
                          "tooltipHeader", "tooltipPointFormat", "plotBoxes", "xLabelRotation",
                          "yLabelRotation", "xMin", "xMax")

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
        if( opt %in% c("yTitle","xTitle","title","subtitle", "tooltipHeader", "tooltipPointFormat") ){
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
        if( opt %in% c("invertXAxis", "yOpposite", "xOpposite", "invertYAxis", "legendEnabled") ){
          # Return FALSE
          FALSE
        }else if( opt %in% c("plotBoxes")){
          TRUE
        }else if( opt == "xAxisCatagories"){
          # Set default x axis catagories to values of data column 2
          colNames
        }else if( opt == "markerFillColor"){
          'white'
        }else if( opt == "markerLineWidth"){
          1
        }else if( opt == "markerLineColor"){
          "#7cb5ec"
        }else{
          # Return NULL for all others
          NULL
        }
      }
    }, supportedOptions, SIMPLIFY=F, USE.NAMES=T)



    ##### Generate Data Vector ####
    if( args$plotBoxes ){
      # Generate list version - Boxplot
      JSONdata = list(
        name= "Summary",

          data=mapply(function(col){
            as.numeric(summary(col)[-4])  # return all columns but the mean
          }, data, SIMPLIFY=F, USE.NAMES=F),

        tooltip=list(
          headerFormat= args$tooltipHeader
        )
      )

    }else{
      # Generate list version - 'stripchart'
      JSONdata = list(
        name= "Points" ,
        type= 'scatter',

        data=unlist(mapply(function(col, n){
            mapply(function(v, i){
              c(jitter(i-1, factor=5), as.numeric(v))
            }, col, n, SIMPLIFY=F, USE.NAMES=F)
          }, data, 1:dim(data)[2], SIMPLIFY=F, USE.NAMES=F), recursive=F),

        marker=list(
          fillColor = args$markerFillColor,
          lineWidth = args$markerLineWidth,
          lineColor = args$markerLineColor
        ),

        tooltip=list(
          headerFormat= args$tooltipHeader,
          pointFormat= args$tooltipPointFormat
        )
      )

    }


    #### Return Data ####

    args$data = JSONdata

    return(args)


  }
}




