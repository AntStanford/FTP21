<cfif cgi.remote_host eq '75.87.66.209' or cgi.remote_host eq '65.188.164.161'>
	<cftry>
		<cfdump var="#settings#" />
		<!---
		<cfhttp method="get" url="#settings.booking.track_api_endpoint#/api/custom-fields/" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#">
			<cfhttpparam type="header" name="Accept" value="*/*">
		</cfhttp>

		<cfif isJSON(cfhttp.filecontent)>
			<cfset variables.cf_json = deserializeJSON(cfhttp.filecontent) />

			<!--- <cfdump var="#variables.cf_json._embedded.customFields#" /> --->

			<cfset customFieldArray = variables.cf_json._embedded.customFields />
			<cfdump var="#customFieldArray[44]#">
		<cfelse>
			Something broke
		</cfif>
		--->
		<!--- <cfdump var="#session.__trackcampaign#" /> --->
		<!---
		 <cfset updatedSince = DateFormat(dateAdd('d', -1, now()),'yyyy-mm-dd')>

		<cfhttp url="#settings.booking.track_api_endpoint#/api/pms/reservations" method="get" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#">
			<cfhttpparam type="header" name="Accept" value="*/*">
			<cfhttpparam type="header" name="Content-type" value="application/json">
			<cfhttpparam type="url" name="updatedSince" value="#updatedSince#">
		</cfhttp>

		<cfdump var="#deserializeJSON(cfhttp.filecontent)#" />
		--->
		<!---
		<cfdump var="#session.booking.type#" abort="true" />

		<cfcontent type="text/csv">
		<cfheader name="Content-Disposition" value="filename=southern_resorts_towns_units.csv">
		<!---
		get towns, neighborhoods and complexes
		then get the count of units per those things
		--->
		<cfquery name="getTowns" datasource="#settings.booking.dsn#">
		SELECT id,name,typeName
		FROM track_nodes
		WHERE typeName IN(<cfqueryparam cfsqltype="cf_sql_varchar" value="Area,Beach Community,Complex/Neighborhood" list="true" />)
		ORDER BY typeName,name
		</cfquery>

		<cfsavecontent variable="areacsv">
			Name,UnitCount,AreaType
			<cfloop query="getTowns">
				<cfquery name="getUnitCount" datasource="#settings.booking.dsn#">
				SELECT COUNT(id) AS unit_count
				FROM track_properties

				<cfif typeName is'Complex/Neighborhood'>
					WHERE nodeid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" />
				<cfelse>
					WHERE locality = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#" />
				</cfif>
				</cfquery>

				<cfoutput>#name#,#val(getUnitCount.unit_count)#,<cfif typeName is 'Area'>Town<cfelseif typeName is 'Beach Community'>Neighborhood<cfelse>Complex</cfif>#chr(13)##chr(10)#</cfoutput>
			</cfloop>
		</cfsavecontent>

		<cfoutput>#trim(areacsv)#</cfoutput>
		--->

		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
	</cftry>
</cfif>