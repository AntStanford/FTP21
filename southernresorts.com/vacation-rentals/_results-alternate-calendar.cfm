<div class="results-list-property-calendar-wrap">
	<div class="dates-legend">
		<span><em class="available"></em> Available</span>
		<span><em class="unavailable"></em> Unavailable</span>
		<!---<span><em class="checkin"></em> Check-In</span>
		<span><em class="checkout"></em> Check-Out</span>--->
	</div>

  <cfset sevenDaysBeforeCheckin = DateAdd('d',-7,session.booking.strcheckin)>
  <cfset sevenDaysBeforeCheckin = DateFormat(sevenDaysBeforeCheckin,'yyyy-mm-dd')>

  <cfset sevenDaysAfterCheckout = DateAdd('d',7,session.booking.strcheckout)>
  <cfset sevenDaysAfterCheckout = DateFormat(sevenDaysAfterCheckout,'yyyy-mm-dd')>

	<cfquery name="getFlexAvailability" dataSource="#settings.dsn#">
		select * from track_properties_availability
		where thedate between '#sevenDaysBeforeCheckin#' and '#sevenDaysAfterCheckout#'
		and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
	</cfquery>

	<ul class="dates-review" style="">
		<cfset days = getFlexAvailability.RecordCount>
		<cfset divwidth = days * 28>

		<cfset count = 0>
		<cfset even = true>
		<cfloop query="getFlexAvailability">
			<cfset count = count + 1>
			<cfset mydayOfWeek = DateFormat(getFlexAvailability.thedate,'dddd')>
			<cfset firstChar = Left(mydayOfWeek,1)>
			<cfset theDayofMonth = DateFormat(getFlexAvailability.thedate,'d')>

			<cfset avaiable = true>

			<cfif avail EQ 1>
				<li class="current-day">
			<!---
			<cfelseif code eq 'I'>
				<li class="checkout">
			<cfelseif code eq 'O'>
				<li class="checkin">
--->
			<cfelse>
				<li class="unavailable">
				<cfset avaiable = false>
			</cfif>

			<cfif count EQ 1>
				<cfset threeDigitMonth = DateFormat(getFlexAvailability.thedate,'mmmm')>
				<cfif even>
					<div style="overflow:visible; position:relative;"><cfoutput>#threeDigitMonth#</cfoutput></div>
				<cfelse>
					<div style="overflow:visible; position:relative; background:##90A0B3;"><cfoutput>#threeDigitMonth#</cfoutput></div>
				</cfif>
			<cfelse>
				<cfif theDayOfMonth EQ 1 AND count NEQ 1>
					<cfif even>
						<cfset even = false>
					<cfelse>
						<cfset even = true>
					</cfif>
					<cfset threeDigitMonth = DateFormat(getFlexAvailability.thedate,'mmmm')>
					<cfif even>
						<div style="overflow:visible; position:relative;"><cfoutput>#threeDigitMonth#</cfoutput></div>
					<cfelse>
						<div style="overflow:visible; position:relative; background:##A8B8CB;"><cfoutput>#threeDigitMonth#</cfoutput></div>
					</cfif>
				<cfelse>
					<cfif even>
						<div style=""></div>
					<cfelse>
						<div style="background:##A8B8CB;"></div>
					</cfif>
				</cfif>
			</cfif>
			<cfif even>
				<p><cfoutput>#firstChar#</cfoutput></p>
			<cfelse>
				<p style="background:##EDEDED;"><cfoutput>#firstChar#</cfoutput></p>
			</cfif>

			<cfset dateCick = DateFormat(getFlexAvailability.thedate,'mm/dd/yyyy')>
			<cfset dateEnd = dateAdd('d', 2, getFlexAvailability.thedate)>
			<cfset dateEnd = DateFormat(dateEnd,'mm/dd/yyyy')>
			<cfif avaiable>
<!--- 				<a href="javascript:;" onClick="dayClick('#dateCick#','#dateEnd#','#getUnitInfo.seoPropertyName#','#getUnitInfo.unitcode#');"> ---><p><cfoutput>#theDayofMonth#</cfoutput></p><!--- </a> --->
			<cfelse>
<!--- 				<a href="javascript:;"> ---><p><cfoutput>#theDayofMonth#</cfoutput></p><!--- </a> --->
			</cfif>
			</li>
		</cfloop>
	</ul>

</div><!-- END results-list-calendar-wrap -->