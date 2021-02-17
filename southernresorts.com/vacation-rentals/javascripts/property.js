// MASTER VARIABLE FOR BOOKING DIRECTORY
var bookingFolder = '/vacation-rentals';

// FORM SUBMITTER FUNCTION
function submitForm() {
  // THIS FORM IS FOUND IN _travel-dates.cfm ON PROPERTY DETAIL PAGE
  if ($('#refineForm').find('[value=details-datepicker]').val()) {

    //$('#APIresponse').html('<img class="loading" src="/images/layout/loader.gif"/>');
    $('#APIresponse').html('<div class="cssload-container"><div class="cssload-spinner"></div></div>');

    var strcheckin = $('#refineForm').find('input[name=strcheckin]').val();
    var strcheckout = $('#refineForm').find('input[name=strcheckout]').val();

    // SET OUR HIDDEN INPUT FIELDS
    $('form#propertyContactForm input#hiddenstrcheckin').val(strcheckin);
    $('form#propertyContactForm input#hiddenstrcheckout').val(strcheckout);

    // IF YOU FIND THE DETAILS DATEPICKER VALUE IN THE FORM, SKIP ALL THE STUFF BELOW AND JUST DO THIS ONE AJAX CALL PLEASE
    $.ajax({
      type: "POST",
      url: bookingFolder+'/ajax/get-pdp-rates.cfm',
      data: $('#refineForm').serialize(),
      success: function(data) {
        var response = $.trim(data);
        if(response == 'No'){
          $('#APIresponse').html('<div class="alert alert-danger">Sorry, this property is not available for the selected dates.</div>').show();
        } else if (response == 'API Error') {
          $('#APIresponse').html('<div class="alert alert-danger">Sorry, there was a problem retrieving availability info for this property.</div>').show();
        } else {
  		    $('#selectDates').addClass('hidden');
          $('#APIresponse').html(data).show();
        }
      }
    });
  } // END IF ABOVE
  return false;
};


