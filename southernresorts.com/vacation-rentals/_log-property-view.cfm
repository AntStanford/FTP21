<cfif settings.logPropertiesViewed eq 'yes'>
			
	<cfquery datasource="#settings.dsn#">
		INSERT INTO be_prop_view_stats (siteID,unitcode,unitshortname,
		<cfif isdefined('Cookie.TrackingEmail')>TrackingEmail<cfelse>UserTrackerValue</cfif>
		<cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin) and isValid('date',session.booking.strcheckin)>
			,checkin
		</cfif>
		<cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout) and isValid('date',session.booking.strcheckout)>
			,checkout
		</cfif>
		)
		VALUES(
		<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#settings.id#">,
		<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#property.propertyid#">,
		<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#property.name#">
		<cfif isdefined('Cookie.TrackingEmail')>
			,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.TrackingEmail#">
		<cfelse>
			,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#">
		</cfif>
		<cfif isdefined('session.booking.strcheckin') and len(session.booking.strcheckin) and isValid('date',session.booking.strcheckin)>
			,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#session.booking.strcheckin#">
		</cfif>
		<cfif isdefined('session.booking.strcheckout') and len(session.booking.strcheckout) and isValid('date',session.booking.strcheckout)>
			,<cfqueryparam CFSQLType="CF_SQL_DATE" value="#session.booking.strcheckout#">
		</cfif>		
		)
	</cfquery>
	
	<!---END: LOGGING PROPERTIES VIEWED--->

</cfif>