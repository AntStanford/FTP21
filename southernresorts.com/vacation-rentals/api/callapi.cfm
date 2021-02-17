<cfparam name="variables.flexCheck" default="false" />
<cfparam name="session.booking.streamlineIdList" default="" />


<cfif NOT StructKeyExists(session.booking,'methodname')>
   <cfset session.errorMessage = 'API method name is required.'>
   <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">
</cfif>

<cfinclude template="../inc-custom-search-page-settings.cfm">

<!--- <cfif isDefined("session.booking.strType") and len(session.booking.strType)>
   <cfset session.booking.home_type = session.booking.strType/>
</cfif> --->

<cfif
      cgi.HTTP_USER_AGENT contains 'Chrome' or
      cgi.HTTP_USER_AGENT contains 'MSIE' or
      cgi.HTTP_USER_AGENT contains 'Firefox' or
      cgi.HTTP_USER_AGENT contains 'Opera' or
      cgi.HTTP_USER_AGENT contains 'Safari' or
      cgi.HTTP_USER_AGENT contains 'Mozilla'>

      <cfsavecontent variable="xmlvar">
         <cfoutput>
         <?xml version="1.0" encoding="UTF-8"?>
         <methodCall>
            <methodName>#session.booking.methodname#</methodName>
            <params>
               <token_key>#settings.booking.streamlineTokenKey#</token_key>
               <token_secret>#settings.booking.streamlineTokenSecret#</token_secret>
               <cfif variables.flexCheck>
                  <turn_dates_logic>1</turn_dates_logic>
               </cfif>
          <cfif StructKeyExists(session.booking,'unit_id') and session.booking.unit_id neq '' and session.booking.unit_id gt 0>
                  <unit_id>#session.booking.unit_id#</unit_id>
               </cfif>
               <cfif StructKeyExists(session.booking,'strcheckin') and session.booking.strcheckin neq '' and IsValid('date',session.booking.strcheckin)>
                  <startdate>#session.booking.strcheckin#</startdate>
               </cfif>
               <cfif StructKeyExists(session.booking,'strcheckout') and session.booking.strcheckout neq '' and IsValid('date',session.booking.strcheckout)>
                  <enddate>#session.booking.strcheckout#</enddate>
               </cfif>
               <cfif session.booking.methodname eq 'GetPropertyAvailability'>
                <occupants>1</occupants>
               </cfif>
               <cfif session.booking.methodname eq 'MakeReservation'>

                    <status_id>10</status_id>

                    <!--- ALWAYS include TI when making a reservation - http://pt.icnd.net/projects/view-task.cfm?projectID=515&taskid=17700 --->
                    <!---
                      Update: laws have changed and now the guest must be presented with an opt-choice
                      http://pt.icnd.net/projects/view-task.cfm?projectID=387&taskid=25662
                      Cole - 07/10/2018
                    --->
                    <cfif structKeyExists( session.booking, "travel_insurance" ) and len( session.booking.travel_insurance ) gt 0>
                      <optional_fee_157277>yes</optional_fee_157277>
                    <cfelse>
                      <optional_fee_157277>no</optional_fee_157277>
                    </cfif>

                    <cfif StructKeyExists(session.booking,'maxoccupancy') and session.booking.maxoccupancy neq '' and session.booking.maxoccupancy gt 0>
                        <occupants>#session.booking.maxoccupancy#</occupants>
                    </cfif>
                    <cfif StructKeyExists(session.booking,'coupon_code') and session.booking.coupon_code neq ''>
                        <coupon_code>#session.booking.coupon_code#</coupon_code>
                    </cfif>
                    <cfparam name="form.mobile_phone" default="555-5555">
                    <cfparam name="form.client_comments" default="website">
                    <maketype_id>1</maketype_id> <!--- indicates an internet booking --->
                    <mobile_phone>#form.mobile_phone#</mobile_phone> <!--- required for booking --->
                    <hear_about_new>I Do Not Know The Source</hear_about_new> <!--- required for booking --->
                <cfelse>
                    <cfif StructKeyExists(session.booking,'maxoccupancy') and session.booking.maxoccupancy neq '' and session.booking.maxoccupancy gt 0>
                        <min_occupants>#session.booking.maxoccupancy#</min_occupants>
                    </cfif>
                </cfif>
               <cfif StructKeyExists(session.booking,'bedrooms') and session.booking.bedrooms neq '' and session.booking.bedrooms contains ','>
                  <min_bedrooms_number>#ListFirst(session.booking.bedrooms)#</min_bedrooms_number>
                  <max_bedrooms_number>#ListLast(session.booking.bedrooms)#</max_bedrooms_number>
               </cfif>
               <cfif StructKeyExists(session.booking,'bathrooms') and session.booking.bathrooms neq '' and session.booking.bathrooms contains ','>
                  <min_bathrooms_number>#ListFirst(session.booking.bathrooms)#</min_bathrooms_number>
                  <max_bathrooms_number>#ListLast(session.booking.bathrooms)#</max_bathrooms_number>
               </cfif>
               <cfif StructKeyExists(session.booking,'strSortBy') and session.booking.strSortBy neq '' and !variables.flexCheck>
                  <sort_by>#session.booking.strSortBy#</sort_by>
               </cfif>
               <cfif StructKeyExists(form,'first_name') and len(form.first_name)>
                  <first_name>#form.first_name#</first_name>
               </cfif>
               <cfif StructKeyExists(form,'last_name') and len(form.last_name)>
                  <last_name>#form.last_name#</last_name>
               </cfif>
               <cfif StructKeyExists(form,'email') and len(form.email)>
                  <email>#form.email#</email>
               </cfif>
               <cfif StructKeyExists(form,'country_name') and len(form.country_name)>
                  <country_name>#form.country_name#</country_name>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_type_id') and len(form.credit_card_type_id) and isValid('integer',form.credit_card_type_id)>
                  <credit_card_type_id>#form.credit_card_type_id#</credit_card_type_id>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_number') and len(form.credit_card_number)>
                  <credit_card_number>#form.credit_card_number#</credit_card_number>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_cid') and len(form.credit_card_cid)>
                  <credit_card_cid>#form.credit_card_cid#</credit_card_cid>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_expiration_month') and len(form.credit_card_expiration_month) and isValid('integer',form.credit_card_expiration_month)>
                  <credit_card_expiration_month>#form.credit_card_expiration_month#</credit_card_expiration_month>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_expiration_year') and len(form.credit_card_expiration_year) and isValid('integer',form.credit_card_expiration_year)>
                  <credit_card_expiration_year>#form.credit_card_expiration_year#</credit_card_expiration_year>
               </cfif>
               <cfif StructKeyExists(form,'credit_card_amount') and len(form.credit_card_amount)>
                  <credit_card_amount>#form.credit_card_amount#</credit_card_amount>
               </cfif>
               <cfif StructKeyExists(form,'address') and len(form.address)>
                  <address>#form.address#</address>
               </cfif>
               <cfif StructKeyExists(form,'address2') and len(form.address2)>
                  <address2>#form.address2#</address2>
               </cfif>
               <cfif StructKeyExists(form,'city') and len(form.city)>
                  <city>#form.city#</city>
               </cfif>
               <cfif StructKeyExists(form,'zip') and len(form.zip)>
                  <zip>#form.zip#</zip>
               </cfif>
               <cfif StructKeyExists(form,'state_name') and len(form.state_name)>
                  <state_name>#form.state_name#</state_name>
               </cfif>
               <cfif StructKeyExists(form,'client_comments') and len(form.client_comments)>
                  <client_comments>#form.client_comments#</client_comments>
               </cfif>
               <cfif StructKeyExists(form,'numChildren') and len(form.numChildren) and form.numChildren gt 0>
                  <occupants_small>#form.numChildren#</occupants_small>
               </cfif>
               <cfif StructKeyExists(form,'phone') and len(form.phone)>
                  <phone>#form.phone#</phone>
               </cfif>
               <cfif isdefined('url.coupon_code') and url.coupon_code neq ''>
                 <coupon_code>#url.coupon_code#</coupon_code>
               </cfif>
               <cfif isdefined('url.optionalfee')>
                  <cfloop list="#url.optionalfee#" index="i">
                    <cfif i neq '157277'>
                     <cfset feeNode = "<optional_fee_#i#>yes</optional_fee_#i#>">
                     #feeNode#
                    </cfif>
                  </cfloop>
               </cfif>
               <cfif isdefined('url.numpets') and len(url.numpets)>
                  <pets>#url.numpets#</pets>
               </cfif>
               <cfif isdefined('session.booking.neighborhoodAreaId') and len(session.booking.neighborhoodAreaId)>
                  <neighborhood_area_id>#session.booking.neighborhoodAreaId#</neighborhood_area_id>
               </cfif>
               <cfif isdefined('session.booking.longtermEnabled') and len(session.booking.longtermEnabled)>
                  <longterm_enabled>#session.booking.longtermEnabled#</longterm_enabled>
               </cfif>
               <cfif isdefined('session.booking.condoTypeGroupId') and len(session.booking.condoTypeGroupId)>
                  <condo_type_group_id>#session.booking.condoTypeGroupId#</condo_type_group_id>
               </cfif>
               <cfif isdefined('session.booking.amenities') and len(session.booking.amenities)>
                  <amenities_filter>#session.booking.amenities#</amenities_filter>
               </cfif>
               <cfif isdefined('session.booking.luxury') and len(session.booking.luxury)>
                  <condo_type_group_id>#session.booking.luxury#</condo_type_group_id>
               </cfif>
               <cfif isdefined('session.booking.lakefront') and len(session.booking.lakefront)>
                  <resort_area_id>#session.booking.lakefront#</resort_area_id>
               </cfif>
               <cfif isdefined('session.booking.hash') and len(session.booking.hash)>
                  <hash>#session.booking.hash#</hash>
               </cfif>
               <!--- <cfif isdefined('session.booking.strarea') and len(session.booking.strarea)>
                  <location_area_name>#session.booking.strarea#</location_area_name>
               </cfif> --->
               <!--- <cfif isdefined('session.booking.home_type') and len(session.booking.home_type)>
                  <home_type>#session.booking.home_type#</home_type>
               </cfif> --->
               <cfif isdefined('session.booking.resort_area_id') and len(session.booking.resort_area_id)>
                <resort_area_id>#session.booking.resort_area_id#</resort_area_id>
               </cfif>
               
               <cfif isdefined('session.booking.travel_insurance')>
                <!--- ALWAYS include TI when making a reservation - http://pt.icnd.net/projects/view-task.cfm?projectID=515&taskid=17700 --->
                <!--- IF this is a reservation, it is already included --->
                <!---
                  Update: laws have changed and now the guest must be presented with an opt-choice
                  http://pt.icnd.net/projects/view-task.cfm?projectID=387&taskid=25662
                  Cole - 07/10/2018
                --->
                <cfif session.booking.methodname neq 'MakeReservation'>
                  <cfif len( session.booking.travel_insurance ) gt 0>
                    <optional_fee_157277>#session.booking.travel_insurance#</optional_fee_157277>
                  <cfelse>
                    <optional_fee_157277>no</optional_fee_157277>
                  </cfif>
                </cfif>
               </cfif>

               <cfparam name="form.blnPoolHeat" default="false"/>
               <cfif form.blnPoolHeat or cgi.script_name contains "book-now.cfm">
                 <cfif isdefined('session.booking.pool_heat') and session.booking.pool_heat neq 'No'>
                  <optional_fee_#session.booking.pool_heat#>yes</optional_fee_#session.booking.pool_heat#>
					 <cfelse>
						<optional_fee_131290>no</optional_fee_131290>
						<optional_fee_131446>no</optional_fee_131446>
					 </cfif>
                </cfif>


               <cfif findnocase('reservation', session.booking.methodname) and StructKeyExists(session,'shoppingcart') and arraylen(session.shoppingcart) gt 0>
                  <cfloop from="1" to="#arraylen(session.shoppingcart)#" index="i">

                     <cfset session.booking.streamlineIdList = listappend(session.booking.streamlineIdList, session.shoppingCart[i].amenity_id) />

                     <cfset itmamt = session.shoppingCart[i].amt />
                     <cfset itmqty = session.shoppingCart[i].qty />
                     <cfset itmnm = session.shoppingCart[i].nm />
                     <cfset itmid = session.shoppingCart[i].id />
                     <cfset amenity_id = session.shoppingCart[i].amenity_id />
                     <cfif session.shoppingCart[i].amt neq '' and session.shoppingCart[i].amt neq '0'>
                        <amenity_addon>
                           <amenity_id>#amenity_id#</amenity_id>
                           <amenity_quantity>#itmqty#</amenity_quantity>
                        </amenity_addon>
                        <!---<optional_fee_#amenity_id#>#itmqty#</optional_fee_#amenity_id#>--->
                     </cfif>

                  </cfloop>

               </cfif>
            </params>
         </methodCall>
         </cfoutput>
      </cfsavecontent>


 <cfif session.booking.methodname eq "GetPreReservationPrice" AND cgi.remote_addr eq "108.52.31.150">
