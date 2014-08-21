
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$heatmap <- renderHighcharts({
    rows = rep(c(0:15), 24)

    cols = vector()
    for(i in 0:23){
      cols = c(cols, rep(i, 16))
    }

    values = rnorm(384, mean=input$mean, sd=input$sd)
    data=data.frame(column=cols, row=rows, values=values)

    # Highcharts options
    myChart=list(
      credits=list(
        enabled=FALSE
      ),

      chart=list(
        type='heatmap'
      ),

      title=list(
        text=input$title,
        align='left'
      ),

      subtitle=list(
        text="subtitle",
        align='left'
      ),

      xAxis=list(
        categories=as.character(1:24),
        opposite=TRUE,
        lineWidth=0,
        minorGridLineWidth=0,
        minorTickLength=0,
        tickLength=0,
        lineColor='transparent'
      ),

      yAxis=list(
        reversed=TRUE,
        categories=LETTERS[1:16],
        lineWidth=0,
        minorGridLineWidth=0,
        minorTickLength=0,
        tickLength=0,
        lineColor='transparent',
        title=list(
          text=""
        )
      ),

      colorAxis=list(
        min=min(data$values),
        minColor='#ffffff',
        maxColor=getHighchartsColors()[1]
      ),

      legend=list(
        align='right',
        layout='vertical',
        margin=0,
        symbolHeight=320
      ),

      tooltip=list(
        headerFormat='{series.name} <br/>',
        pointFormat='{point.x},{point.y}: <b>{point.value}</b><br/>'
      ),

      series=list(
        list(
          name="Series Name",
          borderWidth=1,
          data=JSONify(data)
        )
      )
    )

    return( list(chart=myChart) )
  } )

})
