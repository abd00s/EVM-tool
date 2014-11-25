
$(function() {

  

  var d4 = gon.info

  $.plot("#chart", [d4]);

  // Make a rails controller method that returns some json
  // $.getJSON("/the/controller/method", function(data) { $plot("#chart", [ data["series"] ]); });
});