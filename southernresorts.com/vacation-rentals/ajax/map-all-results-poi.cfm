<cfif CGI.HTTP_REFERER eq "https://southernresorts.com/vacation-rentals/results" and isdefined('session.booking.resort.getResults')>

	<cfquery dbtype="query" name="tmpMapData">
		SELECT
			seopropertyname,
			isproperty,
		    seoDestinationName,
			propertyid as unitcode,
			defaultPhoto as MAPPHOTO,
			name as unitshortname,
			bedrooms as bedrooms,
			bedroomsrange,
			bathrooms,
			bathroomsRange,
			sleeps as maxoccupancy,
			sleepsrange,
			minprice as MapPrice,
			latitude,
			longitude
		FROM 	session.booking.resort.getResults
	</cfquery>

<cfelseif isdefined('session.booking.getResults')>

	<cfquery dbtype="query" name="tmpMapData">
		SELECT
			seopropertyname,
			isproperty,
		    seoDestinationName,
			propertyid as unitcode,
			defaultPhoto as MAPPHOTO,
			name as unitshortname,
			bedrooms as bedrooms,
			bedroomsrange,
			bathrooms,
			bathroomsRange,
			sleeps as maxoccupancy,
			sleepsrange,
			minprice as MapPrice,
			latitude,
			longitude
		FROM 	session.booking.getResults
	</cfquery>

</cfif>
<cfquery  name="poiMapData" datasource="#settings.dsn#">
    SELECT
        cms_map.title,
        cms_map_categories.title AS category,
        cms_map.latitude,
        cms_map.longitude
    FROM
        cms_map_categories
    JOIN cms_map
    ON cms_map_categories.id = cms_map.catID
</cfquery>


<cfset variables.propJson = '' />

<cfset variables.firstWrite = true />

<cfset lastProp = structNew() />
<cfset lastProp.seopropertyname = '' />
<cfset lastProp.seodestinationname = '' />
<cfset lastProp.unitcode = '' />
<cfset lastProp.mapphoto = '' />
<cfset lastProp.unitshortname = '' />
<cfset lastProp.bedrooms = '' />
<cfset lastProp.bathrooms = '' />
<cfset lastProp.maxoccupancy = '' />
<cfset lastProp.latitude = '' />
<cfset lastProp.longitude = '' />
<cfset lastProp.mapprice = '' />


<cfset returnJson = '{"COLUMNS": ["ISPROPERTY","TYPE","SEOPROPERTYNAME","SEODESTINATIONNAME", "UNITCODE", "MAPPHOTO", "UNITSHORTNAME", "BEDROOMS", "BATHROOMS", "MAXOCCUPANCY", "LATITUDE", "LONGITUDE", "MAPPRICE", "ISARRAY", "PROPARRAY"], "DATA": [' />

<cfif isdefined('tmpMapData') and isquery(tmpMapData)>

	<cfloop query="tmpMapData">

		<!--- strip out double quotes from unit name so the map will work --->
		<cfset tmpMapData.unitshortname = replace(tmpMapData.unitshortname,'"','','all')>

		<cfif isDefined('tmpMapData.bedroomsrange') and tmpMapData.bedroomsrange contains '-'>
			<cfset local.bedroomCnt = replace(tmpMapData.bedroomsrange,'abc','')>
		<cfelse>
			<cfset local.bedroomCnt = tmpMapData.bedrooms>
		</cfif>

		<cfset returnJson &= '["#tmpMapData.isproperty#","property","#tmpMapData.seopropertyname#","#tmpMapData.seodestinationname#","#tmpMapData.unitcode#","https://img.trackhs.com/180x100/#tmpMapData.mapphoto#","#tmpMapData.unitshortname#","#local.bedroomCnt#","#replace(tmpMapData.bathroomsrange,"abc","")#","#replace(tmpMapData.sleepsrange,"abc","")#","#tmpMapData.latitude#","#tmpMapData.longitude#","#tmpMapData.MapPrice#",0,""]' />

		<!--- <cfif tmpMapData.currentrow neq tmpMapData.recordcount> --->
			<cfset returnJson &= ',' />
		<!--- </cfif> --->

    </cfloop>
    </cfif>

    <cfloop query="poiMapData">
        <cfset returnJson &= '["false","#poiMapData.category#","","","","","#poiMapData.title#","","","","#poiMapData.latitude#","#poiMapData.longitude#","",0,""]' />

		<cfif poiMapData.currentrow neq poiMapData.recordcount>
			<cfset returnJson &= ',' />
		</cfif>
    </cfloop>






<cfset returnJson &= ']}' />
<cfheader name="Content-Type" value="application/json">
<cfoutput>#returnJson#</cfoutput>
