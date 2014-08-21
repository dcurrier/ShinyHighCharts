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
  return $(scope).find(".highcharts-arealine");
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

  if(input.xAxisCatagories != null && typeof(input.xAxisCatagories) != 'string' &&
                                                input.xAxisCatagories.length > 1) input.xAxisCatagories.map(String);



  $('#'+el.id).highcharts({
        credits:{
          enabled: false
        },
        chart: {
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
          categories: input.xAxisCatagories,
          min: input.xMin,
          max: input.xMax,
          title: {
            text: input.xTitle
          }
        },
        yAxis: {
          title: {
            text: input.yTitle
          }
        },
        tooltip: {
            crosshairs: true,
            shared: true
        },
        legend: {
          enabled: input.legendEnabled
        },

        series: input.data

    });


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts-arealine");

})();