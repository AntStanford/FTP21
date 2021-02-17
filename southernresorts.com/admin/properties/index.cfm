<style>
  label {height:100%;width:100%;text-align: center;}
  .select2-container {height: 80px; overflow: auto;} 
  .amenityytd div .select2-container{ padding-top:14%; }
  .propertytd div{ padding-top:15%; }
</style> 

<cfset page.title ="Properties">
<cfinclude template="/admin/components/header.cfm">

<cfoutput>
  <cfset propertyWithAmenityList = "">

  <cfif structKeyExists(form, "FilterResults")>
    <cfif structKeyExists(form, "amenity") and form.amenity NEQ 'all'>
     <cfquery name="qGetPropertywithAmenity" dataSource="#settings.booking.dsn#">
        select distinct(propertyid)
        from  track_properties_amenities
        where 
        amenityName in (<cfqueryparam list = "true" value="#form.amenity#" cfsqltype="cf_sql_varchar" />)
      </cfquery>

      <cfdump var="#qGetPropertywithAmenity#">

      <cfset propertyWithAmenityList = "#valueList(qGetPropertywithAmenity.propertyid)#">  
    </cfif>
  </cfif>

  <cfquery name="qGetAmenities" datasource="#settings.booking.dsn#">
    SELECT distinct(amenityName) FROM track_properties_amenities order by amenityName ASC
  </cfquery>

  <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
    select 
    id as property_id,
    name as property_name
    from track_properties
    where name is not null
    
    <cfif structKeyExists(form,"property") and form.property NEQ 'all'>
      and id = <cfqueryparam value="#form.property#" cfsqltype="cf_sql_integer" />
    </cfif>

    <cfif isDefined("propertyWithAmenityList") and listLen(propertyWithAmenityList)>
      and id in (<cfqueryparam list="true" value="#propertyWithAmenityList#" cfsqltype="cf_sql_integer">) 
    </cfif>

    order by name
  </cfquery>
  

  <form action="index.cfm" method="post" id="filterProperties">
    <table>
    <tr>
      <!--- <td>Start Date:</td><td><input type="text" class="datepicker" name="StartDate" value="#startdate#"></td>
      <td>End Date:</td><td><input type="text" class="datepicker" name="EndDate" value="#EndDate#"></td>
      <td>Came From:</td><td>
        <select name="CameFrom" style="width: 150px;">
          <option value="all">All</option>
          <!---<option value="PDP" <cfif isdefined('CameFrom') and CameFrom is 'PDP'>selected</cfif>>Property Page</option>--->
          <option value="Checkout" <cfif isdefined('CameFrom') and CameFrom is 'Checkout'>selected</cfif>>Checkout Page</option>
        </select>
      </td> --->
      <td>Amenities:</td>
      <td class="amenityytd">
        <div>
          <select name="amenity" multiple="multiple"  style="width: 200px;">
            <option value="all" value="all">All</option>
            <cfloop query="#qGetAmenities#">
              <option value="#amenityName#" <cfif isdefined('form.amenity') and form.amenity EQ #amenityName#>selected</cfif>>#amenityName#</option>
            </cfloop>
          </select>
        </div>
      </td>
      
      <td>Property:</td>
      <td class="propertytd">
        <select name="property" style="width: 180px;">
          <option value="all" value="all">All</option>
          <cfloop query="#getinfo#">
            <option value="#property_id#" <cfif isdefined('form.property') and form.property EQ #property_id#>selected</cfif>>#property_name#</option>
          </cfloop>
        </select>
      </td>

    <td><input type="submit" class="btn btn-success" name="FilterResults" value="Filter"></td><td><a href="index.cfm" class="btn btn-warning">Reset</a></td>
    </tr>
    </table>
  </form>
  <div class="row-fluid">
    <div class="col-md-12">
      <p>#getinfo.recordcount# properties found!</p>
    </div>
  </div>
</cfoutput>

<!--- <cfquery name="gettp" dataSource="#settings.booking.dsn#">
  select *
  from track_properties
  where id not in (select strpropid from cms_property_enhancements)
  order by shortname
</cfquery>  --->


<!--- <cfoutput query="gettp">
	<cfif isnumeric(id)>
	<cfquery name="update" dataSource="#settings.booking.dsn#">
		insert into cms_property_enhancements(strpropid,seopropertyname,title)
		values(#id#,'#seopropertyname#','#shortname#')
		
	</cfquery>
	</cfif>
</cfoutput> --->

<!--- <cfquery name="gettp" dataSource="#settings.booking.dsn#">
     SELECT * FROM cms_property_enhancements WHERE title NOT IN (SELECT shortname FROM track_properties) 
	</cfquery>
<cfif gettp.recordcount>
	<cfquery name="gettp2" dataSource="#settings.booking.dsn#">
     select 
     *
     from track_properties
		 where id in (#valuelist(gettp.strpropid)#)
   </cfquery>
	
	<cfoutput query="gettp2">
		<cfif len(gettp2.id)>
			
		<cfquery name="update" dataSource="#settings.booking.dsn#">
		update cms_property_enhancements
			set seopropertyname = '#gettp2.seopropertyname#',
			title = '#gettp2.shortname#'
			where strpropid = '#gettp2.id#'
		
		</cfquery>
		</cfif>
	</cfoutput>
	
</cfif> --->

   <!--- <cfquery name="getinfo" dataSource="#settings.booking.dsn#">
     select 
     id as property_id,
     name as property_name
     from track_properties
	   where name is not null
     order by name
   </cfquery>  --->

<!---      
<cfif isdefined('message') and len(message)>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">x</button>
    <strong><cfoutput>#message#</cfoutput></strong>
  </div>
</cfif> --->

<div class="widget-box">
  <div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>  
  	<h5>Properties</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped table-hover">
    
    <cfoutput query="getinfo">
      
      <form method="post" action="form.cfm" id="theForm_#currentrow#">          
         <cfif currentrow eq 1>
         <tr>
            <th>No.</th>
            <th>Unit</th>                         
            <th></th>
         </tr>        
         </cfif>         
         <tr>
            <td><a name="#property_id#"></a>#currentrow#.</td>
            <td>#property_name#</td>                    
            <td colspan="9" style="text-align:right"><a href="form.cfm?id=#property_id#&name=#property_name#" class="btn btn-success">Edit</a></td>            
         </tr>        
       </form> 
    </cfoutput>
    
</table>

<cfinclude template="/admin/components/footer.cfm">