<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">

<cfquery name="getUser" dataSource="#settings.dsn#">
	select * from guest_focus_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
</cfquery>

<div class="content-wrap">

  <div class="page-header">
    <h1>Profile</h1>
  </div>

  <div class="profile-wrap">

    <div class="alert alert-info">
      Welcome <strong><cfoutput>#cookie.GuestFocusLoggedInName#</cfoutput></strong>
    </div>
    
    <cfif isdefined('url.success')>
    <div class="alert alert-success">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    		<span aria-hidden="true">&times;</span>
  		</button>
      <b>Success!</b> Your profile has been updated.
    </div>
    </cfif>

    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Settings</h3>
      </div>
      <div class="panel-body">
        <cfoutput>
        <form class="form-horizontal" id="createaccountform" method="post" action="submit.cfm">
          <input type="hidden" name="action" value="updateprofile">
          <fieldset>
            <div class="row">
              <div class="control-group col-md-6">
                <div class="controls">
                  <label>First name</label>
                  <input type="text" placeholder="First Name" class="form-control required" name="firstname" value="#getUser.firstname#">
                </div>
              </div>
              <div class="control-group col-md-6">
                <div class="controls">
                  <label>Last Name</label>
                  <input type="text" placeholder="Last Name" class="form-control required" name="lastname" value="#getUser.lastname#">
                </div>
              </div>
            </div>
            <div class="control-group">
              <div class="controls">
                <label>Phone Number</label>
                <input type="text" placeholder="Phone Number" class="form-control" name="phone" value="#getUser.phone#">
              </div>
            </div>
            <div class="control-group">
              <div class="controls">
                <label>Email Address</label>
                <input type="text" disabled="" placeholder="Email Address" class="form-control required email" name="" value="#getUser.email#">
              </div>
            </div>
        	  <div class="control-group">
              <div class="controls">
                <label>Address</label>
                <input type="text" placeholder="Address" class="form-control required address" name="address" value="#getUser.address#">
              </div>
            </div>
      	    <div class="control-group">
              <div class="controls">
                <label>City</label>
                <input type="text" placeholder="City" class="form-control required city" name="City" value="#getUser.city#">
              </div>
            </div>
            <div class="row">
        	    <div class="control-group col-md-6">
                <div class="controls">
                  <label>State</label>
                  <input type="text" placeholder="State" class="form-control required state" size="2" name="State" value="#getUser.state#">
                </div>
              </div>
        	    <div class="control-group col-md-6">
                <div class="controls">
                 <label>Zip</label>
                  <input type="text" placeholder="Zip" class="form-control required zip" name="Zip" value="#getUser.zip#">
                </div>
              </div>
            </div>
            <div class="row">
              <div class="control-group col-md-6">
                <div class="controls">
                  <label>Password</label>
                  <input type="password" placeholder="Password" class="form-control required" name="password" value="#getUser.password#">
                </div>
              </div>
              <div class="control-group col-md-6">
                <!---
                <div class="controls">
                  <label>Re-Enter Password</label>
                  <input type="password" placeholder="Re-Enter Password" class="form-control required" name="password2" value="#getUser.password#">
                </div>
                --->
              </div>
        	    <div class="control-group col-md-12">
                <div class="controls">
                  <div class="well input-well">
                    <input id="optinContact" name="optin" type="checkbox" class="form-control" value="Yes"> <label for="optinContact">I agree to receive information about your rentals, services and specials via phone, email or SMS. <br />
                    You can unsubscribe at anytime. <a href="/privacy-policy.cfm" target="_blank">Privacy Policy</a></label>
                  </div>
                </div>
              </div>
            </div>
            <div class="control-group">
              <div class="controls">
                <button class="btn btn-primary" name="GuestSubscriberUpdate">Update Account</button>
              </div>
            </div>
          </fieldset>
        </form>
        </cfoutput>
      </div>
    </div>

  </div>

</div>

<cfinclude template="../guest-focus/components/footer.cfm">