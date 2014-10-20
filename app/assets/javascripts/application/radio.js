$(document).ready(function() {
  $('#playlist_links a').click(function() {
    info = radiosInfo[$(this).data('item')];

    $('#radio_name').html(info['title']);
    $('#radio').html(getRadioIframe(info));
  });

  function getRadioIframe(info) {
    var iframe  = '<iframe width="380" height="480" scrolling="no" frameborder="no"';
        iframe += 'src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/';
        iframe += info['id'];
        iframe += '&amp;color=' + info['color'];
        iframe += '&amp;auto_play=true&amp;hide_related=true&amp;show_comments=false&amp;show_user=false&amp;show_reposts=false">';
        iframe += '</iframe>';

    return iframe;
  }

  var radiosInfo = {
    'acervo':   { 'id': '54865629%3Fsecret_token%3Ds-Xa7kd', 'color': '00aaad', 'title': 'Acervo completo' },
    'chorinho': { 'id': '55060099%3Fsecret_token%3Ds-6Bz16', 'color': '135d60', 'title': 'Chorinhos do Brasil' },
    'jazz':     { 'id': '55067951%3Fsecret_token%3Ds-XoaV3', 'color': '8d201b', 'title': 'Jazz' },
    'rock':     { 'id': '55210093%3Fsecret_token%3Ds-lJchf', 'color': '503d64', 'title': 'Rock' },
    'baioes':   { 'id': '55073200%3Fsecret_token%3Ds-V7WI4', 'color': '6c7a27', 'title': 'Baiões Nordestinos' },
  }
});
