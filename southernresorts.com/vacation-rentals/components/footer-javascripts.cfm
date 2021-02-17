<!--- ALL PAGES --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js" defer type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js" defer type="text/javascript"></script>
<script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script> <!--- needed for Google reCaptcha --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js" defer type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" defer type="text/javascript"></script>
<!--- GROWL --->
<cfoutput>
<link href="/#settings.booking.dir#/javascripts/vendors/growl/jquery.growl.min.css" rel="stylesheet" type="text/css">
<script src="/#settings.booking.dir#/javascripts/vendors/growl/jquery.growl.min.js" defer type="text/javascript"></script>
</cfoutput>
<!--- OWL CAROUSEL --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js" defer type="text/javascript"></script>

<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm'>
<cfelse>
	<!--- FANCYBOX --->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.js" defer type="text/javascript"></script>
</cfif>

<!--- <cfoutput>#cgi.script_name#</cfoutput> --->

<script>
	if ($('.amenityTopWrapper').length) {
		 var amenityTopHeight = $( ".amenityTopWrapper" ).height()+28;
		 //console.log('amenityTopHeight: '+amenityTopHeight);
		 $(".amenities-wrap").css("height", amenityTopHeight);
	}

  (function(){
    var c = function() {
      var track = new Track('svr', 'trackphone');
      track.track();
    };

    var t = document.createElement('script');t.type = 'text/javascript'; t.src = '//cdn.trackhs.com/tracking/tracking.js';
    t.onload = t.onreadystatechange = function() { var state = s.readyState; if(!c.done && (!state || /loaded|complete/.test(state))){c.done = true; c()} };
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t,s);
  }());
</script>
<!---
<script type="text/javascript">window.$trChatSettings = {title: "Southern Vacation Rentals Chat", color: "#0B3736", welcome: "Would you like to chat with us today?", away: "We are sorry, there are no available agents to chat at this time.  We will use your contact information to get back to you as soon as possible.", goodbye: "Thank you for chatting with us.  We look forward to helping you again in the future.", hiddenOnStart: false, brand: 1, domain: "svr"};
    window.$trChat || (function(){
        var t = document.createElement('script'); t.type = 'text/javascript'; t.async = true; t.src = '//chat.trackhs.com/chat/track-webchat-boot.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t, s);
  }());
</script>
--->

