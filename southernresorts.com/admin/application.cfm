<cfinclude template="../application.cfm">

<!--- Admin Global Settings --->
<cfset dsn = settings.dsn>
<cfset application.dsn = settings.dsn>

<cffunction name="getCount" returnType="string">
  
  <cfargument name="table" hint="Name of the database table" required="true" type="string">
    
  <cfquery name="returnCount" dataSource="#settings.dsn#">
    select count(id) as 'numrows' from #table#
  </cfquery>     
  
  <cfreturn returnCount.numrows>

</cffunction>


<!--- This is for the Price Range options on form.cfm, 'Custom Results Form' tab. This sets the min and max values for a weekly price. --->
<cfset minmaxprice = application.bookingObject.getMinMaxPrice()>
<cfset settings.booking.minPrice = minmaxprice.minPrice>
<cfset settings.booking.maxPrice = minmaxprice.maxPrice>


