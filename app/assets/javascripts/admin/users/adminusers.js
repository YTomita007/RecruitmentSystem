$( document ).on('turbolinks:load', function() {

  $(".registration_role_box.input_client").click(function(){
    $(this).attr('id', 'active');
    $(".registration_role_box.input_creator").removeAttr('id', 'active');
  })

  $(".registration_role_box.input_creator").click(function(){
    $(this).attr('id', 'active');
    $(".registration_role_box.input_client").removeAttr('id', 'active').css("border-right", "0");
  })


  $(".setting_availability_box.available").not('.disabled_box').click(function(){
    $(this).attr('id', 'active');
    $(".setting_availability_box.unavailable").removeAttr('id', 'active');
  })

  $(".setting_availability_box.unavailable").not('.disabled_box').click(function(){
    $(this).attr('id', 'active');
    $(".setting_availability_box.available").removeAttr('id', 'active').css("border-right", "0");
  })
});
