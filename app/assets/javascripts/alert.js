// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$( document ).on('turbolinks:load', function() {
  
  setTimeout(function show_message(){
    $('.message_alert').css("top", '65px');
  }, 500)
  setTimeout(function hide_message(){
    $('.message_alert').css("top", '-100px');
  }, 3500);

  $(document).click(function(){
    $('.message_alert').css("top", '-100px');
    setTimeout(function hide_message(){
      $('.message_alert').hide();
    }, 500)
  });
  
  
  
  
});