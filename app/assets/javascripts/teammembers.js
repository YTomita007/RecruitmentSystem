$( document ).on('turbolinks:load', function() {

  var acc = $(".readmore_button");
  var i;

  for (i = 0; i < acc.length; i++) {
    acc[i].addEventListener("click", function() {
      this.classList.toggle("active");
      $(this).children('.readmore_arrow').children('span.rmic').toggleClass("rmarw_t rmarw_b");
      var panel = this.previousSibling;
      if (panel.style.maxHeight){
        panel.style.maxHeight = null;
      } else {
        panel.style.maxHeight = panel.scrollHeight + "px";
      } 
    });
  }
  
  
});