// Put code in an Immediately Invoked Function Expression (IIFE).
// This isn't strictly necessary, but it's good JavaScript hygiene.
(function() {

// See http://rstudio.github.io/shiny/tutorial/#building-outputs for
// more information on creating output bindings.

// First create a generic output binding instance, then overwrite
// specific methods whose behavior we want to change.
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".highcharts-heatmap");
};

binding.renderValue = function(el, input) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  console.debug(input);
  console.debug(el.id);

  if(input == null){
    return;
  }

  if(input.xAxisCatagories.length > 1 && typeof(input.xAxisCatagories) != 'string') input.xAxisCatagories.map(String)
  if(input.yAxisCatagories.length > 1 && typeof(input.yAxisCatagories) != 'string') input.yAxisCatagories.map(String)

  if(input.colRange == null) input.colRange = ["#ffffff", Highcharts.getOptions().colors[0]]

  $('#'+el.id).highcharts({
        credits:{
          enabled: false
        },
        chart: {
          type: 'heatmap',
          marginTop: input.topMargin,
          marginRight: input.rightMargin,
          marginBottom: input.bottomMargin,
          marginLeft: input.leftMargin
        },
        title: {
          text: input.title,
          align: 'left',
          margin: input.titleMargin
        },
        subtitle: {
          text: input.subtitle,
          align: 'left'
        },
        xAxis: {
          reversed: input.invertXAxis,
          categories: input.xAxisCatagories,
          title: input.xTitle,
          opposite: input.xOpposite,
          lineWidth: 0,
          minorGridLineWidth: 0,
          minorTickLength: 0,
          tickLength: 0,
          lineColor: 'transparent'
        },
        yAxis: {
          reversed: input.invertYAxis,
          categories: input.yAxisCatagories,
          title: input.yTitle,
          opposite: input.yOpposite,
          lineWidth: 0,
          minorGridLineWidth: 0,
          minorTickLength: 0,
          tickLength: 0,
          lineColor: 'transparent'
        },
        colorAxis: {
          min: input.dataMin,
          minColor: input.colRange[0],
          maxColor: input.colRange[1]
        },
        legend: {
          align: 'right',
          layout: 'vertical',
          margin: 0,
          symbolHeight: 320
        },
        tooltip: {
          headerFormat: input.tooltipHeader,
          pointFormat: input.tooltipPointFormat
        },
        series: [{
          name: input.seriesName,
          borderWidth: 1,
          data: input.data
        }]

    });


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts-heatmap");

})();