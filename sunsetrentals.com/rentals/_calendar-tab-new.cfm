<!---
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
        <span data-toggle="tooltip" data-placement="top" title="The Morning is Available - The Afternoon is Unavailable"><div class="check-in"></div> Check-In</span>
        <span data-toggle="tooltip" data-placement="top" title="The Morning is Unavailable - The Afternoon is Available"><div class="check-out"></div> Check-Out</span>
      </div>

      <div class="owl-carousel calendar-carousel">

        <cfloop from="1" to="12" index="i" step="1">

          <cfif theMonth gt 12>
            <cfset theMonth = 1>
            <cfset theYear = DateAdd('yyyy',1,now())>
            <cfset theYear = DateFormat(theYear,'yyyy')>
          </cfif>

          <cfset ThisMonthYear = CreateDate(theYear, #theMonth#, '1')>
          <cfset dateob = CreateDate(theYear,#theMonth#,1)>

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
                <cfset FIRSTOFMONTH = CreateDate(Year(DateOb),Month(DateOb),1)>
                <cfset TOPAD = DayOfWeek(FIRSTOFMONTH) - 1>
                <cfset PADSTR = RepeatString("<td width=""75"" class=""hdnvcgray"">&nbsp;</td>",TOPAD)>
                <cfoutput>#PADSTR#</cfoutput>
                <cfset DW = TOPAD>

                <cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">

                <cfif len(theMonth) eq 1>
                  <cfset theMonth = '0' & theMonth>
                </cfif>

                <cfif len(x) eq 1>
                  <cfset x = '0' & x>
                </cfif>

                <cfset temp = "#theMonth#/#x#/#theYear#">

                <cfif settings.booking.pms eq 'Escapia'>

                    <cfif ListFind(nonAvailList,temp)>
                      <cfset myclass = 'booked'>
                    <cfelseif ListFind(checkInOnlyList,temp)>
                      <cfset myclass = 'splitViewCheckout'>
                    <cfelseif ListFind(checkOutOnlyList,temp)>
                      <cfset myclass = 'splitViewCheckin'>
                    <cfelse>
                      <cfset myclass = 'available'>
                      <cfset showPrice = true>
                    </cfif>

                <cfelse>
                  <cfif ListFind(nonAvailList,temp)>
                    <cfset PreviousDate = DateFormat(DateAdd('d',-1,temp),'mm/dd/yyyy')>
                    <cfset NextDate = DateFormat(DateAdd('d',1,temp),'mm/dd/yyyy')>
                    <!---
                      Since Track doesn't mark dates as check-in/check-out pretty much
                      we have to do it
                      This function will get the availability of the previous date and the current date
                      if the previous date avail = 0 and current date avail =  1, then current date is check-out
                      and if the previous date is 1 and the current date is 0, the current date is a check-in
                      if the current date is 0, it's booked
                      if the current date is 1, it's available
                    --->
                    <cfset prev_avail = application.bookingObject.getDateAvail( property.propertyid, PreviousDate ) />
                    <cfset current_avail = application.bookingObject.getDateAvail( property.propertyid, temp ) />

                    <cfif prev_avail eq 0 and current_avail eq 1>
                      <cfset myclass = 'splitViewCheckout'>
                    <cfelseif prev_avail eq 1 and current_avail eq 0>
                      <cfset myclass = 'splitViewCheckin'>
                    <cfelseif current_avail eq 0>
                      <cfset myclass = 'booked'>
                    <cfelse>
                      <cfset myclass = 'available'>
                    </cfif>
                  <cfelse>
                    <cfset myclass = 'available'>
                  </cfif>
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


                    <cfif showPrice>
                      <cfset getRate = application.bookingObject.getCalendarRates(property.propertyid,formattedDate)>

                      <cfif formattedDate gt now() and getRate gt 0>
                        <cfset myCheckout = DateFormat(DateAdd('d',7,temp),'mm/dd/yyyy')>
                        <cfoutput><a href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#property.propertyid#&strcheckin=#temp#&strcheckout=#myCheckout#" class="property-rate text-black">#NumberFormat(getRate,'$__')#</a></cfoutput>
                      </cfif>
                    </cfif><!-- END of showprice -->

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
        <button id="prevCalendar" class="btn site-color-1-bg site-color-3-bg-hover text-black" type="button">Prev</button>
        <button id="nextCalendar" class="btn site-color-1-bg site-color-3-bg-hover text-black" type="button">Next</button>
      </div>
    </div><!-- END info-wrap-body -->
  </div><!-- END calendar-wrap -->
--->
<!--- old code
  <cfset theYear = DatePart('yyyy',now())>
  <cfset theMonth = DatePart('m',now())>
  <cfset nonAvailList = application.bookingObject.getCalendarData(property.propertyid)>
  <cfset nonAvailListForDatepicker = nonAvailList>

  <cfif settings.booking.pms eq 'Homeaway' or settings.booking.pms eq 'Barefoot'>
    <!--- We generate a separate list for the date pickers for certain vendors --->
    <cfset nonAvailListForDatepicker = application.bookingObject.getCalendarDataForDatePickers(property.propertyid)>
  </cfif>

  <cfif settings.booking.pms eq 'Escapia'>

    <cfquery name="checkInOnly" dataSource="#settings.booking.dsn#">
      select Date_Format(thedate,'%m/%d/%Y') as mydate from escapia_dailyavailabilities
      where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#"> and code = 'I'
      and thedate >= '#theYear#-#theMonth#-01'
    </cfquery>

    <cfquery name="checkOutOnly" dataSource="#settings.booking.dsn#">
      select Date_Format(thedate,'%m/%d/%Y') as mydate from escapia_dailyavailabilities
      where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property.propertyid#"> and code = 'O'
      and thedate >= '#theYear#-#theMonth#-01'
    </cfquery>

    <!--- We need these lists for the calendar tab further down the page, see line 89 --->
    <cfset checkInOnlyList = ValueList(checkInOnly.mydate)>
    <cfset checkOutOnlyList = ValueList(checkOutOnly.mydate)>

    <!--- Escapia uses the same list for both calendar tab AND the date pickers --->
    <cfset nonAvailListForDatepicker = nonAvailList>

  </cfif>


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

          <cfset ThisMonthYear = CreateDate(theYear, #theMonth#, '1')>
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

                <cfif settings.booking.pms eq 'Escapia'>

                    <cfif ListFind(nonAvailList,temp)>
                      <cfset myclass = 'booked'>
                    <cfelseif ListFind(checkInOnlyList,temp)>
                      <cfset myclass = 'splitViewCheckout'>
                    <cfelseif ListFind(checkOutOnlyList,temp)>
                      <cfset myclass = 'splitViewCheckin'>
                    <cfelse>
                      <cfset myclass = 'available'>
                      <cfset showPrice = true>
                    </cfif>

                <cfelse>

                    <cfif ListFind(nonAvailList,temp)>

                      <cfset PreviousDate = DateFormat(DateAdd('d',-1,temp),'mm/dd/yyyy')>
                      <cfset NextDate = DateFormat(DateAdd('d',1,temp),'mm/dd/yyyy')>

                      <cfif ListFind(nonAvailList,PreviousDate) AND NOT ListFind(nonAvailList,NextDate)> <!--- Checkout day --->
                        <cfset myclass = 'splitViewCheckout'>
                      <cfelseif ListFind(nonAvailList,NextDate) AND NOT ListFind(nonAvailList,PreviousDate)> <!--- checkin day --->
                        <cfset myclass = 'splitViewCheckin'>
                      <cfelse>
                        <cfset myclass = 'booked'>
                      </cfif>
                    <cfelse>
                      <cfset myclass = 'available'>
                    </cfif>

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


                    <cfif showPrice>
                      <cfset getRate = application.bookingObject.getCalendarRates(property.propertyid,formattedDate)>

                      <cfif formattedDate gt now() and getRate gt 0>

                        <cfset myCheckout = DateFormat(DateAdd('d',7,temp),'mm/dd/yyyy')>
                        <cfoutput><a href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#property.propertyid#&strcheckin=#temp#&strcheckout=#myCheckout#" class="property-rate text-black">#NumberFormat(getRate,'$__')#</a></cfoutput>

                      </cfif>
                    </cfif><!-- END of showprice -->

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
--->
