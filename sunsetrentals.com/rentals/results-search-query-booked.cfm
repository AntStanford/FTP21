<!--- <cfdump var="#session.booking#"> --->
<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate
	AND isdefined('session.booking.strCheckin') AND isValid('date', session.booking.strCheckin)
	AND isdefined('session.booking.strCheckout') AND isValid('date', session.booking.strCheckout)>
	
		<cfquery name="getNumberOf" dataSource="#settings.booking.dsn#">
		SELECT count(distinct id) as bookedProperties
		FROM track_properties
		WHERE 1=1
			    AND id IN (SELECT distinct propertyid 
                     FROM track_properties_availability 
                     WHERE <cfqueryparam value="#session.booking.strCheckin#" cfsqltype="cf_sql_date"> = theDate
			)
			<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">
		</cfquery>	


	<cfif isdefined('getNumberOf.bookedProperties') and isdefined('cookie.numresults')>
		
		<cfset totalPropertiesThatMatch = getNumberOf.bookedProperties + cookie.numresults>
		
		<cfif getNumberOf.bookedProperties gt 0 and totalPropertiesThatMatch gt 0>
			<cfset PercentBooked = (getNumberOf.bookedProperties / totalPropertiesThatMatch)>
			<cfset PercentBooked = 1 - PercentBooked>
			<cfset PercentBooked = PercentBooked*100>
			<cfset PercentBooked = 100-PercentBooked>

			<cfif PercentBooked gt 30 and PercentBooked lt 100>
				<cfset displayThis = PercentBooked>
			</cfif>
		
			<cfif isdefined('returnValue') and getNumberOf.bookedProperties gt 0>
				<cfoutput>#PercentBooked#</cfoutput>
			</cfif>
		</cfif>
		
	</cfif>

</cfif>






