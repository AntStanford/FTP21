
	
<!--- Check and see if this property has a special --->
<cfquery name="specialsUnitCheck" dataSource="#settings.dsn#">
SELECT specialID 
FROM cms_specials_properties 
WHERE unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">
      AND active = 'yes'
</cfquery>

<cfif specialsUnitCheck.recordcount gt 0>
	
	<!--- We know the unit is part of a special, now make sure that the special is still valid based on the start date/end date. --->		
	<cfquery name="confirmValidSpecial" dataSource="#settings.dsn#">
	SELECT * 
  FROM cms_specials 
  WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#specialsUnitCheck.specialID#">
		    AND now() BETWEEN startdate AND enddate
        AND active = 'yes'
	</cfquery> 
	
	<cfif confirmValidSpecial.recordcount gt 0>
		
		<cfoutput>
		<div class="property-specials">
		  <div class="property-special">
		    <span class="special-icon fa-stack">
		      <i class="fa fa-certificate fa-stack-2x site-color-2" aria-hidden="true"></i>
		      <i class="fa fa-exclamation fa-stack-1x text-white" aria-hidden="true"></i>
		    </span>
		    <p class="h3">#confirmValidSpecial.title#</p>
		    <p>#confirmValidSpecial.description#</p>
		    <small><i>Offer expires #DateFormat(confirmValidSpecial.enddate,'mm/dd/yyyy')# and you must book your vacation between #DateFormat(confirmValidSpecial.allowedBookingStartDate,'mm/dd/yyyy')# and #DateFormat(confirmValidSpecial.allowedBookingEndDate,'mm/dd/yyyy')#.</i></small>
		  </div>
		</div>
		</cfoutput>
		
	</cfif>
	
</cfif>
	
