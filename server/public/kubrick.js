(function() {
  window.log = function() {
    log.history = log.history || [];
    log.history.push(arguments);
    return (this.console) ? console.log(Array.prototype.slice.call(arguments)) : null;
  };
  $(function() {});
}).call(this);
