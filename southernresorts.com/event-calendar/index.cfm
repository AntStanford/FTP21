<cfinclude template="/components/header.cfm">

<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">

<link href="/event-calendar/calendar.css" type="text/css" rel="stylesheet">
<script src="/event-calendar/calendarfunction.js" type="text/javascript"></script>


<!--- Set Varibles Start --->
<cfparam name="url.adam" default="1">
<cfparam name="url.da" default="#datepart("d",Now())#">
<cfparam name="url.mo" default="#datepart("m",Now())#">
<cfparam name="url.ye" default="#datepart("yyyy",Now())#">

<cfif isDefined("url.ye")>
	<cfif IsNumeric(url.ye) eq "no">
		<cfset url.ye = #Year(now())#>
	</cfif>
</cfif>
<cfif isDefined("url.mo")>
	<cfif IsNumeric(url.mo) eq "yes">
		<cfif url.mo gt 12>
		<cfset url.mo = 12>
		</cfif>
	<cfelse>
		<cfset url.mo = 1>
	</cfif>
</cfif>
<cfif isDefined("url.da")>
	<cfif IsNumeric(url.da) eq "yes">
		<cfif url.da gt #DaysInMonth(CreateDate(url.ye,url.mo,1))#>
		<cfset url.da = #DaysInMonth(CreateDate(url.ye,url.mo,1))# -1>
		</cfif>
	<cfelse>
		<cfset url.da = 1>
	</cfif>
</cfif>

<cfset dateob=CreateDate(url.ye,url.mo,1)>
<cfset laye = #url.ye#>
<cfset neye = #url.ye#>
<!--- Set Varibles End --->

<style>
td.hdnvc:hover{background:#e5eef9}
</style>

<div class="event-calendar">

	<div class="alert site-color-1-bg" style="overflow:hidden;">
	  <form name="selmo" style="float:left;margin-right:5px; text-align: left;">
	    <b class="text-white">Events for the month of</b>
	    <select name="theselmo" onChange="gotomo()">
	      <cfoutput>
	  			<option value="index.cfm?da=1&amp;mo=1&amp;ye=#url.ye#" <cfif url.mo IS 1>selected="selected"</cfif> >January</option>
	  			<option value="index.cfm?da=1&amp;mo=2&amp;ye=#url.ye#" <cfif url.mo IS 2>selected="selected"</cfif> >February</option>
	  			<option value="index.cfm?da=1&amp;mo=3&amp;ye=#url.ye#" <cfif url.mo IS 3>selected="selected"</cfif> >March</option>
	  			<option value="index.cfm?da=1&amp;mo=4&amp;ye=#url.ye#" <cfif url.mo IS 4>selected="selected"</cfif> >April</option>
	  			<option value="index.cfm?da=1&amp;mo=5&amp;ye=#url.ye#" <cfif url.mo IS 5>selected="selected"</cfif> >May</option>
	  			<option value="index.cfm?da=1&amp;mo=6&amp;ye=#url.ye#" <cfif url.mo IS 6>selected="selected"</cfif> >June</option>
	  			<option value="index.cfm?da=1&amp;mo=7&amp;ye=#url.ye#" <cfif url.mo IS 7>selected="selected"</cfif> >July</option>
	  			<option value="index.cfm?da=1&amp;mo=8&amp;ye=#url.ye#" <cfif url.mo IS 8>selected="selected"</cfif> >August</option>
	  			<option value="index.cfm?da=1&amp;mo=9&amp;ye=#url.ye#" <cfif url.mo IS 9>selected="selected"</cfif> >September</option>
	  			<option value="index.cfm?da=1&amp;mo=10&amp;ye=#url.ye#" <cfif url.mo IS 10>selected="selected"</cfif> >October</option>
	  			<option value="index.cfm?da=1&amp;mo=11&amp;ye=#url.ye#" <cfif url.mo IS 11>selected="selected"</cfif> >November</option>
	  			<option value="index.cfm?da=1&amp;mo=12&amp;ye=#url.ye#" <cfif url.mo IS 12>selected="selected"</cfif> >December</option>
	      </cfoutput>
	    </select>
	  </form>
	  <form name="selyr" style="text-align: left;">
	    <select name="theselyr" onChange="gotoyr()">
	      <cfloop index="a" from="1" to="1" step="-1">
	        <cfset b = laye - a>
	        <cfoutput><option  value="index.cfm?da=1&amp;mo=#url.mo#&amp;ye=#b#" <cfif url.ye IS #b#>selected="selected"</cfif> >#b#</option></cfoutput>
	      </cfloop>
	      <cfoutput><option value="index.cfm?da=1&amp;mo=#url.mo#&amp;ye=#url.ye#" <cfif url.ye IS neye>selected="selected"</cfif> >#url.ye#</option></cfoutput>
	      <cfloop index="f" from="1" to="4" step="+1">
	        <cfset g = neye + f>
	        <cfoutput><option value="index.cfm?da=1&amp;mo=#url.mo#&amp;ye=#g#" <cfif url.ye IS #g#>selected="selected"</cfif> >#g#</option></cfoutput>
	      </cfloop>
	    </select>
	    <a href="/southern-events" class="btn site-color-3-bg site-color-1-bg-hover text-white pull-right"><i class="fa fa-bars"></i> List View</a>
	  </form>
	</div>

	<div class="row cal-bigcal">
	  <div class="col-xs-12 col-md-9">
	    <table class="table table-bordered big-cal">
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
		        <cfquery name="appshow" datasource="#settings.dsn#">
		        SELECT 	id,event_title
		        FROM 	cms_eventcal
		        WHERE	start_date = #Createdate(url.ye,url.mo,X)#
		        order by time_start
		        </cfquery>
		        <td class="hdnvc<cfif day(now()) eq X and month(now()) eq url.mo> site-color-2-bg</cfif>" width="14.28%">

		          <cfif appshow.recordcount EQ 0>

		          	 <cfoutput><span class="label site-color-1-bg">#X#</span></cfoutput>

		          <cfelse>

		            <cfoutput>
		  			    <a href="allday.cfm?da=#x#&mo=#url.mo#&ye=#url.ye#" style="margin-bottom:5px;display:block;">
		  			      <span class="label site-color-1-bg">#X#</span>
		  			    </a>
		  			  </cfoutput>

		            <cfset CV=1>
		            <cfoutput query="appshow">
		              <label class="label site-color-3-bg site-color-3-lighten-bg-hover">
		                <a href="eventshow.cfm?id=#id#" class="text-white text-white-hover"><!--- #CV#.  --->#event_title#</a>
		              </label>
		              <cfset CV=CV + 1>
		            </cfoutput>

		          </cfif>

		        </td>
		        <cfset DW=DW + 1>
		        <cfif DW EQ 7>
		          </tr>
		          <cfset DW=0>
		          <cfif X LT DaysInMonth(DateOb)><tr></cfif>
		        </cfif>
		      </cfloop>
		      <cfset TOPAD=7 - DW>
		      <cfif TOPAD LT 7>
		        <cfset PADSTR=RepeatString("<td width=""75"" class=""hdnvcgray"">&nbsp;</td>",TOPAD)>
		        <cfoutput>#PADSTR#</cfoutput>
		      </cfif>
		    </tr>
	    </table>
	  </div>
	  <div class="col-xs-12 col-md-3">
	    <cfinclude template="twomonths.cfm">
	  </div>
	</div>

</div>

</div></div></div></div>

<cfinclude template="/components/footer.cfm">