$(function() {
  (function() {

    function search(word) {
      var client = new dmm.Client({
        api_id: window.Extoon.config.dmm.api_id,
        affiliate_id: window.Extoon.config.dmm.affiliate_id
      });

      client.product({
        keyword: word,
        site: 'DMM.R18',
        // article: 'actress',
        // service: 'digital',
        // floor: 'videoa',
        fllor: 'anime',  // anime
        sort: 'date',  // latest
        // TODO: Gotta see the fllor and service code in api ref
      }, function (err, data) {
        if (! data) {
          return;  // console.log(err);
        }


      });
    }

    debugger
    search('猫');


  })();
});
