
<cfset page.title ="Full Data Harvest Request">
<cfset module = 'Full Data Harvest Request'>
<cfinclude template="/admin/components/header.cfm">

<cfoutput>

  <cfif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Data Harvest Request Successful. You will receive an email when the task has completed.  10 minutes approximately.</strong> 
    </div>
  </cfif>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Data Harvest Request Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form action="submit.cfm" method="post" class="form-horizontal">
      
        		<div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						<input maxlength="255" name="RequestFullUpdateEmail" type="text" <cfif parameterexists(id)>value="#getinfo.RequestFullUpdateEmail#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label"></label>
					<div class="controls">
						<p>This allows you to request a full data harvest from your PMS into ICND's database.  If you have to initiate a harvest after the initial request - you must wait until you have received email notification that the first data harvest has completed.  Not following these rules could cause data corruption.</p>

<p>Please email <a href="mailto:support@icoastalnet.com">support@icoastalnet.com</a> with the exact details if you still have issues after this task runs.  Please provide exact detail, URL, what you are seeing and what you should be seeing.  The more detail you can provide the better we can quickly troubleshoot.</p>

<p>Thank you very much!<br>
Team ICND!
</p>


					</div>
				</div>
    
				<div class="form-actions">
				  <input type="submit" value="Submit" class="btn btn-primary">
				</div>
  		</form> 

    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">