<cfset minmaxamenities 					= application.bookingObject.getMinMaxAmenities()>
<cfset settings.booking.minBed 			= minmaxamenities.minBed>
<cfset settings.booking.maxBed 			= minmaxamenities.maxBed>
<cfset settings.booking.minBath 		= minmaxamenities.minBath>
<cfset settings.booking.maxBath 		= minmaxamenities.maxBath>
<cfset settings.booking.minOccupancy 	= minmaxamenities.minOccupancy>
<cfset settings.booking.maxOccupancy 	= minmaxamenities.maxOccupancy> 

<!--- needed for refine search --->
<cfset settings.booking.typeList 		= application.bookingObject.getDistinctTypes()>
<cfset settings.booking.areaList 		= application.bookingObject.getDistinctAreas()>
<cfset settings.booking.locations 		= application.bookingObject.getLocations()>
<cfset settings.booking.properties 		= application.bookingObject.getAllProperties()>
<cfset settings.booking.viewList 		= application.bookingObject.getDistinctViews()>  

<!--- We are doing this so we can sort the list by propertyID on the refine search --->
<cfquery name="settings.booking.propertiesByID" dbtype="query">
    SELECT 
    seoPropertyName,propertyid
    FROM settings.booking.properties ORDER BY propertyid
</cfquery>  

<cfquery name="settings.booking.getAmenities" dataSource="#settings.dsn#">
    select * from cms_amenities order by title
</cfquery>