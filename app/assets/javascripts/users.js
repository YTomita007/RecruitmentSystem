// 新規登録で職種の選択肢 
$(".registration_role_box.input_client").click(function(){
  $(this).attr('id', 'active');
  $(".registration_role_box.input_creator").removeAttr('id', 'active');
})

$(".registration_role_box.input_creator").click(function(){
  $(this).attr('id', 'active');
  $(".registration_role_box.input_client").removeAttr('id', 'active').css("border-right", "0");
})

// プロフィールで稼働は可能の選択肢 
$(".setting_availability_box.available").not('.disabled_box').click(function(){
  $(this).attr('id', 'active');
  $(".setting_availability_box.unavailable").removeAttr('id', 'active');
})

$(".setting_availability_box.unavailable").not('.disabled_box').click(function(){
  $(this).attr('id', 'active');
  $(".setting_availability_box.available").removeAttr('id', 'active').css("border-right", "0");
})