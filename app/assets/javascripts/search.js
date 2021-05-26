$( document ).on('turbolinks:load', function() {
  
  $(".question_box_options_item").click(function(){
    if ( $( ".discard" ).length ) {
        if ( $(this).hasClass('active') ) { $(".question_box_options_item").not(this).addClass("discard"); } 
        else if ( $(this).hasClass('discard') ) {
          $(".question_box_options_item.active").removeClass("active");
          $(this).removeClass('discard').addClass('active');
          $(".question_box_options_item").not(this).addClass("discard");
        }
    } else if ( !$(".question_box_options_item").hasClass("active") ) {
      $(this).addClass("active");
      $(".question_box_options_item").not(this).addClass("discard");
    }
    
    $('button.question_box_command_next_txt').removeAttr("disabled");
    
  })
});