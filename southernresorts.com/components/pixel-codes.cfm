<cfquery name="GetPixelCodes" dataSource="#settings.booking.dsn#">
  select pixelcode from cms_pixel_codes
</cfquery>

<cfoutput query="GetPixelCodes">
#pixelcode# #chr(10)##chr(10)#
</cfoutput>

<cfoutput>
<cfif cgi.SCRIPT_NAME eq '/#settings.booking.dir#/book-now-confirm.cfm' AND StructKeyExists(request,'reservationCode') AND Len(request.reservationCode)>
<cftry>
  <cfif IsDefined('form.travelInsurance') and form.travelInsurance is "true">
	<cfset totalReservationAmount = form.TotalWithInsurance>
  <cfelse>
    <cfset totalReservationAmount = form.total>
  </cfif>
  <script>
    fbq('track', 'Purchase', 
	{
		currency: "USD", 
		value: #totalReservationAmount#,
		content_name: "#form.propertyname#",
		num_items: 1
	});
  </script>
  <cfcatch>
	<cfif IsDefined("ravenClient")>
        <cfset ravenClient.captureException(cfcatch)>
    </cfif>
  </cfcatch>
</cftry>
</cfif>
</cfoutput>