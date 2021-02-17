<cfif isdefined('session.booking.getResults')>

	<cfquery dbtype="query" name="tmpMapData">
		SELECT
			seopropertyname,
			propertyid as unitcode,
			defaultPhoto as MAPPHOTO,
			name as unitshortname,
			bedrooms as bedrooms,
			bathrooms,
			sleeps as maxoccupancy,
			minprice as MapPrice,
			latitude,
			longitude
		FROM 	session.booking.getResults
	</cfquery>

</cfif>

<cfset variables.propJson = '' />

<cfset variables.firstWrite = true />

<cfset lastProp = structNew() />
<cfset lastProp.seopropertyname = '' />
<cfset lastProp.unitcode = '' />
<cfset lastProp.mapphoto = '' />
<cfset lastProp.unitshortname = '' />
<cfset lastProp.bedrooms = '' />
<cfset lastProp.bathrooms = '' />
<cfset lastProp.maxoccupancy = '' />
<cfset lastProp.latitude = '' />
<cfset lastProp.longitude = '' />
<cfset lastProp.mapprice = '' />
<cfset lastProp.camefromsearchform = 'yes' />

<cfset returnJson = '{"COLUMNS": ["SEOPROPERTYNAME", "UNITCODE", "MAPPHOTO", "UNITSHORTNAME", "BEDROOMS", "BATHROOMS", "MAXOCCUPANCY", "LATITUDE", "LONGITUDE", "MAPPRICE", "ISARRAY", "PROPARRAY"], "DATA": [' />

<cfif isdefined('tmpMapData') and isquery(tmpMapData)>

	<cfloop query="tmpMapData">

		<!--- strip out double quotes from unit name so the map will work --->
		<cfset tmpMapData.unitshortname = replace(tmpMapData.unitshortname,'"','','all')>

		<cfset returnJson &= '["#tmpMapData.seopropertyname#","#tmpMapData.unitcode#","https://img.trackhs.com/180x100/#tmpMapData.MAPPHOTO#","#tmpMapData.unitshortname#","#tmpMapData.bedrooms#","#tmpMapData.bathrooms#","#tmpMapData.maxoccupancy#","#tmpMapData.latitude#","#tmpMapData.longitude#","#tmpMapData.MapPrice#",0,""]' />

		<cfif tmpMapData.currentrow neq tmpMapData.recordcount>
			<cfset returnJson &= ',' />
		</cfif>

	</cfloop>
</cfif>

<cfset returnJson &= ']}' />

<cfoutput>#returnJson#</cfoutput>