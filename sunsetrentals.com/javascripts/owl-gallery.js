$(document).ready(function(){

  //Wait and then show Owl Gallery
  setTimeout(function(){
    $('.owl-gallery-loader-container').fadeOut(200);
  }, 1500);

  //Owl Gallery Sync
  var sync1 = $('.owl-gallery');
  var sync2 = $('.owl-gallery-thumbs');
  var slidesPerPage = 6;
  var syncedSecondary = true;
  sync1.owlCarousel({
    lazyLoad: true, lazyLoadEager: 2, items: 1, slideSpeed: 2000, nav: true, autoplay: false, dots: true, loop: true, margin: 10, navText: [], responsiveRefreshRate: 100
  }).on('changed.owl.carousel', syncPosition);
  sync2
    .on('initialized.owl.carousel', function() {
      sync2.find('.owl-item').eq(0).addClass('current');
    })
    .owlCarousel({
      lazyLoad: true, items: slidesPerPage, dots: false, nav: true, loop: false, smartSpeed: 200, slideSpeed: 500, slideBy: 1, navText: [], responsiveRefreshRate: 100, margin: 10,
      responsive: { 0: { items: 3 }, 480: { items: 4 }, 568: { items: 5 }, 768: { items: 6 }, 1200: { items: 8 } }
    })
    .on('changed.owl.carousel');
  
  function updateResult(pos,value){
    status.find(pos).find('.result').text(value);
  }
  function syncPosition(el) {
    var count = el.item.count-1;
    var current = Math.round(el.item.index - (el.item.count/2) - .5);
    if(current < 0) { current = count; }
    if(current > count) { current = 0; }
    sync2
      .find('.owl-item')
      .removeClass('current')
      .eq(current)
      .addClass('current');
    var onscreen = sync2.find('.owl-item.active').length - 1;
    var start = sync2.find('.owl-item.active').first().index();
    var end = sync2.find('.owl-item.active').last().index();
    if (current > end) {
      sync2.data('owl.carousel').to(current, 100, true);
    }
    if (current < start) {
      sync2.data('owl.carousel').to(current - onscreen, 100, true);
    }
  }
  sync2.on('click', '.owl-item', function(e){
    e.preventDefault();
    var number = $(this).index();
    sync1.data('owl.carousel').to(number, 300, true);
  });

});