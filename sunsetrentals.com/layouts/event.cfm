<cfquery name="getEvent" dataSource="#settings.dsn#">
	select * from cms_eventcal where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cgi.query_string#">
</cfquery>
<cfinclude template="/components/header.cfm">
<cfif getEvent.recordcount gt 0>
	<cfoutput query="getEvent">
		<div class="i-content int">
		  <div class="container">
		  	<div class="row">
		  		<div class="col">
		  		  <a href="/events-list" class="btn site-color-1-bg site-color-2-bg-hover text-white"><span class="glyphicon glyphicon-chevron-left"></span> Back to Events</a><br><br>
		        <div class="row">
		          <div class="col-sm-12 col-md-5 col-lg-4 col-xl-3">
		          	<cfif len(photo)>
		            	<img class="card lazy" data-src="/images/events/#photo#" src="/images/layout/1x1.png" width="100%" alt="Events #photo#">
		            </cfif>
		          </div>
		          <div class="col-sm-12 col-md-7 col-lg-8 col-xl-9">
		            <p class="h1 site-color-3 m-0 p-0">#event_title#</p>
		            <p class="h2 site-color-2">#event_location#</p>
		            <p>
		              <b>Date:</b> #DateFormat(start_date,'mm/dd/yyyy')# - #DateFormat(end_date,'mm/dd/yyyy')#<br>
		              <cfif len(time_start)><b>Starts:</b> #time_start#<br></cfif>
		              <cfif len(time_end)><b>Ends:</b> #time_end#<br></cfif>
		            </p>
		            #details_long#
		          </div>
		        </div>
		  		</div>
		  	</div>
		  </div>
		</div>
	</cfoutput>
<cfelse>
	<div class="i-content int">
		<div class="container">
			<div class="row">
				<div class="col">
          <h1>Record Not Found</h1>
          <p>Sorry, that record was not found.</p>
				</div>
			</div>
  		<cfinclude template="/components/callouts.cfm">
		</div>
  </div><!-- END i-content -->
</cfif>
<cfinclude template="/components/footer.cfm">