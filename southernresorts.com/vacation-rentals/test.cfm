<cfquery name="getAmenities" dataSource="#settings.dsn#">
	select * from cms_amenities order by category
</cfquery> 

<cfset theCategory = getAmenities.category>

<cfoutput>#theCategory#</cfoutput>

<cfloop query="getAmenities">
	
	<cfoutput>
	
	
		
		
		<cfif getAmenities.category eq theCategory>
			
		<cfelse>
			<cfset theCategory = getAmenities.category>
			<p>#theCategory#</p>
		</cfif>
	
	
	
	
	
	
	<li>#title#</li>
	</cfoutput>
	
</cfloop>