//var data = require('./scripts/mychart2.json'); //(with path)

//data = src="mychart2.json"
// <script type="text/javascript" src="javascript.js"></script>

console.log("Running mychar2_2.js");
console.log(interessen_bindungen);
console.log(interessen_bindungen[0].values[0]);
console.log('test');


nv.addGraph(function() {
  var chart = nv.models.discreteBarChart()
    .x(function(d) { return d.label })
    .y(function(d) { return d.value })
    .staggerLabels(true)
    .showValues(true)

  d3.select('#chart-interessenbindungen svg')
    .datum(interessen_bindungen)
    .transition().duration(500)
    .call(chart)
    ;

  nv.utils.windowResize(chart.update);

  return chart;
});

