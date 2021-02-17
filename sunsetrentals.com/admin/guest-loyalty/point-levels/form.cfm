<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from guest_loyalty_point_levels where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfset page.title ="Guest Loyalty Point Levels">
<cfset module = 'Guest Loyalty Point Level'>
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
      <strong>Insert successful!</strong> Add another #module# or <a href="index.cfm">go back.</a>
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
					<label class="control-label">Points</label>
					<div class="controls">
						<input maxlength="255" name="points" type="text" <cfif parameterexists(id)>value="#getinfo.points#"</cfif>>
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