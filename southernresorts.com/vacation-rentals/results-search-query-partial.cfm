

<!--- This is code for the partial search results --->
<!---<cfif session.booking.searchbydate>--->
<cfif session.booking.searchbydate and session.booking.strcheckin neq '' and isdate(session.booking.strcheckin) and session.booking.strcheckin lt session.booking.strcheckout>

   <cfset numNights = DateDiff('d',session.booking.strcheckin,session.booking.strcheckout)>

   <!--- Get all the properties that are available 7 days prior to user's checkin date and put them in a list --->
   <cfset sevenDaysBeforeCheckin = DateAdd('d',-7,session.booking.strcheckin)>
   <cfset sevenDaysBeforeCheckin = DateFormat(sevenDaysBeforeCheckin,'yyyy-mm-dd')>

   <cfquery name="getAvailablePropertiesBeforeCheckin" dataSource="#settings.dsn#">

         select id as propertyid from track_properties

         <!--- all the dates from 7 days prior up to the checkin date are available --->
         where id IN

           (
	   
	  

              select distinct propertyid from track_properties_availability where

              <cfloop from="0" to="#numNights#" index="i">

                (thedate = #createodbcdate(dateAdd("d",i,sevenDaysBeforeCheckin))# and avail = 1 and thedate > #createodbcdate(now())#)  <cfif i lt (numNights)>or</cfif>

               </cfloop>

            )



         <!--- and the user's selected dates are not-available --->
         and id IN

            (

              select distinct propertyid from track_properties_availability where

              <cfloop from="0" to="#numNights#" index="i">

                (thedate = #createodbcdate(dateAdd("d",i,session.booking.strCheckin))# and avail = 0 and thedate > #createodbcdate(now())#)  <cfif i lt (numNights)>or</cfif>

               </cfloop>

            )

         order by ID

   </cfquery>


   <cfset tempList = ValueList(getAvailablePropertiesBeforeCheckin.propertyid)>




   <!--- Get all the properties that are available 7 days after the user's checkout date and put them in a list --->
   <cfset sevenDaysAfterCheckout = DateAdd('d',7,session.booking.strcheckout)>
   <cfset sevenDaysAfterCheckout = DateFormat(sevenDaysAfterCheckout,'yyyy-mm-dd')>

   <cfquery name="getAvailablePropertiesAfterCheckout" dataSource="#settings.dsn#">

         select id as propertyid from track_properties

         <!--- all the dates from checkout up to 7 days after are available --->
         where id IN

           (

              select propertyid from track_properties_availability where

              <cfloop from="1" to="#numNights#" index="i">

                (thedate = #createodbcdate(dateAdd("d",i,session.booking.strcheckout))# and avail = 1 and thedate > #createodbcdate(now())#)  <cfif i lt (numNights)>or</cfif>

               </cfloop>

            )

         <!--- and the user's selected dates are not-available --->
         and ID IN

            (

              select propertyid from track_properties_availability where

              <cfloop from="0" to="#numNights#" index="i">

                (thedate = #createodbcdate(dateAdd("d",i,session.booking.strCheckin))# and avail = 0 and thedate > #createodbcdate(now())#)  <cfif i lt (numNights)>or</cfif>

               </cfloop>

            )

         order by ID

   </cfquery>


   <!--- Append second list to first list --->
   <cfloop query="getAvailablePropertiesAfterCheckout">

      <cfset tempList = ListAppend(tempList,getAvailablePropertiesAfterCheckout.propertyid)>

   </cfloop>


   <!---
   Now, do a query to find any properties with at least one date available from checkin/checkout that are NOT IN the original exact match list
   This handles the situation where dates inside checkin/checkout are available. For example, the user searches from 6/29 to 7/2. The
   partial results should also return properties that are available from 6/30 to 7/2. --->
   <cfquery name="getAvailablePropertiesInsideCheckinCheckout" dataSource="#settings.dsn#">

         select id as propertyid  from track_properties

         where id NOT IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.unitCodeList#" list="yes">)

         and id IN

            (

              select propertyid from track_properties_availability where

              <cfloop from="0" to="#numNights#" index="i">

                (thedate = #createodbcdate(dateAdd("d",i,session.booking.strCheckin))# and avail = 1 and thedate > #createodbcdate(now())#)  <cfif i lt (numNights)>or</cfif>

               </cfloop>

            )

         order by id

   </cfquery>


   <!--- Append second list to first list --->
   <cfloop query="getAvailablePropertiesInsideCheckinCheckout">

      <cfset tempList = ListAppend(tempList,getAvailablePropertiesInsideCheckinCheckout.propertyid)>

   </cfloop>



   <!--- Remove any duplicates; now we have a list of properties that are available before/after user's selected dates --->
   <cfset session.booking.partialResultsList = ListRemoveDuplicates(tempList)>


</cfif>