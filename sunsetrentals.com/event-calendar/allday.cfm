<cfinclude template="/components/header.cfm">

<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">

<link href="calendar.css" type="text/css" rel="stylesheet">

<cfset thisYear = year(now())>
<cfset thisMonth = month(now())>
<cfparam name="url.ye" default="#thisYear#">
<cfparam name="url.mo" default="#thisMonth#">
<cfparam name="url.da" default="01">

<!--- Set Varibles Start --->
<cfset today = Createdate(url.ye, url.mo, url.da)>

<cfquery name="appshow" datasource="#settings.dsn#">
   SELECT 	id,start_date,event_title,event_location,time_start,time_end,details_long
   FROM 	cms_eventcal
   WHERE	start_date = <cfqueryparam cfsqltype="cf_sql_date" value="#today#">
   order by time_start desc
</cfquery>

<div class="event-calendar">

	<div class="alert site-color-1-bg text-white" style="overflow:hidden;">
	  Events for <cfoutput><cfif appshow.recordcount>#dateformat(appshow.start_date, 'dddd, mmmm dd, yyyy')#<cfelse>#dateformat(today, 'dddd, mmmm dd, yyyy')#</cfif></cfoutput>
	</div>

	<div class="row">
	  <div class="col-xs-12 col-md-9">
	    <cfif appshow.recordcount>
	      <cfoutput query="appshow">
	        <div class="well">
	          <h3 style="margin-top:0">#event_title#</h3>
	          <p>#details_long#</p>
	        </div>
	      </cfoutput>
	    <cfelse>
	      <h3>No Events Scheduled</h3>
	    </cfif>
	  </div>
	  <div class="col-xs-12 col-md-3">
	    <cfoutput>
	      <cfif appshow.recordcount>
	        <a href="index.cfm?da=#day(appshow.start_date)#&mo=#month(appshow.start_date)#&ye=#year(appshow.start_date)#" class="btn btn-block site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">Home</a>
	      <cfelse>
	        <a href="index.cfm?da=#url.da#&mo=#url.mo#&ye=#url.ye#" class="btn btn-block site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">Home</a>
	      </cfif>
	    </cfoutput>

	  </div>
	</div>

</div>

</div></div></div></div>

<cfinclude template="/components/footer.cfm">