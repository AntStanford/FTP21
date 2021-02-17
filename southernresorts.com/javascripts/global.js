$(document).ready(function(){
  var bookingFolder = '/vacation-rentals';
////////////////////////////////////////////
// UPDATE THIS IN booking/global.js TO MATCH
////////////////////////////////////////////
  // OPEN/CLOSE MOBILE MENU
  $('.i-header-mobileToggle').click(function(){
    $(this).find('.fa').toggleClass('fa-bars').toggleClass('fa-times');
    $('body').toggleClass('nav-open');
    $('.i-wrapper').toggleClass('menu-open');
    $(this).siblings('ul').toggleClass('open');
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
	$('.i-header-qs-scroller').click(function() {
    $('html,body').animate({
      scrollTop: $('#quickSearch').offset().top - 50}, // -50 is MARGIN OFFSET
    '1500');
  });
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
	/////////////// START DATEPICKER CODE ///////////////
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
//////////////// END DATEPICKER CODE ////////////////
  // SELECTPICKER
  if ($('.selectpicker').length) {
    $('.selectpicker').selectpicker();
  }

  // OWL CAROUSEL
  if ($('.owl-carousel').length) {
    // HP BANNER SLIDER
    if ($('.owl-carousel.hp').length) {
      $('.owl-carousel.hp').owlCarousel({
        items: 1, autoplay: true, autoplayTimeout: 5000, smartSpeed: 1000, lazyLoad: true, loop: true, nav: true, navText: ["<i class='fa fa-arrow-left text-white'></i>","<i class='fa fa-arrow-right text-white'></i>"]
      });
    }
    // FEATURED PROPERTIES SLIDER
    if ($('.owl-carousel.featured-props-carousel').length) {
      $('.owl-carousel.featured-props-carousel').hide().delay(1500).fadeIn();

      $('.owl-carousel.featured-props-carousel').owlCarousel({
        responsive: {0:{items: 1}, 768:{items: 2}, 993:{items: 3}}, margin: 15, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: false, nav: true, navText: ["<i class='fa fa-arrow-left text-white'></i>","<i class='fa fa-arrow-right text-white'></i>"], dots: false
      });

      // LOADER BEFORE CAROUSEL LOADS IN
      $('.cssload-container').delay(1200).fadeOut();
    }    
    // OWL GALLERY
    if ($('.owl-gallery').length) {
      $.getScript('/javascripts/owl-gallery.js');
    }
  }
  // FANCYBOX
  if ($('.fancybox').length) {
    $('.fancybox').fancybox();
  }
  // TOOLTIPS
  if ($('[data-toggle="tooltip"]').length) {
    $('[data-toggle="tooltip"]').tooltip();
  }
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

  // Loop through Short Code Divs and ajax in the corresponding content
  $(".icnd-shortcode").each(function() {
    var thisID = $(this).data('id');
    $.ajax({
        url : "/content-builder-modules/shortcode.cfm?scodeID=" + thisID,
        type: "POST",
        success: function(data) 
        { 
          $('.icnd-shortcode[data-id='+ thisID +']').html(data);
        }
    });
  });

});