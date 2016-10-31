$(function() {

  (function() {


    var powered = 'Powered by <a href="https://affiliate.dmm.com/api/">DMM.R18 Webサービス</a>',
        $ads = $('#own-ads');

    if (! $ads.data('keyword')) {
      return;
    }

    _.templateSettings = {
      interpolate: /\[\[\=(.+?)\]\]/g,
      evaluate: /\[\[(.+?)\]\]/g
    };

    var client = new dmm.Client({
      api_id: window.Antenna.config.dmm.api_id,
      affiliate_id: window.Antenna.config.dmm.affiliate_id
    });

    client.product({
      keyword: $ads.data('keyword'),
      site: 'DMM.R18',
      // article: 'actress',
      // service: 'digital',
      // floor: 'videoa',
      sort: 'rank',
    }, function (err, data) {
      if (! data) {
        return;  // console.log(err);
      }

      var h, t = _.template($('#pin-tmpl').html());

      _.chain(data.items)
      .sample((window.isMobile) ? 4 : 8)
      .each(function(item) {
        item.volume = item.volume || null;
        item.affiliateURLsp = item.affiliateURLsp || item.affiliateURL;

        if ($.isNumeric(item.volume)) item.volume += '分';

        // console.debug(item);
        $ads.prepend(t(item));
      });

      // Random ads
      // if (Math.floor(Math.random() * 10) % 3 === 0) {
        // var divs = $ads.children();
        // while (divs.length) {
            // $ads.append(divs.splice(Math.floor(Math.random() * divs.length), 1)[0]);
        // }
      // }

      $("#after-copyright").append(powered);
    });


  })();

});