<!--- RESULTS PAGE ONLY --->
<cfif cgi.script_name eq '/destination-page.cfm' OR cgi.script_name eq '/#settings.booking.dir#/results2.cfm' OR cgi.script_name eq '/layouts/special.cfm' OR cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/vacation-rentals/special-layout.cfm')>

	<!--- sets the min/max rates for the refine search price range slider --->
	<cfif
		isdefined('session.booking.strcheckin') and
		len(session.booking.strcheckin) and
		isvalid('date',session.booking.strcheckin) and
		isdefined('session.booking.strcheckout') and
		len(session.booking.strcheckout) and
		isvalid('date',session.booking.strcheckout)>
		<cfset minmaxprice = application.bookingObject.getMinMaxPrice(session.booking.strcheckin,session.booking.strcheckout)>
	<cfelse>
		<cfset minmaxprice = application.bookingObject.getMinMaxPrice()>
	</cfif>

	<cfset session.booking.priceRangeMin = minmaxprice.minPrice>
	<cfset session.booking.priceRangeMax = minmaxprice.maxPrice>

  <cfif cgi.script_name is '/layouts/resort.cfm'>
    <cfoutput><script src="/#settings.booking.dir#/javascripts/resort-results.js?v=1.0.18" defer></script></cfoutput>
  <cfelse>
		<cfif ICNDEyesOnly>
			<cfoutput><script src="/#settings.booking.dir#/javascripts/results-sara.js?v=1.2.5" defer></script></cfoutput>
		<cfelse>
	   		<cfoutput><script src="/#settings.booking.dir#/javascripts/results.js?v=1.2.5" defer></script></cfoutput>
		</cfif>
  </cfif>

  <link href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.css" rel="stylesheet" type="text/css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.js" defer type="text/javascript"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/wnumb/1.1.0/wNumb.min.js" defer type="text/javascript"></script>
  <script type="text/javascript">
    $(document).ready(function(){

			if ($(window).width() < 1024) {
				var headerHeight = $('.i-header').outerHeight();
				var refineHeight = $('.refine-mobile-controls').outerHeight();
				var headerRefineHeight = headerHeight + refineHeight + 15; console.log(headerRefineHeight);
				$(window).load(function() { 
					$('html, body').animate({scrollTop : $('#list-all-results').position().top - 50},800);
				})
			}

			$("#clearfilters").click(function( event ){
				event.preventDefault();
				$("#startDateRefine").val("");
				$("#arrivalDayDetail").html("DD");
				$("#arrivalMonthDetail").html("MM");
				$("#endDateRefine").val("");
				$("#departureDayDetail").html("DD");
				$("#departureMonthDetail").html("MM");
				//$("#guest").val("");
				//$("#beds").val("");

				$("#guest").val('default');
				$("#guest").selectpicker("refresh");
				$("#beds").val('default');
				$("#beds").selectpicker("refresh");
				$("#petFriendly").prop("checked",false);
				$("#fullView").prop("checked",false);
				$("#beachService").prop("checked",false);

				$("#refineForm").submit();

			});
      if ($('.refine-slider-bedrooms-wrap').length) {
        /////////////////////////////////////
        // BEDROOMS SLIDER - REFINE SEARCH //
        /////////////////////////////////////
        // REPLACE 'Bedrooms' TEXT WITH SLIDER VALUES ON CLICK
        $('.refine-bedrooms .refine-text').click(function(){
          $('.refine-bedrooms .refine-text-title').addClass('hidden');
          $('.refine-bedrooms .refine-min-max').removeClass('hidden');
        });

      	// REFINE BEDROOM SLIDER
      	var refineBedroomsSlider = document.getElementById('refineBedroomsSlider');
        noUiSlider.create(refineBedroomsSlider,{
        	start: [ <cfoutput>#settings.booking.minBed#, #settings.booking.maxBed#</cfoutput> ],
        	step: 1,
        	tooltips: [ wNumb({ decimals: 0 }), wNumb({ decimals: 0 }) ],
          connect: [false, true, false],
        	range: {
        		'min': [ <cfoutput>#settings.booking.minBed#</cfoutput> ],
        		'max': [ <cfoutput>#settings.booking.maxBed#</cfoutput> ]
        	},
        	format: wNumb({ decimals: 0 })
        });

        // SHOW REFINE BEDROOM - MIN/MAX VALUES
        var refineBedroomsMin = document.getElementById('refineBedroomsMin');
        var refineBedroomsMax = document.getElementById('refineBedroomsMax');
        refineBedroomsSlider.noUiSlider.on('update', function(values,handle){
          if (handle) {
            refineBedroomsMax.innerHTML = Math.floor(values[handle]);
          } else {
            refineBedroomsMin.innerHTML = Math.floor(values[handle]);
          }
        });

        // IF THE SESSION HAS BEDROOM INFO, ON RELOAD, LOAD IT
        <cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms)>
  	      refineBedroomsSlider.noUiSlider.set(<cfoutput>#session.booking.bedrooms#</cfoutput>);
  	      $('.refine-bedrooms .refine-text-title').addClass('hidden');
  	      $('.refine-bedrooms .refine-min-max').removeClass('hidden');
        </cfif>

        // REFINE BEDROOM SLIDER APPLY
        $('#refineBedroomsApply').click(function(){
        	var bedroomValues = refineBedroomsSlider.noUiSlider.get();
        	$('[name=bedrooms]').val(bedroomValues);
        	submitForm();
        });

        // CLOSE - RESETS AND HIDES THE NUMBER
        $('#refineBedroomsClose').click(function(){
          $('.refine-bedrooms .refine-text-title').removeClass('hidden');
          $('.refine-bedrooms .refine-min-max').addClass('hidden');
          refineBedroomsSlider.noUiSlider.reset();
          $('[name=bedrooms]').val('');
    			submitForm();
        });
      }

      if ($('.refine-slider-price-wrap-removed').length) {
        /////////////////////////////////////////
        // PRICE RANGE SLIDER - REFINE SEARCH  //
        /////////////////////////////////////////
        // REPLACE 'Price Range' TEXT WITH SLIDER VALUES ON CLICK
        $('.refine-price .refine-text').click(function(){
          $('.refine-price .refine-text-title').addClass('hidden');
          $('.refine-price .refine-min-max').removeClass('hidden');
        });

        var refinePriceSlider = document.getElementById('refinePriceSlider');
        noUiSlider.create(refinePriceSlider,{
        	start: [ <cfoutput>#session.booking.priceRangeMin/7#, #session.booking.priceRangeMax/7#</cfoutput> ],
        	tooltips: [ wNumb({ decimals: 0 }), wNumb({ decimals: 0 }) ],
          connect: [false, true, false],
        	range: {
        		'min': [ <cfoutput>#session.booking.priceRangeMin/7#</cfoutput> ],
        		'max': [ <cfoutput>#session.booking.priceRangeMax/7#</cfoutput> ]
        	},
        	format: wNumb({ decimals: 0 })
        });

        // SHOW REFINE PRICE - MIN/MAX VALUES
        var refinePriceMin = document.getElementById('refinePriceMin');
        var refinePriceMax = document.getElementById('refinePriceMax');
        refinePriceSlider.noUiSlider.on('update', function(values,handle){
          if (handle) {
            refinePriceMax.innerHTML = Math.floor(values[handle]);
          } else {
            refinePriceMin.innerHTML = Math.floor(values[handle]);
          }
        });

        // REFINE PRICE SLIDER APPLY
        $('#refinePriceApply').click(function(){
        	var priceSliderValues = refinePriceSlider.noUiSlider.get();
        	$('[name=rentalRate]').val(priceSliderValues);
        	submitForm();
        });

        // CLOSE - RESET VALUES TI MIN AND PUT 'Price Range' TEXT BACK
        $('#refinePriceClose').click(function(){
          $('.refine-price .refine-text-title').removeClass('hidden');
          $('.refine-price .refine-min-max').addClass('hidden');
          refinePriceSlider.noUiSlider.reset();
          $('[name=rentalRate]').val('');
    			submitForm();
        });
      }
      // ALL RANGER SLIDER THEME COLOR
      $('.noUi-connect').addClass('site-color-2-bg');


			if ($(window).width() >= 767) {
				var body = document.body,
	      timer;

				window.addEventListener('scroll', function() {
				  clearTimeout(timer);
				  if(!body.classList.contains('disable-mobile-hover')) {
				    body.classList.add('disable-mobile-hover')
				  }

				  timer = setTimeout(function(){
				    body.classList.remove('disable-mobile-hover')
				  },500);
				}, false);
  			$(".results-list-property-link").one("click", function(e) {
  		      e.preventDefault();
  		      console.log("Click again to open");
  		  });
  		}

		  $('.owl-carousel.owl-quick-gallery .owl-nav button').hover(
			  // console.log('y'),
			  function(){ $(this).addClass('active-owl') },
       function(){ $(this).removeClass('active-owl') },
       function(){ $('.results-list-property-img-wrap').addClass('inactive') },
       function(){ $('.results-list-property-img-wrap').removeClass('inactive') }
      )

    });
  </script>
</cfif>

<!--- PROPERTY DETAIL PAGE ONLY --->
<cfif cgi.script_name eq '/#settings.booking.dir#/property.cfm'>
	<script src="/javascripts/owl-gallery.js"></script>
  <cfoutput><script src="/#settings.booking.dir#/javascripts/property.js?v=2.1.4" defer></script></cfoutput>
  <script type="text/javascript">
    $(document).ready(function(){

  function submitTheForm(){ 
    var formdata = $.param( $("#propertyContactForm input") ); 
      $.ajax({ 
      url: "/receiver-details-page.cfm", 
      data: formdata, 
      success: function( data ) { 

      } 
    }); 
  } 

  $("form#propertyContactForm input").focusin(submitTheForm); 
  $("form#propertyContactForm input").focusout(submitTheForm);
  
    	//DETAIL PAGE CALENDAR TAB/PDP DATEPICKER VARIABLES & FUNCTION
    	//This script can be found in /vacation-rentals/components/footer-javascripts.cfm
    	var myBadDates = [];
    	var myBadCheckinDates = [];
    	var myBadCheckoutDates = [];
    	var counter = 0;

		  //24th is not available
      //nonAvailListForDatepicker IS DEFINED IN _calendar-tab.cfm
      //cfset nonAvailListForDatepicker = ReplaceNoCase(nonAvailListForDatepicker,",","','",ALL)>

    	<cfloop list="#nonAvailListForDatepicker#" index="i">
    		<cfoutput>
    		<cfif CGI.REMOTE_ADDR eq "69.143.223.135" or CGI.REMOTE_ADDR eq "173.93.73.19">
    			<cfset PreviousDate = DateFormat(DateAdd('d',-1,i),'mm-dd-yyyy')>
          <cfset NextDate = DateFormat(DateAdd('d',1,i),'mm-dd-yyyy')>
        <cfelse>
					<cfset PreviousDate = DateFormat(DateAdd('d',-1,i),'mm/dd/yyyy')>
          <cfset NextDate = DateFormat(DateAdd('d',1,i),'mm/dd/yyyy')>
        </cfif>
					<cfif ListFind(nonAvailListForDatepicker,PreviousDate) AND NOT ListFind(nonAvailListForDatepicker,NextDate) AND DateCompare(i,Now()) GT 0> <!--- Checkout day --->
						myBadCheckoutDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';
          <cfelseif ListFind(nonAvailListForDatepicker,NextDate) AND NOT ListFind(nonAvailListForDatepicker,PreviousDate) AND DateCompare(i,Now()) GT 0> <!--- Checkin day --->
						myBadCheckinDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';
          </cfif>
					myBadDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';
    		</cfoutput>
    		counter = counter + 1;
    	</cfloop>

    	function checkAvailabilityStart(mydate){
    		var $return=true;
    		var $returnclass ="available";
    		$checkdate = $.datepicker.formatDate('yy-mm-dd', mydate);

    		for(var i = 0; i < myBadDates.length; i++)
    		{
    			if(myBadDates[i] == $checkdate){
    				$return = false;
    				$returnclass= "unavailable";
    			}
    		}
    		for(var i = 0; i < myBadCheckoutDates.length; i++)
    		{
    			if(myBadCheckoutDates[i] == $checkdate){
    				$return = true;
    				$returnclass= "availableCheckout";
    			}
    		}
    		for(var i = 0; i < myBadCheckinDates.length; i++)
    		{
    			if(myBadCheckinDates[i] == $checkdate){
    				$return = false;
    				$returnclass= "unavailableCheckin";
    			}
    		}
    		return [$return,$returnclass];
    	}

    	function checkAvailabilityEnd(mydate){
    		var $return=true;
    		var $returnclass ="available";
    		$checkdate = $.datepicker.formatDate('yy-mm-dd', mydate);

    		for(var i = 0; i < myBadDates.length; i++)
    		{
    			if(myBadDates[i] == $checkdate){
    				$return = false;
    				$returnclass= "unavailable";
    			}
    		}
    		for(var i = 0; i < myBadCheckoutDates.length; i++)
    		{
    			if(myBadCheckoutDates[i] == $checkdate){
    				$return = false;
    				$returnclass= "unavailableCheckout";
    			}
    		}
    		for(var i = 0; i < myBadCheckinDates.length; i++)
    		{
    			if(myBadCheckinDates[i] == $checkdate){
    				$return = true;
    				$returnclass= "availableCheckin";
    			}
    		}
    		return [$return,$returnclass];
    	}
    	//console.log('checkAvailabilityEnd:'+checkAvailabilityEnd);
    	//console.log('mydate:'+mydate); /*not defined*/

      // OUTSIDE CLICK TO CLOSE THE DROPDOWNS
		  $(document).on('click', function(e) {
		    if ($(e.target).is('.refine-text, .refine-text *, .refine-dropdown, .refine-dropdown *, .refine-filter-box, .refine-filter-box *, .ui-datepicker-next, .ui-datepicker-next *, .ui-datepicker-prev, .ui-datepicker-prev *, .amen-arrow, #refineForm .datepicker-wrap, .refine-dates, input#startDateDetail, input#endDateDetail')) {
		      e.stopPropagation();
		      //console.log('uhmm');
		    } else {
		      $('.refine-dropdown').addClass('hidden');
		      //console.log('uhmm2');
		      //$('.refine-text').removeClass('active');
		      //$('.refine-text').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
		    }
		  });

		  // REFINE APPLY/CANCEL - HIDES CURRENT BOX
		  $('.refine-apply, .refine-close').on('click', function(){
		    // GENERAL DROPDOWNS
		    if ($(this).parent().hasClass('refine-dropdown')) {
		      $(this).parent().addClass('hidden');
		    }
		    // FILTERS
/*		    if ($(this).parent().hasClass('refine-filter-action')) {
		      $(this).parent().parent().addClass('hidden');
		    }
		    if ($(this).parent().parent().hasClass('refine-filter-box')) {
		      $(this).parent().parent().prev().find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
		    } else {
		      $(this).parent().prev().find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
		    }*/
		  });



      // DROP DOWN IN REFINE WRAP
		  $('#refineForm .datepicker-wrap').on('click', function(){
		    // TOGGLE DROP DOWNS
		    if ($(this).next().hasClass('hidden')) {
		      //hideMoreFilters();
		      //$('.refine-dropdown').addClass('hidden');
		      //$(this).addClass('active');
		      //$('.refine-text').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up'); // FIND ADJACENT CHEVRONS, FLIP TOGGLE WHEN OTHER REFINE ITEM IS SELECTED
		      //$(this).find('.fa-chevron-down').removeClass('fa-chevron-down').addClass('fa-chevron-up');
		      //$(this).next().removeClass('hidden');
		      $('.property-dates .refine-dropdown.datepicker-wrap').removeClass('hidden');
		      //console.log('cmon');
		    } else {
		      //$(this).removeClass('active');
		      //$(this).find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
		      $(this).next().addClass('hidden');
		      //console.log('cmon2');
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
			  var dateToday = new Date();
			  //console.log('dateToday');
			  var startDate = $('#startDateDetail').val();
			  //var array = ["2019-12-10","2019-12-11"]
			  //var unavailableDates = ['12-15-2019', '12-16-2019'];
			  var nonAvailListForDatepicker = [<cfoutput>#listQualify(nonAvailListForDatepicker,"'")#</cfoutput>];
			  //console.log('nonAvailListForDatepicker: '+nonAvailListForDatepicker);

			  $.datepicker.setDefaults({
			    dateFormat: 'mm/dd/yy',
			    minDate: dateToday
			  });

	      function restricedDates(date) {
			    //dmy = (date.getMonth() + 1) + "-" + date.getDate() + "-" + date.getFullYear();
			    //console.log('date-getMonth: '+date.getMonth()); //this is good, just too much output for now
			    //console.log('date-getDate: '+date.getDate()); //this is good, just too much output for now
			    //console.log('date-getFullYear: '+date.getFullYear()); //this is good, just too much output for now



		      var dmy = date.getMonth() + 1;
          if (date.getMonth() < 9)
            dmy = "0" + dmy;
            dmy += "-";
          if (date.getDate() < 10) dmy += "0";
          dmy += date.getDate() + "-" + date.getFullYear();


        /*
          console.log('dmy: '+otherdatesAlt + ' : ' + ($.inArray(otherdatesAlt, unavailableDates)));
          //date is not defined

          if ($.inArray(otherdatesAlt, unavailableDates) == -1) {
              return [true, "", "Available"];
          } else {
              return [false, "", "unAvailable"];
          }
			    */


			    if ($.inArray(dmy, nonAvailListForDatepicker) == 0) {
			      return [false, "", "Unavailable"];
			      //console.log('dmy-unavail: '+dmy);
			    } else {
				    //console.log('dmy: '+dmy); //this is good, just too much output for now
				    //console.log('dmy-and-unavail: '+dmy + ' : ' + ($.inArray(dmy, nonAvailListForDatepicker))); //this is good, just too much output for now
			      return highlight(date);
			    }
				}

		    function highlight (date) {
			    //checkAvailabilityStart
			    var dmy = date.getMonth() + 1;
          if (date.getMonth() < 9)
            dmy = "0" + dmy;
            dmy += "-";
          if (date.getDate() < 10) dmy += "0";
          dmy += date.getDate() + "-" + date.getFullYear();
		      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#startDateDetail').val());
		      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#endDateDetail').val());
		      var isHighlight = date1 && ((date.getTime() == date1.getTime()) || (date2 && date >= date1 && date <= date2));

		      if ($.inArray(dmy, nonAvailListForDatepicker) == -1) {
	          //return [true, "", "Available"];
	          return [true, isHighlight ? 'dp-highlight' : ''];
	        } else {
	          return [false, "", "unAvailable"];
	        }
		    }

	      /*
		    var MyDate = new Date();
				var MyDateString;

				MyDate.setDate(MyDate.getDate() + 20);

				MyDateString = ('0' + MyDate.getDate()).slice(-2) + '/'
        + ('0' + (MyDate.getMonth()+1)).slice(-2) + '/'
        + MyDate.getFullYear();
		    */

		    /* ********************************** */
		    /* ********************************** */

	      /*var string = jQuery.datepicker.formatDate('mm/dd/yy', date);
	      return [true, isHighlight ? 'dp-highlight' : ''
	      && array.indexOf(string) == -1 ];*/

		    /*
	      function dateRange(date) {
		        /*var dmy = inst.selectedMonth+1;
            if (date.getMonth() < 9)
                dmy = "0" + dmy;
            dmy += "-";

            if (date.getDate() < 10) dmy += "0";
            dmy += date.getDate() + "-" + date.getFullYear();*/
          /*
            console.log('dmy: '+otherdatesAlt + ' : ' + ($.inArray(otherdatesAlt, unavailableDates)));
            //date is not defined

            if ($.inArray(otherdatesAlt, unavailableDates) == -1) {
                return [true, "", "Available"];
            } else {
                return [false, "", "unAvailable"];
            }
            */
	          /*var dmy = (date.getMonth() + 1);
	            if (date.getMonth() < 9)
	                dmy = "0" + dmy;
	            dmy += "-";

	            if (date.getDate() < 10) dmy += "0";
	            dmy += date.getDate() + "-" + date.getFullYear();

	            console.log(dmy + ' : ' + ($.inArray(dmy, unavailableDates)));

	            if ($.inArray(dmy, unavailableDates) == -1) {
	                return [true, "", "Available"];
	            } else {
	                return [false, "", "unAvailable"];
	            }*/

				  /* }*/

			    /*  }*/

			  $('#refineDatepicker').datepicker({
			    defaultDate: startDate,
			    numberOfMonths: calCount,
			    minDate: '+1d',
			    beforeShowDay: restricedDates
			    //restricedDates
			    //checkAvailabilityStart
			    //checkAvailabilityEnd
		    ,
		    onSelect: function(dateText, inst) {
		      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#startDateDetail').val());
		      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $('#endDateDetail').val());
		      var selectedDate = $.datepicker.parseDate($.datepicker._defaults.dateFormat, dateText);

		      var otherdates = new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
		      //console.log('otherdates: '+otherdates);
		      var otherdatesMonth = $.datepicker.formatDate("M", otherdates);
		      //console.log('otherdatesMonth: '+otherdatesMonth);

		      var otherdays = new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
		      //console.log('otherdays: '+otherdays);
		      var otherdaysDay = $.datepicker.formatDate("DD", otherdays);
		      //console.log('otherdaysDay: '+otherdaysDay);

		      //if($('.destination-calendar').length) {

			       var date1value = $('#startDateDetail').val();
			       //console.log('date1value: '+date1value);

			       var arrMonthObj = new Date(date1value);
			       //var arrMonth = arrMonthObj.getMonth()+1;
			       var arrMonth = inst.selectedMonth+1;
			       //console.log('arrMonth: '+arrMonth);

			       var arrDayObj = new Date(date1value);
			       var arrDay2 = arrDayObj.getDate();
			       var arrDay = inst.selectedDay;
			       //console.log('arrDayObj: '+arrDayObj);
			       //console.log('arrDay: '+arrDay);
			       //console.log('arrDay2: '+arrDay2);

		         $('#arrivalMonthDetail').text(otherdatesMonth);

			    //}

		      if (!date1 || date2) {
		        $('#startDateDetail').val(dateText).addClass('date-entered');
		        $('#endDateDetail').val('').addClass('date-entered');
		        //console.log('Start Date Entered');

		        /*var arrMonth = arrMonthObj.getMonth()+1;
		        console.log('start-date-entered_dateText: '+dateText);
		        console.log('start-date-entered_arrMonth: '+arrMonth);
		        console.log('start-date-entered_inst.selectedMonth: '+inst.selectedMonth+(i));
		        console.log('start-date-entered_inst.selectedMonth2: '+inst.selectedMonth+(1));
			      console.log('start-date-entered_inst.selectedMonth3: '+inst.selectedMonth+(i+1));
			      console.log('start-date-entered_inst.selectedMonth3: '+inst.selectedMonth+1);
			      console.log('i: '+i);*/



		         //var arrMonth = arrMonthObj.getMonth()+1;

		         var otherdatesAlt = inst.selectedMonth+'-'+inst.selectedDay+'-'+inst.selectedYear;
		         //console.log('otherdatesAlt: '+otherdatesAlt);


		         //var arrDayObj = new Date(date1value);
			       //var arrDay3 = otherdatesAlt.getDate();
			       var arrDay4 = inst.selectedDay;
			       var arrDay5 = arrDay;

			       $('#arrivalDayDetail.arrival-day').text(arrDay);

			       //console.log('arrDay3: '+arrDay3);
			       //console.log('arrDay4: '+arrDay4);
			       //console.log('arrDay5: '+arrDay5);


		         var tarih = $("#datepicker").datepicker("getDate"); //returns [object Object]
		         var tarih2 = new Date(Date.parse(($("#DatePicker").val()))); //returns [object Object]
		         //console.log('tarih: '+tarih);
		         //console.log('tarih2: '+tarih);

		        //var startdayentgetDate = $(date.getDate()); //date is not defined
		        //console.log('start-date-entered_getDate: '+startdayentgetDate); //date is not defined
		        //console.log('start-date-entered_getMonth: '+date.getMonth()); //date is not defined
		        //console.log('start-date-entered_getFullYear: '+date.getFullYear()); //date is not defined
		        
		        /*if($('.destination-calendar').length) {
			      }*/

		        //console.log('End Date Entered');
		      } else if (selectedDate < date1) {
		        $('#endDateDetail').val($('startDateDetail').val());
		        $('#startDateDetail').val(dateText);
		        $('#arrivalDayDetail.arrival-day').text(arrDay);
		/*
		          var before = $('#startDateRefine').val(dateText);
		          console.log('before: '+before);
		*/
		          //console.log('You are going Backwards!');
		      } else {
		        $('#endDateDetail').val(dateText);
			       var otherdates2 = new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay);
			       //console.log('otherdates2: '+otherdates2);
			       var otherdatesMonth2 = $.datepicker.formatDate("M", otherdates2);
			       //console.log('otherdatesMonth2: '+otherdatesMonth2);
			       $('#DepartureMonthDetail').text(otherdatesMonth2);

			       var date2value = $('#endDateDetail').val();
			       //console.log('date2value: '+date2value);

			       var depMonthObj = new Date(date2value);
			       var depMonth = depMonthObj.getMonth()+1;
			       //console.log('depMonth: '+depMonth);

			       var depDayObj = new Date(date2value);
			       var depDay = depDayObj.getDate();
			       //console.log('depDay: '+depDay);

			       $('#departureMonthDetail').text(otherdatesMonth2);
						 $('div#checkoutValueDetail.departure-day').text(depDay);

		        //console.log('End Date Entered');
		      }
		    }
		  });//END datepicker

      $(document).on('click','.refine-clear',function(){
        // SET DATE TO TODAY FOR RESET
        $('#detailDatepickerCheckin').datepicker('setDate',new Date());
        $('#detailDatepickerCheckout').datepicker('setDate',new Date());
        $('#startDateDetail').val('').removeClass('date-entered').datepicker('refresh');
        $('#endDateDetail').val('').removeClass('date-entered').datepicker('refresh');
        $('#arrivalDayDetail').text('Day');
        $('#checkoutValueDetail').text('Day');
        $('#arrivalMonthDetail').text('Month');
        $('#departureMonthDetail').text('Month');

        // REMOVE HIGHLIGHT FROM DATEPICKER
        $('.ui-datepicker-calendar td').removeClass('dp-highlight');
		    submitForm();
      });

		  // REFINE DATES APPLY - SUBMITS FORM
		  $(document).on('click','#refineDatesApply',function(){
		    submitForm();
		  });

    });
  </script>

	<cfif len(property.latitude) and len(property.longitude)>
		<script type="text/javascript">
			function initialize() {
				<cfoutput>
					var myLatlng = new google.maps.LatLng(#property.latitude#,#property.longitude#);
				</cfoutput>
				var styleArray = [
				   {
				    featureType: "poi.business",
				    elementType: "labels",
				    stylers: [
				      { visibility: "off" }
				    ]
				  }
				];
				var mapOptions = {
					zoom: 17,
					center: myLatlng,
					styles: styleArray,
					mapTypeId: google.maps.MapTypeId.STREET
				}
				var map = new google.maps.Map(document.getElementById('map'), mapOptions);

        var marker = new google.maps.Marker({
          map: map,
					position: myLatlng,
          title: '',
          icon: bookingFolder+'/images/marker.png'
        });

        function animateit(marker) {
          google.maps.event.addListener(marker, 'mouseover', function() {
            var icon = {url:bookingFolder+'/images/marker-hover.png', scaledSize: new google.maps.Size(31,38)};
            marker.setIcon(icon);
          });

          google.maps.event.addListener(marker, 'mouseout', function() {
            var icon = {url:bookingFolder+'/images/marker.png', scaledSize: new google.maps.Size(31,38)};
            marker.setIcon(icon);
          });
        }
        animateit(marker);
			}
			google.maps.event.addDomListener(window, 'load', initialize);
			//console.log('map-loaded');

<!---
			$('#propertyMapBtn').on('click', function(){
				setTimeout(function(){
					initialize();
				}, 10);
			});
--->
		</script>
	</cfif>

</cfif>

<!--- BOOK NOW PAGE - ALL SCRIPTS ARE ON PAGE --->
