<cfset page.title ="Guest Loyalty  - Redeem Points">
<cfset module = 'Guest Loyalty  - Redeem Points'>
<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.id')>
	<cfquery name="getPointValue" dataSource="#application.dsn#">
	  select * from guest_loyalty_redeem_points where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
	</cfquery>
</cfif>

<cfquery name="getProperties" dataSource="#settings.dsn#">
	select strpropid,strname from pp_propertyinfo order by strname
</cfquery>

<cfquery name="getPointLevels" dataSource="#application.dsn#">
  select * from guest_loyalty_point_levels order by points
</cfquery>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
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
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form action="submit-redeem-points.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
	  
			<div class="control-group">
					<label class="control-label">Property</label>
					<div class="controls">
						<select name="property" style="width:300px;">
							<cfloop query="getProperties">
								<option value="#strpropid#">#strname#</option>
							</cfloop>
						</select>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Reason</label>
					<div class="controls">
						<select name="reason" style="width:300px;">
							<cfloop query="getPointLevels">
								<option>#title#</option>
							</cfloop>
							<option>Other</option>
						</select>
					</div>
				</div>
				
         <div class="control-group">
            <label class="control-label">Points To Redeem</label>
            <div class="controls">
               <input maxlength="255" name="pointsRedeemed" type="text" <cfif parameterexists(id)>value="#trim(numberformat(getinfo.pointsRedeemed,'___.__'))#"</cfif> style="width:100px" />
            </div>
         </div>
		 
		  <div class="control-group">
					<label class="control-label">Comments</label>
					<div class="controls">
						<textarea name="comments"><cfif parameterexists(id)>#getinfo.comments#</cfif></textarea>
					</div>
			</div>



				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
		  			<input type="hidden" name="email" value="#email#">
				</div>
      </form>
    
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

