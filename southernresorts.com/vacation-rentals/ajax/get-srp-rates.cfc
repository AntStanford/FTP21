<cfcomponent>
	<cffunction name="getRates" access="remote">
		<cfargument name="propertyid">
		<cfargument name="checkin">
		<cfargument name="checkout">
		<cfargument name="resortproplist">
		<cfset returns = application.bookingObject.getDetailRates2(arguments.propertyid,arguments.checkin,arguments.checkout,arguments.resortproplist)>
		<cfset rates = structNew()>
		<cfset rates.apiresponse = returns.apiresponse>
		<cfset rates.total = returns.total>
			
		<cfset newRates = arrayNew(1)>
		<<cfset newRates[1] = returns.total>
			
		<cfset rates3 = "{total: '#returns.total#'}">
			
			
		<cfscript>
		// Define the local scope.
		var LOCAL = StructNew();
		// Create the string buffer for creating the response string.
		LOCAL.ResponseBuffer = CreateObject( "java", "java.lang.StringBuffer" );
		// Start the object.
		LOCAL.ResponseBuffer.Append( "{" );
		// Get the key count.
		LOCAL.KeyCount = StructCount( rates );
		// Get an index for keeping track of the key usage.
		LOCAL.KeyIndex = 1;
		// Loop over the keys to create the object values.
		for (LOCAL.Key in rates){
			// Get the value.
			LOCAL.Value = rates[ LOCAL.Key ];
			// Add the pair. Escape the value so that is doesn't break the string. This requires the
			// use of the "\" before single quotes, double quotes, and backward slashes (which
			// ordinarily would be special characters in Javascript).
			LOCAL.ResponseBuffer.Append( LCase( LOCAL.Key ) & ":""" & REReplace( LOCAL.Value, "(""|\\)", "\\\1", "ALL" ) & """" );
			// Check to see if we need to add the comma.
			if (LOCAL.KeyIndex LT LOCAL.KeyCount){
				LOCAL.ResponseBuffer.Append( "," );
			}
			// Add one to the key index.
			LOCAL.KeyIndex = (LOCAL.KeyIndex + 1);
		}
		// End the object.
		LOCAL.ResponseBuffer.Append( "}" );
		// Return the string.
		
	</cfscript>
			<cfflush>
			<cfoutput>#Replace(responseBuffer.ToString()#</cfoutput>
		
	</cffunction>
		
		
</cfcomponent>