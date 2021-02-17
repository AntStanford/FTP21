<!--- The Calendar Parameters start --->
<cfset prev_date=DateAdd("m",-1,dateob)>
<cfset next_date=DateAdd("m",1,dateob)>

<cfset prevmonth = arraynew(1)>
<cfset nextmonth = arraynew(1)>

<cfloop index="pm" from="1" to="#DaysInMonth(prev_date)#">
  <cfset prevmonth[#pm#]="no">
</cfloop>

<cfloop index="nm" from="1" to="#DaysInMonth(next_date)#">
	<cfset nextmonth[#nm#]="no">
</cfloop>
<cfquery name="getprevmonth" datasource="#settings.dsn#">
	SELECT 	start_date,(day(start_date)) AS theprevmonth
	FROM 	cms_eventcal
	WHERE (start_date >= #CreateDate(Year(prev_date),Month(prev_date),1)#) and (start_date <= #CreateDate(Year(prev_date),Month(prev_date),DaysInMonth(prev_date))#)
</cfquery>
<cfoutput query="getprevmonth" group="start_date">
	<cfset prevmonth[#theprevmonth#]="yes">
</cfoutput>

<cfquery name="getnextmonth" datasource="#settings.dsn#">
	SELECT 	start_date,(day(start_date)) AS thenextmonth
	FROM 	cms_eventcal
	WHERE	(start_date >= #CreateDate(Year(next_date),Month(next_date),1)#) and (start_date <= #CreateDate(Year(next_date),Month(next_date),DaysInMonth(next_date))#)
</cfquery>
<cfoutput query="getnextmonth" group="start_date">
	<cfset nextmonth[#thenextmonth#]="yes">
</cfoutput>
<!--- The Calendar Parameters end --->

<!---
<label class="label label-info">&nbsp;</label> Appointment<br>
<label class="label label-danger">&nbsp;</label> Not Working<br>
<label class="label label-default">&nbsp;</label> Default<br>
--->

<!--- Last Month's Calendar Start --->
<h3>Last Month</h3>
<cfoutput>
  <h4><a href="index.cfm?da=1&mo=#datepart("m",prev_date)#&ye=#datepart("yyyy",prev_date)#" class="site-color-1 site-color-1-lighten-hover">#MonthAsString(Month(prev_date))#</a></h4>
</cfoutput>
<table class="table table-bordered mcal">
<tr>
  <th class="text-center site-color-1-bg text-white">S</th>
  <th class="text-center site-color-1-bg text-white">M</th>
  <th class="text-center site-color-1-bg text-white">T</th>
  <th class="text-center site-color-1-bg text-white">W</th>
  <th class="text-center site-color-1-bg text-white">T</th>
  <th class="text-center site-color-1-bg text-white">F</th>
  <th class="text-center site-color-1-bg text-white">S</th>
</tr>
<tr>
  <cfset FIRSTOFMONTH=CreateDate(Year(prev_date),Month(prev_date),1)>
  <cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
  <cfset PADSTR=RepeatString("<td class=""emptyday"">&nbsp;</td>",TOPAD)>
  <cfoutput>#PADSTR#</cfoutput>
  <cfset DW=TOPAD>
  <cfloop INDEX="x" FROM="1" TO="#DaysInMonth(prev_date)#">
  	 
  	  <cfset theMonth = datepart("m",prev_date)>
  	 	<cfset theYear = datepart("yyyy",prev_date)>
  	 	
  	 <cfquery name="appshow" datasource="#settings.dsn#">
		SELECT id,event_title
		FROM 	cms_eventcal
		WHERE	start_date = #Createdate(theYear,theMonth,X)#
		order by time_start
	</cfquery>
		
    <cfoutput>
      <cfif #prevmonth[x]# is "no">
        <td class="text-center">
        	 <cfif appshow.recordcount EQ 0>
        	 	#x#
        	 <cfelse>
          	<a href="allday.cfm?da=#x#&amp;mo=#datepart("m",prev_date)#&amp;ye=#datepart("yyyy",prev_date)#" class="smcal">#x#</a>
          </cfif>
        </td>
      <cfelse>
        <td class="text-center site-color-1-bg">
        	 <cfif appshow.recordcount EQ 0>
        	 	#x#
        	 <cfelse>
          	<a href="allday.cfm?da=#x#&amp;mo=#datepart("m",prev_date)#&amp;ye=#datepart("yyyy",prev_date)#" class="smcalday">#x#</a>
          </cfif>
        </td>
      </cfif>
    </cfoutput>
    <cfset DW=DW + 1>
    <cfif DW EQ 7>
      </tr>
      <cfset DW=0>
      <cfif X LT DaysInMonth(prev_date)><tr></cfif>
    </cfif>
  </cfloop>
  <cfset TOPAD=7 - DW>
  <cfif TOPAD LT 7>
    <cfset PADSTR=RepeatString("<td class=""emptyday"">&nbsp;</td>",TOPAD)>
    <cfoutput>#PADSTR#</cfoutput>
    </tr>
  </cfif>
</table>
<!--- Last Month's Calendar End --->

<!--- Next Month's Calendar Start --->
<h3>Next Month</h3>
<cfoutput>
  <h4><a href="index.cfm?da=1&mo=#datepart("m",next_date)#&ye=#datepart("yyyy",next_date)#" class="site-color-1 site-color-1-lighten-hover">#MonthAsString(Month(next_date))#</a></h4>
</cfoutput>
<table class="table table-bordered mcal">
<tr>
  <th class="text-center site-color-1-bg text-white">S</th>
  <th class="text-center site-color-1-bg text-white">M</th>
  <th class="text-center site-color-1-bg text-white">T</th>
  <th class="text-center site-color-1-bg text-white">W</th>
  <th class="text-center site-color-1-bg text-white">T</th>
  <th class="text-center site-color-1-bg text-white">F</th>
  <th class="text-center site-color-1-bg text-white">S</th>
</tr>
<tr>
  <cfset FIRSTOFMONTH=CreateDate(Year(next_date),Month(next_date),1)>
  <cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
  <cfset PADSTR=RepeatString("<td class=""emptyday"">&nbsp;</td>",TOPAD)>
  <cfoutput>#PADSTR#</cfoutput>
  <cfset DW=TOPAD>
  <cfloop INDEX="x" FROM="1" TO="#DaysInMonth(next_date)#">
  	 	
  	 	<cfset theMonth = datepart("m",next_date)>
  	 	<cfset theYear = datepart("yyyy",next_date)>
  	 	
		<cfquery name="appshow" datasource="#settings.dsn#">
			SELECT id,event_title
			FROM 	cms_eventcal
			WHERE	start_date = #Createdate(theYear,theMonth,X)#
			order by time_start
		</cfquery>
  	 
    <cfoutput>
      <cfif #nextmonth[x]# is "no">
        <td class="text-center">
        	 <cfif appshow.recordcount EQ 0>
        	 	#x#
        	 <cfelse>
          	<a href="allday.cfm?da=#x#&amp;mo=#datepart("m",next_date)#&amp;ye=#datepart("yyyy",next_date)#" class="smcal">#x#</a>
          </cfif>
        </td>
      <cfelse>
        <td class="text-center site-color-1-bg">
        	 <cfif appshow.recordcount EQ 0>
          	#x#
          <cfelse>
          	<a href="allday.cfm?da=#x#&amp;mo=#datepart("m",next_date)#&amp;ye=#datepart("yyyy",next_date)#" class="smcalday">#x#</a>
          </cfif>
        </td>
      </cfif>
    </cfoutput>
    <cfset DW=DW + 1>
    <cfif DW EQ 7></tr>
      <cfset DW=0>
      <cfif X LT DaysInMonth(next_date)><tr></cfif>
    </cfif>
  </cfloop>
  <cfset TOPAD=7 - DW>
  <cfif TOPAD LT 7>
    <cfset PADSTR=RepeatString("<td class=""emptyday"">&nbsp;</td>",TOPAD)>
    <cfoutput>#PADSTR#</cfoutput>
    </tr>
  </cfif>
</table>
<!--- Next Month's Calendar Start End --->