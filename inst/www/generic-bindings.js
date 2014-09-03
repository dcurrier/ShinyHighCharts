// Put code in an Immediately Invoked Function Expression (IIFE).
// This isn't strictly necessary, but it's good JavaScript hygiene.
(function() {

// See http://rstudio.github.io/shiny/tutorial/#building-outputs for
// more information on creating output bindings.

// Create a property of Window to save the series data before
// changing things
window.HighchartsAddOn = new Object();

// Create a generic output binding instance, then overwrite
// specific methods whose behavior we want to change.
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".highcharts");
};

binding.renderValue = function(el, input) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.

  // Return Null if input is null
  if(input == null) return;

  // Set plot options if they are specified
  if( typeof(input.options) != 'undefined' ) Highcharts.setOptions(input.options);

  // Convert tooltip formatter to a function
  if( typeof(input.chart.tooltip.formatter) != 'undefined' ) input.chart.tooltip.formatter = new Function(input.chart.tooltip.formatter);

  // Convert series events to functions
  for(i=0; i<input.chart.series.length; i++){
    var series = input.chart.series[i];
    if( typeof(series.events) != 'undefined' ){
      var keys = Object.keys(series.events);
      for(j=0; j<keys.length; j++){
        if( typeof(series.events[keys[j]]) != 'undefined' ) {
          input.chart.series[i].events[keys[j]] = new Function(input.chart.series[i].events[keys[j]]);
        }

      }
    }else{
      input.chart.series[i].point = new Object();
      input.chart.series[i].point.events = new Object();
      input.chart.series[i].point.events['click'] = function(){
        var attr = { x: this.x,
                     y: this.y,
                     value: this.value,
                     color: this.color  };

          console.debug(attr);

          Shiny.onInputChange(el.id, attr);
      }
    }
  }


  console.debug(el.id);
  console.debug(input);

  $('#'+el.id).highcharts( input.chart );


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts");

})();