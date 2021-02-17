<cfif cgi.remote_host eq '75.87.66.209'>
	<cftry>
		<cfset myarray = [] />
		<cfset mystruct1 = {} />
		<cfset mystruct1['displayAs'] = 'itemize' />
		<cfset mystruct1['id'] = 18 />
		<cfset mystruct1['itemPrice'] = 35.00 />
		<cfset mystruct1['itemTax'] = 2.45 />
		<cfset mystruct1['maxQuantity'] = 999 />
		<cfset mystruct1['name'] = 'Bike Adult (Weekly)' />
		<cfset mystruct1['taxable'] = 'YES' />
		<cfset mystruct1['type'] = 'flat' />
		<!--- add another and then add the car pass and then add something after that --->
		<cfset mystruct2['displayAs'] = 'itemize' />
		<cfset mystruct2['id'] = 123 />
		<cfset mystruct2['itemPrice'] = 50.00 />
		<cfset mystruct2['itemTax'] = 3.50 />
		<cfset mystruct2['maxQuantity'] = 999 />
		<cfset mystruct2['name'] = 'Bike - Jogger' />
		<cfset mystruct2['taxable'] = 'YES' />
		<cfset mystruct2['type'] = 'flat' />
		<!--- car pass --->
		<cfset mystruct3['displayAs'] = 'itemize' />
		<cfset mystruct3['id'] = 139 />
		<cfset mystruct3['itemPrice'] = 17.00 />
		<cfset mystruct3['itemTax'] = 1.87 />
		<cfset mystruct3['maxQuantity'] = 2 />
		<cfset mystruct3['name'] = 'Additional Sea Pines Car Pass' />
		<cfset mystruct3['taxable'] = 'YES' />
		<cfset mystruct3['type'] = 'flat' />
		<!--- something alphabetical that does at the end --->
		<cfset mystruct4['displayAs'] = 'itemize' />
		<cfset mystruct4['id'] = 7 />
		<cfset mystruct4['itemPrice'] = 95.00 />
		<cfset mystruct4['itemTax'] = 6.65 />
		<cfset mystruct4['maxQuantity'] = 3 />
		<cfset mystruct4['name'] = 'Crib Fee' />
		<cfset mystruct4['taxable'] = 'YES' />
		<cfset mystruct4['type'] = 'base' />
		<cfset _temp = arrayAppend( myarray, mystruct1 ) />
		<cfset _temp = arrayAppend( myarray, mystruct2 ) />
		<cfset _temp = arrayAppend( myarray, mystruct3 ) />
		<cfset _temp = arrayAppend( myarray, mystruct4 ) />
		<cfset arrayToQuery = application.bookingObject.associativeArrayToQuery( myarray ) />

		<cfquery name="sortAddons" dbtype="query">
		SELECt *
		FROM arrayToQuery
		ORDER BY sort
		</cfquery>

		<cfdump var="#arrayToQuery#" />
		<cfdump var="#sortAddons#" />
		<!---
		<cffunction name="associativeArrayToQuery" hint="Turns an array into a query.">
			<cfargument name="array_var" required="true" type="array" />

			<cftry>
				<cfset local.array_to_query = '' />

				<cfif isArray( arguments.array_var ) and arrayLen( arguments.array_var ) gt 0>
					<cfset local.query_columns = structKeyList( myarray[1] ) />
					<cfset local.query_columns &= ',sort' />
					<cfset local.array_to_query = queryNew( local.query_columns ) />
					
					<cfloop from="1" to="#arrayLen( arguments.array_var )#" index="i">
						<cfset local.array_to_query_row = queryAddRow( local.array_to_query ) />
						<cfset local.sort = 1 />

						<cfloop collection="#arguments.array_var[i]#" item="j">
							<cfif arguments.array_var[i][j] contains 'Car Pass'>
								<cfset local.sort = 0 />
							</cfif>

							<cfset querySetCell( local.array_to_query, j, arguments.array_var[i][j], local.array_to_query_row ) />
							<cfset querySetCell( local.array_to_query, 'sort', local.sort, local.array_to_query_row ) />
						</cfloop>
					</cfloop>
				</cfif>

				<cfcatch>
					<cfdump var="#cfcatch#" abort="true" />
				</cfcatch>
			</cftry>

			<cfreturn local.array_to_query />
		</cffunction>
		--->
		<cfcatch>
			<cfdump var="#cfcatch#" abort="true" />
		</cfcatch>
	</cftry>
</cfif>