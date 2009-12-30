$(function(){
    $('#start_button').click(start);
    $('#hashtag_form').submit(start);
});

function start(){
  var tag = $('#hashtag').val();
  $('#hashtag').parent().hide();
  if(tag == ''){
    tag = 'sample stream';
  }
  var p = $(document.createElement('p'));
  p.html(tag + 'を中継中');
  $("#now_streaming").append(p);
  var url = '/hashtag/' + tag;
  $.post(url, null, function(){
           $.getJSON('/message/' + tag, {data: Date}, reflect);
         });
  return false;
}

function reflect(response){
  $.each({dd: response.text,
          dt: (response.user && response.user.name)}, function(k, v){
            var node = $(document.createElement(k));
            node.html(v);
            if(k == 'dt'){
              var img = document.createElement('img');
              img.src = (response.user && response.user.profile_image_url);
              img.style.width = '48px';
              img.style.height = '48px';
              node.prepend(img);
            }
            $("#messages").prepend(node);
          });
  setTimeout(function(){$.getJSON('/message/' + response.hashtag,
                                  {data: Date}, reflect);}, 1000);
}