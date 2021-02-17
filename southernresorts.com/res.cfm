<cftry>
	<cfset propertyid = 1943 />
	<!--- UNIT AVAILABILITY --->
	<!---
	<cfhttp method="get" url="#settings.booking.track_api_endpoint#/api/pms/unit-blocks/?unitId=1" username="#settings.booking.username#" password="#settings.booking.password#">
		<cfhttpparam type="header" name="Accept" value="*/*">
		<cfhttpparam type="header" name="Content-type" value="application/json" />
	</cfhttp>

	<cfdump var="#cfhttp#" />
	--->
	<!--- RESERVATIONS --->
	<cfhttp method="get" url="#settings.booking.track_api_endpoint#/api/pms/reservations/?unitId=#propertyid#" username="#settings.booking.username#" password="#settings.booking.password#">
		<cfhttpparam type="header" name="Accept" value="*/*">
		<cfhttpparam type="header" name="Content-type" value="application/json" />
	</cfhttp>
	
	<cfif isJSON( cfhttp.filecontent )>
		<cfset resobj = deserializeJSON( cfhttp.filecontent ) />
		<cfset resarray = resobj._embedded.reservations />

		<cfdump var="#resobj#" abort="true" />

		<cfif arrayLen( resarray ) gt 0>
			<cfloop from="1" to="#arrayLen( resarray )#" index="i">
				<!---
				Checked out is in the past
				Cancelled is open
				Our options are Checked in, Confirmed
				--->
				<cfif !resarray[i].status is 'Checked Out' and !resarray[i].status is 'Cancelled'>
					<cfset numofUdays = dateDiff( 'd', resarray[i].arrivalDate, resarray[i].departureDate ) />
					
					<cfoutput>
						#resarray[i].arrivalDate# - I<br/>
					</cfoutput>
					
					<cfloop from="1" to="#numofUdays#" index="k">
						<cfset _thisday = dateAdd( 'd', k, resarray[i].arrivalDate ) />
						<cfset thisday = dateformat( _thisday, 'yyyy-mm-dd' ) />
						
						<cfif thisday is resarray[i].departureDate>
							<cfset thisdaytype = 'O' />
						<cfelse>
							<cfset thisdaytype = 'U' />
						</cfif>

						<cfoutput>
							#thisday# - #thisdaytype#<br/>
						</cfoutput>
					</cfloop>

					<cfquery name="addResDates" datasource="#settings.dsn#">
					insert into track_reservation_availability( propertyid, thedate, daytype )
					values(1,'#resarray[i].arrivalDate#','I'),
					
					<cfloop from="1" to="#numofUdays#" index="k">
						<cfset _thisday = dateAdd( 'd', k, resarray[i].arrivalDate ) />
						<cfset thisday = dateformat( _thisday, 'yyyy-mm-dd' ) />

						<cfif thisday is resarray[i].departureDate>
							<cfset thisdaytype = 'O' />
						<cfelse>
							<cfset thisdaytype = 'U' />
						</cfif>

						(#propertyid#,'#thisday#','#thisdaytype#')<cfif k lt numofUdays>,</cfif>
					</cfloop>

					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfcatch>
		<cfdump var="#cfcatch#" abort="true" />
	</cfcatch>
</cftry>