<cfquery name="getValues" dataSource="#settings.dsn#">
	SELECT
        min(maxOccupancy) as minGuests
        ,max(maxOccupancy) as maxGuests
        ,min(bedrooms) as minBedrooms
        ,max(bedrooms) as maxBedrooms
        ,min(fullBathrooms) as minfullBathrooms
        ,max(fullBathrooms) as maxfullBathrooms
        ,min(threeQuarterBathrooms) as minthreeQuarterBathrooms
        ,max(threeQuarterBathrooms) as maxthreeQuarterBathrooms
        ,min(halfBathrooms) as minhalfBathrooms
        ,max(halfBathrooms) as maxhalfBathrooms
        FROM southernresorts.track_properties
        WHERE nodeId = #getResort.Id#
</cfquery>
<cfquery name="getAmenities2" dataSource="#settings.dsn#">
   select amenityName,amenityGroupName, CASE when amenityName IN ('Dryer','Washer','TV (s) - Smart','TV (s)','Clean Cover Program - Fresh Duvets per Reservation','Self Check-in (Keyless Lock)','2 Adult Bikes Included','4 Adult Bikes Included','Complimentary Beach Service in Season - 4 Chairs & 2 Umbrellas','Complimentary Beach Service in Season - 2 Chairs & Umbrella','Free WiFi','Pool - Community','Pool - Private Heated for a Fee','Pool - Private','Pool - Indoor/Outdoor','Pool - Indoor') then 1 else 0 END as amenityTop, 0 as ordernum FROM southernresorts.track_nodes_amenities where nodeId = #getResort.Id#
   order by field(amenityname,'Dryer','Washer','TV (s) - Smart','TV (s)','Clean Cover Program - Fresh Duvets per Reservation','Self Check-in (Keyless Lock)','2 Adult Bikes Included','4 Adult Bikes Included','Complimentary Beach Service in Season - 4 Chairs & 2 Umbrellas','Complimentary Beach Service in Season - 2 Chairs & Umbrella','Free WiFi','Pool - Community','Pool - Private Heated for a Fee','Pool - Private','Pool - Indoor/Outdoor','Pool - Indoor') desc, amenityGroupName
</cfquery>

<cfoutput query="getAmenities2">
	<cfif amenityTop NEQ 1>
	<cfif amenityGroupName EQ "Unit Size">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","1",currentRow)>
	<cfelseif amenityGroupName EQ "Bed Types">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","2",currentRow)>
	<cfelseif amenityGroupName EQ "Proximity">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","3",currentRow)>
	<cfelseif amenityGroupName EQ "View">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","4",currentRow)>
	<cfelseif amenityGroupName EQ "Property Features">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","5",currentRow)>
	<cfelseif amenityGroupName EQ "Kitchen Features">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","6",currentRow)>
	<cfelseif amenityGroupName EQ "Bathroom Features">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","7",currentRow)>
	<cfelseif amenityGroupName EQ "Resort/Community Amenities">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","8",currentRow)>
	<cfelseif amenityGroupName EQ "Activities Nearby">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","9",currentRow)>
	<cfelseif amenityGroupName EQ "Attractions Nearby">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","10",currentRow)>
	<cfelseif amenityGroupName EQ "Policies">
		<cfset temp = QuerySetCell(getamenities2,"orderNum","11",currentRow)>
	</cfif>
	</cfif>
</cfoutput>

<cfquery dbtype="query" name="getAmenities2">
	select * from getAmenities2
	order by orderNum
</cfquery>

<cfquery name="getDest" datasource="#settings.dsn#">
	select id,title from cms_destinations where nodeid = #resortdestID#
