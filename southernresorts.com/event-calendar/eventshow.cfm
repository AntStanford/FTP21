<cfif !isdefined('url.id')>
   You cannot access this page.<cfabort>
</cfif>

<cfquery name="appshow" datasource="#settings.dsn#">
SELECT 	start_date,event_title,event_location,details_long,time_start,time_end,photo
FROM 	cms_eventcal
WHERE	id = <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
</cfquery>

<cfinclude template="/components/header.cfm">

<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">

<link href="/event-calendar/calendar.css" type="text/css" rel="stylesheet">





<cfset allday = Createdate(year(appshow.start_date), month(appshow.start_date), day(appshow.start_date))>
<cfquery name="otherapp" datasource="#settings.dsn#">
SELECT 	id,start_date,event_title,event_location,details_long,time_start,time_end
FROM 	cms_eventcal
WHERE	start_date = #allday#
and		id <> <cfqueryparam value="#url.id#" cfsqltype="CF_SQL_INTEGER">
order by time_start
</cfquery>
<!--- Set Varibles End --->

<div class="event-calendar">

	<div class="alert site-color-1-bg text-white" style="overflow:hidden;">
	  Events for <cfoutput><cfif appshow.recordcount>#dateformat(appshow.start_date, 'dddd, mmmm dd, yyyy')#<cfelse>#dateformat(today, 'dddd, mmmm dd, yyyy')#</cfif></cfoutput>
	</div>

	<div class="row">
	  <div class="col-xs-12 col-md-9">
	    <cfoutput query="appshow">
	      <div class="well">
	        <h3>#event_title#</h3>
	        <p>#paragraphformat(details_long)#</p>
	      </div>
	    </cfoutput>
	  </div>
	  <div class="col-xs-12 col-md-3">
	    <div class="well">
	      <h4 style="margin-top:0">Time</h4>
				<cfoutput query="appshow">
				  Start: #timeFormat(time_start, 'hh:mmtt')#<br>
				  End: #timeFormat(time_end, 'hh:mmtt')#
			  </cfoutput>
	    </div>
	    <div class="well">
			<h4 style="margin-top:0">Location</h4>
			<cfoutput query="appshow">
  			#event_location#
			</cfoutput>
	    </div>
	    <div class="well">
			<h4 style="margin-top:0">Photo</h4>
			<cfoutput query="appshow">
			 <cfif len(photo)>
  			    <img src="/images/events/#photo#" alt="#event_title#">
  			 </cfif>
			</cfoutput>
	    </div>
	    <div class="well">
	      <h4 style="margin-top:0">Other Events Today</h4>
				<cfif otherapp.recordcount>
				  <cfoutput query="otherapp">
				    <a href="eventshow.cfm?id=#id#">#event_title#</a>
				  </cfoutput>
			  <cfelse>
			  </cfif>
			</div>
			<cfoutput>
	      <a href="index.cfm?da=#day(appshow.start_date)#&mo=#month(appshow.start_date)#&ye=#year(appshow.start_date)#" class="btn btn-block site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">Home</a>
			</cfoutput>

	  </div>
	</div>
</div>

</div></div></div></div>

<cfinclude template="/components/footer.cfm">