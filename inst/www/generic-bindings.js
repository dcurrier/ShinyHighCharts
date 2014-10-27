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


  // Convert string representations of functions to actual functions
  // Remove elements with type 'object' and length 0
  // First we need to declare the iterate function
  function iterate(obj, stack) {
        for (var property in obj) {
            //console.debug(obj[property]);
            if (obj.hasOwnProperty(property)) {
                if (typeof obj[property] == "object") {
                  if( obj[property] == null || obj[property].length == 0 ){
                    delete obj[property];
                  }else{
                    iterate(obj[property], stack + '.' + property);
                  }
                } else if(typeof obj[property] == "string" && obj[property].indexOf('function()') !== -1) {
                    try{
                      obj[property] = eval("(" + obj[property] + ")");
                    } catch(e){
                       console.debug(e);
                       console.debug(obj[property]);
                    }
                }
            }
        }
    }

  // Now we need to call the iterate function on the input
  iterate(input.chart, '');

  // Declare function to check for nested arguments
  function checkNested(obj /*, level1, level2, ... levelN*/) {
    var args = Array.prototype.slice.call(arguments),
        obj = args.shift();

    for (var i = 0; i < args.length; i++) {
      if (!obj || !obj.hasOwnProperty(args[i])) {
        return false;
      }
      obj = obj[args[i]];
    }
    return true;
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
    if( input.chart.plotOptions.series.point.events['mouseOver'].indexOf('function()') !== -1 ){
      input.chart.plotOptions.series.point.events['mouseOver'] = eval("("+ input.chart.plotOptions.series.point.events['mouseOver'] +")");
    }

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
    if( input.chart.plotOptions.series.point.events['mouseOut'].indexOf('function()') !== -1 ){
      input.chart.plotOptions.series.point.events['mouseOut'] = eval("("+ input.chart.plotOptions.series.point.events['mouseOut'] +")");
    }

    if(input.chart.plotOptions.series.point.events['mouseOut'] == null ||
        input.chart.plotOptions.series.point.events['mouseOut'].length == 0) {
      delete input.chart.plotOptions.series.point.events['mouseOut'];
    }
  }catch(e){
    input.chart.plotOptions.series.point.events['mouseOut'] = function(){
            Shiny.onInputChange(el.id, null);
        }
  }



  console.debug(el.id);
  console.debug(input);

  if( checkNested(input, 'options3d') && checkNested(input.chart.chart.optionsed, 'enabled') && input.chart.chart.optionsed.enabled ){
    // Give the points a 3D feel by adding a radial gradient
    console.debug('setting 3d effects...');
    Highcharts.getOptions().colors = $.map(Highcharts.getOptions().colors, function (color) {
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

  $('#'+el.id).highcharts( input.chart );


}



// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "ShinyHighChart.highcharts");

})();