<cfset theYear = DatePart('yyyy',now())>
<cfset theMonth = DatePart('m',now())>
<cfset nonAvailList = application.bookingObject.getCalendarData(property.propertyid)>
<cfset nonAvailListForDatepicker = nonAvailList>



<div id="calendar" name="calendar" class="info-wrap calendar-wrap">
	<div class="info-wrap-heading"><i class="fa fa-calendar-check-o" aria-hidden="true"></i> Calendar</div>
  <div class="info-wrap-body">

  	<div class="calendar-legend">
  		<span data-toggle="tooltip" data-placement="top" title="This Date is Available for rent"><div class="available"></div> Available</span>
		  <span data-toggle="tooltip" data-placement="top" title="This Date is Unavailable for rent"><div class="unavailable"></div> Unavailable</span>
		  <!---
  		<span data-toggle="tooltip" data-placement="top" title="The Morning is Available - The Afternoon is Unavailable"><div class="check-in"></div> Check-In</span>
		  <span data-toggle="tooltip" data-placement="top" title="The Morning is Unavailable - The Afternoon is Available"><div class="check-out"></div> Check-Out</span>
		  --->
  	</div>

  	<div class="owl-carousel calendar-carousel">

  		<cfloop from="1" to="12" index="i" step="1">

  			<cfif theMonth gt 12>
  				<cfset theMonth = 1>
  				<cfset theYear = DateAdd('yyyy',1,now())>
  				<cfset theYear = DateFormat(theYear,'yyyy')>
  			</cfif>

  			<CFSET ThisMonthYear = CreateDate(theYear, #theMonth#, '1')>
  			<cfset dateob=CreateDate(theYear,#theMonth#,1)>

  			<div class="cal-container">

  				<table class="table table-bordered calendar-table">
    				<tr><th class="month" colspan="7"><cfoutput><strong>#DateFormat(ThisMonthYear,"MMMM YYYY")#</strong></cfoutput></th></tr>
  					<tr>
  						<th class="text-center">Sun</th>
  						<th class="text-center">Mon</th>
  						<th class="text-center">Tue</th>
  						<th class="text-center">Wed</th>
  						<th class="text-center">Thu</th>
  						<th class="text-center">Fri</th>
  						<th class="text-center">Sat</th>
  					</tr>
  					<tr>
  						<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
  						<cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
  						<cfset PADSTR=RepeatString("<td width=""75"" class=""hdnvcgray"">&nbsp;</td>",TOPAD)>
  						<cfoutput>#PADSTR#</cfoutput>
  						<cfset DW=TOPAD>

  						<cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">

  						<cfif len(theMonth) eq 1>
  							<cfset theMonth = '0' & theMonth>
  						</cfif>

  						<cfif len(x) eq 1>
  							<cfset x = '0' & x>
  						</cfif>

  						<cfset temp = "#theMonth#/#x#/#theYear#">



  									<cfset PreviousDate = DateFormat(DateAdd('d',-1,temp),'mm/dd/yyyy')>
  									<cfset NextDate = DateFormat(DateAdd('d',1,temp),'mm/dd/yyyy')>

  									<cfif ListFind(nonAvailList,PreviousDate) AND NOT ListFind(nonAvailList,temp)> <!--- Checkout day --->
  										<cfset myclass = 'splitViewCheckout'>
  									<cfelseif ListFind(nonAvailList,temp) AND NOT ListFind(nonAvailList,PreviousDate)> <!--- checkin day --->
  										<cfset myclass = 'splitViewCheckin'>
  									<cfelseif ListFind(nonAvailList,temp)>
  										<cfset myclass = 'booked'>
                    <cfelse>
  										<cfset myclass = 'available'>
  									</cfif>


  						<cfset formattedDate = "#theYear#-#theMonth#-#x#">

  						<td class="text-white<cfoutput><cfif formattedDate lt #dateformat(now(),'yyyy-mm-dd')#> booked<cfelse> #myclass#</cfif></cfoutput>" width="14.28%">
  							<cfoutput><span>#X#</span></cfoutput>

  							<!--- Is this a Saturday? --->
  							<cfif DayOfWeek("#theYear#-#theMonth#-#x#") is 7 and myclass neq 'booked'>
  								<cfset showPrice = true>

  								<!--- Are the next 7 days available? If so, add price and link to book now --->
  								<cfloop from="1" to="7" index="i">
  									<cfset tempDate = DateFormat(DateAdd('d',i,temp),'mm/dd/yyyy')>

  									<cfif ListFind(nonAvailList,tempDate)>
  										<cfset showPrice = false>
  										<cfbreak>
  									</cfif>
  								</cfloop>

  								<!---
                  <cfif showPrice>
  									<cfset getRate = application.bookingObject.getCalendarRates(property.propertyid,formattedDate)>

  									<cfif formattedDate gt now() and getRate gt 0>

  										<cfset myCheckout = DateFormat(DateAdd('d',7,temp),'mm/dd/yyyy')>
                      				<cfoutput><a href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#property.propertyid#&strcheckin=#temp#&strcheckout=#myCheckout#" class="property-rate text-black">#NumberFormat(getRate,'$__')#</a></cfoutput>

  									</cfif>
  								</cfif><!-- END of showprice -->
                  --->

  							</cfif><!-- END of Saturday check -->
  						</td>

  					<cfset DW=DW + 1>
  					<cfif DW EQ 7>
  					</tr>

  					<cfset DW=0>
  					<cfif X LT DaysInMonth(DateOb)><tr></cfif>
  					</cfif>
  						</cfloop>

  					</tr>
  				</table>

  			<cfif i MOD 3 eq 0>
  			<cfset i = 1>

  			</div><!-- END cal-container -->

  			<cfelse>
  			<cfset i = i +1>

  			</div>

  			</cfif>

  			<cfset theMonth = theMonth + 1>

  		</cfloop>
  	</div><!-- END calendar-carousel -->

    <small class="scroll-indicator"><i class="fa fa-arrows-h" aria-hidden="true"></i><strong><span class="swipe">Swipe</span><span class="drag">Drag</span> for Availability</strong></small>

    <div class="btn-group">
      <button id="prevCalendar" class="btn site-color-1-bg site-color-3-bg-hover text-white" type="button">Prev</button>
      <button id="nextCalendar" class="btn site-color-1-bg site-color-3-bg-hover text-white" type="button">Next</button>
    </div>
  </div><!-- END info-wrap-body -->
</div><!-- END calendar-wrap -->
