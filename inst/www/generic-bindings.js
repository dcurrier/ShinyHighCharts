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
  return $(scope).find(".highcharts");
};

binding.renderValue = function(el, input) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  console.debug(input);
  console.debug(el.id);

  // Return Null if input is null
  if(input == null) return;

  if( typeof(input.options) != 'undefined' ) Highcharts.setOptions(input.options);

  $('#'+el.id).highcharts( input.chart );


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts");

})();