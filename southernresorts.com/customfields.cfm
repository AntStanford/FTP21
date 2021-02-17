<cfif cgi.remote_host eq '75.87.66.209' or cgi.remote_host eq '99.1.177.220' or CGI.REMOTE_ADDR eq '103.38.13.217'>
	<cftry>
		<!--- <cfhttp method="get" url="#settings.booking.track_api_endpoint#/api/custom-fields/" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#">
			<cfhttpparam type="header" name="Accept" value="*/*">
		</cfhttp> --->
		<cfhttp method="get" url="https://svr.trackhs.com/api/pms/units/1125" username="30a5d5c074bd5537f35ae765081f4ed5" password="2b74261e3fd1cdce561d602338e57fcd">
			<cfhttpparam type="header" name="Accept" value="*/*">
		</cfhttp> 
		
		<cfif isJSON(cfhttp.filecontent)>
			<cfset variables.cf_json = deserializeJSON(cfhttp.filecontent) />

			<cfdump var="#variables.cf_json#" />

			<!--- <cfset customFieldArray = variables.cf_json._embedded.customFields />
			<cfdump var="#customFieldArray[44]._embedded.values#"> --->
		<cfelse>
			Something broke
		</cfif>

		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
	</cftry>
</cfif>