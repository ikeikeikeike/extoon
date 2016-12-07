$(function() {

  var urlFor = function() {
    var attachEvent, clean_url, linkTo;

    clean_url = function(url) {
      return url;
    };

    linkTo = function() {
      return $('body').find('[url-for]').each(function(index) {
        var $this;

        $this = $(this);
        $this.addClass('pointer');

        return $this.off('click').on('click', function(e) {

          var w, url = clean_url($(this).attr('url-for'));

          // happend error in phoenix router
          // if (document.referrer) {
            // var referrer = "referrer=" + encodeURIComponent(document.referrer);
            // url = url + (location.search ? '&' : '?') + referrer;
          // }

          if ($(this).attr('target') === '_blank') {
            w = window.open();
            w.location.href = url;
            return;
          }

          if (e.ctrlKey || e.metaKey) {
            w = window.open();
            w.location.href = url;
            return;
          }

          location.href = url;
        });
      });
    };

    attachEvent = function() {

      /* Event */
      linkTo();
      return $('html, body').ajaxStart(function() {
        return linkTo();
      }).ajaxStop(function() {
        return linkTo();
      }).ajaxComplete(function() {
        return linkTo();
      });
    };

    attachEvent();
  };

  urlFor();


  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });


});
