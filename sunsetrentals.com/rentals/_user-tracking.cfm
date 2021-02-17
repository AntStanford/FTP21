<!---START: THIS IS USED TO BIND THE BE SEARCH STATS TO A USER PROFILE NOW THAT THE USER HAS SUBMITTED THE FORM
<cftry>

	<cfif isdefined('cookie.UserTrackingCookie') is "No">
		<cfset cookie.UserTrackingCookie = "#CFID##CFTOKEN#">
	</cfif>
	
	<cfif settings.logSearchHistory eq 'yes' and cgi.HTTP_USER_AGENT does not contain 'bot'>
		<CFQUERY DATASOURCE="#settings.dsn#" NAME="GetInfo">
			update be_search_stats set TrackingEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">
			where UserTrackerValue = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#">
		</CFQUERY>
	</cfif>
	
	<cfif settings.logPropertiesViewed eq 'yes' and cgi.HTTP_USER_AGENT does not contain 'bot'>
		<CFQUERY DATASOURCE="#settings.dsn#" NAME="GetInfo">
			update be_prop_view_stats set TrackingEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">
			where UserTrackerValue = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#">
		</CFQUERY>
	</cfif>
	
	<cfif settings.logPagesViewed eq 'yes' and cgi.HTTP_USER_AGENT does not contain 'bot'>
		<CFQUERY DATASOURCE="#settings.dsn#" NAME="GetInfo">
			update be_pageviewtracking set TrackingEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">
			where UserTrackerValue = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.UserTrackingCookie#">
		</CFQUERY>
	</cfif>
	
	<cfcookie name="TrackingEmail" value="#form.email#" expires="NEVER">
	
	<cfcatch></cfcatch>
	
</cftry>
END: THIS IS USED TO BIND THE BE SEARCH STATS TO A USER PROFILE NOW THAT THE USER HAS SUBMITTED THE FORM--->