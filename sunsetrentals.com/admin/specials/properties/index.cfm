<cfset page.title ="Property Specials">

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
   
   <cfquery name="getAllProperties" dataSource="#settings.booking.dsn#">
     select id as unitcode, shortName as unitshortname, streetAddress as address 
     from track_properties
     order by shortName
   </cfquery>
      
</cfif>  


<!--- make all units active for this special --->
<cfif isdefined('url.selectall')>

	<cfloop query="getAllProperties">
		
		<cfquery name="doesUnitExist" dataSource="#settings.dsn#">
			select unitcode from cms_specials_properties 
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#"> 
			and specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.specialid#">
		</cfquery>
		
		<cfif doesUnitExist.recordcount eq 0>
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_specials_properties(specialid,unitcode,active) 
				values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#">,
				'Yes'
				) 
			</cfquery>
			
		<cfelse>
		
			<cfquery dataSource="#settings.dsn#">
				update cms_specials_properties set
				active = 'Yes'
				where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#">
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
			where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#"> 
			and specialid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.specialid#">
		</cfquery>
		
		<cfif doesUnitExist.recordcount eq 0>
			
			<cfquery dataSource="#settings.dsn#">
				insert into cms_specials_properties(specialid,unitcode,active) 
				values(
				<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.specialid#">,
				<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#">,
				'No'
				) 
			</cfquery>
			
		<cfelse>
		
			<cfquery dataSource="#settings.dsn#">
				update cms_specials_properties set
				active = 'No'
				where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#">
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

<cfoutput>
<p>
   <a href="/admin/specials/index.cfm" class="btn btn-success"><i class="icon-chevron-left icon-white"></i>Back to the Specials Page</a>
   <a style="margin-left:10px" href="index.cfm?specialid=#url.specialid#&selectall" class="btn btn-success pull-right"><i class="icon-tags icon-white"></i> Select All</a>
   <a href="index.cfm?specialid=#url.specialid#&deselectall" class="btn btn-success pull-right"><i class="icon-tags icon-white"></i> De-Select All</a>
</p>
</cfoutput>


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
			select * from getSpecialProperties where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getAllProperties.unitcode#">
		</cfquery>
      
      <tr>
			<td width="45">#currentrow#.</td>
			<td>#unitshortname#</td>
			<td><input type="text" name="priceWas_#unitcode#" value="#propCheck.pricewas#"></td>
			<td><input type="text" name="priceIs_#unitcode#" value="#propCheck.pricereducedto#"></td>
			<td width="50"><a href="javascript:;" class="btn btn-info updatePricing" data-unitcode="#unitcode#"> Update</a></td>
			<cfif propCheck.recordcount gt 0 and propCheck.active eq 'yes'>
				<td><input type="checkbox" checked="checked" data-toggle="toggle" class="toggle-event" data-unitcode="#unitcode#"></td>
			<cfelse>
				<td><input type="checkbox" data-toggle="toggle" class="toggle-event" data-unitcode="#unitcode#"></td>
			</cfif>
      </tr>
    </cfoutput>
    </table>
  </div>
</div>


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