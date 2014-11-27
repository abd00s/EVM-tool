
$(function() {

  

  var d1 = gon.bcws
  // var d2 = gon.bcwp
  // var d3 = gon.acwp

  $.plot("#chart", [d1]);

  // Make a rails controller method that returns some json
  // $.getJSON("/the/controller/method", function(data) { $plot("#chart", [ data["series"] ]); });
});