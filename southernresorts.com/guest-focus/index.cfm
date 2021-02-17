<cfinclude template="/guest-focus/components/header.cfm">

<cfquery name="getStates" dataSource="booking_clients">
	select name_short from states order by name_short
</cfquery>

<div class="logo-wrap text-center">
  <img src="../guest-focus/images/layout/icnd-logo.png">
</div>

<div class="login-wrap">

  <cfif isdefined('url.confirmaccount')>
    <div class="alert alert-success">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      We have sent an email to your address. Please open the email and click on the link to confirm your registration.
    </div>
  </cfif>

  <cfif isdefined('url.error') and url.error eq 'dup'>
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      That user already exists. Did you forget your password? <a href="javascript:;" data-toggle="modal" data-target="#forgotPasswordModal">Click here to request a new one.</a>
    </div>
  </cfif>

  <cfif isdefined('url.activated')>
    <div class="alert alert-success">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      Success! Your account has been activated, please login using the form below.
    </div>
  </cfif>

  <cfif isdefined('url.error') and url.error eq 'notoken'>
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      Whoops! Sorry, we could not find your user.
    </div>
  </cfif>

  <div class="alert alert-info forgot-password-alert hidden">
 		<button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
		</button>
    <p>Please check your email to continue.</p>
  </div>

  <div class="login-tabs">
    <a href="javascript:;" class="btn btn-lg btn-info active" data-tab="accountLogin">Account Login</a>
    <a href="javascript:;" class="btn btn-lg btn-success" data-tab="createAnAccount">Create an Account</a>
  </div>

  <div class="login-form-wrap">

    <div class="login-form-item<cfif isdefined('url.error') and url.error eq 'dup'> hidden</cfif>" id="accountLogin">
      <h3>Account Login <a href="javascript:;" class="btn btn-sm btn-default pull-right" data-toggle="modal" data-target="#forgotPasswordModal">Forgot Password?</a></h3>
      <form class="form-horizontal" id="loginform" method="post" action="submit.cfm" novalidate="novalidate">
        <input type="hidden" name="action" value="login">
        <div class="control-group">
          <div class="controls">
            <label for="email">Email Address</label>
            <input type="text" placeholder="Email Address" class="form-control required email valid" name="email" required="" value="">
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
            <label for="password">Password</label>
            <input type="password" placeholder="Password" class="form-control required valid" name="password" required="" value="">
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
            <button class="btn btn-lg btn-block btn-primary" name="GuestLogin">Log In</button>
          </div>
        </div>
      </form>
      <cfif isdefined('url.error') and url.error eq 'user'>
      	<div class="alert alert-danger">
      		User not found. Please try again.
      	</div>
      <cfelseif isdefined('url.error') and url.error eq 'form'>
      	<div class="alert alert-danger">
      		Both email and password are required fields, please try again.
      	</div>
      </cfif>
      <cfif isdefined('url.logout')>
  		  <cfcookie name="GuestFocusLoggedInID" expires="NOW">
  		  <cfcookie name="GuestFocusLoggedInName" expires="NOW">
  		  <div class="alert alert-success">
  		    You have successfully logged out.
  		  </div>
  		</cfif>
    </div>

    <div class="login-form-item<cfif isdefined('url.error') and url.error eq 'dup'><cfelse> hidden</cfif>" id="createAnAccount">
      <h3>Create an Account</h3>
      <form class="form-horizontal" id="createaccountform" method="post" action="submit.cfm" novalidate="novalidate">
        <input type="hidden" name="action" value="createaccount">
        <div class="row">
          <div class="control-group col-md-6">
            <div class="controls">
              <label>First Name</label>
              <input type="text" placeholder="First Name" class="form-control required" name="firstname" value="" aria-required="true">
            </div>
          </div>
          <div class="control-group col-md-6">
            <div class="controls">
              <label>Last Name</label>
              <input type="text" placeholder="Last Name" class="form-control required" name="lastname" value="" aria-required="true">
            </div>
          </div>
        </div>
         <div class="control-group">
          <div class="controls">
              <label>Email Address</label>
            <input type="text" placeholder="Email Address" class="form-control required email valid" name="email" value="" aria-required="true" aria-invalid="false">
          </div>
        </div>
       <!---
        <div class="control-group">
          <div class="controls">
              <label>Phone Number</label>
            <input type="text" placeholder="Phone Number" class="form-control" name="phone" value="">
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
              <label>Address</label>
            <input type="text" placeholder="Address" class="form-control address" name="address" value="" aria-required="true">
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
              <label>City</label>
            <input type="text" placeholder="City" class="form-control city" name="City" value="" aria-required="true">
          </div>
        </div>
        <div class="row">
          <div class="control-group col-md-6">
            <div class="controls">
              <label>State</label>
              <select id="state" name="state" class="form-control">
      				<option value=" ">- Choose One -</option>
      				<cfloop query="getStates">
      					<option><cfoutput>#name_short#</cfoutput></option>
      				</cfloop>
    			  </select>
            </div>
          </div>
          <div class="control-group col-md-6">
            <div class="controls">
              <label>Zip</label>
              <input type="text" placeholder="Zip" class="form-control zip" name="Zip" value="" aria-required="true">
            </div>
          </div>
        </div>
--->
        <div class="row">
          <div class="control-group col-md-6">
            <div class="controls">
              <label>Password</label>
              <input type="password" placeholder="Password" class="form-control required valid" name="password" id="password" value="" aria-required="true" aria-invalid="false">
            </div>
          </div>
          <div class="control-group col-md-6">
            <div class="controls">
              <label>Re-Enter Password</label>
              <input type="password" placeholder="Re-Enter Password" class="form-control required" name="password_again" value="" aria-required="true">
            </div>
          </div>
        </div>
        <div class="control-group">
          <div class="well input-well">
            <input id="optinGuestFocus" name="optin" type="checkbox" value="Yes"> <label for="optinGuestFocus">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br>
            You can unsubscribe at anytime. <a href="/privacy-policy.cfm" target="_blank">Privacy Policy</a></label>
          </div>
        </div>
        <div class="control-group">
          <div class="controls">
            <button class="btn btn-lg btn-block btn-primary" name="GuestSubcriber">Sign Me Up!</button>
          </div>
        </div>
      </form>
    </div>

  </div>

</div>

<!-- Forgot Password Modal -->
<div class="modal fade" id="forgotPasswordModal" tabindex="-1" role="dialog" aria-labelledby="forgotPasswordModal">
  <div class="modal-dialog" role="document">
    <form id="forgotPasswordForm">
      <input type="hidden" name="action" value="forgotPassword">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="myModalLabel">Forgot Password?</h4>
        </div>
        <div class="modal-body">
          <p>Please enter your email address below, we will send your password to your email address.</p>
          <div class="form-group">
            <label for="forgotPasswordEmailAddress">Email Address <span style="color:red;">*</span></label>
            <input type="email" name="email" placeholder="Email Address" id="forgotPasswordEmailAddress" class="form-control required" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-primary">Send</button>
        </div>
      </div>
    </form>
  </div>
</div>

<cfinclude template="../guest-focus/components/footer.cfm">