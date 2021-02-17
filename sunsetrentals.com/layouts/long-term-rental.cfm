<cfquery name="getLongTermRental" dataSource="#settings.dsn#">
	select * from cms_longterm_rentals where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#"> and status = 'active'
</cfquery>

<cfinclude template="/components/header.cfm">

<cfif getLongTermRental.recordcount gt 0>
	<cfquery name="getPhotos" dataSource="#settings.dsn#">
		select * from cms_assets where section = 'Long Term Rental' and foreignKey = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getLongTermRental.id#">
	</cfquery>

	<div class="i-content int">
	  <div class="container">
	  	<div class="row">
	  		<div class="col">
	    		<div class="row">
	      		<div class="col-sm-12 col-md-6 col-lg-6">
	            <cfoutput>
	              <div class="owl-gallery-wrap">
	                <div class="owl-carousel owl-theme owl-gallery">
	                  <div class="item">
                      <a href="/images/longtermrentals/#getLongTermRental.mainphoto#" class="fancybox" data-fancybox="owl-gallery-group">
                        <img class="owl-lazy" data-src="/images/longtermrentals/#getLongTermRental.mainphoto#" alt="Long Term Rental Main Photo">
                      </a>
	                  </div>
	                  <cfloop query="getPhotos">
                      <div class="item">
                        <a href="/images/longtermrentals/#thefile#" class="fancybox" data-fancybox="owl-gallery-group">
                          <img class="owl-lazy" data-src="/images/longtermrentals/#thefile#" alt="Long Term Rental Image">
                        </a>
                      </div>
	                  </cfloop>
	                </div>
	                <div class="owl-carousel owl-theme owl-gallery-thumbs">
	                  <div class="item">
                      <a href="/images/longtermrentals/#getLongTermRental.mainphoto#" class="fancybox" data-fancybox="owl-gallery-group">
                        <img class="owl-lazy" data-src="/images/longtermrentals/#getLongTermRental.mainphoto#" alt="Long Term Rental Main Thumb">
                      </a>
	                  </div>
	                  <cfloop query="getPhotos">
                      <div class="item">
                        <span class="owl-lazy" data-src="/images/longtermrentals/#thefile#"></span>
                      </div>
	                  </cfloop>
	                </div>
	              </div>
	            </cfoutput>
	      		</div>
	      		<div class="col-sm-12 col-md-6 col-lg-6">
	      		<cfoutput>
							<cfif len(getLongTermRental.h1)>
	            	<h1 class="site-color-3 m-0">#getLongTermRental.h1#</h1>
	            <cfelse>
	            	<h1 class="site-color-3 m-0">#getLongTermRental.name#</h1>
	            </cfif>
	            <p class="h5" style="line-height:1.5;">
	              <cfif len(getLongTermRental.address)><b>Address:</b> #getLongTermRental.address#<br></cfif>
	              <cfif len(getLongTermRental.type)><b>Type:</b> #getLongTermRental.type#<br></cfif>
	              <cfif len(getLongTermRental.bedrooms)><b>Beds:</b> #getLongTermRental.bedrooms#<br /></cfif>
	              <cfif len(getLongTermRental.bathrooms)><b>Baths:</b> #getLongTermRental.bathrooms#<br /></cfif>
	              <cfif len(getLongTermRental.pet_friendly)><b>Pet Friendly:</b> #getLongTermRental.pet_friendly#<br /></cfif>
	              <cfif len(getLongTermRental.monthly_rate)><b>Monthly Rate:</b> $#getLongTermRental.monthly_rate#<br /></cfif>
	            </p>
	            </cfoutput>
	      		</div>
	    		</div><br>
	        <ul class="nav nav-tabs nav-justified i-resort-tabs">
	          <li class="nav-item"><a class="nav-link btn site-color-2-bg site-color-2-lighten-bg-hover text-white text-white-hover active" id="overview-tab" href="#overviewTab" aria-controls="overviewTab" role="tab" data-toggle="tab" aria-selected="true">Overview</a></li>
	          <li class="nav-item"><a class="nav-link btn site-color-3-bg site-color-3-lighten-bg-hover text-white text-white-hover" id="amenities-tab" href="#amenitiesTab" aria-controls="amenitiesTab" role="tab" data-toggle="tab" aria-selected="false">Amenities</a></li>
	          <cfif len(getLongTermRental.address) and len(getLongTermRental.city) and len(getLongTermRental.state) and len(getLongTermRental.zip)>
  	          <li class="nav-item"><a class="nav-link btn site-color-3-bg site-color-3-lighten-bg-hover text-white text-white-hover" id="map-tab" href="#mapTab" aria-controls="mapTab" role="tab" data-toggle="tab" aria-selected="false">Map</a></li>
            </cfif>
	          <li class="nav-item"><a class="nav-link btn site-color-3-bg site-color-3-lighten-bg-hover text-white text-white-hover" id="contact-tab" href="#contactTab" aria-controls="contactTab" role="tab" data-toggle="tab" aria-selected="false">Contact</a></li>
	        </ul>
	        <div class="tab-content">
	          <div role="tabpanel" class="tab-pane active" id="overviewTab" role="tabpanel" aria-labelledby="overview-tab">
	            <div class="card">
  	            <div class="card-body">
                  <cfoutput>#getLongTermRental.description#</cfoutput>
  	            </div>
	            </div>
	          </div>
	          <div role="tabpanel" class="tab-pane" id="amenitiesTab" role="tabpanel" aria-labelledby="amenities-tab">
	            <div class="card">
  	            <div class="card-body">
    	            <ul class="list-group">
        						<cfset cleanAmenities = replace(getLongTermRental.amenities,'<p>','','all')>
        						<cfset cleanAmenities = replace(cleanAmenities,'</p>','','all')>
        						<cfloop list="#cleanAmenities#" delimiters=";" index="i">
        							<li class="list-group-item"><cfoutput>#i#</cfoutput></li>
        						</cfloop>
        					</ul>
                </div>
              </div>
	          </div>
	          <cfif len(getLongTermRental.address) and len(getLongTermRental.city) and len(getLongTermRental.state) and len(getLongTermRental.zip)>
		          <div role="tabpanel" class="tab-pane" id="mapTab" role="tabpanel" aria-labelledby="map-tab">
	              <div class="embed-responsive embed-responsive-16by9">
	                <cfoutput>
	                  <iframe src="https://maps.google.com/maps?q=#getLongTermRental.address#%2C+#getLongTermRental.city#%2C+#getLongTermRental.state#+#getLongTermRental.zip#&ie=UTF8&output=embed" width="600" height="450" frameborder="0" style="border:0" allowfullscreen></iframe>
	                </cfoutput>
	              </div><br>
		          </div>
	          </cfif>
	          <div role="tabpanel" class="tab-pane" id="contactTab" role="tabpanel" aria-labelledby="contact-tab">
	            <div class="card">
  	            <div class="card-body">
  	              <form id="resort-contactform" method="post" action="/submit.cfm" novalidate="novalidate" class="validate">
  	              	<cfinclude template="/cfformprotect/cffp.cfm">
  	              	<fieldset>
    	              	<div class="row">
                        <div class="col-sm-12 col-md-6 form-group mb-1">
  	              				<label class="control-label" for="firstname">First Name</label>
  	              				<div class="controls">
  	              					<input type="text" class="form-control required" name="firstname" data-msg-required="Please enter first name" aria-required="true">
  	              				</div>
  	              		  </div>
                        <div class="col-sm-12 col-md-6 form-group mb-1">
  	              				<label class="control-label" for="lastname">Last Name</label>
  	              				<div class="controls">
  	              					<input type="text" class="form-control required" name="lastname" data-msg-required="Please enter last name" aria-required="true">
  	              				</div>
  	              		  </div>
                        <div class="col-sm-12 col-md-6 form-group mb-1">
  	              				<label class="control-label" for="phone">Phone (optional)</label>
  	              				<div class="controls">
  	              					<input type="text" class="form-control" name="phone">
  	              				</div>
  	              			</div>
                        <div class="col-sm-12 col-md-6 form-group mb-1">
  	              				<label class="control-label" for="email">Email</label>
  	              				<div class="controls">
  	              					<input type="text" class="form-control required email" name="email" data-msg-required="Please enter Email" aria-required="true">
  	              				</div>
  	              		  </div>
                        <div class="col-sm-12 col-md-12 form-group mb-3">
  	              				<label class="control-label">Comments</label>
  	              				<div class="controls">
  	              					<textarea name="comments" class="form-control"></textarea>
  	              				</div>
  	              		  </div>
                        <div class="col-sm-12 col-md-12 form-group mb-3">
      						    		<div id="contactcaptcha"></div>
      						  			<div class="g-recaptcha-error"></div>
      						      </div>
                        <div class="col-sm-12 col-md-12 form-group mb-3">
                          <div class="card input-well">
                            <input id="optinLongTermRental" name="optin" type="checkbox" value="Yes"> <label for="optinLongTermRental">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br>
                            You can unsubscribe at anytime. <a href="/privacy-policy.cfm" target="_blank">Privacy Policy</a></label>
                          </div>
                        </div>
                        <div class="col-sm-12 col-md-12 form-group m-0">
                  				<div class="controls">
                    				<button id="contactform" name="contactform" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" onclick="ga('send', 'event', { eventCategory: 'contact', eventAction: 'more information request'});">Send my question!</button>
                  				</div>
                  		  </div>
                        <input type="hidden" name="longtermrental" value="<cfoutput>#getLongTermRental.name#</cfoutput>">
    	              	</div>
  	              	</fieldset>
  	              </form>
  	            </div>
	            </div>
	          </div>
	        </div>
	  		</div>
	  	</div>
	  </div>
  </div><!-- END i-content -->
	<cf_htmlfoot>
	<script type="text/javascript">
	$(document).ready(function(){
	  //Color Themes Active Tabs for Overview/Amenities/Map/Rates/Contact
	  $('.i-resort-tabs li a').click(function(){
	  	$('.i-resort-tabs li a.active')
	  		.removeClass('site-color-2-bg site-color-2-lighten-bg-hover')
	  	  .addClass('site-color-3-bg site-color-3-lighten-bg-hover');
	    $(this).addClass('site-color-2-bg site-color-2-lighten-bg-hover');
	    $(this).removeClass('site-color-3-bg site-color-3-lighten-bg-hover');
	  });
	});
	</script>
	</cf_htmlfoot>
<cfelse>
	<div class="i-content int">
		<div class="container">
			<div class="row">
				<div class="col">
          <h1>Record Not Found</h1>
          <p>Sorry, that record was not found.</p>
				</div>
			</div>
  		<cfinclude template="/components/callouts.cfm">
		</div>
  </div><!-- END i-content -->
</cfif>
<cfinclude template="/components/footer.cfm">