<cfquery name="getEvent" dataSource="#settings.dsn#">
	select * from cms_eventcal where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cgi.query_string#">
</cfquery>
<cfinclude template="/components/header.cfm">
<cfif getEvent.recordcount gt 0>
	<cfoutput query="getEvent">
		<div class="i-content">
		  <div class="container">
		  	<div class="row">
		  		<div class="col-lg-12">
		  		  <a href="#CGI.HTTP_REFERER#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white"><span class="glyphicon glyphicon-chevron-left"></span> Back to Events</a><br /><br />
		        <div class="row">
		          <div class="col-lg-4 col-md-4 col-sm-5">
		          	<cfif len(photo)>
		            	<img src="/images/events/#photo#" class="thumbnail" width="100%">
		            </cfif>
		          </div>
		          <div class="col-lg-8 col-md-8 col-sm-7">
		            <p class="h1 site-color-1 nopadding nomargin text-left">#event_title#</p>
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
	<div class="i-content">
		<div class="container">
			<div class="row">
				<div class="col-lg-9 col-md-8 col-sm-12">
		     		<h1>Record Not Found</h1>
		     		<p>Sorry, that record was not found.</p>
				</div>
				<div class="col-lg-3 col-md-4 col-sm-12">
      		<div class="i-sidebar">
      			<cfinclude template="/components/callouts.cfm">
      		</div>
				</div>
			</div>
		</div>
	</div>
</cfif>
<cfinclude template="/components/footer.cfm">