<textarea rows="20" cols="200">

<cfoutput>
#xmlvar#
</cfoutput>

</textarea><br>

</cfif>

 <cfif session.booking.methodname eq "MakeReservation" AND cgi.remote_addr eq "108.52.31.150">
<textarea rows="20" cols="200">

<cfoutput>
#xmlvar#
</cfoutput>

</textarea><br>
<!---<cfabort/>--->
</cfif>

<!--- ADOUTE DEBUG --->
<!--- <cfif listFindNoCase('216.99.119.254x,70.40.89.12', cgi.REMOTE_ADDR)><cfoutput><script>console.log('session.booking.pool_heat: <cfif isdefined('session.booking.pool_heat')>#session.booking.pool_heat#<cfelse>not defined</cfif>');</script></cfoutput></cfif> --->
<!--- ADOUTE DEBUG --->

<!--- ADOUTE DEBUG --->
<!--- <cfif listFindNoCase('216.99.119.254,70.40.89.12', cgi.REMOTE_ADDR)><cfset variables.ADapiStart = getTickCount() /></cfif> --->
<!--- ADOUTE DEBUG --->

      <cfhttp url="#settings.booking.streamlineendpoint#" method="POST" timeout="30">
         <cfhttpparam type="header" name="content-type" value="text/xml" />
         <cfhttpparam type="header" name="content-length" value="#Len(Trim(XMLvar))#" />
         <cfhttpparam type="header" name="charset" value="utf-8" />
         <cfhttpparam type="xml" value="#Trim(XMLvar)#" />
      </cfhttp>
      
      <cfif cgi.remote_addr eq "98.114.40.122" <!---or cgi.remote_host eq '107.195.105.158'--->><hr><cfoutput><textarea>#cfhttp.filecontent#</textarea></cfoutput><hr></cfif>