//   ****     ****    ****  **  **   ***  ***   ******  **   **  ******       *****   ******   ****   ****    **  **
//   **  **  **  **  **     **  **  ** **** **  **      ***  **    **         **  **  **      **  **  **  **  **  **
//   **  **  **  **  **     **  **  **  **  **  *****   ** ** *    **         ** **   *****   ******  **  **   ****
//   **  **  **  **  **     **  **  **  **  **  **      **  ***    **         *** *   **      **  **  **  **    **
//   ****     ****    ****   ****   **      **  ******  **   **    **         **  **  ******  **  **  ****      **
$(document).ready(function(){
////////////////////////////////////////
///////////   LEFT COLUMN   ////////////
////////////////////////////////////////

  // PROPERTY BANNER CONTAINER VARIABLES
  var pdpBanner = $('#propertyImage');
  var pdpMap = $('#propertyMap');
  var pdpTour = $('#propertyTour');

  // PROPERTY IMAGE
  if ($('#propertyImage').length) {
    $('#propertyImage > img').delay(500).fadeIn(800);

    // LOAD GALLERY IF PROPERTY IMAGE IS CLICKED - IF CHANGED, UPDATE THE CLICK EVENT FOR GALLERY BUTTON BELOW
    $('#propertyImage > img').on('click', function() {
      pdpGallery.eq(0).click();// STARTING AT 0 - CORRELATES TO NUMBER OF IMAGE IN GALLERY TO LOAD
    });
  }

  // PROPERTY GALLERY LOAD
  if ($('.hidden-gallery').length) {
    var pdpGallery = $('#hiddenGallery').find('a');

    // LOAD GALLERY IF BUTTON IS CLICKED - IF CHANGED, UPDATE THE CLICK EVENT FOR PROPERTY IMAGE ABOVE
    $('#propertyGalleryBtn').on('click', function() {
      pdpGallery.eq(0).click();// STARTING AT 0 - CORRELATES TO NUMBER OF IMAGE IN GALLERY TO LOAD
    });
  }

  // PROPERTY MAP LOAD
  if ($('#propertyMapBtn').length) {
    $('#propertyMapBtn').on('click', function(){
      // ADD ACTIVE CLASS TO MAP CONTAINER - ACTIVE CLASS ADDS HIGHER Z-INDEX - ADJUST IN STYLESHEET
      pdpMap.toggleClass('active');
      pdpTour.removeClass('active');

      // BUTTON TEXT SWITCH - PROPERTY MAP BUTTON
      var $this = $(this).toggleClass('inactive');
      $(this).toggleClass('active');
      if($(this).hasClass('inactive')){
        $(this).html('<i class="fa fa-map-marker"></i> <span>View Map</span>');
      } else {
        $(this).html('<i class="fa fa-close"></i> <span>Hide Map</span>');

        // PAUSE THE VIDEO IF PROPERTY MAP BUTTON IS CLICKED
        $('#propertyTour iframe')[0].contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
      }

      // IF SIBLING BUTTON IS ACTIVE, RETURN TO NORMAL STATE - PROPERTY TOUR BUTTON
      if($('#propertyTourBtn').hasClass('active')){
        $('#propertyTourBtn').removeClass('active').addClass('inactive').html('<i class="fa fa-video-camera"></i> <span>View Tour</span>');
      }
    });
  }

  // PROPERTY TOUR LOAD
  if ($('#propertyTourBtn').length) {
    $('#propertyTourBtn').on('click', function(){
      // ADD ACTIVE CLASS TO TOUR CONTAINER - ACTIVE CLASS ADDS HIGHER Z-INDEX - ADJUST IN STYLESHEET
      pdpTour.toggleClass('active');
      pdpMap.removeClass('active');

      // BUTTON TEXT SWITCH - PROPERTY TOUR BUTTON
      var $this = $(this).toggleClass('inactive');
      $(this).toggleClass('active');
      if($(this).hasClass('inactive')){
        $(this).html('<i class="fa fa-video-camera"></i> <span>View Tour</span>');

        // PAUSE THE VIDEO IF CLASS IS REMOVED
        $('#propertyTour iframe')[0].contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
      } else {
        $(this).html('<i class="fa fa-close"></i> <span>Hide Tour</span>');

        // PLAY THE VIDEO IF CLASS IS ADDED
        $('#propertyTour iframe')[0].contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
      }

      // IF SIBLING BUTTON IS ACTIVE, RETURN TO NORMAL STATE - PROPERTY MAP BUTTON
      if($('#propertyMapBtn').hasClass('active')){
        $('#propertyMapBtn').removeClass('active').addClass('inactive').html('<i class="fa fa-map-marker"></i> <span>View Map</span>');
      }
    });
  }

  $(window).on('resize',function(){
    if ($(window).outerWidth() <= 1024) {
      $('.pdp-activities').appendTo('.travel-callout-wrap');
    } else {
      $('.pdp-activities').appendTo('#travelDates');
    }
  }).resize();

  // STICKY FUNCTION - FIXED TABS
  function stickyTabs() {
    var window_top = $(window).scrollTop();
    var tab_anchor = $('#propertyTabsAnchor').offset().top;
    if (window_top > tab_anchor) {
      $('#propertyTabs').addClass('fixed');
      $('#propertyTabsAnchor').height($('#propertyTabs').outerHeight());
      $('#returnToTop').fadeIn(250);
    } else {
      $('#propertyTabs').removeClass('fixed');
      $('#propertyTabsAnchor').height(0);
      $('#returnToTop').fadeOut(250);
    }
  }

  $(function() {
    $(window).scroll(stickyTabs);
    stickyTabs();
  });

  // VARIABLES FOR FIXED TABS
  var sections = $('.info-wrap');
  var tabs = $('#propertyTabs');
  var tabs_height = tabs.outerHeight();

  // CLICK TAB - SMOOTH SCROLL INSTEAD OF HARD JUMP
  tabs.find('a').on('click', function() {
    var $tab = $(this);
    var id = $tab.attr('href');

    $('html, body').animate({
      scrollTop: $(id).offset().top - tabs_height + 2
    }, 800);

    return false;
  });


  $( "a.dtb" ).on( "click", function() {
    var $tab = $(this);
    var id = $tab.attr('href');

    $('html, body').animate({
      scrollTop: $(id).offset().top - tabs_height + 2
    }, 800);

    return false;
  });

  // FIND EACH SECTION on SCROLL or CLICK for JUMP LINKS
  $(window).on('scroll', function() {
    var cur_pos = $(this).scrollTop();

    sections.each(function() {
      var tab_top = $(this).offset().top - tabs_height;
      var tab_bottom = tab_top + $(this).outerHeight();
      // ADD/REMOVE ACTIVE CLASS ON TABS
      if (cur_pos >= tab_top && cur_pos <= tab_bottom) {
        tabs.find('a').removeClass('active');
        sections.removeClass('active');
        $(this).addClass('active');
        tabs.find('a[href="#'+$(this).attr('id')+'"]').addClass('active');

      // ADD/REMOVE ACTIVE CLASS ON LAST TAB ITEM - WHEN LAST TAB HAS REACHED BOTTOM
      } else if ($(window).scrollTop() + $(window).height() == $(document).height()) {
        tabs.find('a').removeClass('active');
        sections.removeClass('active');
        $(this).addClass('active');
        tabs.find('a[href="#'+$(this).attr('id')+'"]').addClass('active');
      }
    });
  });

  // CALENDAR TRIGGER FOR ARRIVAL DATEPICKER
	if( $(window).width() < 1024) {
  	$('.calendar-table').on('click', function() {
      $('body').addClass('no-scroll travel-dates-active')
      $('#travelDates').fadeToggle().addClass('active');
    });
  } else {
    if ($('.calendar-table').length) {
    	$('.calendar-table').on('click', function() {
    		$('#startDateDetail').datepicker('show');
    	});
    }
  }


////////////  FORM VALIDATION   ////////////
  if ($('#sendToFriendForm').length) {

  		$('form#sendToFriendForm').validate({
			submitHandler: function(form){
				$.ajax({
					type: "POST",
					url: bookingFolder + "/_submit.cfm",
					data: $('form#sendToFriendForm').serialize(),
					dataType: "text",
					success: function (response) {
						response = $.trim(response);
						//console.log(response);
						if(response === "success") {
							$('form#sendToFriendForm').hide();
							$('#sendToFriendFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
						}
						else {
							$("form#sendToFriendForm div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
						}
					}
				});
				return false;
			}
		});

	}

	// VALIDATES AND SUBMITS THE 'Review' FORM ON THE PROPERTY DETAIL PAGE
  if ($('#propertyReviewForm').length) {

    $('form#propertyReviewForm').validate({
			submitHandler: function(form){
				$.ajax({
					type: "POST",
					url: bookingFolder + "/_submit.cfm",
					data: $('form#propertyReviewForm').serialize(),
					dataType: "text",
					success: function (response) {
						response = $.trim(response);
						//console.log(response);
						if(response === "success") {
							$('form#propertyReviewForm').hide();
							$('#propertyReviewFormMSG').html("<font color='green'>Thanks! Your review has been submitted for approval.</font>");
						}
						else {
							$("form#propertyReviewForm div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
						}
					}
				});
				return false;
			}
		});

  	$('#reviewCheckInDate').datepicker({
      beforeShow:function(instance){
        $('#reviewDatepickerCheckin').append($('#ui-datepicker-div'));
      },
  		onSelect: function() {
  			var newDate = $(this).datepicker('getDate');
				newDate.setDate(newDate.getDate()+1);
				$('#reviewCheckOutDate').datepicker('option','minDate',newDate);
				setTimeout(function(){
					$('#reviewCheckOutDate').datepicker('show');
				}, 16);
  		}
  	});
  	$('#reviewCheckOutDate').datepicker({
      beforeShow:function(instance){
        $('#reviewDatepickerCheckout').append($('#ui-datepicker-div'));
      }
  	});
  }

	// VALIDATES AND SUBMITS THE 'Ask A Question' FORM ON THE PROPERTY DETAIL PAGE
  if ($('#propertyQandAForm').length) {

  		$('form#propertyQandAForm').validate({
			submitHandler: function(form){
				$.ajax({
					type: "POST",
					url: bookingFolder + "/_submit.cfm",
					data: $('form#propertyQandAForm').serialize(),
					dataType: "text",
					success: function (response) {
						response = $.trim(response);
						//console.log(response);
						if(response === "success") {
							$('form#propertyQandAForm').hide();
							$('#propertyQandAFormMSG').html("<font color='green'>Thanks! Your question has been sent for review! Close this window to continue browsing the website.</font>");
						}
						else {
							$("form#propertyQandAForm div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
						}
					}
				});
				return false;
			}
		});
  }

 // VALIDATES AND SUBMITS THE 'Contact' FORM ON THE PROPERTY DETAIL PAGE
  if ($('#propertyContactForm').length) {

	  	$('form#propertyContactForm').validate({
			submitHandler: function(form){
				$.ajax({
					type: "POST",
					url: bookingFolder + "/_submit.cfm",
					data: $('form#propertyContactForm').serialize(),
					dataType: "text",
					success: function (response) {
						response = $.trim(response);
						//console.log(response);
						if(response === "success") {
							$('form#propertyContactForm').hide();
							$('#propertyContactFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
						}
						else {
							$("form#propertyContactForm div.g-recaptcha-error").html("<font color='red'>You must complete the reCAPTCHA</font>");
						}
					}
				});
				return false;
			}
		});

  }

/////////////////////////////////////////
////////////  RIGHT COLUMN   ////////////
/////////////////////////////////////////

  // STICKY FUNCTION - FIXED TRAVEL DATES
/*
  var window_top = $(window).scrollTop();
  var sticky_anchor = $('#travelDatesAnchor').offset().top-154;
  var sticky = $('#travelDates');
  var footer_anchor = $('#footerAnchor').offset().top+50;
  var travel_dates_bottom = $('#travelDatesBottom').offset().top;
  console.log('nowthis');
  if (travel_dates_bottom > footer_anchor) {
    $('.property-dates-wrap').addClass('at-footer');
  } else {
    $('.property-dates-wrap').removeClass('at-footer');
  }
  if (window_top > sticky_anchor) {
    $('#travelDates').addClass('fixed');
    $('#travelDatesAnchor').height($('#travelDates').outerHeight());
  } else {
    $('#travelDates').removeClass('fixed');
    $('#travelDatesAnchor').height(0);
  }
*/


  function sticky_dates() {
    var window_top = $(window).scrollTop()+50;
    // var sticky_anchor = $('#travelDatesAnchor').offset().top-154;
    var sticky_anchor = $('#travelDatesAnchor').offset().top;
    var sticky = $('#travelDates');
    var footer_anchor = $('#footerAnchor').offset().top-150;
    var footer_height = $('.i-footer').height();
    var travel_dates_bottom = $('#travelDatesBottom').offset().top;
    var doc_height = $(document).height();
    var footer_space = doc_height-footer_height-690;
    var property_dates_width = $( '.property-dates-wrap' ).width()+'px';
/*
    console.log('doc_height: '+doc_height);
    console.log('window_top: '+window_top);
    console.log('sticky_anchor: '+sticky_anchor);
    console.log('footer_anchor: '+footer_anchor);
    console.log('travel_dates_bottom: '+travel_dates_bottom);
    console.log('footer_space: '+footer_space);
    console.log('property_dates_width: '+property_dates_width);
*/

    //console.log('footer_space: '+footer_space);
    if ((window_top > sticky_anchor) && (travel_dates_bottom > footer_anchor)) {
// 	      $('#travelDates').addClass('fixed');
        if (window_top > footer_space) {
		      $('#travelDates').removeClass('fixed');
		      //$('#travelDatesAnchor').height($('#travelDates').outerHeight());
		      $('.property-dates-wrap').addClass('at-footer');
		      //console.log('YO!');
		    }
		    //console.log('do nothing');
	    } else if (window_top > sticky_anchor && window_top < footer_space) {
// 	      $('#travelDates').removeClass('fixed');
	      $('#travelDates').addClass('fixed');
	      $('.property-dates-wrap').removeClass('at-footer');
	      //$('#travelDatesAnchor').height(0);
	      $('#travelDates').css('width', property_dates_width);
	      //console.log('TWOCONDITIONS');
	    } else if (window_top > sticky_anchor) {
	      //console.log('ELSEIF!');
	    } else {
		    //console.log('ELSE!');
		    $('.property-dates-wrap').removeClass('at-footer');
		    $('#travelDates').removeClass('fixed');
	    }

    //if (travel_dates_bottom > footer_anchor) {
      //$('.property-dates-wrap').addClass('at-footer');



      //$('#travelDates').removeClass('fixed');
      //$('#travelDatesAnchor').height($('#travelDates').outerHeight());



    //} else {
	         // $('.property-dates-wrap').removeClass('at-footer');



      //$('#travelDatesAnchor').height(0);




     //}
  }

/*
    var footer_anchor = $('#footerAnchor').offset().top+50;
    var travel_dates_bottom = $('#travelDatesBottom').offset().top;
    console.log('footer_anchor: '+footer_anchor);
    console.log('travelDatesBottom: '+travel_dates_bottom);

    if (travel_dates_bottom > footer_anchor) {
      $('.property-dates-wrap').addClass('at-footer');    } else {
      $('.property-dates-wrap').removeClass('at-footer');
    }
*/

  $(function() {
    $(window).scroll(sticky_dates);
    sticky_dates();
  });

  // TRAVEL DATES SECTION
  ///////////////////////
  // ARRIVAL/DEPARTURE DATEPICKER CODE IN components/footer-javscripts.js

  // BUTTON TRIGGER FOR ARRIVAL DATEPICKER
  if ($('#selectDates').length) {
  	$('#selectDates').on('click', function(e) {
		  e.preventDefault();
  		//$('#startDateDetail').datepicker('show');
  		$('#startDateDetail').click();
  		return false
  	});
  }

  // BUTTON TRIGGER FOR SMOOTH SCROLL TO INQURE FORM
  $('#requestInfoBtn').on('click', function(){
    // SCROLL TO SECTION, SUBTRACT HEIGHT FOR HEADING FOR ALIGNMENT
    $('html, body').animate({scrollTop: $('#inquire').offset().top - 45},1600);
    return false;
  });

  // MOBILE TOGGLE - LOAD TRAVEL DATES POP-UP WINDOW
  if ($('#travelDates').length) {
    $('#mobileDatesToggle').on('click', function() {
      $('body').addClass('no-scroll travel-dates-active');
      $('#travelDates').fadeToggle().addClass('active');
    });
    $('#mobileClose').on('click', function() {
      $('body').removeClass('no-scroll travel-dates-active');
      $('#travelDates').fadeToggle().removeClass('active');
    });
  }

  // MOBILE TOGGLE - CLICK BUTTON, HIDE MOBILE TRAVEL DATES POP-UP WINDOW
	if( $(window).width() < 1024) {
    $('#splitCostCalc, #requestInfoBtn').on('click', function() {
      $('body').removeClass('no-scroll travel-dates-active');
      $('#travelDates').fadeToggle().removeClass('active');
    });
  }

  // CLICK EVENT TO SCROLL UP - FADE FUNCTION WITH STICKY TABS FUNCTION
  $('#returnToTop').on('click', function(){
    $('html, body').animate({scrollTop : 0},800);
    return false;
  });

  //console.log('jtest-travel');

	var pdpdatepicker = $(".refine-dates");
	var pos = pdpdatepicker.position();
	var divHeight = $( ".i-footer" ).height();
	$(window).scroll(function() {
		var windowpos = $(window).scrollTop();
		var windowHeight = $(window).height(),
    docScroll = $(document).scrollTop(),
    divPosition = $( ".i-footer" ).offset().top,
    divHeight = $( ".i-footer" ).height(),
    hiddenBefore = docScroll - divPosition,
    hiddenAfter = (divPosition + divHeight) - (docScroll + windowHeight);
    /*
    console.log('hiddenAfter: '+hiddenAfter);
    console.log('hiddenBefore: '+hiddenBefore);
    */

		if (windowpos >= pos.top & windowpos <=1000) {
			pdpdatepicker.addClass("stick");
		} else {
			pdpdatepicker.removeClass("stick");
		}
		/*
		console.log('pos: '+pos);
		console.log('windowpos: '+windowpos);
		console.log('pos.top: '+pos.top);
		console.log('divHeight: '+divHeight);
		*/

    if ((docScroll > divPosition + divHeight) || (divPosition > docScroll + windowHeight)) {
      return 0;
      //console.log('hold1');
    } else {
      var result = 100;
      //console.log('hold2');
      $(".map-wrap" ).addClass( "map-wrap-footer");
        //$(".map-wrap-footer").css("height", heightFixedFooterMap);
        // resulttest -= (hiddenAfter * 100) / divHeight;
        //  var resultfooter = (result *divHeight)/100;
        //     var resultpx = resultfooter+'px';
        //     console.log('resultpx: '+resultpx);
        // if (hiddenBefore > 0) {
        //     result -= (hiddenBefore * 100) / divHeight;
        //     console.log('result1: '+result);
        // what does this do???}

        if (hiddenAfter < 0) {
          var posHiddenAfter = -hiddenAfter;
          //console.log('posHiddenAfter: '+posHiddenAfter);
          var divHeightNext = divHeight;
          //console.log('divHeightNext: '+divHeightNext);

          result -= (posHiddenAfter * 100) / divHeight;

          //console.log('resultttttt: '+result);

          // console.log('resultfooterNext: '+resultfooterNext);
            // console.log('resultfooterNext: '+resultfooterNext);

          var resultfooterNextAlmost = (result *divHeight)/100;
          //console.log('resultfooterNextAlmost: '+resultfooterNextAlmost);
          var resultfooterNext = resultfooterNextAlmost+posHiddenAfter+posHiddenAfter;
          //console.log('resultfooterNext: '+resultfooterNext);
          var resultpxNext = resultfooterNext+'px';
          //console.log('resultpxNext: '+resultpxNext);


          var heightFixedFooterMapRes3 = "calc(83vh - "+resultpxNext+")";
          //console.log('heightFixedFooterMapRes3:'+ heightFixedFooterMapRes3);

          $(".map-wrap-footer").css("height", heightFixedFooterMapRes3);

          //  var resultfooter = (result *divHeight)/100;
          // var resultpx = resultfooter+'px';
          // console.log('resultpx: '+resultpx);
          // console.log()
          //console.log('result3: '+result);
        }
        //console.log('hold3');
        //return result;
      }
      //console.log('finished');
	    //console.log('hiddenBefore: '+hiddenBefore);
	});
	$('.property-cost-list-total').click(function(){
	  $(this).find('span#costRowShowHide').toggleClass('glyphicon-plus').toggleClass('glyphicon-minus');
	});
});

$( document ).ajaxComplete(function() {
	$('[data-toggle="tooltip"]').tooltip();

	$('.property-cost-list-total').click(function(){
    $(this).find('span#costRowShowHide').toggleClass('glyphicon-plus').toggleClass('glyphicon-minus');
  });

});

