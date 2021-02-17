<cfquery name="GetPixelCodes" dataSource="#settings.booking.dsn#">
  select pixelcode from cms_pixel_codes
</cfquery>

<cfoutput query="GetPixelCodes">
#pixelcode# #chr(10)##chr(10)#
</cfoutput>
