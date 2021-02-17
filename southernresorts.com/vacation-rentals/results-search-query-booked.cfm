<cfset returnValue = 'true'>
<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate
	AND isdefined('session.booking.strCheckin') AND isValid('date', session.booking.strCheckin)
	AND isdefined('session.booking.strCheckout') AND isValid('date', session.booking.strCheckout)>

	<cfif settings.booking.pms eq 'Escapia'>

		<cfset numNights = DateDiff('d',session.booking.strCheckin,session.booking.strCheckout)>
	  <!---
		At this point, we have a list of units that match most of the clien't search criteria, returned by the API
		Now we use a local query to get booked units + units that match additional search criteria like amenities
		--->

		<cfquery name="getNumberOf" dataSource="#settings.booking.dsn#">
			select count(escapia_properties.unitcode) as bookedProperties
			from escapia_properties
			where 1=1
			<cfif isdefined('session.booking.cityname') and session.booking.cityname neq ''>
				and cityname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.cityname#">
			</cfif>
			<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate) and session.booking.rentalRate contains ','>
				and escapia_properties.unitcode IN (select distinct unitcode from escapia_rates where minRent*7 between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ListFirst(session.booking.rentalRate)#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ListLast(session.booking.rentalRate)#"> and ratetype = 'Weekly')
			</cfif>
			<cfif isdefined('session.booking.amenities') and ListFind(session.booking.amenities,'Dog Friendly')>
				and petsAllowedCode = 'Pets Allowed'
			</cfif>
			<cfif isdefined('session.booking.bedrooms') and len(session.booking.bedrooms) and session.booking.bedrooms contains ','>
				and bedrooms between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ListFirst(session.booking.bedrooms)#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ListLast(session.booking.bedrooms)#">
			</cfif>
			<cfif isdefined('session.booking.sleeps') and session.booking.sleeps neq '' and session.booking.sleeps gt 0>
				and maxoccupancy >= <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.booking.sleeps#">
			</cfif>

			<!--- Find properties that are in a list of booked dates --->
			and escapia_properties.unitcode IN (
				select distinct unitcode from escapia_dailyavailabilities
				where
				(
					<cfif isNumeric(numNights)>
						<cfloop from="1" to="#numNights#" index="i">
							(thedate = #createodbcdate(dateAdd("d",i,session.booking.strCheckin))# and code = 'U')  <cfif i lt (numNights)>or</cfif>
						</cfloop>
					</cfif> <!--- end of isnumeric	--->
				)order by unitcode
			)
			<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">
		</cfquery>

	<cfelseif settings.booking.pms eq 'Barefoot'>

		<cfquery name="getNumberOf" dataSource="#settings.booking.dsn#">
			select count(distinct bf_properties.propertyid) as bookedProperties
			from bf_properties
			where 1=1
			and bf_properties.propertyid IN (
				select distinct propertyid from bf_non_available_dates where #createodbcdate(session.booking.strCheckin)# between startdate and enddate
			)
			<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">
		</cfquery>


	<cfelseif settings.booking.pms eq 'Homeaway'>

		<cfquery name="getNumberOf" dataSource="#settings.booking.dsn#">
			select count(pp_propertyinfo.strpropid) as bookedProperties
			from pp_propertyinfo
			where pp_propertyinfo.strpropid IN (
				select distinct strpropid from pp_property_non_available_dates where #createodbcdate(session.booking.strCheckin)# between DtFromDate and DtToDate
			)
			<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">
		</cfquery>

	<cfelseif settings.booking.pms eq 'Track'>

		<cfquery name="getNumberOfQry" dataSource="#settings.booking.dsn#">
			Select Distinct(track_properties.id)
			From track_properties
			left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
					left join track_nodes ndsa ON track_properties.nodeId = ndsa.id
					left join track_nodes nds2 on nds2.id = ndsa.parentid
					left join track_nodes nds3 on nds3.id = nds2.parentid
			Where 1 = 1
				<cfloop from="#session.booking.strcheckin#" to="#session.booking.strcheckout#" step="#CreateTimeSpan(1,0,0,0)#" index="i">
					AND
					track_properties.ID in (
							Select distinct(propertyid)
							From track_properties_availability
							Where avail = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and theDate = <cfqueryparam value="#dateformat(i,'yyyy-mm-dd')#" cfsqltype="cf_sql_date">
						)
			</cfloop>
			<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">
		</cfquery>

		<cfset getNumberOf.bookedProperties = getNumberOfQry.recordcount>

	</cfif>


		<cfif isdefined('getNumberOf.bookedProperties') and isdefined('cookie.numresults')>

			<cfset totalPropertiesThatMatch = getNumberOf.bookedProperties + cookie.numresults>

			<cfif getNumberOf.bookedProperties gt 0 and totalPropertiesThatMatch gt 0>
				<cfset PercentBooked = (getNumberOf.bookedProperties / totalPropertiesThatMatch)>
				<cfset PercentBooked = 1 - PercentBooked>
				<cfset PercentBooked = PercentBooked*100>
				<cfset PercentBooked = 100-PercentBooked>

				<cfif PercentBooked gt 65 and PercentBooked lt 100>
					<cfset displayThis = PercentBooked>
				
					<cfif isdefined('returnValue') and getNumberOf.bookedProperties gt 0>
						<b><cfoutput>#Ceiling(PercentBooked)#</cfoutput>% of our inventory is booked.</b>
						<!--- this allows first page load to display --->
						<cf_htmlfoot>
						<script type="text/javascript">
							$('#results-list-alert-popular-ajax').show();
						</script>
						</cf_htmlfoot>
				
					</cfif>

				</cfif>
			</cfif>

		</cfif>


</cfif>






