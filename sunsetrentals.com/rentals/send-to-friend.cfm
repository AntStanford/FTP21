
<cf_htmlfoot>
<div class="modal fade" id="sendtofriends" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Send to a Friend</h4>
			</div>
			<div class="modal-body">
				<style>label.error{color:red}</style>
				<div id="sendToFriendMSG"></div>
				<form role="form" method="post" class="send-to-friend-form" id="sendToFriend">
					<input type="hidden" name="sendToFriend">
					<input type="hidden" name="camefrom" value="sendToFriend">

					<cfinclude template="/cfformprotect/cffp.cfm">
					<p>Fil out the form below to send this property to a friend.</p>
					<fieldset>
  						<cfquery name="getProperty" dataSource="#settings.booking.dsn#">
  							select name,id,coverImage,seoFriendlyURL
  							from track_properties where id =<cfqueryparam cfsqltype="cf_sql_varchar" value="#property.propertyid#">
  						</cfquery>
  						<cfoutput query="getProperty">
  						<input type="hidden" name="image" value="https://img.trackhs.com/133x90/#coverImage#">
  						<input type="hidden" name="propertyName" value="#name#">
  						<input type="hidden" name="seopropertyName" value="#seoFriendlyURL#">
  						<div class="property-info" id="">
  							<label>#name#</label>
  							<div class="row">
    							<div class="col-lg-3 col-md-3 col-sm-3 col-xs-4">
    								<img src="https://img.trackhs.com/133x90/#coverImage#" name="image" class="thumbnail propertyPic" width="100%">
    							</div>
    							<div class="col-lg-9 col-md-9 col-sm-9 col-xs-8">
      							<textarea name="message" class="propertyNotes" placeholder="Add your comments here"></textarea>
    							</div>
  							</div>
  						</div>
  						</cfoutput>
  					<div class="form-group">
  						<label>Your Email</label>
  						<input type="text" name="youremail" class="form-control required email">
  					</div>
  					<div class="form-group">
  						<label>Friend's Email</label>
  						<input type="text" name="friendsemail" class="form-control required email">
  					</div>
  					<div class="form-group">
      				<div id="sendtofriendcaptcha"></div>
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
