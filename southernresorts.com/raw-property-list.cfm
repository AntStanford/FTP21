<cfquery name="getallproperties" datasource="#settings.dsn#">
Select seoDestinationName,seoPropertyName,name
From track_properties
order by name
</cfquery>
<cfoutput query="getallproperties">
<cfset detailPage = '/#settings.booking.dir#/#seoDestinationName#/#seoPropertyName#'>
<a href="#detailpage#">#name#</a><br>
</cfoutput>