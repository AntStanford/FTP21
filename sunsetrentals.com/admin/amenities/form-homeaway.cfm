<cfset page.title ="Manage Your Amenities">
<cfset module = 'amenity'>
<cfinclude template="/admin/components/header.cfm">

<cfset amenityList = ''>
<cfquery name="getAmenities" dataSource="#settings.booking.dsn#">
	select distinct featureList from pp_propertyinfo
</cfquery>

<cfloop query="getAmenities">
	<cfset amenityList = ListAppend(amenityList,getAmenities.featureList)>
</cfloop>

<cfset amenityList = ListRemoveDuplicates(amenityList)>
<cfset amenityList = ListSort(amenityList,'text')>

<cfif isdefined('url.amenity') and isdefined('url.btnSubmit')>
	
	<!--- First, make sure it doesn't already exist. --->
	<cfquery name="amenityCheck" dataSource="#settings.dsn#">
		select title from cms_amenities where title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">
	</cfquery>
	
	<cfif amenityCheck.recordcount eq 0>
	
			<!--- use the title to create a unique ID by removing all special characters and spaces; we will use this unique_id value on the front end ---> 
		   <cfset newString = replace(url.amenity,' ','','all')>
		   <cfset newString = replace(newString,'(','','all')>
		   <cfset newString = replace(newString,')','','all')>
		   <cfset newString = replace(newString,'-','','all')>
		   <cfset newString = replace(newString,'/','','all')>	
		   <cfset newString = replace(newString,'$','','all')>	
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_amenities(title,unique_id) 
				values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.amenity#">,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Amenity#newString#">)
			</cfquery>
			
			<div class="alert alert-success">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>The amenity was added.</strong>
		    </div>
    
    <cfelse>
    		
    		<div class="alert alert-danger">
		      <button class="close" data-dismiss="alert">x</button>
		      <strong>That amenity has already been added; please choose a different one.</strong>
		    </div>
    		
    </cfif>
    
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
					<label class="control-label">Choose amenity</label>
					<div class="controls">
						<select name="amenity" style="width:300px">
							<option value=" ">- Select One -</option>
							<cfloop list="#amenityList#" index="i">
								<option>#upperFirst(i)#</option>
							</cfloop>  					
						</select>
					</div>
				</div>
				
				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary" name="btnSubmit">
			   </div>				
				
		</form>
				
				
    </div>
  </div>
  
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">