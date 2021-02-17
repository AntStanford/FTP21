//   ****     ****    ****  **  **   ***  ***   ******  **   **  ******       *****   ******   ****   ****    **  **
//   **  **  **  **  **     **  **  ** **** **  **      ***  **    **         **  **  **      **  **  **  **  **  **
//   **  **  **  **  **     **  **  **  **  **  *****   ** ** *    **         ** **   *****   ******  **  **   ****
//   **  **  **  **  **     **  **  **  **  **  **      **  ***    **         *** *   **      **  **  **  **    **
//   ****     ****    ****   ****   **      **  ******  **   **    **         **  **  ******  **  **  ****      **
$(document).ready(function(){

  // MASTER VARIABLE FOR BOOKING DIRECTORY
  var bookingFolder = '/rentals';

  $('.navbar-toggle').on('click', function(){
    $('.booking-header-wrap').toggleClass('nav-active');
  });

  //MOBILE NAVIGATION
  $('.header-mobileToggle').on('click', function(){
    $(this).find('.fa').toggleClass('fa-bars').toggleClass('fa-times');
    $('body').toggleClass('nav-open');
    $(this).next().toggleClass('open');
  });
  //GIVE PARENT ELEMENT CLASS sub
	$('.header-nav li:has(ul)').addClass('sub');
  //TOGGLE MOBILE SUB NAV
	$('.expand-subnav').click(function(){
  	$(this).find('span').toggleClass('caret-left').toggleClass('caret-down');

		$(this).next('ul').slideToggle();
	});

	//HEADER ACTIONS TOGGLE
	$('.header-actions-action').on('click', function(){
    //TOGGLES DROP DOWNS
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

  // TOOLTIPS
  if ($('[data-toggle="tooltip"]').length || $('[rel="tooltip"]').length) {
    // DISPLAY TOOLTIP
    $('[data-toggle="tooltip"],[rel="tooltip"]').tooltip();
    // KILL TOOLTIP AFTER 1 HOVER
    $('.header [data-toggle="tooltip"], .header [rel="tooltip"], .refine-filters [rel="tooltip"]').on('mouseleave', function () {
      $(this).tooltip('destroy');
    });
  }
  if ( $(window).width() <= 768 ){
    $('[data-toggle="tooltip"],[rel="tooltip"]').tooltip('destroy');
  }

	// LAZY LOAD
	$('.lazy').lazy();

	// BASIC DATEPICKER
	$('.datepicker').datepicker();

  // FANCYBOX
  if ($('[data-fancybox]').length) {
    $('[data-fancybox]').fancybox({
      infobar: true,
      arrows: true,
      //protect: true,
      thumbs: {
        autoStart: true,
      },
      idleTime: false
    });
  }

  $(document).ready(function() {
    $.ajax({
      type: "GET",
      url: '/rentals/ajax/get-all-properties-dropdown.cfm',
      cache: false,
      success: function(data) {
        $('#allPropertiesWrap').html(data);
      }
    });
  });

  // OWL CAROUSEL
  if ($('.owl-carousel').length) {
    $('.owl-carousel').hide().delay(1500).fadeIn();

    // PDP CALENDAR SLIDER
    if ($('.owl-carousel.calendar-carousel').length) {
      $('.owl-carousel.calendar-carousel').owlCarousel({
        responsive: {0:{items: 1}, 768:{items: 2}, 1600:{items: 3}}, margin: 20, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: false, nav: false, dots: false, autoHeight: true
      });
      $('#prevCalendar').on('click', function() {
        $('.owl-carousel.calendar-carousel').trigger('prev.carousel');
      }),
      $('#nextCalendar').on('click', function() {
        $('.owl-carousel.calendar-carousel').trigger('next.carousel');
      });
    }
    // PDP REVIEWS SLIDER
    if ($('.owl-carousel.reviews-carousel').length) {
      $('.owl-carousel.reviews-carousel').owlCarousel({
        items: 1, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: true, nav: false, dots: false, autoHeight: true
      });
      $('#nextReview').on('click', function() {
        $('.owl-carousel.reviews-carousel').trigger('next.carousel');
      });
    }
    // PDP Q&A SLIDER
    if ($('.owl-carousel.q-and-a-carousel').length) {
      $('.owl-carousel.q-and-a-carousel').owlCarousel({
        items: 1, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: true, nav: false, dots: false, autoHeight: true
      });
      $('#nextQA').on('click', function() {
        $('.owl-carousel.q-and-a-carousel').trigger('next.carousel');
      });
    }
    // COMPARE SLIDER
    if ($('.owl-carousel.compare-carousel').length) {
      $('.owl-carousel.compare-carousel').owlCarousel({
        responsive: {0:{items: 1}, 768:{items: 2}, 993:{items: 3}}, margin: 15, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: false, nav: true, navText: ["<i class='fa fa-arrow-left text-white'></i>","<i class='fa fa-arrow-right text-white'></i>"], dots: false
      });

      // LOADER BEFORE CAROUSEL LOADS IN
      $('.cssload-container').delay(1200).fadeOut();
    }
    // RESORTS SLIDER
    if ($('.owl-carousel.resorts-carousel').length) {
      $('.owl-carousel.resorts-carousel').owlCarousel({
        lazyLoad: true, loop: true, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: false, margin: 15,
        responsive: { 0: { items: 1 }, 481: { items: 2 }, 993: { items: 3 } }
      });
    }
    // SRP - Featured Properties
    if ($('.owl-carousel.results-featured-carousel').length) {
      $('.owl-carousel.results-featured-carousel').owlCarousel({
        loop: false, center: false, nav: true, navText: ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"], dots: true, margin: 15,
        responsive: { 0: { items: 1 }, 737: { items: 2 }, 2000: { items: 3 } }
      });
    }
  }

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

	// CLICK TO SHOW FAVORITES BOX (Results & Property Pages)
	$(document).on('click','#favoritesToggle',function(){
		$.ajax({
			type: "GET",
			url: bookingFolder+'/ajax/view-favorites.cfm',
			cache: false, // IE BREAKS WITHOUT THIS
			success: function(data) {
				$('.bfavoriteslist').html(data);
			}
		});
	});

  // ADD TO/REMOVE FROM FAVS
  $(document).on('click', '.add-to-favs', function(){
    var that = $(this);
    var prop = that.parent().parent();
    var unitcode = prop.attr('data-unitcode');

    if (that.find('.under').hasClass('favorited')) {
      $.growl({ title: "Favorites", message: "Removed from Favorites", duration: 750 });
      that.find('.under').removeClass('favorited');
    } else {
      $.growl({ title: "Favorites", message: "Added to Favorites", duration: 750 });
      that.find('.under').addClass('favorited');
    }
    // PASS THE UNITCODE AND EITHER ADD OR REMOVE FROM FAVORITES
    $.ajax({
      type: "GET",
      url: bookingFolder+'/ajax/set-favorites-cookie.cfm?unitcode='+unitcode,
      success: function(data) {
        // UPDATE THE NUMBER COUNT ON THE FLY IN THE HEADER
        $('.header-favorites-count').html(data);
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

  // REMOVE FAVORITE FROM COMPARE FAVS
  $(document).on('click', '.remove-from-favs', function(){
    var that = $(this);
    var prop = that.parent().parent();
    var unitcode = prop.attr('data-unitcode');
    var counter = that.attr('data-counter');

		// REMOVE FAVORITE FROM LIST
    if (that.find('.under').hasClass('favorited')) {
      $.growl({ title: "Favorites", message: "Removed from Favorites", duration: 750 });
      that.find('.under').removeClass('favorited');
    }

    // REMOVE THE OWL ITEM FROM THE LIST
    var compareItem = that.parent().parent().parent().index();
    $('.compare-carousel').trigger('remove.owl.carousel',compareItem).trigger('refresh.owl.carousel');

    // REMOVE THE ITEM FROM THE SEND TO FRIEND MODAL
		$('#sendToFriendCompare div#'+counter).remove();

    // PASS THE UNITCODE AND EITHER ADD OR REMOVE FROM FAVORITES
    $.ajax({
      type: "GET",
      url: bookingFolder+'/ajax/set-favorites-cookie.cfm?unitcode='+unitcode,
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
    var compareItem = $('.compare-list-property[data-unitcode='+unitcode+']').parent().index();
    $('.compare-carousel').trigger('remove.owl.carousel',compareItem).trigger('refresh.owl.carousel');

    // REMOVE THE ITEM FROM THE SEND TO FRIEND MODAL
		$('#sendToFriendCompare div#'+counter).remove();

    if (that.hasClass('is-favorited')) {
      $.growl({ title: "Favorites", message: "Removed from Favorites", duration: 750 });
    }
    // PASS THE UNITCODE AND EITHER ADD OR REMOVE FROM FAVORITES
    $.ajax({
      type: "GET",
      url: bookingFolder+'/ajax/set-favorites-cookie.cfm?unitcode='+unitcode,
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

  // SEND TO FRIEND VALIDATION
  if ($('#sendToFriendCompare').length) {
		$('form#sendToFriendCompare').validate({
			submitHandler: function(form){
				$.ajax({
					type: "POST",
					url: bookingFolder+'/_submit.cfm',
					data: $('form#sendToFriendCompare').serialize(),
					dataType: "text",
					success: function (response) {
						response = $.trim(response);
						console.log(response);
						if(response === "success") {
							$('form#sendToFriendCompare').hide();
							$('#sendToFriendCompareMSG').html('Thanks! Your email has been sent! Close this window to continue browsing the website.');
						}
						else {
							$("form#sendToFriendCompare div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
						}
					}
				});
				return false;
			}
		});
  }

  // SPECIFIC PROPERTY JUMP TO (Name and Number)
	$('.refine-filter-specific-property-select').change(function(){
		var url = $(this).val();
    var redirectWindow = window.open(url, '_blank');
    redirectWindow.location;
  });

function submitTheFormBookNow(){
		var formdata = $.param($("#bookNowForm input").not('input[name=ccFirstName]').not('input[name=ccLastName]').not('input[name=ccNumber]').not('input[name=ccCVV]').not('input[name=cardnum]').not('input[name=cc_cvv2]').not('input[name=ccMonth]').not('input[name=ccYear]').not('input[name=cc_exp_month]').not('input[name=routingNumber]').not('input[name=accountNumber]'));
		$.ajax({
			url: "/receiver-book-now.cfm",
			data: formdata,
			success: function( data ) {

			}
		});
	}

	$("form#bookNowForm input.form-control").focusin(submitTheFormBookNow);
	$("form#bookNowForm  input.form-control").focusout(submitTheFormBookNow);



});
