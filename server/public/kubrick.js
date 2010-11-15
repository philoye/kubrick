window.onload = function () {
  var r = Raphael("altitude-graph");
  var x = [], y = [];
  for (var i = 0; i < 1e6; i++) {
      x[i] = i * 10;
      y[i] = (y[i - 1] || 0) + (Math.random() * 7) - 3;
  }
  r.g.linechart(-10, 0, 970, 180, x, y, {shade: true});
};


(function($){

  $(document).ready(function(){


  });



})(this.jQuery);



// usage: log('inside coolFunc',this,arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console){
    console.log( Array.prototype.slice.call(arguments) );
  }
};
