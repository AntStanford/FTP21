<cfset page.title ="CallOuts">
<cfset module = 'callout'>
<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_callouts where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
  </cfquery>
</cfif>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
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

      <form action="submit.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
        <div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						<input type="text" name="title" <cfif parameterexists(id)>value="#getinfo.title#"</cfif>>
					</div>
				</div>

        <div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<textarea name="description" style="height:100px"><cfif parameterexists(id)>#getinfo.description#</cfif></textarea>
					</div>
				</div>
		  <div class="control-group">
					<label class="control-label">Link</label>
					<div class="controls">
						<input type="text" name="link" <cfif parameterexists(id)>value="#getinfo.link#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Image</label>
			    <div class="controls">
			      <div class="uploader" id="uniform-undefined">
			        <input type="file" size="19" name="photo" style="opacity:0;">
			        <span class="filename">No file selected</span>
			        <span class="action">Choose File</span>
			      </div>
			      <div class="help-block">(Image must be resized to 262 by 200 before uploaded; max file size is 200kb)</div>
            <cfif parameterexists(id) and len(getinfo.photo)>
              <br /><img src="/images/callouts/#getinfo.photo#">
            </cfif>
			    </div>
				</div>
				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">