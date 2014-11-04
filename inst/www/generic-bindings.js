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

  // Check for renderTo element, default to element id
  try{
    if( typeof(input.chart.chart.renderTo) == 'undefined' ) {
      input.chart.chart.renderTo = el.id;
    }
  }catch(e){
    if( typeof(input.chart.chart) == 'undefined' ) input.chart.chart = new Object();
    input.chart.chart.renderTo = el.id;
  }

  // Setup global 'mouseOver' event to capture current point data
  try{
    typeof(input.chart.plotOptions.series.point.events)
  } catch(e){
    if(typeof(input.chart.plotOptions) == 'undefined') input.chart.plotOptions = new Object();
    if(typeof(input.chart.plotOptions.series) == 'undefined') input.chart.plotOptions.series = new Object();
    if(typeof(input.chart.plotOptions.series.point) == 'undefined') input.chart.plotOptions.series.point = new Object();
    if(typeof(input.chart.plotOptions.series.point.events) == 'undefined') input.chart.plotOptions.series.point.events = new Object();
  }

  try{
   if(input.chart.plotOptions.series.point.events['mouseOver'] == null ||
        input.chart.plotOptions.series.point.events['mouseOver'].length == 0) {
      delete input.chart.plotOptions.series.point.events['mouseOver'];
    }
  }catch(e){
    input.chart.plotOptions.series.point.events['mouseOver'] = function(){
        var attr = { x: this.x,
                     y: this.y,
                     value: this.value,
                       color: this.color,
                        name: this.series.name };

            console.debug(attr);

            Shiny.onInputChange(el.id, attr);
        }
  }

  // Reset to null
  try{
    if(input.chart.plotOptions.series.point.events['mouseOut'] == null ||
        input.chart.plotOptions.series.point.events['mouseOut'].length == 0) {
      delete input.chart.plotOptions.series.point.events['mouseOut'];
    }
  }catch(e){
    input.chart.plotOptions.series.point.events['mouseOut'] = function(){
            Shiny.onInputChange(el.id, null);
        }
  }

  // Convert string representations of functions to actual functions
  // Remove elements with type 'object' and length 0
  cleanUp(input.chart, '');


  console.debug(el.id);
  console.debug(input);

  if( checkNested(input.chart.chart, 'options3d') && checkNested(input.chart.chart.options3d, 'enabled') && input.chart.chart.options3d.enabled ){
    // Give the points a 3D feel by adding a radial gradient
    console.debug('setting 3d effects...');
    input.chart.colors = $.map(Highcharts.getOptions().colors, function (color) {
        return {
            radialGradient: {
                cx: 0.4,
                cy: 0.3,
                r: 0.5
            },
            stops: [
                [0, color],
                [1, Highcharts.Color(color).brighten(-0.2).get('rgb')]
            ]
        };
    });
  }

  //$( '#' + el.id ).highcharts( input.chart );
  var chart = new Highcharts.Chart(input.chart);

  // Add mouse events for rotation
  if( checkNested(input.chart.chart, 'options3d') && checkNested(input.chart.chart.options3d, 'enabled') && input.chart.chart.options3d.enabled ){
    // Add mouse events for rotation
    $(chart.container).bind('mousedown.hc touchstart.hc', function (e) {
        e = chart.pointer.normalize(e);

        var posX = e.pageX,
            posY = e.pageY,
            alpha = chart.options.chart.options3d.alpha,
            beta = chart.options.chart.options3d.beta,
            newAlpha,
            newBeta,
            sensitivity = 5; // lower is more sensitive

        $(document).bind({
            'mousemove.hc touchdrag.hc': function (e) {
                // Run beta
                newBeta = beta + (posX - e.pageX) / sensitivity;
                newBeta = Math.min(100, Math.max(-100, newBeta));
                chart.options.chart.options3d.beta = newBeta;

                // Run alpha
                newAlpha = alpha + (e.pageY - posY) / sensitivity;
                newAlpha = Math.min(100, Math.max(-100, newAlpha));
                chart.options.chart.options3d.alpha = newAlpha;

                chart.redraw(false);
            },
            'mouseup touchend': function () {
                $(document).unbind('.hc');
            }
        });
    });
  }


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts");

})();