$( window ).on( "click", function() {
  ;( function( $, window, document, undefined )
  {
  $( '.inputfile' ).each( function()
  {
    var $input	 = $( this ),
      $label	 = $input.next( 'label' ),
      labelVal = $label.html();

    $input.on( 'change', function( e )
    {
      var fileName = '';
      if( this.files && this.files.length > 1 )
        fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
      else if( e.target.value )
        fileName = e.target.value.split( '\\' ).pop();

      if( fileName )
        $label.find( 'span' ).html( fileName );
      else
        $label.html( labelVal );
    });
    // Firefox bug fix
    $input
    .on( 'focus', function(){ $input.addClass( 'has-focus' ); })
    .on( 'blur', function(){ $input.removeClass( 'has-focus' ); });
  });
  })( jQuery, window, document );
  
  
  $('.files').change(function(e) {
    // ファイル情報を取得
    var fileData = e.target.files[0];
    //サムネイル表示エリアのエレメント取得
    var object = $('object').get(0);
    // FileReaderオブジェクトを使ってファイル読み込み
    var reader = new FileReader();
    // サイズの判定
    var size = fileData.size; // ファイル容量（byte）
    var limit = 20000000; // byte, 20MB
    // サイズの20MBまで
    if ( limit < size ) {
      // インプットをリセット
      $('.files').val(null);
      $('.files').next().children("span").html('');
      alert('20MBを超えています。20MB以下のファイルを選択してください。').off();
    }
    // 2MB以上のpdfを表示区別
    if ( fileData.type == 'application/pdf' && fileData.size > 2000000 ) {
      var pdficon = 'https://cdn4.iconfinder.com/data/icons/file-extension-names-vol-8/512/24-512.png';
      //ノードの複製
      var cln = object.cloneNode(true);
      //複製したノードのdata要素をにFileAPIの読み込み結果をセット
      cln.setAttribute("data",pdficon);
      object.parentNode.replaceChild(cln, object);
    } 
      // 2MB以下のpdfを表示区別
      else {
      // ファイル読取り成功時処理
      reader.onload = function() {
          //ノードの複製
          var cln = object.cloneNode(true);
          //複製したノードのdata要素をにFileAPIの読み込み結果をセット
          cln.setAttribute("data",reader.result);
          object.parentNode.replaceChild(cln, object);
      }
      // ファイル読み込みを実行
      reader.readAsDataURL(fileData);
    }
  });
   
  $('.profile_setting_todelete a').click(function(){
     $('.profile_portfolios_left').hide();
   });
  
});

function hidebtn() {
   $('.add_nested_fields').hide();
 };

function loading() {
 $('button.profile_setting_save').addClass('loading');
 return true;
};