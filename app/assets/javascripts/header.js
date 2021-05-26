$(document).on('click', function(e) {
  
  // Desktop Menu
  var button = $(e.target).closest('.header_account, .menu-item'),
      overlay = $(e.target).closest('#overlay');

  if ( button.length ) {
    $('.header_account').toggleClass('active');
    $('#overlay').toggleClass('open');
    $('span.mnic').toggleClass("arw_t arw_b")
  } else if (!overlay.length) {
    $('.header_account').removeClass('active');
    if ( $('#overlay').hasClass('open') ) {
      $('span.mnic').toggleClass("arw_t arw_b")
    }
    $('#overlay').removeClass('open');
  }
  
  // Mobile Menu
  var mbbutton = $(e.target).closest('#toggle'),
      mboverlay  = $(e.target).closest('#mobile_overlay');
  
  if ( mbbutton.length ) {
    $('#toggle').toggleClass('active_mbmenu');
    $('#mobile_overlay').toggleClass('open_mbmenu');
    $('.shadow').toggleClass('covered');
    $('body').toggleClass('overflow-y-hidden fixed h-full w-full');
  } else if (!mboverlay.length) {
    $('#toggle').removeClass('active_mbmenu');
    $('#mobile_overlay').removeClass('open_mbmenu');
    $('.shadow').removeClass('covered');
    $('body').removeClass('overflow-y-hidden fixed h-full w-full');
  }
  
});