</cfquery>
<div class="property-wrap">
  <div id="propertyDetails" class="property-details-wrap" data-unitcode="2070" data-id="2070">
	  <div class="property-overview">
      <h1 class="property-name"><!--- Beachwood Villas #6H - Knot A Worry! ---><cfoutput>#getResort.name#</cfoutput></h1>
      <div class="property-info">
	      <a href="#resort-property-anchor" class="">View Properties</a>
	      <span class="property-info-item"><!--- <span>Locality:</span> ---> <cfoutput><cfif getDest.title EQ "30A">#getresort.locality#<cfelse>#getDest.title#</cfif>, #getresort.region# </cfoutput></span>
	    </div><!-- END property-info -->
		  <div class="property-info property-info-icons">
		    <span class="property-info-item info-icon"><i class="fa fa-users" aria-hidden="true"></i> <!--- 4 Guests ---><cfoutput>#getValues.minGuests#<cfif getValues.maxGuests NEQ getValues.minGuests> - #getValues.maxGuests#</cfif> Guests</cfoutput></span>
		    <cfif getValues.minBedrooms gt 0>
		    <span class="property-info-item info-icon"><i class="fa fa-bed" aria-hidden="true"></i><!---  1 Beds ---> <cfoutput>#getValues.minBedrooms#<cfif getValues.maxBedrooms NEQ getValues.minBedrooms> - #getValues.maxBedrooms#</cfif> Bedrooms</cfoutput></span>
		    </cfif>
		    <cfif getValues.minfullBathrooms gt 0>
		    <span class="property-info-item info-icon"><i class="fa fa-bath" aria-hidden="true"></i> <!--- 1 Baths --->
				<cfoutput>
					#getValues.minfullBathrooms#<cfif getValues.maxfullBathrooms NEQ getValues.minfullBathrooms> - #getValues.maxfullBathrooms#</cfif> Full Baths
					<cfif getValues.minthreeQuarterBathrooms gt 0>, #getValues.minthreeQuarterBathrooms# - #getValues.maxthreeQuarterBathrooms# Quarter Baths</cfif>
					<cfif getValues.minhalfBathrooms gt 0>
						,
						<cfif getValues.minhalfBathrooms NEQ getValues.maxhalfBathrooms>
							#getValues.minhalfBathrooms# - #getValues.maxhalfBathrooms#
						<cfelse>
							#getValues.minhalfBathrooms#
						</cfif>
						 Half Baths
					</cfif>
				</cfoutput>
			</span>
		    </cfif>
		  </div><!-- END property-info -->
		</div><!-- END property-overview -->
    <!-- Property Tabs -->
    <div class="property-tabs-wrap">
      <div id="propertyTabsAnchor" style="height: 0px;"><!-- TRAVEL STICKY TABS ANCHOR FOR SCROLL --></div>
      <ul id="propertyTabs" class="property-tabs tabs tab-group">
        <li><a href="javascript:;" data-scrollto="description-wrap" data-scrollto-adjust="170" class="active"><i class="fa fa-align-left" aria-hidden="true"></i> <span>Description</span></a></li>
        <li><a href="javascript:;" data-scrollto="amenities-wrap" data-scrollto-adjust="125" class=""><i class="fa fa-list" aria-hidden="true"></i> <span>Amenities</span></a></li>
        <!---<li><a href="#qanda"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Virtual Tour</span></a></li>--->
        <!---<li><a href="#map"><i class="fa fa-question-circle" aria-hidden="true"></i> <span>Map</span></a></li> --->
      </ul><!-- END propertyTabs -->
    </div>

    <!-- Property Description | #description -->
    <cfinclude template="_description-tab.cfm">

    <!-- Property Amenities | #amenities -->

		<div id="amenities" name="amenities" class="info-wrap amenities-wrap less">
		  <div class="info-wrap-heading"><i class="fa fa-list" aria-hidden="true"></i> Amenities</div>
		  <div class="info-wrap-body">
			  <cfif len(getAmenities2.amenitygroupname)>
<!---
				  <cfif CGI.REMOTE_ADDR eq "173.93.73.19">
					  test
					<cfelse>
					</cfif>
