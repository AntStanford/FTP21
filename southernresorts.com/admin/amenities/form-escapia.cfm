<cfset page.title ="Manage Your Amenities">
<cfset module = 'amenity'>
<cfinclude template="/admin/components/header.cfm">

<cfquery name="getAmenityCategories" dataSource="#settings.booking.dsn#">
	select distinct escapia_amenities.category from escapia_amenities order by escapia_amenities.category
</cfquery>

<cfif isdefined('url.id')>
	<cfquery name="getinfo" dataSource="#dsn#">
	   select * from cms_amenities where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
	</cfquery>
	<cfquery name="getCategoryAmenities" dataSource="#settings.booking.dsn#">
		select distinct categoryvalue from escapia_amenities where category = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.category#">
	</cfquery>
</cfif>

<cfif isdefined('url.category')>
	<cfquery name="getCategoryAmenities" dataSource="#settings.booking.dsn#">
		select distinct categoryvalue from escapia_amenities where category = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.category#">
	</cfquery>
</cfif>

<cfif isdefined('url.category') and isdefined('url.amenity') and isdefined('url.btnSubmit')>

	<!--- First, make sure it doesn't already exist. --->
	<cfquery name="amenityCheck" dataSource="#settings.dsn#">
		select title from cms_amenities where title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">
	</cfquery>

	<!--- use the title to create a unique ID by removing all special characters and spaces; we will use this unique_id value on the front end ---> 
	<cfset newString = replace(url.amenity,' ','','all')>
	<cfset newString = replace(newString,'(','','all')>
	<cfset newString = replace(newString,')','','all')>
	<cfset newString = replace(newString,'-','','all')>
	<cfset newString = replace(newString,'/','','all')>	
    <cfset newString = replace(newString,'$','','all')>	
	
	<cfif amenityCheck.recordcount eq 0 and !isdefined('url.id')>			
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_amenities(title,category,unique_id) 
				values(	<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.category#">,
						<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Amenity#newString#">
					)
			</cfquery>
			
			<div class="alert alert-success">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>The amenity was added.</strong>
		    </div>
    
    <cfelseif isDefined('url.id')>
    		<cfquery dataSource="#settings.dsn#">
				UPDATE cms_amenities
				SET title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">,
					category = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.category#">,
					unique_id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Amenity#newString#">
				WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
			</cfquery>
			
			<div class="alert alert-success">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>The amenity was Updated.</strong>
		    </div>

		    <cflocation url="form-escapia.cfm?id=#url.id#&updated">
    <cfelse>
    		
    		<div class="alert alert-danger">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>That amenity has already been added; please choose a different one.</strong>
		    </div>
    		
    </cfif>
    
</cfif>

<cfif isdefined('url.updated')>
	<div class="alert alert-success">
      <button class="close" data-dismiss="alert">x</button>
      <strong>The amenity was Updated.</strong>
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
      	<cfif isdefined('url.id')>
      		<input type="hidden" name="id" value="#url.id#">
      	</cfif>
            								
            <div class="control-group">
					<label class="control-label">Choose category</label>
					<div class="controls">
						<select name="category" style="width:300px" onchange="javascript:this.form.submit();">
							<option value=" ">- Select One -</option>
							<cfloop query="getAmenityCategories">
								<option <cfif (isdefined('url.category') and url.category eq getAmenityCategories.category) or (isdefined('url.id') and getinfo.category eq getAmenityCategories.category)>selected</cfif>>#category#</option>
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
									<option value="#upperFirst(categoryvalue)#" <cfif isdefined('url.id') and getinfo.title eq getCategoryAmenities.categoryvalue>selected</cfif>>#upperFirst(categoryvalue)#</option>
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