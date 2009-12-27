$(function(){
    $('#start_button').click(function(){
                               var tag = $('#hashtag').val();
                               var url = '/hashtag/' + tag;
                               $.post(url, null, function(){
                                        $.getJSON('/message/' + tag, {data: Date}, reflect);
                                      });
                             });
});

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