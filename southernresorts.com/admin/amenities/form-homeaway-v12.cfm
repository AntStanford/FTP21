<cfset page.title ="Manage Your Amenities">
<cfset module = 'amenity'>
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getAmenityCategories" dataSource="#settings.booking.dsn#">
	select distinct attribute from pp_attributes order by attribute
</cfquery>

<cfif isdefined('url.category')>
	<cfquery name="getCategoryAmenities" dataSource="#settings.booking.dsn#">
		select distinct attribute_value from pp_attributes where `attribute` = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.category#">
	</cfquery>
</cfif>

<cfif isdefined('url.category') and isdefined('url.amenity') and isdefined('url.btnSubmit')>	
	
			<!--- use the title to create a unique ID by removing all special characters and spaces; we will use this unique_id value on the front end ---> 
		   <cfset newString = replace(url.amenity,' ','','all')>
		   <cfset newString = replace(newString,'(','','all')>
		   <cfset newString = replace(newString,')','','all')>
		   <cfset newString = replace(newString,'-','','all')>
		   <cfset newString = replace(newString,'/','','all')>	
		   <cfset newString = replace(newString,'$','','all')>	
			
			<cfif url.amenity eq 'Yes'>
				
				<cfquery dataSource="#settings.dsn#">
					insert into cms_amenities(title,unique_id) 
					values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.category#">,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Amenity#newString#">)
				</cfquery>
			
			<cfelse>
				
				<cfquery dataSource="#settings.dsn#">
					insert into cms_amenities(title,unique_id) 
					values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Amenity#newString#">)
				</cfquery>
			
			</cfif>			
			
			<div class="alert alert-success">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>The amenity was added.</strong>
		   </div>
        
</cfif>

<cfoutput>
  
  <p><a href="index.cfm" class="btn btn-success"><i class="icon-chevron-left icon-white"></i> Back to Amenity List</a></p>
  
  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">
  
      <form method="get" class="form-horizontal">
            								
            <div class="control-group">
					<label class="control-label">Choose category</label>
					<div class="controls">
						<select name="category" style="width:300px" onchange="javascript:this.form.submit();">
							<option value=" ">- Select One -</option>
							<cfloop query="getAmenityCategories">
								<option <cfif isdefined('url.category') and url.category eq getAmenityCategories.attribute>selected</cfif>>#attribute#</option>
							</cfloop>  					
						</select>
					</div>
				</div>      
            
            <cfif isdefined('getCategoryAmenities')>
					<div class="control-group">
						<label class="control-label">Choose amenity</label>
						<div class="controls">
							<select name="amenity" style="width:300px">
								<option value=" ">- Select One -</option>
								<cfloop query="getCategoryAmenities">
									<option>#attribute_value#</option>
								</cfloop>  					
							</select>
						</div>
					</div>
					
					<div class="form-actions">
						<input type="submit" value="Submit" class="btn btn-primary" name="btnSubmit">
				   </div>
				
				</cfif>
				
		</form>
				
				
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">