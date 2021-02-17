<cfparam name="form.startDate" default="">
<cfparam name="form.endDate" default="">

<cfquery name="geteventsdates" datasource="#settings.dsn#">
  select id,start_date,end_date
  from cms_eventcal
  where end_date >= now()
        <cfif IsDate(form.startDate) AND IsDate(form.endDate)>
        	AND start_date BETWEEN <cfqueryparam value="#form.startDate#" cfsqltype="cf_sql_date"> AND <cfqueryparam value="#form.endDate#" cfsqltype="cf_sql_date">
        </cfif>
  group by start_date
  order by start_date asc
</cfquery>

<cfoutput query="geteventsdates">
	<cfquery name="getevents" datasource="#settings.dsn#">
		select *
		from cms_eventcal
		where start_date = <cfqueryparam cfsqltype="cf_sql_date" value="#start_date#" />
	</cfquery>

	<cfloop query="getevents">
		<div class="media">
			<cfset link = replace( getevents.event_title, ' ', '-', 'all' ) />

			<div class="media-left">
				<a href="#getevents.externallink#" class="media-img-link <cfif isDefined("getevents.photo") and getevents.photo eq "">no-photo</cfif>" target="_blank">
					<cfif len(getevents.photo)>
						<div class="event-img-wrap"><div data-src="/images/events/#getevents.photo#"></div></div>
					</cfif>
					<span class="date">
						<span class="date-wrap">
							<span class="start-date">
								#DateFormat(start_date,"mmm")#
								<em>#DateFormat(start_date,"dd")#</em>
							</span>
							<cfif len(end_date) and end_date is not start_date>
								<span class="end-date"><b>-</b>
									#DateFormat(end_date,"mmm")#
									<em>#DateFormat(end_date,"dd")#</em>
								</span>
							</cfif>
						</span>
					</span>
				</a>
			</div><!-- media-left -->

			<div class="media-body">
				<h2 class="media-heading">
					<cfif len(getevents.externallink) gt 0>
						<a href="#getevents.externallink#" class="site-color-3 site-color-2-hover">#getevents.event_title#</a>
					<cfelse>
						<a href="/event/#lcase( link )#/#id#" class="site-color-3 site-color-2-hover">#getevents.event_title#</a>
					</cfif>
				</h2>

				<p class="lead event-info">
					<cfif getevents.time_start is not ''>
						Starts: #getevents.time_start# <cfif getevents.time_end is not ''>| </cfif>
					</cfif>
					<cfif time_end is not ''>
						Ends: #getevents.time_end#
					</cfif>
				</p>
				#getevents.details_long#
			</div><!-- END media-body -->

		</div><!-- END media -->
	</cfloop>
</cfoutput>
