<cfset page.title ="Property Specials">
<cfparam name="url.areaid" default="0">
<cfparam name="url.resortid" default="0">

<cfif settings.booking.pms eq 'Homeaway'>
   
   <cfquery name="getAllProperties" dataSource="#settings.booking.dsn#">
     select strpropid as unitcode,strname,straddress2 
     from pp_propertyinfo
     order by strname
   </cfquery>

<cfelseif settings.booking.pms eq 'Barefoot'>
   
   <cfquery name="getAllProperties" dataSource="#settings.booking.dsn#">
     select propertyid as unitcode,name,propaddress 
     from bf_properties
     order by name
   </cfquery>
   
<cfelseif settings.booking.pms eq 'Escapia'>
   
   <cfquery name="getAllProperties" dataSource="#settings.booking.dsn#">
     select unitcode,unitshortname,address 
     from escapia_properties
     order by unitshortname
   </cfquery>
      
<cfelseif settings.booking.pms eq 'Track'> 
   <cfif url.areaid gt 0>
	   <cfquery name="getAllProperties" dataSource="#settings.booking.dsn#">
	      select track_properties.id,track_properties.name,track_properties.streetaddress 
	     from track_properties
		 left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
					left join track_nodes ndsa ON track_properties.nodeId = ndsa.id 
					left join track_nodes nds2 on nds2.id = ndsa.parentid
					left join track_nodes nds3 on nds3.id = nds2.parentid
	     where
	     <cfif url.resortid gt 0>
	     	nodeid = #url.resortid#
	     <cfelseif url.resortid eq -1>
	     	nodeid = #url.AreaID#
	     <cfelse> 
		      
			 
			 ((nds.typeid = 3 AND nds.id = #url.AreaID#) 
		OR
		(nds2.typeid = 3 AND nds2.id = #url.AreaID#) 
		OR
		(nds3.typeid = 3 AND nds3.id = #url.AreaID#)
			 )
	     </cfif>
	     order by name
	   </cfquery>
    </cfif> 
</cfif>  

<cfquery name="getAllAreas" datasource="#settings.booking.dsn#">
SELECT name, id FROM southernresorts.track_nodes where typeId = 3;
</cfquery>

<cfquery name="getAllResorts" datasource="#settings.booking.dsn#">
SELECT name, id FROM southernresorts.track_nodes where typeId = 5 and ParentID = #url.areaID#;
</cfquery>



<!--- make all units active for this special --->
<cfif isdefined('url.selectall')>

	<cfloop query="getAllProperties">
		
		<cfquery name="doesUnitExist" dataSource="#settings.dsn#">
			select unitcode from cms_specials_properties 
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#"> 
			and specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.specialid#">
		</cfquery>
		
		<cfif doesUnitExist.recordcount eq 0>
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_specials_properties(specialid,unitcode,active) 
				values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#">,
				'Yes'
				) 
			</cfquery>
			
		<cfelse>
		
			<cfquery dataSource="#settings.dsn#">
				update cms_specials_properties set
				active = 'Yes'
				where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#">
				and specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">
			</cfquery>
		
		</cfif>
		
	</cfloop>
	
</cfif>


<!--- make all units in-active for this special --->
<cfif isdefined('url.deselectall')>

	<cfloop query="getAllProperties">
		
		<cfquery name="doesUnitExist" dataSource="#settings.dsn#">
			select unitcode from cms_specials_properties 
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#"> 
			and specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.specialid#">
		</cfquery>
		
		<cfif doesUnitExist.recordcount eq 0>
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_specials_properties(specialid,unitcode,active) 
				values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#">,
				'No'
				) 
			</cfquery>
			
		<cfelse>
		
			<cfquery dataSource="#settings.dsn#">
				update cms_specials_properties set
				active = 'No'
				where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#">
				and specialid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">
			</cfquery>
		
		</cfif>
		
	</cfloop>
	
</cfif>




<cfquery name="getSpecialProperties" dataSource="#application.dsn#">
	SELECT *
	FROM cms_specials_properties
	where specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.specialid#">
</cfquery>


  
<cfinclude template="/admin/components/header.cfm">


<div class="alert alert-success confirmMessage" style="display:none">
	<button class="close" data-dismiss="alert">×</button>
	<strong>Record updated!</strong>
</div>
 <form action="index.cfm">
<cfoutput>
<p>
   <a href="/admin/specials/index.cfm" class="btn btn-success"><i class="icon-chevron-left icon-white"></i>Back to the Specials Page</a>
  
   <select name="AreaID" onchange="this.form.submit()" style="width: 200px">
   		<option value="0">Filter By Area</option>
   		<cfloop query="getAllAreas">
   			<option value="#getAllAreas.id#" <cfif url.areaid eq getAllAreas.id>selected</cfif>>#getAllAreas.name#</option>
   		</cfloop>
   </select>  
   <cfif url.areaid gt 0> 
	   <select name="ResortID" id="ResortID" onchange="this.form.submit()" style="width: 300px">
	   		<option value="0">Filter By Resort</option>
	   		<option value="-1">Properties With No Resort</option>
	   		<cfloop query="getAllResorts">
	   			<option value="#getAllResorts.id#" <cfif url.resortid eq getAllResorts.id>selected</cfif>>#getAllResorts.name#</option>
	   		</cfloop>
	   </select>
   <a style="margin-left:10px" href="index.cfm?specialid=#url.specialid#&areaID=#url.areaID#&resortID=#url.resortID#&selectall" class="btn btn-success pull-right"><i class="icon-tags icon-white"></i> Select All</a>
   <a href="index.cfm?specialid=#url.specialid#&areaID=#url.areaID#&resortID=#url.resortID#&deselectall" class="btn btn-success pull-right"><i class="icon-tags icon-white"></i> De-Select All</a>
	</cfif>
   <input type="hidden" name="specialid" value="#specialid#">
</p>
</cfoutput>

	</form>
<cfif url.areaid gt 0>
	<div class="widget-box">
	  <div class="widget-content nopadding">
	    <table class="table table-bordered table-striped">
	    <tr>
			<th>No.</th>
			<th>Property</th>
			<th>Price Was</th>
			<th>Price Is</th>
			<th></th>
			<th>Active</th>
	    </tr>
	    <cfoutput query="getAllProperties">
	      
	      <cfquery name="propCheck" dbtype="query">
				select * from getSpecialProperties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.id#">
			</cfquery>
	      
	      <tr>
				<td width="45">#currentrow#.</td>
				<td>#name#</td>
				<td><input type="text" name="priceWas_#id#" value="#propCheck.pricewas#"></td>
				<td><input type="text" name="priceIs_#id#" value="#propCheck.pricereducedto#"></td>
				<td width="50"><a href="javascript:;" class="btn btn-info updatePricing" data-unitcode="#id#"> Update</a></td>
				<cfif propCheck.recordcount gt 0 and propCheck.active eq 'yes'>
					<td><input type="checkbox" checked="checked" data-toggle="toggle" class="toggle-event" data-unitcode="#id#"></td>
				<cfelse>
					<td><input type="checkbox" data-toggle="toggle" class="toggle-event" data-unitcode="#id#"></td>
				</cfif>
	      </tr>
	    </cfoutput>
	    </table>
	  </div>
	</div>
</cfif>

<script type="text/javascript">

	$(function() {
    
    $('.toggle-event').change(function() {
      
      var unitcode = $(this).data('unitcode');      
      var status = $(this).prop('checked');
      
      //active = true
      //deactivate = false
      
		$.ajax({
			url: 'update-status.cfm?unitcode='+unitcode+'&specialid=<cfoutput>#url.specialid#</cfoutput>&status='+status,
			success: function(data) {
				$('div.confirmMessage').show();
			}
		});
      
      
    });
    
    $('a.updatePricing').click(function(){
    	
    	var unitcode = $(this).data('unitcode');
    	var pricewas = $('input[name=priceWas_'+unitcode+']').val();
    	var priceis = $('input[name=priceIs_'+unitcode+']').val();
    	
    	$.ajax({
			url: 'update-pricing.cfm?unitcode='+unitcode+'&specialid=<cfoutput>#url.specialid#</cfoutput>&pricewas='+pricewas+'&priceis='+priceis,
			success: function(data) {
				$('div.confirmMessage').show();
			}
		});
    
    });
    
    
  })

</script>

<cfinclude template="/admin/components/footer.cfm">