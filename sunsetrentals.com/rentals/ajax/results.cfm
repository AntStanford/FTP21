<cfset request.ajaxCall = 1>
<cfinclude template="/#settings.booking.dir#/results-search-query.cfm">
<cfinclude template="/#settings.booking.dir#/results-loop.cfm">

<!--- sets the min/max rates for the refine search price range slider --->
<cfif
    isdefined('session.booking.strcheckin') and
    len(session.booking.strcheckin) and
    isvalid('date',session.booking.strcheckin) and
    isdefined('session.booking.strcheckout') and
    len(session.booking.strcheckout) and
    isvalid('date',session.booking.strcheckout)>
    <cfset minmaxprice = application.bookingObject.getMinMaxPrice(session.booking.strcheckin,session.booking.strcheckout)>
    <cfset numNights = DateDiff('d',session.booking.strcheckin,session.booking.strcheckout)>
<cfelse>
    <cfset minmaxprice = application.bookingObject.getMinMaxPrice()>
    <cfset numNights = 7>
</cfif>

<cfset session.booking.priceRangeMin = minmaxprice.minPrice>
<cfset session.booking.priceRangeMax = minmaxprice.maxPrice>

<cfif form.refineSearchType eq 'weekly' and numNights lt 7>

    <!--- User started with weekly search and changed to a less-than-weekly search --->
    <script type="text/javascript">
        $(document).ready(function(){
            var refinePriceSlider = document.getElementById('refinePriceSlider');

            refinePriceSlider.noUiSlider.updateOptions({
            start: [ <cfoutput>#session.booking.priceRangeMin#, #session.booking.priceRangeMax#</cfoutput> ],
            range: {
            'min': <cfoutput>#session.booking.priceRangeMin#</cfoutput>,
            'max': <cfoutput>#session.booking.priceRangeMax#</cfoutput>
            }
            });

            $('#refineSearchType').val('nightly');
        });
    </script>

<cfelseif form.refineSearchType eq 'nightly' and numNights eq 7>

    <!--- User started with nightly search and changed to a weekly search --->
    <script type="text/javascript">
        $(document).ready(function(){
            var refinePriceSlider = document.getElementById('refinePriceSlider');

            refinePriceSlider.noUiSlider.updateOptions({
            start: [ <cfoutput>#session.booking.priceRangeMin#, #session.booking.priceRangeMax#</cfoutput> ],
            range: {
            'min': <cfoutput>#session.booking.priceRangeMin#</cfoutput>,
            'max': <cfoutput>#session.booking.priceRangeMax#</cfoutput>
            }
            });

            $('#refineSearchType').val('weekly');
        });
    </script>

<cfelse>
    <!--- don't reset the slider, keep values the same --->
</cfif>

<!--- Flex nights - if flex is checked, call the required JS --->
<cfif isDefined('form.flex_dates') and form.flex_dates is "on">
  <script type="text/javascript">
<!--- console.log('calling setFlexTabDates()'); --->
    setFlexTabDates();
  </script>
<!--- <cfelse><cfdump var="#form#" abort="true"> --->
</cfif>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js" defer type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" defer type="text/javascript"></script>
<script type="text/javascript">
  // MASTER VARIABLE FOR BOOKING DIRECTORY
  var bookingFolder = '/rentals';

  $(document).ready(function(){

    // SPECIALS MODAL HTML SWAP - IF YOU HAVE TO CHANGE THIS, UPDATE IN javascripts/results.js
    $('.results-list-property-img-wrap').on('click','.results-list-property-special',function(){
      var test = $(this).parent().find('.special-modal-content').html();
      $('#specialModalContent').html(test);
    });

  	// LAZY LOAD
  	$('.lazy').lazy();

    // BASIC DATEPICKER
    $('.datepicker').datepicker();

    // SELECTPICKER
    $('.selectpicker').selectpicker();

    $('form#noResultsContactForm').validate({
  		submitHandler: function(form){
  			$.ajax({
  				type: "POST",
  				url: "_submit.cfm",
  				data: $('form#noResultsContactForm').serialize(),
  				dataType: "text",
  				success: function (response) {
  					response = $.trim(response);
  					console.log(response);
  					if(response === "success") {
  						$('.caption').hide();
  						$('form#noResultsContactForm').hide();
  						$('div#noResultsContactFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
  					}
  				}
  			});
  			return false;
  		}
  	});

  });

  <cfif isdefined('session.booking.unitCodeList') and ListLen(session.booking.unitCodeList) gt 0 and isdefined('session.booking.getResults')>
    <!--- ADD MAP HOVER BINDING TO THE NEW PROPERTIES (THE if PREVENTS IT FROM RUNNING ON THE FIRST, WHICH IS HANDLED BY results.js) --->
    if (window.jQuery) {
      $(".results-list-property").mouseover(function(){
        var markerid = $(this).attr('data-mapMarkerID');
        var icon = {url:bookingFolder+'/images/marker-hover.png', scaledSize: new google.maps.Size(28,39)};
        markers[markerid].setIcon(icon);
              markers[markerid].setZIndex(100);
      });

      $(".results-list-property").mouseout(function(){
        var markerid = $(this).attr('data-mapMarkerID');
        var icon = {url:bookingFolder+'/images/marker.png', scaledSize: new google.maps.Size(28,39)};
        markers[markerid].setIcon(icon);
        markers[markerid].setZIndex(1);
      });
    }
  <cfelse>
    <!--- DO NOTHNIG --->
  </cfif>


  <cfset variables.gaString = application.bookingObject.getGoogleSearchLog('refine')>

  <cfif len(variables.gaString)>
      <cfoutput>#variables.gaString#</cfoutput>
  </cfif>
</script>
