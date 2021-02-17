<cfset getAmenities = settings.booking.getAmenities>
<cfset getTowns = settings.booking.getTowns>
<cfset getNeighborhoods = settings.booking.getNeighborhoods>
<cfset getBuildingComplexes = settings.booking.getBuildingComplexes>

<!---
	This list is used on the home page quick search, refine search and admin area, Custom Search form tab in the Pages module
	Change as needed per site.
	You will also need to update results-search-query-common.cfm
--->
<cfset mustHavesList = 'Pet Friendly,Condominium,Oceanfront,Cable TV'>

<!---
These are the filters that are typically found in the properties table and don't fit in other categories
like Amenities, Type or View. Modify as needed per project.
--->
<cfset otherFilters = 'Pet Friendly'>


<!--- While on dev, don't attempt to use https --->
<cfif cgi.server_name eq settings.devURL or findnocase('.icnd.',cgi.server_name)>
	<cfset settings.booking.bookingURL = 'http://' & cgi.server_name>
<cfelse>
	<cfset settings.booking.bookingURL = 'https://' & cgi.server_name>
</cfif>

<!--- set a cookie to store the recently viewed properties --->
<cfif NOT StructKeyExists(cookie,'recent')>
   <cfcookie name="recent" expires="never">
</cfif>

<!--- set a cookie to store the recently viewed properties --->
<cfif NOT StructKeyExists(cookie,'favorites')>
   <cfcookie name="favorites" expires="never">
</cfif>

<!---user tracking unique id--->
<cfif isdefined('cookie.UserTrackingCookie') is "No">
	<cfcookie name="UserTrackingCookie" value="#CFID##CFTOKEN#" expires="NEVER">
</cfif>

<!---SETS THE SESSION FOR THE QUOTES--->
<cfif isdefined('CreateQuote')>
  <cfcookie name="quotenumber" value="#QuoteNumber#">
  <cfcookie name="LeadEmail" value="#QuoteEmail#">
  <cfcookie name="SpecialistEmail" value="#SpecialistEmail#">
  <cfcookie name="SpecialistName" value="#SpecialistName#">
</cfif>


<!--- Booking engine stuff starts here --->
<cfset settings.booking.crlf = "#Chr(13)##Chr(10)#">


<!--- MOVED TO APPLICATION.CFM INIT CONDITION FOR PERFORMANCE REASONS - see /booking-folder/settings-inc-init.cfm
<cfset minmaxamenities = application.bookingObject.getMinMaxAmenities()>
<cfset settings.booking.minBed = minmaxamenities.minBed>
<cfset settings.booking.maxBed = minmaxamenities.maxBed>
<cfset settings.booking.minBath = minmaxamenities.minBath>
<cfset settings.booking.maxBath = minmaxamenities.maxBath>
<cfset settings.booking.minOccupancy = minmaxamenities.minOccupancy>
<cfset settings.booking.maxOccupancy = minmaxamenities.maxOccupancy>

<!--- needed for refine search --->
<cfset typeList = application.bookingObject.getDistinctTypes()>
<cfset areaList = application.bookingObject.getDistinctAreas()>
<cfset properties = application.bookingObject.getAllProperties()>
<cfset viewList = application.bookingObject.getDistinctViews()>

<!--- We are doing this so we can sort the list by propertyID on the refine search --->
<cfquery name="propertiesByID" dbtype="query">
	SELECT
	seoPropertyName,propertyid
	FROM properties ORDER BY propertyid
</cfquery>   --->

<cfscript>
/**
 * Flexible PIN generator, supporting alphabetical, numeric, and alphanumeric types, upper, lower, and mixed cases, and validating prescence of letters and numbers in alphanumeric PINs at least 2 characters long.
 *
 * @param chars 	 Number of characters to return. (Required)
 * @param type 	 Type of PIN to create. Types are: n (numeric), a (alphabetical), m (mixed, or alphanumeric). Default is m. (Optional)
 * @param format 	 Case of PIN. Options are: u (uppercase), l (lowercase), m (mixed). Default is m. (Optional)
 * @return Returns a string.
 * @author Sierra Bufe (&#115;&#105;&#101;&#114;&#114;&#97;&#64;&#98;&#114;&#105;&#103;&#104;&#116;&#101;&#114;&#102;&#117;&#115;&#105;&#111;&#110;&#46;&#99;&#111;&#109;)
 * @version 1, May 14, 2002
 */
function createPIN(chars){
	var type    = "m";
	var format  = "m";
	var PIN     = "";
	var isValid = false;
	var i       = 0;
	var j       = 0;
	var r	    = 0;

	// Check to see if type was provided.  If not, default to "m" (mixed, or alphanumeric).
	if (ArrayLen(Arguments) GT 1) {
		type = Arguments[2];
		if (type is "alphanumeric")
			type = "m";
		type = left(type,1);
		if ("a,n,m" does not contain type)
			return "Invalid type argument.  Valid types are:  alpha, numeric, alphanumeric, mixed, a, n, m.  This argument is optional, and defaults to alphanumeric";
	}

	// Check to see if format was provided.  If not, default to "m" (mixed upper and lower).
	if (ArrayLen(Arguments) GT 2) {
		format = Arguments[3];
		format = left(format,1);
		if ("u,l,m" does not contain format)
			return "Invalid format argument.  Valid formats are:  upper, lower, mixed, u, l, m.";
	}

	// if type is alphanumeric, set j to 10 to allow for numbers in the RandRange
	if (type is "m")
		j = 10;

	while (not isValid) {

		PIN = "";

		// loop through each character of the PIN
		for (i = 1; i LTE chars; i = i+1) {

			// numeric type
			if (type is "n") {
				r = RandRange(0,9) + 48;

			// lowercase format
			} else if (format is "l") {
				r = RandRange(97,122 + j);
				if (r GTE 123)
					r = r - 123 + 48;

			// uppercase format
			} else if (format is "u") {
				r = RandRange(65,90 + j);
				if (r GTE 91)
					r = r - 91 + 48;

			// upper and lower cases mixed
			} else if (format is "m") {
				r = RandRange(65,116 + j);
				if (r GTE 117)
					r = r - 117 + 48;
				else if (r GTE 91)
					r = r + 6;

			}

			PIN = PIN & Chr(r);
		}

		// verfify that alphanumeric strings contain both letters and numbers
		if (type is "m" AND chars GTE 2) {
			if (REFind("[A-Z,a-z]+",PIN) AND REFind("[0-9]+",PIN))
				isValid = true;
		} else {
			isValid = true;
		}

	}

	return PIN;
}
</cfscript>

<cfscript>
function fullLeft(str, count) {
    if (not refind("[[:space:]]", str) or (count gte len(str)))
        return Left(str, count);
    else if(reFind("[[:space:]]",mid(str,count+1,1))) {
          return left(str,count);
    } else {
        if(count-refind("[[:space:]]", reverse(mid(str,1,count)))) return Left(str, (count-refind("[[:space:]]", reverse(mid(str,1,count)))));
        else return(left(str,1));
    }
}
function stripHTMLR(str) {
	return REReplaceNoCase(str,"<[^>]*>","","ALL");
}
</cfscript>


<cffunction name="isAjaxRequest" output="false" returntype="boolean" access="public">
   <cfset var headers = getHttpRequestData().headers />
   <cfreturn structKeyExists(headers, "X-Requested-With") and (headers["X-Requested-With"] eq "XMLHttpRequest") />
</cffunction>