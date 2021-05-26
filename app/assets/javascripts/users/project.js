$( document ).on('turbolinks:load', function() {

  $(".project_box_options_item").click(function(){
    if ( $( ".discard" ).length ) {
        if ( $(this).hasClass('active') ) { $(".project_box_options_item").not(this).addClass("discard"); }
        else if ( $(this).hasClass('discard') ) {
          $(".project_box_options_item.active").removeClass("active");
          $(this).removeClass('discard').addClass('active');
          $(".project_box_options_item").not(this).addClass("discard");
        }
    } else if ( !$(".project_box_options_item").hasClass("active") ) {
      $(this).addClass("active");
      $(".project_box_options_item").not(this).addClass("discard");
    }

    $('button.project_command_next_txt').removeAttr("disabled");

  })
});
