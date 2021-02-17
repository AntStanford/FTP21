<cfinclude template="/#settings.booking.dir#/components/header.cfm">

<div class="compare-wrap">

  <div class="container">
		<cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)>
      <h1 class="pull-left site-color-1">Compare Your <em id="favTotal"><cfoutput>#ListLen(cookie.favorites)#</cfoutput></em> Favorites</h1>

			<cfif cgi.HTTP_REFERER neq ''>
				<a href="<cfoutput>#cgi.HTTP_REFERER#</cfoutput>" class="btn back-btn pull-right site-color-4-bg site-color-4-lighten-bg-hover text-white" title="Back One Page"><i class="fa fa-arrow-left" aria-hidden="true"></i> Back One Page</a>
			</cfif>

      <div class="owl-carousel-wrap">
    	  <div class="owl-carousel compare-carousel">
      	  <cfset counter = 1>
    			<cfloop list="#cookie.favorites#" index="i">
    				<cfset getFavPropertyForComparison = application.bookingObject.getProperty(i)>
    				<cfoutput query="getFavPropertyForComparison">

  	        <div class="compare-list-property" data-unitcode="#propertyid#" id="#seoPropertyName#" data-seoname="#seoPropertyName#" data-unitshortname="#name#" data-photo="https://img.trackhs.com/337x219/#defaultPhoto#" data-straddress1="#address#" data-dblbeds="#bedrooms#" data-intoccu="#sleeps#" data-strlocation="#location#">
              <div class="compare-list-property-img-wrap">

                <!--- Favorite Heart --->
                <a href="javascript:;" class="compare-list-property-favorite remove-from-favs" data-counter="#counter#">
                  <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
                  <i class="fa fa-heart under<cfif ListFind(cookie.favorites,propertyid)> favorited</cfif>" aria-hidden="true"></i>
                </a>

                <a href="/#settings.booking.dir#/#seoPropertyName#" class="compare-list-property-link" target="_blank">
                  <span class="compare-list-property-title-wrap">
                    <span class="compare-list-property-title">
                      <h3>#name#</h3>
                      <span class="compare-list-property-info-type">#type#</span>
                    </span>
                  </span>
                  <span class="compare-list-property-img" style="background:url('https://img.trackhs.com/337x219/#defaultPhoto#');"></span>
                </a>
              </div><!-- END compare-list-property-img-wrap -->

              <div class="compare-list-property-info-wrap">
                <ul class="compare-list-property-info">
                  <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> #bedrooms# Beds</li>
                  <li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i> #bathrooms# Baths</li>
                  <li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> Sleeps #sleeps#</li>
                  <cfif petsallowed eq 'Pets Allowed'>
                    <li><i class="fa fa-paw site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Pet Friendly"></i></li>
                  </cfif>
                </ul>

              </div><!-- END compare-list-property-info-wrap -->
            </div><!-- END compare-list-property -->

    				</cfoutput>
    				<cfset counter = counter + 1>
    		  </cfloop>
        </div><!-- END compare-carousel -->

        <div class="cssload-container">
          <div class="cssload-tube-tunnel"></div>
        </div>
      </div>

			<div class="btn-group">
  			<a href="#" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white staf-btn" title="Send to a Friend" data-toggle="modal" data-target="#sendtofriend"><i class="fa fa-share" aria-hidden="true"></i> Send to A Friend</a>
        <a href="compare-print.cfm" target="_blank" class="btn site-color-3-bg site-color-3-lighten-bg-hover text-white print-btn"><i class="fa fa-print" aria-hidden="true"></i> Print</a>
			</div>

  	<cfelse>

  	  <h1 class="pull-left site-color-1">Compare Your Favorites</h1>
  	  <div class="h3 no-favs">You do not have any Favorites at this time!</div>

		</cfif>

  </div>
</div><!-- END compare-wrap -->

<cf_htmlfoot>
<div class="modal fade" id="sendtofriend" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Send to a Friend</h4>
			</div>
			<div class="modal-body">
				<style>label.error{color:red}</style>
				<div id="sendToFriendCompareMSG"></div>
				<form role="form" method="post" class="send-to-friend-form" id="sendToFriendCompare">
					<input type="hidden" name="sendToFriendCompare">
					<input type="hidden" name="camefrom" value="sendToFriendCompare">
					<cfinclude template="/cfformprotect/cffp.cfm">
					<p>Fill out the form below to send this property to a friend.</p>
					<fieldset>
  					<cfset counter = 1>
  					<cfloop list="#cookie.favorites#" index="i">
  						<cfquery name="getProperty" dataSource="#settings.booking.dsn#">
  							select name,id,coverImage
  							from track_properties where id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#i#">
  						</cfquery>
  						<cfoutput query="getProperty">
  						<div class="property-info" id="#counter#">
  							<label>#name#</label>
  							<div class="row">
    							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-4">
    								<img src="https://img.trackhs.com/133x90/#coverImage#" class="thumbnail propertyPic" width="100%">
    							</div>
    							<div class="col-lg-9 col-md-9 col-sm-9 col-xs-8">
      							<textarea name="comments_for_#counter#" class="propertyNotes" placeholder="Add your comments here"></textarea>
    							</div>
  							</div>
  						</div>
  						</cfoutput>
    					<cfset counter = counter + 1>
  					</cfloop>
  					<div class="form-group">
  						<label>Your Email</label>
  						<input type="text" name="youremail" class="form-control required email">
  					</div>
  					<div class="form-group">
  						<label>Friend's Email</label>
  						<input type="text" name="friendsemail" class="form-control required email">
  					</div>
  					<div class="form-group">
      				<div id="sendtofriendcomparecaptcha"></div>
      				<div class="g-recaptcha-error"></div>
      			</div>
    				<div class="form-group">
				      <div class="well input-well">
				        <input id="optinCompare" name="optin" type="checkbox" value="Yes"> <label for="optinCompare">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br >
				        You can unsubscribe at anytime. <a href="/privacy-policy.cfm" target="_blank">Privacy Policy</a></label>
				      </div>
				    </div>
  					<input type="submit" name="submit" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" value="Submit">
          </fieldset>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
</cf_htmlfoot>

<cfinclude template="/#settings.booking.dir#/components/footer.cfm">