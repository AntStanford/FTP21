<cftry>
	<cfif isdefined('url.slug') and len(url.slug)>
		<cfset errorMessage = ''>
		<cfparam name="isavailable" default="false">

		<!--- set a cookie to store the recently viewed properties --->
		<cfif !structKeyExists(cookie,'recent')>
			<cfcookie name="recent" expires="never">
		</cfif>

		<!--- Get basic property information --->
		<cfset property = application.bookingObject.getProperty('',url.slug)>

		<cfif property.recordcount EQ 0>
			<cfquery name="getNotfound" datasource="#settings.dsn#">
				select notfoundurl from cms_property_enhancements
				where seopropertyname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.slug#">
			</cfquery>
			<cflocation url="http://#cgi.server_name#/#getnotfound.notfoundurl#" addtoken="false">
		</cfif>

		<cfquery name="getDestination" datasource="#settings.dsn#">
		SELECT cd.id,Title, bannerImage, canonicalLink, h1, metaTitle, metaDescription, description, nodeid, t.name as locality
		FROM cms_destinations cd left JOIN track_nodes t on t.id = cd.nodeid
		WHERE cd.title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.location#">
		</cfquery>

		<cfquery name="getDestinationCallOuts" datasource="#settings.dsn#">
		SELECT Title, Description, Photo,link
		FROM cms_callouts
		WHERE destination_id = <cfif getDestination.recordcount><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.nodeid#"><cfelse>0</cfif>
		</cfquery>

		<cfif property.recordcount gt 0>
			<cfquery name="getenhancements" datasource="#settings.dsn#">
			SELECT *
			FROM cms_property_enhancements
			WHERE strpropid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
			</cfquery>
			<!--- Add this property to cookie.recent if it has not already been added --->
			<cfset lf = ListFindNoCase(cookie.recent,property.propertyid)> <!--- Search for the property --->

			<cfif lf gt 0>
				<!--- We found it, so don't do anything --->
			<cfelse>

				<!--- We did not find it, add it to cookie.recent --->
				<cfif len(cookie.recent)>
					<cfcookie name="recent" value="#cookie.recent#,#property.propertyid#">
				<cfelse>
					<cfcookie name="recent" value="#property.propertyid#">
				</cfif>

			</cfif>
			<!--- end cookie.recent section --->

			<!--- Grab the property reviews --->
			<cfset reviews = application.bookingObject.getPropertyReviews(property.propertyid)>
			<cfset numReviews = StructCount(reviews)>
			<!--- Get min/max price range for this property, ex $1500 - $2500 per week --->
			<cfset priceRange = application.bookingObject.getPropertyPriceRange(property.propertyid)>
			<!--- function to get all property photos --->
			<cfset photos = application.bookingObject.getPropertyPhotos(property.propertyid)>
			<!---
			See if this property has construction labels
			https://pt.icnd.net/projects/view-task.cfm?projectid=875&taskid=79060
			--->
			<cfquery name="hasConstructionLabel" datasource="#settings.booking.dsn#">
			SELECT labelId
			FROM construction_property_links
			WHERE propertyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#property.propertyid#" />
			</cfquery>

			<cfif hasConstructionLabel.recordcount gt 0>
				<!--- now get the label --->
				<cfquery name="getConstructLabel" datasource="#settings.booking.dsn#">
				SELECT label
				FROM construction_labels
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#hasConstructionLabel.labelId#" />
				</cfquery>
			</cfif>
			<!--- function to get the average star rating from the be_reviews table --->
			<cfquery name="getAvgRating" dataSource="#settings.booking.dsn#">
				select avg(rating) as average from be_reviews where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#">
			</cfquery>

			<!--- Get the virtual tour link --->
			<cfquery name="getVirtualTour" dataSource="#settings.dsn#">
				select data from track_properties_custom_data
				where
					propertyId = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#"> and
					customDataId = 67
			</cfquery>


			<cfif
				isdefined('url.strcheckin') and
				len(url.strcheckin) and
				isdefined('url.strcheckout') and
				len(url.strcheckout) and
				cgi.HTTP_USER_AGENT does not contain 'bot'>

				<!--- make an API call to check availability and retrieve summary of fees --->
				<cfset apiresponse = application.bookingObject.getDetailRates(property.propertyid,url.strcheckin,url.strcheckout)>

			<cfelseif
				isdefined('session.booking.strcheckin') and
				len(session.booking.strcheckin) and
				isdefined('session.booking.strcheckout') and
				len(session.booking.strcheckout) and
				cgi.HTTP_USER_AGENT does not contain 'bot'>

				<!--- make an API call to check availability and retrieve summary of fees --->
				<cfset apiresponse = application.bookingObject.getDetailRates(property.propertyid,session.booking.strcheckin,session.booking.strcheckout)>

			</cfif>

			<!--- Log the user's visit --->
			<cfinclude template="_log-property-view.cfm">



		<cfelse>


			<!--- this might be a custom search page; lets check the cms_pages first --->
			<cfquery name="customSearchCheck" dataSource="#settings.dsn#">
				select * from cms_pages where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.slug#">
			</cfquery>

			<cfif customSearchCheck.recordcount gt 0>

					<cflocation url="/vacation-rentals/results.cfm">
					<!---
	<cfinclude template="/vacation-rentals/results.cfm">
					<cfset NONAVAILLISTFORDATEPICKER = ''>
	--->

			<cfelse>
					here
					<cfset noproperty = true>

			   	<cfquery datasource="#settings.dsn#">
					insert into notfound(thepage,thereferer,remoteip)
					values(
						<cfqueryparam value="#settings.booking.dir#/#url.slug#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#CGI.HTTP_REFERER#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="CF_SQL_LONGVARCHAR">
					)
					</cfquery>

			</cfif>



		</cfif>

	<cfelse>
	  You cannot access this page without a property ID.
	  <cfabort>
	</cfif>

	<cfcatch>
		<cfif cgi.remote_host eq '75.87.66.209'>
			<cfdump var="#cfcatch#" abort="true" />
		</cfif>
	</cfcatch>
</cftry>