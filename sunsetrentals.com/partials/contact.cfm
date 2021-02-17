<cfif len(settings.address) and len(settings.city) and len(settings.state) and len(settings.zip)>
  <p class="h2">Map</p>
  <div class="embed-responsive embed-responsive-16by9">
	<cfoutput><iframe class="lazy" data-src="https://maps.google.com/maps?q=#settings.address#%2C+#settings.city#%2C+#settings.state#+#settings.zip#&ie=UTF8&output=embed" width="600" height="450" frameborder="0" style="border:1px solid ##e3e3e3" allowfullscreen></iframe></cfoutput>
  </div><br>
</cfif>
<div class="row">
  <div class="col-sm-12 col-md-6">
    <p class="h2">Address</p>
    <div class="card">
      <div class="card-body">
        <p class="m-0">
          <cfoutput>
            #settings.company#<br>
            #settings.address#<br>
            #settings.city#, #settings.state# #settings.zip#<br>
          </cfoutput>
        </p>
      </div>
    </div>
  </div>
  <div class="col-sm-12 col-md-6">
    <p class="h2">Email & Phone</p>
    <div class="card">
      <div class="card-body">
        <p class="m-0">
          <cfoutput>
            <b>Email:</b> <a href="mailto:#settings.clientEmail#">#settings.clientEmail#</a><br>
        	  <cfif len(settings.tollFree)>
        	    <cfoutput><b>Phone (toll free):</b> <a href="tel:#settings.tollFree#">#settings.tollFree#</a></cfoutput>
        	  </cfif>
        	  <br>
        	  <cfif len(settings.phone)>
        	    <cfoutput><b>Phone:</b> <a href="tel:#settings.phone#">#settings.phone#</a></cfoutput>
        	  </cfif>
          </cfoutput>
        </p>
      </div>
    </div>
  </div>
</div>
<p class="h2">Contact Form</p>
<p>Fill out the form below and we will contact you shortly.</p>
<div class="card">
  <div class="card-body">
    <div id="contactformMSG"></div>
    <form class="row validate" id="contactform">
      <cfinclude template="/cfformprotect/cffp.cfm">
      <div class="form-group col-md-6">
        <label for="firstname">First Name *</label>
        <input id="firstname" name="firstname" type="text" class="form-control required">
      </div>
      <div class="form-group col-md-6">
        <label for="lastname">Last Name *</label>
        <input id="lastname" name="lastname" type="text" class="form-control required">
      </div>
      <div class="form-group col-md-6">
        <label for="phone">Phone</label>
        <input id="phone" name="phone" type="text" class="form-control">
      </div>
      <div class="form-group col-md-6">
        <label for="email">Email *</label>
        <input id="email" name="email" type="text" class="form-control required">
      </div>
      <div class="form-group col-md-12">
        <label for="comments">Comments</label>
        <textarea class="form-control" id="comments" name="comments"></textarea>
      </div>
      <div class="form-group col-md-12">
      	<div id="contactcaptcha"></div>
    		<div class="g-recaptcha-error"></div>
      </div>
      <div class="form-group col-md-12">
        <div class="well input-well">
          <input id="optinContact" name="optin" type="checkbox" class="form-control" value="Yes"> <label for="optinContact">I agree to receive information about your rentals, services and specials via phone, email or SMS. <br />
          You can unsubscribe at anytime. <a href="/privacy-policy.cfm" target="_blank">Privacy Policy</a></label>
        </div>
      </div>
      <div class="form-group col-sm-12 m-0">
        <input type="submit" value="Submit" name="contactform" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover" onClick="ga('send','event','Contact Form','Submit','Location - Contact Page','1');">
      </div>
    </form>
  </div>
</div>