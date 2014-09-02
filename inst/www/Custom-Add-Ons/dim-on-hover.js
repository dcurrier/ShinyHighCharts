// Put code in a window property.
// This isn't strictly necessary, but it's good JavaScript hygiene.
window.HighchartsAddOn={
    originalColor: new Array(),
    mouseWasOver: false,

  // Declare function for changing the color of all series except the
  // one we are hovering over.
    dimAllElse: function() {
       var allSeries = this.chart.series;
       HighchartsAddOn.mouseWasOver = true;
        console.debug(allSeries[this.index].options);
       allSeries[this.index].options.marker.radius = 6;
       allSeries[this.index].options.type = 'line';
       allSeries[this.index].options.lineWidth = 2;

        for(i=0; i<allSeries.length; i++){
          HighchartsAddOn.originalColor[i] = allSeries[i].color;
          if(this.index != i){
              allSeries[i].options.color = '#F1F1F1';
              allSeries[i].update(allSeries[i].options);
          }
        }
  },

  // Reset the colors to their original values
  resetSeries: function() {
      if(HighchartsAddOn.originalColor !== null && HighchartsAddOn.mouseWasOver) {
          var allSeries = this.chart.series;
          HighchartsAddOn.mouseWasOver = false;
          allSeries[this.index].options.marker.radius = 4;
          allSeries[this.index].options.type = 'scatter';
          allSeries[this.index].options.lineWidth = 0;

          for(i=0; i<allSeries.length; i++){
              allSeries[i].options.color = HighchartsAddOn.originalColor[i];
              allSeries[i].update(allSeries[i].options);
          }
      }
  }
};