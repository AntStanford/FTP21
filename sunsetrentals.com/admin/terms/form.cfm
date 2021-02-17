<cfquery name="getinfo" dataSource="#application.dsn#">
	select terms from cms_terms where id = 1
</cfquery>

<cfset page.title ="Terms and Conditions">
<cfset module = 'terms and conditions'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong>
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Use the form below to add your terms and conditions for the checkout page</h5>
    </div>
    <div class="widget-content nopadding">
           
         
      <form action="submit.cfm" method="post" class="form-horizontal">         
        
        <div class="control-group">
					<label class="control-label"></label>
					<div class="controls">
						<textarea name="terms">#getinfo.terms#</textarea>
					</div>
				</div>
				<div class="form-actions">
				  <input type="submit" value="Submit" class="btn btn-primary" name="submit">
				</div>
  		</form> 

    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">