<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="booking_clients">
    select * from cms_training_videos where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Training Videos">
<cfset module = 'Training Videos'>
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
  
      <form action="submit.cfm" method="post" class="form-horizontal">
               
        <div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						<input maxlength="255" name="title" type="text" <cfif parameterexists(id)>value="#getinfo.title#"</cfif>>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Link</label>
					<div class="controls">
						<input maxlength="255" name="Link" type="text" <cfif parameterexists(id)>value="#getinfo.Link#"</cfif>>
					</div>
				</div>
        <div class="control-group">
					<label class="control-label">Decription</label>
					<div class="controls">
						
            <textarea name="description" rows="4" cols="30" id="txtContent">
               <cfif parameterexists(id)>#getinfo.description#</cfif>
            </textarea>
                        
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