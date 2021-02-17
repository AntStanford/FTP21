<cfif isDefined("slug")>
<cfset session.booking.weddingproperties = ((slug eq 'gulf-coast-weddings') ? 1 : 0)>
	</cfif>
<cfinclude template="/#settings.booking.dir#/results.cfm">