<!--- ADOUTE DEBUG --->
<!--- <cfif listFindNoCase('216.99.119.254,70.40.89.12', cgi.REMOTE_ADDR)>
   <cfset variables.ADapiEnd = getTickCount() />
   <cfset variables.ADapiTime = variables.ADapiEnd - variables.ADapiStart />
   <cfoutput><script>console.log('api: #variables.ADapiTime#ms');</script></cfoutput>
</cfif> --->
<!--- ADOUTE DEBUG --->
<!--- ADOUTE DEBUG --->
<cfif 1 is 1 and listFindNoCase('216.99.119.254x,209.188.54.252,68.49.100.68,67.209.3.171', cgi.REMOTE_ADDR)>
  <!--- <cfoutput>#expandPath('./temp-xml/req-#(timeformat(now(),'HHmmss'))#.xml')#</cfoutput> --->
  <cffile action="write" file="#expandPath('./temp-xml/req-#(timeformat(now(),'HHmmss'))#.xml')#" output="#XMLvar#">
  <cffile action="write" file="#expandPath('./temp-xml/res-#(timeformat(now(),'HHmmss'))#.xml')#" output="#cfhttp.filecontent#">
</cfif>
<!--- ADOUTE DEBUG --->
      <!---<cfoutput>#session.booking.methodname#<br><textarea>#cfhttp.filecontent#</textarea></cfoutput>--->

      <cftry>

         <!--- We should be hitting this on the second go around if a hash was supplied in the url --->
         <cfif session.booking.methodname eq 'GetPreReservationPrice'>



             <cfset xmlstring = xmlparse(trim(cfhttp.Filecontent))>

             <!---  <cfif ListFind('216.99.119.254,70.35.186.44', CGI.REMOTE_ADDR)><cfdump var="#xmlstring#"></cfif> --->

             <!--- Equates to rent... --->
             <cfif StructKeyExists(xmlstring.response.data,'price') and xmlstring.response.data.price.xmltext gt 0>
                   <cfset session.booking.price = xmlstring.response.data.price.xmltext>
             </cfif>

             <cfif StructKeyExists(xmlstring.response.data,'coupon_discount') and xmlstring.response.data.coupon_discount.xmltext gt 0>
                   <cfset session.booking.coupon_discount = xmlstring.response.data.coupon_discount.xmltext>
             </cfif>

             <cfif StructKeyExists(xmlstring.response.data,'total') and xmlstring.response.data.total.xmltext gt 0>
                   <cfset session.booking.total = xmlstring.response.data.total.xmltext>
             </cfif>

             <cfset session.booking.required_fees = 0>
             <cfif structKeyExists(xmlstring.response.data,"required_fees") and  StructKeyExists(xmlstring.response.data.required_fees, 'value')>
                <cfloop from="1" to="#arraylen(xmlstring.response.data.required_fees)#" index="i">
                    <cfset session.booking.required_fees += LSParseNumber(xmlstring.response.data.required_fees[i].value.xmltext)>
                </cfloop>
             </cfif>

             <cfset session.booking.optional_fees = 0>
             <cfset session.booking.tiFee = 0>

             <cfif StructKeyExists(xmlstring.response.data.optional_fees, 'value')>
                <cfloop from="1" to="#arraylen(xmlstring.response.data.optional_fees)#" index="i">
                    <cfset session.booking.optional_fees += LSParseNumber(xmlstring.response.data.optional_fees[i].value.xmltext)>
                    
                    <!--- <cfif xmlstring.response.data.optional_fees[i].name.xmltext eq 'Red Sky Travel Insurance'> --->
                    <cfif xmlstring.response.data.optional_fees[i].id.xmltext eq '157277'>
                        <cfset session.booking.tiFee = LSParseNumber(xmlstring.response.data.optional_fees[i].value.xmltext)>
                    </cfif>
                </cfloop>
             </cfif>

             <cfset session.booking.taxes_details = 0>
             <cfif StructKeyExists(xmlstring.response.data.taxes_details, 'value')>
                <cfloop from="1" to="#arraylen(xmlstring.response.data.taxes_details)#" index="i">
                    <cfset session.booking.taxes_details += LSParseNumber(xmlstring.response.data.taxes_details[i].value.xmltext)>
                </cfloop>
             </cfif>

         </cfif>

         <!--- record all booking attempts --->
         <cfif session.booking.methodname eq 'MakeReservation'>

            <!--- Added to catch when the visitor enters in wrong information such as a credit card number --->
            <!--- It still needs to log, and the visitor needs to be informed that the reservation never happened --->
            <cfif cfhttp.filecontent contains 'E0'>
                <cfset insertAPILogEntry(settings.id,cgi.server_name,cgi.script_name,xmlVar,cfhttp.filecontent)>

                <cfset session.errorMessage = cfhttp.filecontent>
                <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">
            <cfelse>
                <cfset insertAPILogEntry(settings.id,cgi.server_name,cgi.script_name,xmlVar,cfhttp.filecontent)>
            </cfif>

         </cfif>

         <cfif cfhttp.filecontent contains 'error' AND cfhttp.filecontent does not contain '<season>error</season>'>

            <h1>API Response</h1>
            <cfdump var="#cfhttp.filecontent#"><cfabort>

            <cfif isdefined("ravenClient")>
               <cfset ravenClient.captureMessage('callAPI.cfm. Line 132. cfhttp.filecontent = ' & cfhttp.filecontent)>
            </cfif>
            <cfset session.errorMessage = cfhttp.filecontent>
            <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">

         <cfelseif cfhttp.filecontent eq 'connection timeout'>

            <cfif isdefined("ravenClient")>
               <cfset ravenClient.captureMessage('callAPI.cfm. Line 153. cfhttp.filecontent = Connection Timeout')>
            </cfif>
            <cfset session.errorMessage = 'API Connection Timeout'>
            <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">

         <cfelse>

            <cfset xmlstring = xmlparse(trim(cfhttp.Filecontent))>





<!--- <h1>Api response</h1><cfdump var="#xmlstring#"> --->





            <cfif isdefined('xmlstring.response.status')>

               <cfset session.errorMessage = xmlstring.response.status.description>
               <cfset session.booking.actualResponse = xmlstring.response.status.description.xmltext>


                <cfif cgi.script_name eq '/vacation-rentals/book-now.cfm'>
                    <cfoutput>
                        <!--- <cflocation addToken="no" url="/vacation-rentals/#session.booking.unit_id#/#session.booking.unit_id#"> --->
                        <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">
                    </cfoutput>
                </cfif>

            </cfif>

         </cfif>

      <cfcatch>
         <cfif isdefined("ravenClient")>
               <cfset ravenClient.captureMessage(cfcatch,50)>
         </cfif>
         
         <cfset session.errorMessage = cfcatch.message>
<cfdump var="#cfhttp.filecontent#">
<cfdump var="#cfcatch#" abort="true">         
         <cflocation addToken="no" url="/vacation-rentals/booking-error.cfm">
      </cfcatch>
      </cftry>

<cfelse>
   no bots allowed <cfabort>
</cfif>
