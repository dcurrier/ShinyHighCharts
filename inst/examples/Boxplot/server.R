
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$boxplot <- renderHighBoxplot({

    data=data.frame(cat1=rnorm(300, mean=100, sd=15), cat2=rnorm(60, mean=80, sd=15))

    return(list(data=data,
                title=input$title,
                subtitle="A thrilling subtitle",
                xAxisCatagories=c("A", "B"),
                tooltipHeader="<em>Catagory {point.key}</em><br/>"
                ))
  } )


  output$stripchart <- renderHighBoxplot({

    data=data.frame(cat1=rnorm(300, mean=100, sd=15), cat2=rnorm(60, mean=80, sd=15))

    return(list(data=data,
                title=input$title,
                subtitle="A thrilling subtitle",
                xAxisCatagories=c("A", "B"),
                plotBoxes=F,
                tooltipHeader="",
                tooltipPointFormat="<span style='color:{series.color}'>\u25CF</span> Value: <b>{point.y}</b><br/>"
    ))
  } )

})
