<cfset page.title ="Guest Loyalty  - Add Points">
<cfset module = 'Guest Loyalty  - Add Points'>
<cfinclude template="/admin/components/header.cfm">  

<cfif isdefined('url.id')>
	<cfquery name="getPointValue" dataSource="#application.dsn#">
	  select * from guest_loyalty_manual_points where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
	</cfquery>
</cfif>

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
  
      <form action="submit-add-points.cfm" method="post" class="form-horizontal" enctype="multipart/form-data">
	  
	  
		  
		   <div class="control-group">
            <label class="control-label">Reason</label>
            <div class="controls">
					<select name="label" style="width:200px;">
						<option value=""> - Select Reason - </option>
						<option value="Bonus Points" <cfif parameterexists(id) and getinfo.label is "Bonus Points">selected</cfif>>Bonus Points</option>
						<option value="Refund Points" <cfif parameterexists(id) and getinfo.label is "Refund Points">selected</cfif>>Refund Points</option>
						<option value="Other" <cfif parameterexists(id) and getinfo.label is "Other">selected</cfif>>Other</option>
					</select>
					<input maxlength="255" name="labelOther" type="text" style="width:300px" placeholder="Other" />
            </div>
         </div>
		 
		 
					
         

         <div class="control-group">
            <label class="control-label">Points To Add</label>
            <div class="controls">
               <input maxlength="255" name="PointsToAdd" type="text" <cfif parameterexists(id)>value="#trim(numberformat(getinfo.PointsToAdd,'___.__'))#"</cfif> style="width:100px" />
            </div>
         </div>
		 
		  <div class="control-group">
					<label class="control-label">Internal Message</label>
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

