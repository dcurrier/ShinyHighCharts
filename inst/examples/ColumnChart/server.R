
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  output$columnchart <- renderHighColumnChart({
    cat1=rnorm(300, mean=100, sd=15)
    cat2=rnorm(60, mean=80, sd=15)

    h=hist(c(cat1, cat2), plot=F)


    data=data.frame(cat1=hist(cat1, plot=F, breaks=h$breaks)$counts, cat2=hist(cat2, plot=F, breaks=h$breaks)$counts)

    return(list(data=data,
                title=input$title,
                subtitle="A thrilling subtitle",
                xAxisCatagories=as.character(h$breaks),
                groupPadding=0.1,
                pointPadding=0,
                legendEnabled=F))
  } )

})
