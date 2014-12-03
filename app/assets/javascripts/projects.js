
$(function() {

  

  var d1 = gon.bcws
  var d2 = gon.bcwp
  var d3 = gon.acwp

  $.plot("#chart", [d1, d2, d3]);

  // Make a rails controller method that returns some json
  // $.getJSON("/the/controller/method", function(data) { $plot("#chart", [ data["series"] ]); });


var chart = c3.generate({
    bindto: '#cpigauge',
    data: {
        columns: [
            ['CPI', gon.cpi]
        ],
        type: 'gauge',

    },
    gauge: {
       label: {
           format: function(value, ratio) {
               return value;
           },
           show: true // to turn off the min/max labels.
       },
   min: 0.5, // 0 is default, //can handle negative min e.g. vacuum / voltage / current flow / rate of change
   max: 1.5, // 100 is default
   // units: '',
   width: 80 // for adjusting arc thickness
    },
    color: {
        pattern: ['#FF0000', '#F97600', '#F6C600', '#60B044'], // the three color levels for the percentage values.
        threshold: {
//            unit: 'value', // percentage is default
//            max: 200, // 100 is default
            values: [0.7, 0.85, 1.0, 1.0]
        }
    },
    size: {
        height: 180
    }
});

var chart2 = c3.generate({
    bindto: '#spigauge',
    data: {
        columns: [
            ['SPI', gon.spi]
        ],
        type: 'gauge',

    },
    gauge: {
       label: {
           format: function(value, ratio) {
               return value;
           },
           show: true // to turn off the min/max labels.
       },
   min: 0.5, // 0 is default, //can handle negative min e.g. vacuum / voltage / current flow / rate of change
   max: 1.5, // 100 is default
   // units: '',
   width: 80 // for adjusting arc thickness
    },
    color: {
        pattern: ['#FF0000', '#F97600', '#F6C600', '#60B044'], // the three color levels for the percentage values.
        threshold: {
//            unit: 'value', // percentage is default
//            max: 200, // 100 is default
            values: [0.7, 0.85, 1.0, 1.0]
        }
    },
    size: {
        height: 180
    }
});
});