--->
			  	<cfoutput query="getAmenities2" group="amenitygroupname">
					  <cfif findnocase ("resort", amenitygroupname)>
					  	<div class="amenity-row<cfif getAmenities2.amenityTop EQ 1> amenityTopWrapper</cfif>" >
								<cfif getAmenities2.amenityTop NEQ 1 ><p>#amenitygroupname#</p></cfif>
			    	    <ul>
						      <cfoutput>
							      <li class="amenity-#left(getAmenities2.amenityName, 3)#<cfif getAmenities2.amenityTop EQ 1> amenityTop</cfif><cfif findNoCase('Pool - Community',getAmenities2.amenityName)> pool-community</cfif><cfif findNoCase('Pool - Private',getAmenities2.amenityName)> pool-private</cfif>">#amenityname#</li>
							    </cfoutput>
							  </ul>
							</div><!--END amenity row-->
						</cfif>
					</cfoutput>
				<cfelse>
					<p>No Amenities Listed</p>
		    </cfif>
		  </div><!-- END info-wrap-body -->
		</div><!-- END amenities-wrap -->
		<!--- <button id="selectDates" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn" type="button" style="background-color: transparent !important; color: #000 !important;">See More Amenities<i class="fa fa-chevron-right" aria-hidden="true"></i></button>  --->
<!---
		<cfif len(getAmenities2.amenitygroupname)>
		  <button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-amenities" type="button" style="background-color: transparent !important; color: #000 !important;"><span>See More Amenities</span><i class="fa fa-chevron-right" aria-hidden="true"></i></button>
		</cfif>
--->
		        <!-- Property Map -->
		<!---
		  <div id="propertyMap" class="property-map property-iframe">
		<div id="map"></div>
		    <iframe src="https://maps.google.com/maps?q=30.31460000,-86.11377000&amp;ie=UTF8&amp;output=embed" width="100%" height="100%" frameborder="0" style="border:0" allowfullscreen=""></iframe>
		  </div>
		--->
      <!-- Property Reviews | #reviews -->
      <!-- Property Inquire Form | #qanda -->
      <!-- JUMP LINK IN _travel-dates.cfm Request More Info Button -->
<!---
      <div id="inquire" name="inquire" class="info-wrap inquire-wrap">
			  <div class="info-wrap-body" style="padding: 0;">
			    <div class="info-wrap info-wrap-heading">Want to know more?</div>
			    <div id="propertyContactFormMSG"></div>
			    <form role="form" id="propertyContactForm" class="contact-form validate" method="post" novalidate="novalidate">

						<script type="text/javascript" defer="defer">
					  function getMousePos(e){if(!e)var e=window.event;e.pageX||e.pageY?(xPos=e.pageX,yPos=e.pageY):(e.clientX||e.clientY)&&(xPos=e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,yPos=e.clientY+document.body.scrollTop+document.documentElement.scrollTop)}function timedMousePos(){if(document.onmousemove=getMousePos,xPos>=0&&yPos>=0){var e=xPos,t=yPos;intervals++}1==intervals?(firstX=xPos,firstY=yPos):2==intervals&&(clearInterval(myInterval),calcDistance(firstX,firstY,e,t))}function calcDistance(e,t,s,o){var n=Math.round(Math.sqrt(Math.pow(e-s,2)+Math.pow(t-o,2)));try{for(var a=getInputElementsByClassName("cffp_mm"),l=0;l<a.length;l++)a[l].value=n}catch(r){}}function logKeys(){keysPressed++;for(var e=getInputElementsByClassName("cffp_kp"),t=0;t<e.length;t++)e[t].value=keysPressed}function dummy(){}var getInputElementsByClassName=function(e){var t=new Array,s=0,o=document.getElementsByTagName("input");for(i=0;i<o.length;i++)o[i].className==e&&(t[s]=o[i],s++);return t},myInterval=window.setInterval(timedMousePos,250),xPos=-1,yPos=-1,firstX=-1,firstY=-1,intervals=0,keysPressed=0;document.onkeypress=logKeys;
					  </script>

						<input id="fp1" type="hidden" name="formfield1234567891" class="cffp_mm" value="76">
						<input id="fp2" type="hidden" name="formfield1234567892" class="cffp_kp" value="">
						<input id="fp3" type="hidden" name="formfield1234567893" value="39931007,19851722">
						<span style="display:none">Leave this field empty <input id="fp4" type="text" name="formfield1234567894" value=""></span>
			  		<input type="hidden" name="property_name" value="Beachwood Villas #6H - Knot A Worry!">
			  		<input type="hidden" name="property_id" value="2070">
			  		<input type="hidden" name="property_photo" value="https://track-pm.s3.amazonaws.com/svr/unit-images/045173a1-4c84-421e-92a5-ace7de2b413a.JPG">
			  		<input type="hidden" name="key" value="3356028198992584">
			  		<input type="hidden" name="hiddenstrcheckin" value="" id="hiddenstrcheckin">
			  		<input type="hidden" name="hiddenstrcheckout" value="" id="hiddenstrcheckout">
			  		<input type="hidden" name="requestMoreInfoForm">

			      <fieldset class="row">
			        <div class="form-group col-xs-12 col-sm-6">
			          <label>First Name</label>
			          <input type="text" id="firstName" name="firstName" placeholder="First" class="required">
			        </div>
			        <div class="form-group col-xs-12 col-sm-6">
			          <label>Last Name</label>
			          <input type="text" id="lastName" name="lastName" placeholder="Last" class="required">
			        </div>
			        <div class="form-group col-xs-12">
			          <label>Email Address</label>
			          <input type="email" id="email" name="email" placeholder="Email" class="required">
			        </div>
			        <div class="form-group col-xs-12">
			          <label>Comments/Questions</label>
			          <textarea id="" name="comments" placeholder="Comments..."></textarea>
			        </div>
			        <div class="form-group col-xs-12">
			          <div id="pdpmoreinfocaptcha"></div>
			          <div class="g-recaptcha-error"></div>
			        </div>
			        <div class="form-group col-xs-12">
			          <div class="well input-well">
			            <input id="optinRequestInfo" name="optin" type="checkbox" value="Yes"> <label for="optinRequestInfo">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br>
			            You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank">Privacy Policy</a></label>
			          </div>
			        </div>
			        <div class="form-group col-xs-12">
			          <input type="submit" id="" name="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" value="Request Info" onclick="ga('send','event','Contact Form','Submit','Location - Property Contact Form','1');">
			        </div>
			      </fieldset>
			    </form>
			  </div><!-- END info-wrap-body -->
			</div>
