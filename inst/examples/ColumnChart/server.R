
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$columnchart <- renderHighcharts({
    cat1=rnorm(300, mean=100, sd=15)
    cat2=rnorm(60, mean=80, sd=15)

    h=hist(c(cat1, cat2), plot=F)

    # Highcharts options
    myChart=list(
      credits=list(
        enabled=FALSE
      ),
      chart=list(
        type='column'
      ),

      title=list(
        text=input$title,
        align='left'
      ),

      subtitle=list(
        text="The Subtitle",
        align='left'
      ),

      xAxis=list(
        categories=as.character(h$breaks)
      ),

      yAxis=list(
        title=list(
          text="Frequency"
        )
      ),

      legend=list(
        enabled=FALSE
      ),

      plotOptions=list(
        series=list(
          groupPadding=0.1,
          pointPadding=0
        )
      ),

      series=list(
        list(
          name="Category 1",
          data=hist(cat1, plot=F, breaks=h$breaks)$counts
        ),
        list(
          name="Category 2",
          data=hist(cat2, plot=F, breaks=h$breaks)$counts
        )
      )
  )

    return( list(chart=myChart) )
  } )

})
