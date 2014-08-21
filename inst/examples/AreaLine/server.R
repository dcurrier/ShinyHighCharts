
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$arealinechart <- renderHighcharts({

    data=data.frame(x = 1:30, min=rnorm(30, mean=18, sd=0.1), max=rnorm(30, mean=25, sd=0.2),
                    line1=rnorm(30, mean=20, sd=0.2), line2=rnorm(30, mean=21, sd=0.2))

    # Construct the chart options
    credits = list(
      enabled=FALSE
    )

    title = list(
      text=input$title
    )

    yAxis = list(
      title = list(
        text="Y Label"
      )
    )

    tooltip=list(
      crosshairs=TRUE,
      shared=TRUE
    )

    series=list(
      list(
        name='Line 1',
        data=JSONify(data[, c(1,4)]),
        zIndex=1,
        marker=list(
          fillColor='white',
          lineWidth=2,
          lineColor=getHighchartsColors()[1]
        )
      ),
      list(
        name='Line 2',
        data=JSONify(data[, c(1,5)]),
        zIndex=1,
        marker=list(
          fillColor='white',
          lineWidth=2,
          lineColor=getHighchartsColors()[1]
        )
      ),
      list(
        name='Range',
        data=JSONify(data[, 1:3]),
        type='arearange',
        lineWidth=0,
        linkedTo=':previous',
        color=getHighchartsColors()[1],
        fillOpacity=0.3,
        zIndex=0
      )
    )

    return( list( chart=list(credits=credits, title=title, yAxis=yAxis, tooltip=tooltip, series=series) ) )
  } )


})
