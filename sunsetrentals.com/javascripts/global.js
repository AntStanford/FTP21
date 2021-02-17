$(document).ready(function(){

  var bookingFolder = '/rentals';

  // MOBILE MOVE FIXED NAVIGATION BAR TO TOP, MOST FOR z-index REASONS
  $(window).on('resize',function(){
    if ($(window).outerWidth() <= 1024) {
      $('.i-header-navigation').prependTo('body');
    } else {
      $('.i-header-navigation').insertAfter('.i-header-logo-wrap');
    }
  }).resize();

////////////////////////////////////////////
// UPDATE THIS IN booking/global.js TO MATCH
////////////////////////////////////////////
  // OPEN/CLOSE MOBILE MENU
  $('.i-header-mobileToggle').click(function(){
    $(this).find('.fa').toggleClass('fa-bars').toggleClass('fa-times');
    $('body').toggleClass('nav-open');
    $('.i-wrapper').toggleClass('menu-open');
    $(this).next('ul').toggleClass('open');
  });
  // GIVE PARENT ELEMENT CLASS sub
	$('.i-header-navigation li:has(ul)').addClass('sub');
	// HOVER OVER CHILD ELEMENT ADD CLASS active
	$('.i-header-navigation li.sub ul').hover(function(){
		$(this).parent().toggleClass('active');
	});
  // TOGGLE MOBILE SUB NAV
	$('.i-header-navigation li a + i').click(function(){
		$(this).parent('li.sub').toggleClass('open');
		$(this).toggleClass('fa-chevron-down').toggleClass('fa-chevron-up').next('ul').slideToggle();
	});
////////////////////////////////////////////

	$('.i-header-qs-scroller').click(function() {
    $('html,body').animate({
      scrollTop: $('#quickSearch').offset().top - 50}, // -50 is MARGIN OFFSET
    '1500');
  });

/* IF CLIENT HAS TABS ON QS - THIS WILL ADD CLASS AND TOGGLE BACKGROUND COLOR TO MAKE IT EASY ON USER FOR WHICH TAB THEY ARE ON
  $('.i-quick-search .nav-tabs li a').on('click', function(){
    if ($(this).parent('li').hasClass('realty')) {
      $('.i-quick-search').addClass('realty');
    } else {
      $('.i-quick-search').removeClass('realty');
    }
	});
*/

	// HEADER ACTIONS TOGGLE
	$('.header-action').on('click', function(){
    // TOGGLES DROP DOWNS
    if ($(this).next('.header-dropbox').hasClass('hidden')) {
      $('.header-dropbox').addClass('hidden');
      $(this).next('.header-dropbox').removeClass('hidden');
    } else {
      $(this).next('.header-dropbox').addClass('hidden');
    }
	});

	$(document).on('click','.header-dropbox-close',function(){
    $(this).parent().addClass('hidden');
	});

	// RECENTLY VIEWED
	$(document).on('click','#recentlyViewedToggle',function(){
		// NOW LOAD THE DATE IN TO THE TOP RIGHT VIA AJAX
		$.ajax({
			type: "GET",
			url: bookingFolder + '/ajax/recent-view.cfm',
			cache: false,
			success: function(data) {
				$('.brecentlist').html(data);
			}
		});
	});

  // CLICK TO SHOW FAVORITES BOX
	$(document).on('click','#favoritesToggle',function(){
		$.ajax({
			type: "GET",
			url: bookingFolder + '/ajax/view-favorites.cfm',
			cache: false, // IE BREAKS WITHOUT THIS
			success: function(data) {
				$('.bfavoriteslist').html(data);
			}
		});
	});

  // REMOVE FAVORITE FROM DROP LIST
  $(document).on('click', '.remove-from-favs-list', function(){
    var that = $(this);
    var prop = that.parent();
    var unitcode = prop.attr('data-unitcode');
    var counter = $('.remove-from-favs').attr('data-counter');
    var id = prop.attr('data-id');

    // REMOVE THE FAVORITE FROM THE RESULTS
		$('.results-list-property[data-unitcode='+unitcode+'] .add-to-favs .under').removeClass('favorited');

    // REMOVE THE FAVORITE FROM THE PDP
		$('.property-details-wrap[data-unitcode='+unitcode+'] .add-to-favs .under').removeClass('favorited');

    // REMOVE THE FAVORITE FROM THE COMPARE FAVORITES LIST
		$('.compare-list-property[data-unitcode='+unitcode+'] .remove-from-favs .under').removeClass('favorited');

    // REMOVE THE OWL ITEM FROM THE COMPARE FAVORITES LIST
    $('.compare-list-property[data-unitcode='+unitcode+']').parent().delay(250).fadeOut().queue(function(){$(this).remove();});

    // REMOVE THE ITEM FROM THE SEND TO FRIEND MODAL
		$('#sendToFriendCompare div#'+counter).remove();


    // PASS THE UNITCODE AND EITHER ADD OR REMOVE FROM FAVORITES
    $.ajax({
      type: "GET",
      url: bookingFolder+'/ajax/set-favorites-cookie.cfm?unitcode='+unitcode+'&favAdded=0',
      success: function(data) {
        // UPDATE THE NUMBER COUNT ON THE FLY IN THE HEADER
        $('.header-favorites-count').html(data);
				// NOW UPDATE COUNTER ON PAGE
        $('#favTotal').html(data);
        // NOW LOAD THE DATA INTO THE TOP RIGHT VIEW VIA AJAX
        $.ajax({
          type: "GET",
          url: bookingFolder+'/ajax/view-favorites.cfm',
          cache: false,
          success: function(data) {
            $('.bfavoriteslist').html(data);
          }
        });
      }
    });
	});

/////////////////////////////////////////////////////
/////////////// START DATEPICKER CODE ///////////////
/////////////////////////////////////////////////////
  if ($('#start-date').length) {
    // DISABLE END DATE - PREVENT USER FROM SELECTING THIS BEFORE THE START DATE
    // $('#end-date').attr('disabled', 'disable');
  	$('#start-date').datepicker({
  		minDate: '+1d',
  		onSelect: function( selectedDate ) {
  			var newDate = $(this).datepicker('getDate');
  			newDate.setDate(newDate.getDate()+7);
  			// MAKE THE END DATE SELECTABLE
  			$('#end-date').removeAttr('disabled');
  			$('#end-date').datepicker('setDate',newDate);
  			$('#end-date').datepicker('option','minDate',selectedDate);
  			setTimeout(function(){
  				$('#end-date').datepicker('show');
  			}, 16);
  		}
  	});
  	$('#end-date').datepicker({
      minDate: '+1d'
  	});
  }

/*
  if ($('#start-date').length) {
    // DATEPICKER WRAP TRIGGER
    $('.search-text').on('click', function(){
      $(this).toggleClass('active');

      if ($(this).next().hasClass('hidden')) {
        $('.datepicker-wrap').removeClass('hidden');
      } else {
        $(this).next().addClass('hidden');
      }
    });

    // ARRIVAL -> DEPARTURE DATEPICKER
    var calCount = 1;
    if ($(window).width() > 768) {
      // DESKTOP
      var calCount = [1, 2]; // TWO CALENDARS ON PAGE LOAD
    } else {
      // MOBILE
      var calCount = 1; // ONE CALENDAR ON PAGE LOAD
    }
    var startDate = $('#start-date').val();

    $.datepicker.setDefaults({dateFormat: 'mm/dd/yy'});

    $('#searchDatepicker').datepicker({
      defaultDate: startDate,
      minDate: '+1',
      numberOfMonths: calCount,
      beforeShowDay: function(date) {
        var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#start-date').val());
        var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#end-date').val());
        var isHighlight = date1 && ((date.getTime() == date1.getTime()) || (date2 && date >= date1 && date <= date2));
        return [true, isHighlight ? 'dp-highlight' : ''];
      },
      onSelect: function(dateText, inst) {
        var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#start-date').val());
        var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#end-date').val());
        var selectedDate = $.datepicker.parseDate($.datepicker._defaults.dateFormat, dateText);
        if (!date1 || date2) {
          $('#start-date').val(dateText).addClass('date-entered');
          $('#searchArrival label').addClass('active');
          $('#end-date').val('').addClass('date-entered');
          console.log('Start Date Entered');
        } else if (selectedDate < date1) {
          $('#end-date').val($('start-date').val());
          $('#start-date').val(dateText);
          console.log('You are going Backwards!');
        } else {
          $('#end-date').val(dateText).addClass('date-entered');
          $('#searchDeparture label').addClass('active');
          $('.datepicker-wrap').addClass('hidden');
          console.log('End Date Entered');
        }
      }
    });

    // DATEPICKER WRAP CLOSE BUTTON
  	$('.search-close').on('click', function(){
    	// GENERAL DROPDOWNS
      $('.search-text').removeClass('active');

    	if ($(this).parent().hasClass('datepicker-wrap')) {
      	$(this).parent().addClass('hidden');
      }
  	});

    // CLEAR/RESET DATEPICKERS & DATEPICKER WINDOW
  	$(document).on('click','.search-clear',function(){
    	// CLEAR/RESET THE DATEPICKER VALUES
      $('#searchDatepicker').datepicker('refresh');
      // SET DATE TO TODAY FOR RESET
      $('#searchDatepicker').datepicker('setDate',new Date());
      $('#start-date').val('').removeClass('date-entered').datepicker('refresh');
      $('#end-date').val('').removeClass('date-entered').datepicker('refresh');
      $('#searchArrival label').removeClass('active');
      $('#searchDeparture label').removeClass('active');
      // REMOVE HIGHLIGHT FROM DATEPICKER
      $('.ui-datepicker-calendar td').removeClass('dp-highlight');
    });

    // CLOSE DATEPICKERS WHEN SELECTPICKER IS CLICKED
  	$('.i-quick-search .select-wrap').on('click', function(){
      $('.search-text').removeClass('active');
  	  $('.datepicker-wrap').addClass('hidden');
  	});
  }
*/
/////////////////////////////////////////////////////
//////////////// END DATEPICKER CODE ////////////////
/////////////////////////////////////////////////////

  // SELECTPICKER
  if ($('.selectpicker').length) {
    $('.selectpicker').selectpicker();
  }

  // LAZY LOAD
  if ($('.lazy').length) {
    $('.lazy').lazy();
  }


  // OWL CAROUSEL
  if ($('.owl-carousel').length) {
    // HP BANNER SLIDER
    if ($('.owl-carousel.hp').length) {
      $('.owl-carousel.hp').owlCarousel({
        items: 1, autoplay: true, autoplayTimeout: 5000, autoHeight: false,  smartSpeed: 1000, lazyLoad: true, loop: true, onInitialized: removePlaceholder
      });
      function removePlaceholder() {
        $('.i-hero-wrap').removeClass('placeholder');
      }
    }
    // FEATURED PROPERTIES SLIDER
    if ($('.owl-carousel.featured-props-carousel').length) {
      $('.owl-carousel.featured-props-carousel').hide().delay(1500).fadeIn();

      $('.owl-carousel.featured-props-carousel').owlCarousel({
        responsive: {0:{items: 1}, 768:{items: 2}, 993:{items: 3}}, margin: 10, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: false, nav: true, navText: ["<img src='/images/layout/chevron-left.png' alt='Chevron Left'>","<img src='/images/layout/chevron-right.png' alt='Chevron Right'>"], dots: false
      });

      // LOADER BEFORE CAROUSEL LOADS IN
      $('.cssload-container').delay(1200).fadeOut();
    }
    // TESTIMONIAL SLIDER
    if ($('.owl-carousel.testimonial-carousel').length) {
      $('.owl-carousel.testimonial-carousel').owlCarousel({
        items: 1, autoplay: true, autoplayTimeout: 5000, smartSpeed: 1000, lazyLoad: true, loop: true, nav: true, navText: ["<img src='/images/layout/chevron-left.png' alt='Chevron Left'>","<img src='/images/layout/chevron-right.png' alt='Chevron Right'>"], dots: true
      });
    }
    // OWL GALLERY
    if ($('.owl-gallery').length) {
      $.getScript('/javascripts/owl-gallery.js');
    }
    // ADA Compliance for Owl Carousel 2
    setTimeout(function(){
      if ($('.owl-dots').length) {
        if (!$('.owl-dot .hidden').length) {
          $('.owl-dot').append('<div class="hidden">Slide Dot</div>');
        }
      }
      if ($('.owl-nav').length) {
        if (!$('.owl-prev .hidden').length) {
          $('.owl-prev').append('<div class="hidden">Prev</div>');
        }
        if (!$('.owl-next .hidden').length) {
          $('.owl-next').append('<div class="hidden">Next</div>');
        }
      }
    }, 500);
  }

  // FANCYBOX
  if ($('.fancybox').length) {
    $('.fancybox').fancybox();
  }

  // TOOLTIPS
  if ($('[data-toggle="tooltip"]').length) {
    $('[data-toggle="tooltip"]').tooltip();
  }

  // CLICK EVENT TO SCROLL UP - FADE FUNCTION WITH STICKY TABS FUNCTION
  $('#returnToTop').on('click', function(){
    $('html, body').animate({scrollTop : 0},500);
    return false;
  });

  if ($('form#contactform').length) {
    $('form#contactform').validate({
  		submitHandler: function(form){
  			$.ajax({
  				type: "POST",
  				url: "/submit.cfm",
  				data: $('form#contactform').serialize(),
  				dataType: "text",
  				success: function (response) {
  					response = $.trim(response);
  					console.log(response);
  					if(response === "success") {
  						$('form#contactform').hide();
  						$('#contactformMSG').html('Thanks! Your email has been sent!');
  					}
  					else {
  						$("#contactform div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
  					}
  				}
  			});
  			return false;
  		}
  	});
  }

  if ($('form#footerform').length) {
  	$('form#footerform').validate({
  		submitHandler: function(form){
  			$.ajax({
  				type: "POST",
  				url: "/submit.cfm",
  				data: $('form#footerform').serialize(),
  				dataType: "text",
  				success: function (response) {
  					response = $.trim(response);
  					console.log(response);
  					if(response === "success") {
  						$('form#footerform').hide();
  						$('#footerformMSG').html('Thanks! Your email has been sent!');
  					}
  					else {
  						$("#footerform div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
  					}
  				}
  			});
  			return false;
  		}
  	});
  }



});