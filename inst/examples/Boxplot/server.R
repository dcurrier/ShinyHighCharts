
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ShinyHighCharts)





shinyServer(function(input, output) {

  cat1=reactive({ rnorm(300, mean=input$mean*2, sd=input$sd) })
  cat2=reactive({ rnorm(60, mean=input$mean*4, sd=input$sd) })

  output$boxplot <- renderHighcharts({

    # Highcharts Options
    myChart=list(
      credits=list(
        enabled=FALSE
      ),
      chart=list(
        type='boxplot'
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
        categories=c("A", "B")
      ),
      yAxis=list(
        title=list(
          text="Values"
        )
      ),
      tooltip=list(
        formatHeader="<em>Catagory {point.key}</em><br/>"
      ),
      legend=list(
        enabled=FALSE
      ),

      series=list(
        list(
          name= "Summary",
          data=list(
            as.numeric(summary(cat1())[-4]),   # return all columns but the mean
            as.numeric(summary(cat2())[-4])
          )
        )
      )
    )

    return(list(chart=myChart))
  } )


  output$stripchart <- renderHighcharts({


    # Highcharts Options
    myChart=list(
      credits=list(
        enabled=FALSE
      ),
      chart=list(
        type='boxplot'
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
        categories=c("A", "B")
      ),
      yAxis=list(
        title=list(
          text="Values"
        )
      ),
      tooltip=list(
        pointFormat="<span style='color:{series.color}'>\u25CF</span> Value: <b>{point.y}</b><br/>"
      ),
      legend=list(
        enabled=FALSE
      ),

      series=list(
        list(
          name="Summary",
          color=getHighchartsColors()[1],
          type="scatter",
          data=c(
            JSONify(data.frame(jitter(rep(0, 300), factor=5), cat1())),   # return all columns but the mean
            JSONify(data.frame(jitter(rep(1, 60), factor=5), cat2()))
          ),
          marker=list(
            fillColor = '#ffffff',
            lineWidth = 1,
            lineColor = getHighchartsColors()[1]
          )
        )
      )
    )

      return(list(chart=myChart))
  })

})
