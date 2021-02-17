<!--- ALL PAGES --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js" defer type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js" defer type="text/javascript"></script>
<script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script> <!--- needed for Google reCaptcha --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js" defer type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" defer type="text/javascript"></script>
<cfoutput>
<!--- MOMENT --->
<script src="/#settings.booking.dir#/javascripts/vendors/moment/moment-with-locales.js" type="text/javascript"></script>

<!--- GROWL --->
<cfoutput>
<link href="/#settings.booking.dir#/javascripts/vendors/growl/jquery.growl.min.css" rel="stylesheet" type="text/css" media="all">
<script src="/#settings.booking.dir#/javascripts/vendors/growl/jquery.growl.min.js" defer type="text/javascript"></script>
</cfoutput>
<!--- OWL CAROUSEL --->
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js" defer type="text/javascript"></script>
<!--- LAZY LOAD --->
<script src="/#settings.booking.dir#/javascripts/vendors/jquery-lazy/jquery.lazy.min.js" defer type="text/javascript"></script>
<script src="/#settings.booking.dir#/javascripts/vendors/jquery-lazy/jquery.lazy.iframe.min.js" defer type="text/javascript"></script>
</cfoutput>

<!--- RESULTS PAGE ONLY --->
<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/rentals/special-layout.cfm')>

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

  <cfoutput><script src="/#settings.booking.dir#/javascripts/results.min.js?v=1.2" defer></script></cfoutput>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.css" rel="stylesheet" type="text/css" media="all">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/11.1.0/nouislider.min.js" defer type="text/javascript"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/wnumb/1.1.0/wNumb.min.js" defer type="text/javascript"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/OverlappingMarkerSpiderfier/1.0.3/oms.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/js-marker-clusterer/1.0.0/markerclusterer_compiled.js"></script>
  <script type="text/javascript">
    $(document).ready(function(){
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
          <cfif isdefined('session.booking.bedrooms') and listlen( session.booking.bedrooms ) gt 0>
            start: [ <cfoutput>#listfirst(session.booking.bedrooms)#, #listlast(session.booking.bedrooms)#</cfoutput> ],
          <cfelse>
            start: [ <cfoutput>#settings.booking.minBed#, #settings.booking.maxBed#</cfoutput> ],
          </cfif>
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

      if ($('.refine-slider-price-wrap').length) {
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
        	start: [ <cfoutput>#session.booking.priceRangeMin#, #session.booking.priceRangeMax#</cfoutput> ],
        	tooltips: [ wNumb({ decimals: 0, prefix: '$' }), wNumb({ decimals: 0, prefix: '$' }) ],
          connect: [false, true, false],
        	range: {
        		'min': [ <cfoutput>#session.booking.priceRangeMin#</cfoutput> ],
        		'max': [ <cfoutput>#session.booking.priceRangeMax#</cfoutput> ]
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
        	console.log('priceSliderValues'+priceSliderValues);
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

      // SUBMIT SELECTPICKER ON CHANGE
      $('#weekSelect').on('hidden.bs.select', function(){
        submitForm();
      });

      // --- FLEX DATE CHECKBOX IN REFINE - TOGGLES TABS BEFORE RESULTS
      // COMING FROM HOMPAGE QUICKSEARCH, CHECK IF IT IS CHECKED
      if ($('#flexDates').is(':checked')) {

        setFlexTabDates();

        $('.results-tab-bar').removeClass('hidden');
      } else {
<!--- console.log('flex is NOT checked:'); --->
  			setTimeout(function(){
          $('.results-tab-bar').addClass('hidden');
        }, 16);
      }

      // WHEN CHECKED IN REFINE, SUBMIT FORM AND CHECK IF IT IS CHECKED
  		$('#flexDates').on('click', function(){
        if ($('#flexDates').is(':checked')) {
    			setTimeout(function(){
<!--- console.log('setting flex dates'); --->
            <!--- make sure we have dates, otherwise show warning --->
            var cid = $('input#startDateRefine').val().length;
            var cod = $('input#endDateRefine').val().length;

            if (cid == 10 && cod == 10){
              <cfif !mobileDetect>
                $('.results-tab-bar').removeClass('hidden');
                <!--- clear the flexed form field --->
                $('#flexed').val('');
                submitForm();
              <cfelse>
                $('.results-tab-bar').removeClass('hidden');
                <!--- clear the flexed form field --->
                $('#flexed').val('');
              </cfif>
            } else {
              $("#flexDates"). prop("checked", false);
              alert('Please enter dates before selecting Flexible Check-In');
              <!--- show the datepickers --->
              <!--- This DOES NOT work...
              $('.refine-dates').removeClass('active');
              $('.refine-dates').find('.fa-chevron-up').addClass('fa-chevron-down').removeClass('fa-chevron-up');
              $('.refine-dates').next().addClass('hidden'); --->
              return false;
            }
          }, 16);
        } else {
<!--- console.log('UNSETTING flex dates'); --->
    			setTimeout(function(){
            <cfif !mobileDetect>
              $('.refine-dropdown.datepicker-wrap').addClass('hidden');
              $('.results-tab-bar').addClass('hidden');
              submitForm();
            <cfelse>
              $('.results-tab-bar').addClass('hidden');
            </cfif>
          }, 16);
        }
      });



      // TABS BEFORE RESULTS - ON CLICK FIRES THE SUBMIT FUNCTION
      $('.results-tab-bar li a').on('click', function(){
      	$(this).parent().addClass('active');
      	$(this).parent().siblings().removeClass('active');

      	//grab the date & which tab was clicked from the tabs at the top of the results page
      	var newCheckInDate = $(this).data('newcheckin');
        var newCheckOutDate = $(this).data('newcheckout');
        var flexed = $(this).data('flextab');
<!--- console.log('newCheckInDate:'+newCheckInDate+'\nnewCheckOutDate:'+newCheckOutDate);
console.log('flexed:'+flexed); --->
      	//set the datepicker to the new date from the tab
      	$('input#startDateRefine').val(newCheckInDate);
        $('input#endDateRefine').val(newCheckOutDate);

		    var newDate = new Date(newCheckInDate);
		    newDate.setDate(newDate.getDate());
		    $('#startDateRefine').datepicker('setDate',newDate);
<!--- console.log('setting new checkin date:'+newDate); --->

        var newDate = new Date(newCheckOutDate);
        newDate.setDate(newDate.getDate());
        $('#endDateRefine').datepicker('setDate',newDate);
<!--- console.log('setting new checkout date:'+newDate); --->
        <!--- set the flexed field accordingly --->
        $('#flexed').val(flexed);
      	//submit the search form
      	submitForm();
	  });

    });
    function setFlexTabDates() {

      // GET THE DATES
      var refineDate = $('#startDateRefine').val();
      var refineDateEndParts = $('#endDateRefine').val().split('/');
      var refineDateEnd = new Date(refineDateEndParts[2], refineDateEndParts[0] - 1, refineDateEndParts[1]);

      var flexed = $('#flexed').val();

<!--- console.log('flex is checked, flex status is:' + flexed +', base arr is:'+refineDate+', base dep date is:'+refineDateEnd); --->
      <!--- set tab dates --->

      if (flexed == 'early2'){
        <!--- flexed early - make the first tab active, set the dates appropriately --->
        // SET EARLY2 DATE
        early2MomentObj2 = moment(refineDate).format('dddd');
        early2MomentObj = moment(refineDate).format('MMM D');
        newcheckin = moment(refineDate).format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).format('MM/DD/YYYY');
        $('.tab-day-early2').text(early2MomentObj2);
        $('.tab-date-early2').text(early2MomentObj);
        $('#early2SelectDay').data('newcheckin', newcheckin);
        $('#early2SelectDay').data('newcheckout', newcheckout);
        // SET EARLY DATE
        earlyMomentObj2 = moment(refineDate).add(1, 'day').format('dddd');
        earlyMomentObj = moment(refineDate).add(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-early').text(earlyMomentObj2);
        $('.tab-date-early').text(earlyMomentObj);
        $('#earlySelectDay').data('newcheckin', newcheckin);
        $('#earlySelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed early\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET MID DATE
        midMomentObj2 = moment(refineDate).add(2, 'day').format('dddd');
        midMomentObj = moment(refineDate).add(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-mid').text(midMomentObj2);
        $('.tab-date-mid').text(midMomentObj);
        $('#midSelectDay').data('newcheckin', newcheckin);
        $('#midSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE DATE
        lateMomentObj2 = moment(refineDate).add(3, 'day').format('dddd');
        lateMomentObj = moment(refineDate).add(3, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(3, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(3, 'day').format('MM/DD/YYYY');
        $('.tab-day-late').text(lateMomentObj2);
        $('.tab-date-late').text(lateMomentObj);
        $('#lateSelectDay').data('newcheckin', newcheckin);
        $('#lateSelectDay').data('newcheckout', newcheckout);
        // SET LATE2 DATE
        late2MomentObj2 = moment(refineDate).add(4, 'day').format('dddd');
        late2MomentObj = moment(refineDate).add(4, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(4, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(4, 'day').format('MM/DD/YYYY');
        $('.tab-day-late2').text(late2MomentObj2);
        $('.tab-date-late2').text(late2MomentObj);
        $('#late2SelectDay').data('newcheckin', newcheckin);
        $('#late2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('late:'+newcheckin+'-'+newcheckout); --->
        $('#early2Tab').addClass('active');
        $('#earlyTab').removeClass('active');
        $('#midTab').removeClass('active');
        $('#lateTab').removeClass('active');
        $('#late2Tab').removeClass('active');
      } else if (flexed == 'early'){
        <!--- flexed early - make the first tab active, set the dates appropriately --->
        // SET EARLY2 DATE
				early2MomentObj2 = moment(refineDate).subtract(1, 'day').format('dddd');
				early2MomentObj = moment(refineDate).subtract(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-early2').text(early2MomentObj2);
        $('.tab-date-early2').text(early2MomentObj);
        $('#early2SelectDay').data('newcheckin', newcheckin);
        $('#early2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed early\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET EARLY DATE
        earlyMomentObj2 = moment(refineDate).format('dddd');
        earlyMomentObj = moment(refineDate).format('MMM D');
        newcheckin = moment(refineDate).format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).format('MM/DD/YYYY');
        $('.tab-day-early').text(earlyMomentObj2);
        $('.tab-date-early').text(earlyMomentObj);
        $('#earlySelectDay').data('newcheckin', newcheckin);
        $('#earlySelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed early\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET MID DATE
        midMomentObj2 = moment(refineDate).add(1, 'day').format('dddd');
        midMomentObj = moment(refineDate).add(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-mid').text(midMomentObj2);
        $('.tab-date-mid').text(midMomentObj);
        $('#midSelectDay').data('newcheckin', newcheckin);
        $('#midSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE DATE
        lateMomentObj2 = moment(refineDate).add(2, 'day').format('dddd');
        lateMomentObj = moment(refineDate).add(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-late').text(lateMomentObj2);
        $('.tab-date-late').text(lateMomentObj);
        $('#lateSelectDay').data('newcheckin', newcheckin);
        $('#lateSelectDay').data('newcheckout', newcheckout);
        // SET LATE2 DATE
        late2MomentObj2 = moment(refineDate).add(3, 'day').format('dddd');
        late2MomentObj = moment(refineDate).add(3, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(3, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(3, 'day').format('MM/DD/YYYY');
        $('.tab-day-late2').text(late2MomentObj2);
        $('.tab-date-late2').text(late2MomentObj);
        $('#late2SelectDay').data('newcheckin', newcheckin);
        $('#late2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('late:'+newcheckin+'-'+newcheckout); --->
        $('#early2Tab').removeClass('active');
        $('#earlyTab').addClass('active');
        $('#midTab').removeClass('active');
        $('#lateTab').removeClass('active');
        $('#late2Tab').removeClass('active');
      } else if(flexed == 'late'){
        <!--- flexed late - make the last tab active, set the dates appropriately --->
        // SET EARLY2 DATE
				early2MomentObj2 = moment(refineDate).subtract(3, 'day').format('dddd');
				early2MomentObj = moment(refineDate).subtract(3, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(3, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(3, 'day').format('MM/DD/YYYY');
        $('.tab-day-early2').text(early2MomentObj2);
        $('.tab-date-early2').text(early2MomentObj);
        $('#early2SelectDay').data('newcheckin', newcheckin);
        $('#early2SelectDay').data('newcheckout', newcheckout);
        // SET EARLY DATE
				earlyMomentObj2 = moment(refineDate).subtract(2, 'day').format('dddd');
				earlyMomentObj = moment(refineDate).subtract(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-early').text(earlyMomentObj2);
        $('.tab-date-early').text(earlyMomentObj);
        $('#earlySelectDay').data('newcheckin', newcheckin);
        $('#earlySelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed late\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET MID DATE
        midMomentObj2 = moment(refineDate).subtract(1, 'day').format('dddd');
        midMomentObj = moment(refineDate).subtract(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-mid').text(midMomentObj2);
        $('.tab-date-mid').text(midMomentObj);
        $('#midSelectDay').data('newcheckin', newcheckin);
        $('#midSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE DATE
        lateMomentObj2 = moment(refineDate).format('dddd');
        lateMomentObj = moment(refineDate).format('MMM D');
        newcheckin = moment(refineDate).format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).format('MM/DD/YYYY');
        $('.tab-day-late').text(lateMomentObj2);
        $('.tab-date-late').text(lateMomentObj);
        $('#lateSelectDay').data('newcheckin', newcheckin);
        $('#lateSelectDay').data('newcheckout', newcheckout);
        // SET LATE2 DATE
        late2MomentObj2 = moment(refineDate).add(1, 'day').format('dddd');
        late2MomentObj = moment(refineDate).add(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-late2').text(late2MomentObj2);
        $('.tab-date-late2').text(late2MomentObj);
        $('#late2SelectDay').data('newcheckin', newcheckin);
        $('#late2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('late:'+newcheckin+'-'+newcheckout); --->
        $('#early2Tab').removeClass('active');
        $('#earlyTab').removeClass('active');
        $('#midTab').removeClass('active');
        $('#lateTab').addClass('active');
        $('#late2Tab').removeClass('active');
      } else if(flexed == 'late2'){
        <!--- flexed late - make the last tab active, set the dates appropriately --->
        // SET EARLY2 DATE
        early2MomentObj2 = moment(refineDate).subtract(4, 'day').format('dddd');
        early2MomentObj = moment(refineDate).subtract(4, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(4, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(4, 'day').format('MM/DD/YYYY');
        $('.tab-day-early2').text(early2MomentObj2);
        $('.tab-date-early2').text(early2MomentObj);
        $('#early2SelectDay').data('newcheckin', newcheckin);
        $('#early2SelectDay').data('newcheckout', newcheckout);
        // SET EARLY DATE
        earlyMomentObj2 = moment(refineDate).subtract(3, 'day').format('dddd');
        earlyMomentObj = moment(refineDate).subtract(3, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(3, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(3, 'day').format('MM/DD/YYYY');
        $('.tab-day-early').text(earlyMomentObj2);
        $('.tab-date-early').text(earlyMomentObj);
        $('#earlySelectDay').data('newcheckin', newcheckin);
        $('#earlySelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed late\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET MID DATE
        midMomentObj2 = moment(refineDate).subtract(2, 'day').format('dddd');
        midMomentObj = moment(refineDate).subtract(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-mid').text(midMomentObj2);
        $('.tab-date-mid').text(midMomentObj);
        $('#midSelectDay').data('newcheckin', newcheckin);
        $('#midSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE DATE
        lateMomentObj2 = moment(refineDate).subtract(1, 'day').format('dddd');
        lateMomentObj = moment(refineDate).subtract(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-late').text(lateMomentObj2);
        $('.tab-date-late').text(lateMomentObj);
        $('#lateSelectDay').data('newcheckin', newcheckin);
        $('#lateSelectDay').data('newcheckout', newcheckout);
        // SET LATE2 DATE
        late2MomentObj2 = moment(refineDate).format('dddd');
        late2MomentObj = moment(refineDate).format('MMM D');
        newcheckin = moment(refineDate).format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).format('MM/DD/YYYY');
        $('.tab-day-late2').text(late2MomentObj2);
        $('.tab-date-late2').text(late2MomentObj);
        $('#late2SelectDay').data('newcheckin', newcheckin);
        $('#late2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('late:'+newcheckin+'-'+newcheckout); --->
        $('#early2Tab').removeClass('active');
        $('#earlyTab').removeClass('active');
        $('#midTab').removeClass('active');
        $('#lateTab').removeClass('active');
        $('#late2Tab').addClass('active');

      } else {
        <!--- flexed middle - make the middle tab active, set the dates appropriately --->
        // SET EARLY2 DATE
        early2MomentObj2 = moment(refineDate).subtract(2, 'day').format('dddd');
        early2MomentObj = moment(refineDate).subtract(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-early2').text(early2MomentObj2);
        $('.tab-date-early2').text(early2MomentObj);
        $('#early2SelectDay').data('newcheckin', newcheckin);
        $('#early2SelectDay').data('newcheckout', newcheckout);
        // SET EARLY DATE
        earlyMomentObj2 = moment(refineDate).subtract(1, 'day').format('dddd');
        earlyMomentObj = moment(refineDate).subtract(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).subtract(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).subtract(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-early').text(earlyMomentObj2);
        $('.tab-date-early').text(earlyMomentObj);
        $('#earlySelectDay').data('newcheckin', newcheckin);
        $('#earlySelectDay').data('newcheckout', newcheckout);
				<!--- console.log('flexed mid\nearly:'+newcheckin+'-'+newcheckout); --->
        // SET MID DATE
        midMomentObj2 = moment(refineDate).format('dddd');
        midMomentObj = moment(refineDate).format('MMM D');
        newcheckin = moment(refineDate).format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).format('MM/DD/YYYY');
        $('.tab-day-mid').text(midMomentObj2);
        $('.tab-date-mid').text(midMomentObj);
        $('#midSelectDay').data('newcheckin', newcheckin);
        $('#midSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE DATE
        lateMomentObj2 = moment(refineDate).add(1, 'day').format('dddd');
        lateMomentObj = moment(refineDate).add(1, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(1, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(1, 'day').format('MM/DD/YYYY');
        $('.tab-day-late').text(lateMomentObj2);
        $('.tab-date-late').text(lateMomentObj);
        $('#lateSelectDay').data('newcheckin', newcheckin);
        $('#lateSelectDay').data('newcheckout', newcheckout);
				<!--- console.log('mid:'+newcheckin+'-'+newcheckout); --->
        // SET LATE2 DATE
        late2MomentObj2 = moment(refineDate).add(2, 'day').format('dddd');
        late2MomentObj = moment(refineDate).add(2, 'day').format('MMM D');
        newcheckin = moment(refineDate).add(2, 'day').format('MM/DD/YYYY');
        newcheckout = moment(refineDateEnd).add(2, 'day').format('MM/DD/YYYY');
        $('.tab-day-late2').text(late2MomentObj2);
        $('.tab-date-late2').text(late2MomentObj);
        $('#late2SelectDay').data('newcheckin', newcheckin);
        $('#late2SelectDay').data('newcheckout', newcheckout);
				<!--- console.log('late:'+newcheckin+'-'+newcheckout); --->
        $('#early2Tab').removeClass('active');
        $('#earlyTab').removeClass('active');
        $('#midTab').addClass('active');
        $('#lateTab').removeClass('active');
        $('#late2Tab').removeClass('active');
      }
    }
  </script>

  <script type="text/javascript">
    // SRP PROPERTY SLIDER
    function loadResultsOwl() { // Function needed for Infinite Scroll in /ajax/results.cfm
      $('#list-all-results .results-list-properties:not(.results-list-properties-featured) .results-list-property-img-wrap .owl-carousel:not(.owl-loaded).result-property-carousel').each(function(){
        var thisOwl = $(this);
        thisOwl.owlCarousel({
          items: 1, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: true, nav: false, dots: false
        });
        thisOwl.siblings('.owl-prev-custom').click(function() {
          thisOwl.trigger('prev.owl.carousel');
        });
        thisOwl.siblings('.owl-next-custom').click(function() {
          thisOwl.trigger('next.owl.carousel');
        });
      });
    }
    $(document).ajaxComplete(function(){ // For Page load and for Infinite Scroll after Ajax Call
      if ($('.owl-carousel.result-property-carousel').length) {
        loadResultsOwl();
      }
    });
  </script>
</cfif>


<!--- PROPERTY DETAIL PAGE ONLY --->
<cfif cgi.script_name eq '/#settings.booking.dir#/property.cfm'>
  <cfoutput><script src="/#settings.booking.dir#/javascripts/property.min.js?v=1.2" defer></script></cfoutput>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.js" defer type="text/javascript"></script>
  <script type="text/javascript">
    $(document).ready(function(){

    	//DETAIL PAGE CALENDAR TAB/PDP DATEPICKER VARIABLES & FUNCTION
    	//This script can be found in /rentals/components/footer-javascripts.cfm
    	var myBadDates = [];
    	var myBadCheckinDates = [];
    	var myBadCheckoutDates = [];
    	var counter = 0;

		//24th is not available

      // nonAvailListForDatepicker IS DEFINED IN _calendar-tab.cfm
      <cfif isDefined('nonAvailListForDatepicker')>
      	<cfloop list="#nonAvailListForDatepicker#" index="i">
      		<cfoutput>
  				<cfset PreviousDate = DateFormat(DateAdd('d',-1,i),'mm/dd/yyyy')>
                 	<cfset NextDate = DateFormat(DateAdd('d',1,i),'mm/dd/yyyy')>

  					<cfif ListFind(nonAvailListForDatepicker,PreviousDate) AND NOT ListFind(nonAvailListForDatepicker,NextDate) AND DateCompare(i,Now()) GT 0> <!--- Checkout day --->
  						myBadCheckoutDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';
                 		<cfelseif ListFind(nonAvailListForDatepicker,NextDate) AND NOT ListFind(nonAvailListForDatepicker,PreviousDate) AND DateCompare(i,Now()) GT 0> <!--- Checkin day --->
  						myBadCheckinDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';
                 		</cfif>

  				myBadDates[counter] = '#DateFormat(i,"yyyy-mm-dd")#';

      		</cfoutput>
      		counter = counter + 1;
      	</cfloop>
        </cfif>

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
    				$return = false;
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

      // ARRIVAL/DEPARTURE DATES
      if ($('.datepicker').length) {
        // DISABLE END DATE - PREVENT USER FROM SELECTING THIS BEFORE THE START DATE
        $('#endDateDetail').attr('disabled', 'disable');

      	$('#startDateDetail').datepicker({
      		minDate: '+1d',
          beforeShow:function(instance){
            $('#detailDatepickerCheckin').append($('#ui-datepicker-div'));
          },
      		beforeShowDay: checkAvailabilityStart,
      		onSelect: function( selectedDate ) {
      			var newDate = $(this).datepicker('getDate');
      			newDate.setDate(newDate.getDate()+7);
      			// MAKE THE END DATE SELECTABLE
      			$('#endDateDetail').removeAttr('disabled');
      			$('#endDateDetail').datepicker('setDate',newDate);
      			$('#endDateDetail').datepicker('option','minDate',selectedDate);
      			setTimeout(function(){
      				$('#endDateDetail').datepicker('show');
      			}, 16);
      			// ON SELECT HIDE SELECT DATES BUTTON
    		    $('#selectDates').fadeOut();

            // RESET SPLIT COST FORMS
            if ($('#peopleForm').length) {
              $('#peopleForm')[0].reset();
            }
            if ($('#familyForm').length) {
              $('#howmanyfamilies').val('');
              $('#familyForm')[0].reset();
              $("#familyForm fieldset.clone").remove();
            }
      		}
      	});
      	$('#endDateDetail').datepicker({
          minDate: '+1d',
          beforeShow:function(instance){
            $('#detailDatepickerCheckout').append($('#ui-datepicker-div'));
          },
      		beforeShowDay: checkAvailabilityEnd,
      		onSelect: function(selectedDate){
      			submitForm();
      		}
      	});
      }

    });
  </script>

	<cfif len(property.latitude) and len(property.longitude)>
		<script type="text/javascript">
			function initialize() {
				<cfoutput>
					var myLatlng = new google.maps.LatLng(#property.latitude#,#property.longitude#);
				</cfoutput>
				var mapOptions = {
					zoom: 17,
					center: myLatlng,
					mapTypeId: google.maps.MapTypeId.STREET,
					fullscreenControl: true,
          fullscreenControlOptions: {
            position: google.maps.ControlPosition.TOP_LEFT
          },
					mapTypeControl: true,
          mapTypeControlOptions: {
            position: google.maps.ControlPosition.TOP_CENTER
          }
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

			$('#propertyMapBtn').on('click', function(){
				setTimeout(function(){
					initialize();
				}, 10);
			});
		</script>
	</cfif>

</cfif>

<!--- BOOK NOW PAGE - ALL SCRIPTS ARE ON PAGE --->
