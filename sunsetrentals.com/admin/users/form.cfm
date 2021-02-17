<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_users where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Users">
<cfset module = 'user'>

<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="index.cfm">go back.</a>
    </div>
  </cfif>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="submit.cfm" method="post" class="form-horizontal" id="usrFrm">
        <div class="control-group">
					<label class="control-label">Name</label>
					<div class="controls">
						<input maxlength="255" name="name" type="text" <cfif parameterexists(id)>value="#getinfo.name#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						<input maxlength="255" name="email" type="text" id="email" <cfif parameterexists(id)>value="#getinfo.email#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Password</label>
					<div class="controls">
						<input maxlength="255" name="password" type="text">
						<p>Cannot reveal password, can only update it</p>
					</div>
				</div>
				<div class="form-actions">
					<input type="submit" value="Save changes" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

<style type="text/css">.error {color: red; font-weight: bold;}</style>

<script type="text/javascript">
  $(document).ready(function() {
    $.validator.addMethod("pwcheck", function(value) {
       return /^[A-Za-z0-9\d=!\-@$%&._*^#)(]*$/.test(value) // consists of only these
           && /[a-z]/.test(value) // has a lowercase letter
           && /[=!\-@$%&._*^#)(]/.test(value) // has a special character
           && /\d/.test(value) // has a digit
    });
    $("#usrFrm").validate({
      rules: {
        name: {
            required: true,
            minlength: 2
        },
        email: {
            required: true,
            email: true
        },
        password: {
            required: true,
            pwcheck: true,
            minlength: 6
        }
      },
      messages: {
        name: {
            required: "Name is required"
        },
        email: {
            required: "A valid email is required"
        },
        password: {
            required: "A password must be provided",
            pwcheck: "The password must contain letters, at least one number, and at least one special character such as ! @ $ %  ( ) & *",
            minlength: "The password must be at least 6 characters long"
        }
      }
    });
  });
</script>