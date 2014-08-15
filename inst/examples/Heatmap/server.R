
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$heatmap <- renderHighHeatmap({
    rows = rep(LETTERS[1:16], 24)

    cols = vector()
    for(i in 1:24){
      cols = c(cols, rep(i, 16))
    }

    values = rnorm(384, mean=input$mean, sd=input$sd)


    data=data.frame(row=rows, column=cols, values=values)

    return(list(data=data,
                title=input$title,
                subtitle="A thrilling subtitle",
                xAxisCatagories=as.character(1:24),
                yAxisCatagories=LETTERS[1:16],
                xOpposite=TRUE,
                bottomMargin=20,
                seriesName="My Series"))
  } )

})