---><!-- END inquire-wrap -->
		</div><!-- END propertyDetails -->
		<cfinclude template="/components/_travel-dates-resorts.cfm">
    <div class="mobile-dates-toggle-wrap">
      <button id="mobileDatesToggle" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" type="button"><i class="fa fa-chevron-right" aria-hidden="true"></i> Show Availability</button>
      <small>Find Available Dates For this Property</small>
    </div>
  </div>

  <div class="resort-bottom">
	  <h2>Vacation Rentals in <cfoutput query="getResort">#getResort.name#</cfoutput></h2>
	  <a name="resort-property-anchor"></a>
		<cf_htmlfoot>
		  <script type="text/javascript" defer>
		    $(document).ready(function(){
			  /*$('.see-more-amenities').click(function(){*/
			    /*var readMoreWrap = $(this).prev('.amenities-wrap');
			    var readMoreWrapHeight = readMoreWrap.data('height');
			    var readMoreWrapFullHeight = readMoreWrap.prop('scrollHeight');
			    if ( $(readMoreWrap).height() === readMoreWrapHeight ) {
				    console.log('bingo');
			      readMoreWrap.css({'height':readMoreWrapFullHeight});
			      setTimeout(function(){
			        readMoreWrap.css({'height':'auto'});
			      }, 500);
			    } else {
				    console.log('bingo2');*/
			      //readMoreWrap.animate({'height':readMoreWrapHeight},500);
			      /*readMoreWrap.css({'height':readMoreWrapFullHeight});
			    }*/
			    //readMoreWrap.toggleClass('read-more-bottom-cover');
			    /*$('.see-more-amenities span').text($(this).text() == 'See More Amenities' ? 'See Less Amenities' : 'See Less Amenities');
			    console.log("readMoreWrap:"+readMoreWrap);
			    console.log('readMoreWrapHeight: '+readMoreWrapHeight);
			    console.log('readMoreWrapFullHeight: '+readMoreWrapFullHeight);*/


			  /*});*/

        /*
		    $('.see-more-amenities').toggle(function () {
			    $(".amenities-wrap").addClass("less");
			    $('.see-more-amenities span').text('See Less Amenities');
				}, function () {
					$(".amenities-wrap").removeClass("less");
					$('.see-more-amenities span').text('See More Amenities');
				});
				*/
				//$('.see-more-amenities span').text($(this).text() == 'See More Amenities' ? 'See Less Amenities' : 'See Less Amenities');

			  function sticky_dates() {
			    var window_top = $(window).scrollTop();
			    // var sticky_anchor = $('#resortDatesAnchor').offset().top-154;
			    var sticky_anchor = $('#resortDatesAnchor').offset().top;
			    var sticky = $('#resortDates');
			    var footer_anchor = $('#footerAnchor').offset().top-150;
			    var footer_height = $('.resort-bottom').height()+75;
			    var travel_dates_bottom = $('#resortDatesBottom').offset().top;
			    var doc_height = $(document).height();
			    var footer_space = doc_height-footer_height;
			    console.log('doc_height: '+doc_height);
			    console.log('window_top: '+window_top);
			    console.log('sticky_anchor: '+sticky_anchor);
			    console.log('footer_anchor: '+footer_anchor);
			    console.log('travel_dates_bottom: '+travel_dates_bottom);
			    console.log('footer_space: '+footer_space);
			    //console.log('footer_space: '+footer_space);
			    if ((window_top > sticky_anchor) && (travel_dates_bottom > footer_anchor)) {
		// 	      $('#resortDates').addClass('fixed');
		        if (window_top > footer_space) {
				      $('#resortDates').removeClass('fixed');
				      //$('#resortDatesAnchor').height($('#resortDates').outerHeight());
				      $('.property-dates-wrap').addClass('at-footer');
				      console.log('YO!');
				    }
				    console.log('do nothing');
			    } else if (window_top > sticky_anchor && window_top < footer_space) {
		// 	      $('#resortDates').removeClass('fixed');
			      $('#resortDates').addClass('fixed');
			      $('.property-dates-wrap').removeClass('at-footer');
			      //$('#resortDatesAnchor').height(0);
			      console.log('TWOCONDITIONS');
			    } else if (window_top > sticky_anchor) {
			      console.log('ELSEIF!');
			    } else {
				    console.log('ELSE!');
				    $('.property-dates-wrap').removeClass('at-footer');
				    $('#resortDates').removeClass('fixed');
			    }
		    }
			  $(function() {
			    $(window).scroll(sticky_dates);
			    sticky_dates();
			  });

			  // If Resorts Results is empty
			  if ( !$.trim( $('.resort-body #list-all-results').html() ).length ) {
  			  var titleText = $('.resort-body .resort-bottom h2').text();
  			  $('.resort-body .results-body').append('<div class="alert alert-danger">There are no '+titleText+' that match your dates, please Pick Your Dates above.</div>');
			  }

		});
		</script>

		<!--- If the page has been reloaded from the 'Check Availability' form on the Resort Page --->
		<cfif cgi.request_method eq "post" and isdefined('form.strcheckin') and isdefined('form.strcheckout') and LEN(form.strcheckin) and LEN(form.strcheckout)>
  	  <script type="text/javascript">
  	  $(document).ready(function(){
    	  // Once form is submitted (CFIF above) scroll to 'Vacation Rentals' area of the page
    	  setTimeout(function(){
  	      $('html, body').animate({scrollTop: $('.resort-bottom').offset().top - 60}, 'slow');
    	  }, 2000);
  	  });
  	  </script>
		</cfif>

		  </cf_htmlfoot>

		<style>
			#resortDates {
			display: block;
		    margin-bottom: 10px;
		    /* padding: 10px 20px 500px; */
		    padding: 10px 20px 0px;
		    position: relative;
		    /* overflow-y: auto; */
		    font-size: 16px;}

			#resortDates.fixed {
		    display: block;
		    /* width: 400px; */
		    width: 250px;
		    max-width: calc(100% / 4);
		    position: fixed;
		    top: 184px;
		    /* bottom: 0; */
		    z-index: 800;
		}
		.owl-gallery-wrap.owl-resorts-gallery-wrap { max-width: 1500px; margin: 0 auto; }
			@media (min-width: 1025px) {
		   #resortDates, #resortDates.fixed { display: block !important; }
		  }
		</style>
