<!---
Function index:

addcoupon

bookNow

checkout

getCalendarData

getCalendarDataForDatePickers

getCalendarRates

getDetailRates

getFeaturedProperties

getMinMaxAmenities

getMinMaxPrice

getProperty

getPropertyAmenities

getPropertyPhotos

getPropertyPriceRange

getPropertyRates

getPropertyReviews

getSearchResults

getSearchResultsProperty

setGoogleAnalytics

setMetaData

submitLeadToThirdParty

getDistinctTypes

getDistinctAreas

getDistinctViews

getAllProperties

insertAPILogEntry

getRandomProperties

getSearchFilterCount

getPriceBasedOnDates
--->




<cfcomponent hint="Barefoot CFC">

   <cffunction name="init" access="public" output="false" hint="constructor">
      <cfargument name="settings" type="struct" required="true" hint="settings" />
      <cfset variables.settings = arguments.settings>
      <cfreturn this />
   </cffunction>

   <cffunction name="addCoupon" returnType="string" hint="Used in book-now.cfm to process a promo code">

   	<cfargument name="leaseID" required="true">
   	<cfargument name="promocode" required="true">
   	<cfargument name="useraction" required="false">

   	<!--- Local variables --->
   	<cfset totalamount = 0>
		<cfset travelinsuranceAmt = 0>

		<cfsavecontent variable="AddCouponXML">
			<AddCoupon xmlns="http://www.barefoot.com/Services/">
				<username>#settings.booking.username#</username>
				<password>#settings.booking.password#</password>
				<barefootAccount>#settings.booking.account#</barefootAccount>
				<leaseid>#arguments.leaseid#</leaseid>
				<couponCode>c#arguments.promocode#-1</couponCode>
			</AddCoupon>
   	</cfsavecontent>

   	<cftry>

				<cfhttp url="#settings.booking.barefootSoapURL#/AddCoupon" timeout="#settings.booking.barefootTimeout#">
					<cfhttpparam type="formField" name="username" value="#settings.booking.username#">
					<cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
					<cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
					<cfhttpparam type="formfield" name="leaseid" value="#arguments.leaseid#">
					<cfhttpparam type="formfield" name="couponCode" value="c#arguments.promocode#-1">
				</cfhttp>

				<cfif isdefined('cfhttp.filecontent') and isXML(cfhttp.FileContent)>

					<cfset xmlDocCoupon = xmlparse(trim(cfhttp.FileContent))>
		         <cfset dataStringCoupon = xmlDocCoupon.string.xmltext>
		         <cfsavecontent variable="xmlStringCoupon"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataStringCoupon#</cfoutput></root></cfsavecontent>
		         <cfset xmlStringCoupon = Replace(xmlStringCoupon,'&','&amp;','all')>
		         <cfset parsedStringCoupon = xmlparse(trim(xmlStringCoupon))>

					<cfset insertAPILogEntry(cgi.script_name,AddCouponXML,parsedStringCoupon)>

					<!--- Let's determine if the coupon code was succesful or not --->
         		<cfset ResponseBoolean = parsedStringCoupon.root.Response.Success.xmltext>
         		<cfset ResponseMessage = parsedStringCoupon.root.Response.Message.xmltext>

					<!--- Typically this would be your break down of all the fees and taxes --->
					<cfif structkeyexists(parsedStringCoupon.root.Response.RateDetailsList,'propertyratesdetails')>
						<cfset feesArray = parsedStringCoupon.root.Response.RateDetailsList.propertyratesdetails>
					</cfif>

					<!--- This displays info about deposits/future payments/due now --->
		         <cfif structkeyexists(parsedStringCoupon.root.Response,'PaymentScheduleList')>
		           <cfset depositsArray = parsedStringCoupon.root.Response.paymentschedulelist.paymentschedule>
		           <cfset totalAmountForAPI = parsedStringCoupon.root.Response.PaymentScheduleList.PaymentSchedule[1].amount.xmltext>
		         </cfif>

		         <cfif ResponseBoolean is 'false' and ResponseMessage is 'Invalid coupon code'>
            		<cfset apiresponse = "Error">
         		<cfelse>
               	<cfsavecontent variable="apiresponse">
		         		<cfinclude template="/#settings.booking.dir#/common/_barefoot-summary-of-fees.cfm">
		         	</cfsavecontent>
         		</cfif>

				<cfelse>

				</cfif>

   	<cfcatch>
   		<cfset insertAPILogEntry(cgi.script_name,AddCouponXML,cfcatch.message)>
   		<cfset apiresponse = cfcatch.message>
   	</cfcatch>

   	</cftry>

   	<cfreturn apiresponse>

   </cffunction>

   <cffunction name="selectOptionalServices" returnType="string" hint="Used in book-now.cfm to add/remove services like travel insurance">

   	<cfargument name="useraction" required="true">
   	<cfargument name="leaseID" required="true">
   	<cfargument name="serviceID" required="true">

   	<!--- Local variables --->
   	<cfset totalamount = 0>
		<cfset travelinsuranceAmt = 0>

   	<cftry>

		   	<cfif arguments.useraction eq 'add_insurance'>

					<cfhttp url="#settings.booking.barefootSoapURL#/selectOptionalServices" timeout="#settings.booking.barefootTimeout#">
						<cfhttpparam type="formField" name="username" value="#settings.booking.username#">
						<cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
						<cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
						<cfhttpparam type="formfield" name="leaseid" value="#arguments.leaseid#">
						<cfhttpparam type="formfield" name="selectedServiceIDs" value="#arguments.serviceID#">
						<cfhttpparam type="formfield" name="waivedServiceIDs" value="">
					</cfhttp>

					<cfset requestList = ''>

					<cfloop list="#StructKeyList(arguments)#" index="i">
        				<cfset requestList = ListAppend(requestList,"#i# = #arguments[i]#")>
    				</cfloop>

					<cfset insertAPILogEntry(cgi.script_name,requestList,cfhttp.filecontent)>

		   	<cfelseif arguments.useraction eq 'remove_insurance'>

		   		<cfhttp url="#settings.booking.barefootSoapURL#/selectOptionalServices" timeout="#settings.booking.barefootTimeout#">
						<cfhttpparam type="formField" name="username" value="#settings.booking.username#">
						<cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
						<cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
						<cfhttpparam type="formfield" name="leaseid" value="#arguments.leaseid#">
						<cfhttpparam type="formfield" name="selectedServiceIDs" value="">
						<cfhttpparam type="formfield" name="waivedServiceIDs" value="#arguments.serviceID#">
					</cfhttp>

					<cfset requestList = ''>

					<cfloop list="#StructKeyList(arguments)#" index="i">
        				<cfset requestList = ListAppend(requestList,"#i# = #arguments[i]#")>
    				</cfloop>

					<cfset insertAPILogEntry(cgi.script_name,requestList,cfhttp.filecontent)>

		   	</cfif>

		   	<cfif isdefined('cfhttp.filecontent') and isXML(cfhttp.filecontent)>

					<cfset xmlDocInsurance = xmlparse(trim(cfhttp.FileContent))>
					<cfset dataStringInsurance = xmlDocInsurance.string.xmltext>
					<cfsavecontent variable="xmlStringInsurance"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataStringInsurance#</cfoutput></root></cfsavecontent>
					<cfset xmlStringInsurance = Replace(xmlStringInsurance,'&','&amp;','all')>
					<cfset parsedStringInsurance = xmlparse(trim(xmlStringInsurance))>

					<cfif structkeyexists(parsedStringInsurance.root.PropertyRates,'propertyratesdetails')>
   					<cfset feesArray = parsedStringInsurance.root.PropertyRates.propertyratesdetails>
   				</cfif>

					<cfif structkeyexists(parsedStringInsurance.root.PaymentScheduleList,'paymentschedule')>
   					<cfset totalAmountForAPI = parsedStringInsurance.root.paymentschedulelist.paymentschedule[1].amount.xmltext>
   					<cfset depositsArray = parsedStringInsurance.root.paymentschedulelist.paymentschedule>
   				</cfif>

					<cfsavecontent variable="apiresponse">
		         	<cfinclude template="/#settings.booking.dir#/common/_barefoot-summary-of-fees.cfm">
		         </cfsavecontent>

		   	</cfif>

		   	<cfcatch>

		   		<cfsavecontent variable="apiresponse">
		   			<cfdump var="#cfcatch#">
		   		</cfsavecontent>

		   	</cfcatch>

   	</cftry>

   	<cfreturn apiresponse>

   </cffunction>

   <cffunction name="bookNow" returnType="string" hint="Used in book-now_.cfm to check availability and get pricing for the checkout page">

		<cfargument name="propertyid" required="true">
		<cfargument name="strcheckin" required="true">
		<cfargument name="strcheckout" required="true">
		<cfargument name="numAdults" required="true" default="0">
		<cfargument name="numChildren" required="true" default="0">
		<cfargument name="maxoccupancy" required="true">
		<cfargument name="useraction" required="false" default="add_insurance"> <!--- This is how you set your default insurance choice; set to 'remove_insurance' if insurance is not included by default --->

		<!--- Local variables --->
		<cfset var unitAvailable = "yes">
   	<cfset var totalamount = 0>
		<cfset var travelinsuranceAmt = 0>


		<!--- Let's just double check and make sure it's still available --->
		<cftry>

			<cfhttp url="#settings.booking.barefootSoapURL#/GetPropertyIDByTerm" timeout="#settings.booking.barefootTimeout#">
	         <cfhttpparam type="formField" name="username" value="#settings.booking.username#">
	         <cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
	         <cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
	         <cfhttpparam type="formField" name="date1" value="#arguments.strcheckin#">
	         <cfhttpparam type="formField" name="date2" value="#arguments.strcheckout#">
	         <cfhttpparam type="formField" name="weekly" value="0"> <!--- obsolete --->
	         <cfhttpparam type="formField" name="sleeps" value="0">
	         <cfhttpparam type="formField" name="baths" value="0">
	         <cfhttpparam type="formField" name="bedrooms" value="0">
	         <cfhttpparam type="formField" name="strwhere" value="and propertyid = '#arguments.propertyid#'">
	      </cfhttp>

	      <cfcatch>
				<cfif isdefined("ravenClient")>
					<cfset ravenClient.captureException(cfcatch)>
				</cfif>
	         <cfset apiresponse = "Error: #cfcatch.message#">
	      </cfcatch>

      </cftry>

		<cfif isdefined('cfhttp.FileContent') and isXML(cfhttp.FileContent)>

			<cftry>

				<cfset xmlDoc = xmlparse(trim(cfhttp.FileContent))>
	         <cfset dataString = xmlDoc.string.xmltext>
	         <cfsavecontent variable="xmlString"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataString#</cfoutput></root></cfsavecontent>
	         <cfset xmlString = Replace(xmlString,'&','&amp;','all')>
	         <cfset parsedString = xmlparse(trim(xmlString))>

	         <cfif isDefined("parsedString.root.Property.PropertyID")>
	         	<cfset unitAvailable = 'Yes'>
	         <cfelse>
	            <cfset unitAvailable = 'No'>
	         </cfif>

	         <cfcatch>
	         	<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureException(cfcatch)>
					</cfif>
		         <cfset apiresponse = "Error: #cfcatch.message#">
	         </cfcatch>

         </cftry>

		</cfif>


		<!--- Unit is still available, download rates from API --->
		<cfif isdefined('unitAvailable') and unitAvailable eq 'Yes'>

			<cfhttp url="#settings.booking.barefootSoapURL#/CreateQuoteAndGetPaymentSchedule" timeout="#settings.booking.barefootTimeout#">
		     <cfhttpparam type="formField" name="username" value="#settings.booking.username#">
		     <cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
		     <cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
		     <cfhttpparam type="formfield" name="strADate" value="#arguments.strcheckin#">
		     <cfhttpparam type="formfield" name="strDDate" value="#arguments.strcheckout#">
		     <cfhttpparam type="formfield" name="propertyId" value="#arguments.propertyid#">
		     <cfhttpparam type="formfield" name="num_adult" value="#arguments.numAdults#">
		     <cfhttpparam type="formfield" name="num_pet" value="0">
		     <cfhttpparam type="formfield" name="num_baby" value="0">
		     <cfhttpparam type="formfield" name="num_child" value="#arguments.numChildren#">
		     <cfhttpparam type="formfield" name="reztypeid" value="#settings.booking.reztypeid#">
		   </cfhttp>

		   <cfif isdefined('cfhttp.FileContent') and cfhttp.filecontent contains 'leaseid' and isXML(cfhttp.filecontent)>

				   <cftry>

		            <cfset isavailable = 'Yes'>
		            <cfset xmlDoc = xmlparse(cfhttp.FileContent)>
		            <cfset dataString = xmlDoc.string.xmltext>
		            <cfsavecontent variable="xmlString"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataString#</cfoutput></root></cfsavecontent>
		            <cfset xmlString = Replace(xmlString,'&','&amp;','all')>
		            <cfset parsedString = xmlparse(trim(xmlString))>

		            <cfset leaseid = parsedString.root.outputlist.quoteinfo.leaseid.xmltext>
		            <cfset feesArray = parsedString.root.outputlist.ratedetailslist.propertyratesdetails>
		            <cfset depositsArray = parsedString.root.outputlist.paymentschedulelist.paymentschedule>
		            <cfset dueToday = parsedString.root.outputlist.paymentschedulelist.paymentschedule[1].amount.xmltext>

		            <cfsavecontent variable="apiresponse">
		            	<cfinclude template="/#settings.booking.dir#/common/_barefoot-summary-of-fees.cfm">
		            </cfsavecontent>

		            <!--- This script loads the data from the API call to the hidden input fields in the checkout form --->
						<script type="text/javascript">
				         $('input.leaseid').val("<cfoutput>#leaseid#</cfoutput>");
				      </script>

		       <cfcatch>

		            <cfif isdefined("ravenClient")>
							<cfset ravenClient.captureException(cfcatch)>
						</cfif>

		            <cfset apiresponse = "Error: #cfcatch.message#">

		       </cfcatch>

		       </cftry>

		   </cfif>

		<cfelse>
		   <cfset apiresponse = "Error: Sorry, that unit is no longer available. API Response = #cfhttp.FileContent#">
		</cfif>



		<!--- Let's make sure the user is not brining more guests than allowed --->
		<cfset totalGuests = arguments.numAdults + arguments.numChildren>

		<cfif totalGuests gt arguments.maxoccupancy>

			<cfset apiresponse = 'The total number of adults + children exceeds the max occupancy of this unit. Please update the form and try again.'>

		</cfif>

		<cfreturn apiresponse>

   </cffunction> <!--- end of bookNow function --->


   <cffunction name="checkout" returnType="string" hint="Book and confirm the reservation">

	   	<cfargument name="form" required="true">
	   	<cfset reservationCode = "">

	   	<cfif isdefined('form.comments') and form.comments NEQ ''>

		   	<!--- This XML is only for logging purposes --->
			   <cfsavecontent variable="xmlvarsetcommentsinfo">
			      <cfoutput>
	             <SetCommentsInfo xmlns="http://www.barefoot.com/Services/">
	               <username>#settings.booking.username#</username>
	               <password>#settings.booking.password#</password>
	               <barefootAccount>#settings.booking.account#</barefootAccount>
	               <leaseid>#form.leaseid#</leaseid>
	               <comments>#form.comments#</comments>
	               <commentType>-1</commentType>
	             </SetCommentsInfo>
			      </cfoutput>
			   </cfsavecontent>

			  <cftry>
			        <cfhttp url="#settings.booking.barefootSoapURL#/SetCommentsInfo" timeout="#settings.booking.barefootTimeout#">
			          <cfhttpparam type="formField" name="username" value="#settings.booking.username#">
			          <cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
			          <cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
			          <cfhttpparam type="formfield" name="leaseid" value="#form.leaseid#">
			          <cfhttpparam type="formfield" name="comments" value="#form.comments#">
			          <cfhttpparam type="formfield" name="commentType" value="-1">
			        </cfhttp>
			  <cfcatch>
			  	   <cfif isdefined("ravenClient")>
			      	<cfset ravenClient.captureMessage("Barefoot.cfc->checkout->SetCommentsInfo = #cfcatch.message#")>
			      </cfif>
			      <cfset insertAPILogEntry(cgi.script_name,xmlvarsetcommentsinfo,"Barefoot.cfc->checkout->SetCommentsInfo = #cfcatch.message#")>
			  </cfcatch>
			  </cftry>

		  </cfif>

		   <!--- This XML is only for logging purposes --->
			<cfsavecontent variable="xmlvarSetConsumerInfo">
			   <cfoutput>
	          <SetConsumerInfo xmlns="http://www.barefoot.com/Services/">
	            <username>#settings.booking.username#</username>
	            <password>#settings.booking.password#</password>
	            <barefootAccount>#settings.booking.account#</barefootAccount>
	            <Info>
	              <string>#form.address1#</string>
	              <string>#form.address2#</string>
	              <string>#form.city#</string>
	              <string>#form.state#</string>
	              <string>#form.zip#</string>
	              <string>#form.country#</string>
	              <string>#form.lastname#</string>
	              <string>#form.firstname#</string>
	              <string>#form.phone#</string>
	              <string><!--- #form.bizphone# ---></string>
	              <string><!--- #form.fax# ---></string>
	              <string><!--- #form.cellphone# ---></string>
	              <string>#form.email#</string>
	              <string>#form.strcheckin#</string>
	              <string>#form.strcheckout#</string>
	              <string>#form.propertyid#</string>
	              <string>Internet</string>
	            </Info>
	          </SetConsumerInfo>
			   </cfoutput>
			</cfsavecontent>

			<cftry>

				  <cfhttp url="#settings.booking.barefootSoapURL#/SetConsumerInfo" result="SetConsumerInfoResult" timeout="#settings.booking.barefootTimeout#">
				    <cfhttpparam type="formfield" name="username" value="#settings.booking.username#">
				    <cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
				    <cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
				    <cfhttpparam type="formfield" name="Info" value="#form.address1#">
				    <cfhttpparam type="formfield" name="Info" value="#form.address2#">
				    <cfhttpparam type="formfield" name="Info" value="#form.city#">
				    <cfhttpparam type="formfield" name="Info" value="#form.state#">
				    <cfhttpparam type="formfield" name="Info" value="#form.zip#">
				    <cfhttpparam type="formfield" name="Info" value="#form.country#">
				    <cfhttpparam type="formfield" name="Info" value="#form.lastname#">
				    <cfhttpparam type="formfield" name="Info" value="#form.firstname#">
				    <cfhttpparam type="formfield" name="Info" value="#form.phone#">
				    <cfhttpparam type="formfield" name="Info" value=""> <!--- #form.bizphone# --->
				    <cfhttpparam type="formfield" name="Info" value=""> <!--- #form.fax# --->
				    <cfhttpparam type="formfield" name="Info" value=""> <!--- #form.cellphone# --->
				    <cfhttpparam type="formfield" name="Info" value="#form.email#">
				    <cfhttpparam type="formfield" name="Info" value="#form.strcheckin#">
				    <cfhttpparam type="formfield" name="Info" value="#form.strcheckout#">
				    <cfhttpparam type="formfield" name="Info" value="#form.propertyid#">
				    <cfhttpparam type="formfield" name="Info" value="Internet">
				  </cfhttp>

				  <cfset xmlDocResult = xmlparse(SetConsumerInfoResult.Filecontent)>

			  	  <!--- We need this tid in the next API call --->
			  	  <cfset tid = xmlDocResult.int.xmlText>

			  <cfcatch>

			    <cfif isdefined("ravenClient")>
			      <cfset ravenClient.captureMessage("Barefoot.cfc->checkout->SetConsumerInfo = #cfcatch.message#")>
			    </cfif>

			    <cfset insertAPILogEntry(cgi.script_name,xmlvarSetConsumerInfo,"Barefoot.cfc->checkout->SetConsumerInfo = #cfcatch.message#")>

			    <cfset apiresponse = "Error: Sorry, there was an issue processing your request: #cfcatch.message#">

			  </cfcatch>

			</cftry>

			<cfif isdefined('tid') and len(tid)>

					<cfprocessingdirective suppresswhitespace="yes">
					<cfsavecontent variable="XMLvar">
					<cfoutput>
					<?xml version="1.0" encoding="utf-8"?>
					<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					  <soap:Body>
					    <PropertyBookingNew xmlns="http://www.barefoot.com/Services/">
					      <username>#settings.booking.username#</username>
					      <password>#settings.booking.password#</password>
					      <barefootAccount>#settings.booking.account#</barefootAccount>
					      <Info>

					         <cfif cgi.server_name eq settings.devURL OR Find('216.99.119.254',cgi.remote_host)>
					             <string>ON</string> <!--- Use test mode? --->
					             <string>0</string>
					         <cfelse>
					             <string>FALSE</string> <!--- Use test mode? --->
					             <string>#form.totalAmountForAPI#</string>
					         </cfif>

					      	<string></string>
					      	<string>#form.propertyid#</string>
					      	<string>#form.strcheckin#</string>
					      	<string>#form.strcheckout#</string>
					      	<string>#tid#</string>
					      	<string>#form.leaseid#</string>
					      	<string></string>
					      	<string>#form.ccFirstName#</string>
					      	<string>#form.ccLastName#</string>
					      	<string></string>
					      	<string>S</string>
					      	<string>C</string>
					      	<string>#form.ccNumber#</string>
					      	<string>#form.ccMonth#</string>
					      	<string>#form.ccYear#</string>
					      	<string>#form.ccCVV#</string>
					      	<string>HOTEL</string>
					      	<string>#form.ccType#</string>
					      	<string></string>
					      	<string></string>
					      	<string></string>
					      	<string></string>
					      	<string></string>
					      </Info>
					       <portalid>0</portalid>
					     </PropertyBookingNew>
					  </soap:Body>
					</soap:Envelope>
					</cfoutput>
					</cfsavecontent>
					</cfprocessingdirective>

					<cfset XMLVar = trim(XMLVar)>

					<cfsavecontent variable="HEADERS">
					<cfoutput>Content-Type: text/xml; charset=utf-8#settings.booking.CRLF#Content-Length: #len(XMLVar)##settings.booking.CRLF#SOAPAction:http://www.barefoot.com/Services/PropertyBookingNew#settings.booking.CRLF#</cfoutput>
					</cfsavecontent>

					<cftry>

					   <CFX_HTTP
					   METHOD="POST"
					   URL="#settings.booking.barefootSoapURL#"
					   HEADERS=#HEADERS#
					   BODY=#XMLvar#
					   OUT="RES"
					   SSL="5">

					   <cfif status eq "ER">
					      <cfif isdefined("ravenClient")>
					         <cfset ravenClient.captureMessage("Barefoot.cfc->checkout->PropertyBookingNew. cfx_http.status eq 'ER'. ERRN = #ERRN# and MSG = #MSG#")>
					      </cfif>
					      <cfset insertAPILogEntry(cgi.script_name,xmlvar,"Barefoot.cfc->checkout->PropertyBookingNew. ERRN = #ERRN# and MSG = #MSG#")>
					      <cfset session.errorMesssage = "Error number = #errn#, Error message = #msg#">
					      <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
					   </CFIF>

					<cfcatch>
					   <cfif isdefined("ravenClient")>
					      <cfset ravenClient.captureMessage('Barefoot.cfc->checkout->PropertyBookingNew. Location A. cfcatch =' & cfcatch.message)>
					   </cfif>
					   <cfset insertAPILogEntry(cgi.script_name,xmlvar,"Barefoot.cfc->checkout->PropertyBookingNew. Location A. cfcatch = #cfcatch.message#")>
					   <cfset session.errorMesssage = cfcatch.message>
					   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
					</cfcatch>

					</cftry>

					<cfif isdefined('RES') and isXML(RES)>

						   <cfset insertAPILogEntry(cgi.script_name,xmlVar,RES)>

						   <cftry>

							      <cfset xmlDoc = xmlparse(trim(RES))>
							      <cfset resultstring = xmlDoc.Envelope.Body.PropertyBookingNewResponse.PropertyBookingNewResult.xmltext>

							      <cfif resultstring contains 'FolioID'>

							            <cfset parsedResult = xmlparse(resultstring)>
							            <cfset reservationCode = parsedResult.paymentinfo.folioID.xmltext>
							            <cfset amount = parsedResult.paymentinfo.amount.xmltext>

							            <cfinclude template="/#settings.booking.dir#/_confirm-email.cfm">

							            <cfinclude template="/#settings.booking.dir#/_log-booking.cfm">

							      <cfelse>

							            <cfif isdefined("ravenClient")>
							               <cfset ravenClient.captureMessage('Barefoot.cfc->checkout->PropertyBookingNew. Location B. Result string did not contain FolioID; resultstring = #resultstring#')>
							            </cfif>
							            <cfset session.errorMessage = resultstring>
							            <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

							      </cfif>

							<cfcatch>

							   <cfif isdefined("ravenClient")>
							      <cfset ravenClient.captureMessage('Barefoot.cfc->checkout->PropertyBookingNew. Location C. cfcatch = ' & cfcatch.message)>
							   </cfif>
							   <cfset session.errorMessage = cfcatch.message>
							   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

							</cfcatch>

							</cftry>

					<cfelse>
					   <cfif isdefined("ravenClient")>
			      		<cfset ravenClient.captureMessage('Barefoot.cfc->checkout->PropertyBookingNew. Location D. RES was not defined for some reason.')>
			   		</cfif>
					   <cfset session.errorMesssage = 'RES is undefined.'>
					   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">
					</cfif>

		   <cfelse>

				<cfif isdefined("ravenClient")>
			      <cfset ravenClient.captureMessage('Barefoot.cfc->checkout->PropertyBookingNew. Location E. TID is not defined for some reason.')>
			   </cfif>
			   <cfset session.errorMessage = 'TID is undefined.'>
			   <cflocation addToken="no" url="/#settings.booking.dir#/booking-error.cfm">

			</cfif> <!--- if tid isdefined() --->

	   	<cfreturn reservationCode>

	</cffunction>


   <cffunction name="getCalendarData" returnType="string" hint="Used in _calendar-tab.cfm to get all the non-available dates">

   	<cfargument name="propertyid" required="true">
   	<cfset nonAvailList = ''>

		<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select startdate,enddate
			from bf_non_available_dates
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.propertyid#">
			order by startdate
		</cfquery>

		<cfloop query="nonavaildates">
			<cfset formattedStartDate = DateFormat(startdate,'mm/dd/yyyy')>
			<cfset nonAvailList = ListAppend(nonAvailList,formattedStartDate)>

			<!--- Get the difference in num nights between start date and end date --->
			<cfset numNights = DateDiff('d',startdate,enddate)>

			<cfloop from="1" to="#numNights#" index="i">
				<cfset newDate = DateAdd('d',i,startdate)>
				<cfset newDate = DateFormat(newDate,'mm/dd/yyyy')>
				<cfset nonAvailList = ListAppend(nonAvailList,newDate)>
			</cfloop>
		</cfloop>

		<cfreturn nonAvailList>

   </cffunction> <!--- end of getCalenderData function --->

   <cffunction name="getCalendarDataForDatePickers" returnType="string" hint="Used to produce smart date pickers on the PDP">

   	<cfargument name="propertyid" required="true">
   	<cfset nonAvailListForDatepicker = ''>

   	<cfquery name="nonavaildates" dataSource="#variables.settings.booking.dsn#">
			select startdate,enddate
			from bf_non_available_dates
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.propertyid#">
			order by startdate
		</cfquery>

		<cfloop from="1" to="#nonavaildates.recordcount#" index="i">

		   <cfset myStartDate = DateFormat(nonavaildates['startdate'][i],'mm/dd/yyyy')>
		   <cfset myEndDate = DateFormat(nonavaildates['enddate'][i],'mm/dd/yyyy')>

		   <!--- First record, go ahead and add 1 day to the startdate and add it to the list --->
		   <cfif i eq 1>

		      <cfset myStartDate = dateAdd('d',1,myStartDate)>
		      <cfset myStartDate = DateFormat(myStartDate,'mm/dd/yyyy')>
		      <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

		   <cfelse>

		      <cfset prevRowEndDate = nonavaildates['enddate'][i-1]> <!--- Get the previous records's end date --->
		      <cfset prevRowEndDate = DateFormat(prevRowEndDate,'mm/dd/yyyy')>

		      <cfif myStartDate neq prevRowEndDate> <!--- if the current row's start date neq previous row's end date, add 1 --->

		         <cfset myStartDate = dateAdd('d',1,myStartDate)>
		         <cfset myStartDate = DateFormat(myStartDate,'mm/dd/yyyy')>

		         <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>

		      <cfelse> <!--- the current row's start date DOES equal the previous row's end date, DO NOT ADD 1, but add to the list --->
		          <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,myStartDate)>
		      </cfif>

		   </cfif>

		   <cfset newEndDate = DateAdd('d',-1,myEndDate)> <!--- always subtract 1 from the end date --->

		   <cfset numNights = DateDiff('d',myStartDate,newEndDate)> <!--- get the difference between start date and end date --->

		   <cfloop from="1" to="#numNights#" index="i"> <!--- add i to the start date and add to the list --->

		      <cfset newDate = DateAdd('d',i,myStartDate)>
		      <cfset newDate = DateFormat(newDate,'mm/dd/yyyy')>

		      <cfset nonAvailListForDatepicker = ListAppend(nonAvailListForDatepicker,newDate)>

		   </cfloop>

		</cfloop>

		<cfreturn nonAvailListForDatepicker>

   </cffunction>



   <cffunction name="getCalendarRates" returnType="numeric" hint="Used in _calendar-tab.cfm to display weekly price on the calendar">

   	<cfargument name="propertyid" required="true">
   	<cfargument name="thedate" required="true">

   	<cfset var qryGetCalendarRates = ''>

		<cfquery name="qryGetCalendarRates" dataSource="#variables.settings.booking.dsn#">
			select rent
			from bf_rates
			where pricetype = 'Weekly'
			and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			and '#thedate#' between startdate and enddate
		</cfquery>

		<cfif qryGetCalendarRates.recordcount gt 0 and qryGetCalendarRates.rent gt 0>
			<cfreturn qryGetCalendarRates.rent>
		<cfelse>
			<cfreturn 0>
		</cfif>

   </cffunction> <!--- end of getCalendarRates function --->



   <cffunction name="getDetailRates" returnType="string" hint="Used on the property detail page to check availability and retrieve summary of fees">

   	<cfargument name="propertyid" required="true">
   	<cfargument name="strcheckin" required="true">
   	<cfargument name="strcheckout" required="true">

   	<cfset totalAmount = 0>

   	<cfif cgi.HTTP_USER_AGENT does not contain 'bot'>

   		<cftry>

				<cfhttp url="#settings.booking.barefootSoapURL#/GetQuoteRatesDetail" timeout="#settings.booking.barefootTimeout#">
					<cfhttpparam type="formField" name="username" value="#settings.booking.username#">
					<cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
					<cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
					<cfhttpparam type="formfield" name="strADate" value="#arguments.strcheckin#">
					<cfhttpparam type="formfield" name="strDDate" value="#arguments.strcheckout#">
					<cfhttpparam type="formfield" name="propertyId" value="#propertyid#">
					<cfhttpparam type="formfield" name="num_adult" value="0">
					<cfhttpparam type="formfield" name="num_pet" value="0">
					<cfhttpparam type="formfield" name="num_baby" value="0">
					<cfhttpparam type="formfield" name="num_child" value="0">
					<cfhttpparam type="formfield" name="reztypeid" value="#settings.booking.reztypeid#">
				</cfhttp>

				<cfif isXML(cfhttp.filecontent) and cfhttp.filecontent contains 'propertyratesdetails'>

					<cfset xmlDoc = xmlparse(trim(cfhttp.FileContent))>
					<cfset dataString = xmlDoc.string.xmltext>
					<cfsavecontent variable="xmlString"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataString#</cfoutput></root></cfsavecontent>
					<cfset xmlString = Replace(xmlString,'&','&amp;','all')>
               <cfset parsedString = xmlparse(trim(xmlString))>
               <cfset feesArray = parsedString.root.propertyratesdetails>

               <cfsavecontent variable="APIresponse">
               <cfoutput>
						<cfquery name="getMinNightStay" dataSource="#variables.settings.booking.dsn#">
							select NumOfMinDay from bf_mindays where #createodbcdate(arguments.strcheckin)# between Period_From and Period_To
							and propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
						</cfquery>
						<cfif getMinNightStay.recordcount gt 0>
                  	<p align="center">Minimum night stay: #getMinNightStay.NumOfMinDay#</p>
                  </cfif>
						<ul class="property-cost-list">
							<cfloop from="1" to="#arraylen(feesArray)#" index="i">
							<cfset theamount = feesArray[i].ratesvalue.xmltext>
								<cfif theamount gt 0>
									<li>#feesArray[i].ratesname.xmltext# <span class="text-right">#DollarFormat(feesArray[i].ratesvalue.xmltext)#</span></li>
									<cfset totalamount = totalamount + #feesArray[i].ratesvalue.xmltext#>
								</cfif>
							</cfloop>
							<li><strong>Total <span class="text-right">#DollarFormat(totalAmount)#</span></strong></li>
						</ul>
            <!-- BOOK NOW BUTTON -->
					  <a id="detailBookBtn" class="btn detail-book-btn site-color-1-bg site-color-1-lighten-bg-hover text-white" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#arguments.propertyid#&strcheckin=#arguments.strcheckin#&strcheckout=#arguments.strcheckout#"><i class="fa fa-check"></i> Book Now</a>
					  <cfset numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
					  <a id="splitCostCalc" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-black" type="button" data-toggle="modal" data-target="##splitCostModal" href="/#settings.booking.dir#/_family-calculator.cfm?total=#totalAmount#&numnights=#numnights#"><i class="fa fa-calculator"></i> Split Cost Calc</a>
					  <input type="hidden" id="splitCalcTotalVal" name="splitCalcTotalVal" value="#totalAmount#">
					  <input type="hidden" id="splitCalcNumNightVal" name="splitCalcNumNightVal" value="#numnights#">
               </cfoutput>
               </cfsavecontent>

            <cfelse>
					<cfsavecontent variable="APIResponse">
						<cfoutput><div class="alert alert-danger">#cfhttp.filecontent#</div></cfoutput>
					</cfsavecontent>
				</cfif>

				<cfcatch>
					<cfsavecontent variable="APIResponse">
						<cfoutput><div class="alert alert-danger">#cfcatch#</div></cfoutput>
					</cfsavecontent>
					<cfif isdefined("ravenClient")>
						<cfset ravenClient.captureMessage('Barefoot.cfc->getDetailRates = ' & cfcatch.message)>
					</cfif>
				</cfcatch>

			</cftry>

   	</cfif>

   	<cfreturn apiresponse>

   </cffunction>



   <cffunction name="getFeaturedProperties" returnType="query" hint="Returns the featured properties typically displayed on the homepage">

         <cfquery name="propertyCheck" dataSource="#variables.settings.dsn#">
            select strpropid from cms_featured_properties order by rand()
         </cfquery>

         <cfif propertyCheck.recordcount gt 0 and len(propertyCheck.strpropid)>

            <cfset var propList = ValueList(propertyCheck.strpropid)>

            <cfquery name="getProperties" dataSource="#variables.settings.booking.dsn#">
               select
                  propertyid,
                  name,
                  bedrooms,
                  bathrooms,
                  maxoccupancy as sleeps,
                  imagePath as photo,
                  seopropertyname,
                  propAddress as address
               from bf_properties
               where propertyid IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propList#" list="yes">)
            </cfquery>

         <cfelse>

            <cfquery name="getProperties" dataSource="#variables.settings.booking.dsn#">
               select
                  propertyid,
                  name,
                  bedrooms,
                  bathrooms,
                  maxoccupancy as sleeps,
                  imagePath as photo,
                  seopropertyname,
                  propAddress as address
               from bf_properties
               order by rand()
               limit 6
            </cfquery>

         </cfif>

         <cfreturn getProperties>

   </cffunction> <!--- end of getFeaturedProperties function --->


   <cffunction name="getMinMaxAmenities" returnType="struct" hint="Returns min/max values for common amenities like bedrooms,bathrooms and occupancy, typically used on refine search sliders">

		<cfset var qryGetMinMaxAmenities = "">

		<cfquery name="qryGetMinMaxAmenities" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(bedrooms) as minBed,
				max(bedrooms) as maxBed,
				min(bathrooms) as minBath,
				max(bathrooms) as maxBath,
				min(maxOccupancy) as minOccupancy,
				max(maxOccupancy) as maxOccupancy
			FROM
				bf_properties
		</cfquery>

		<cfset localStruct = StructNew()>

		<cfset localStruct['minBed'] = qryGetMinMaxAmenities.minBed>
		<cfset localStruct['maxBed'] = qryGetMinMaxAmenities.maxBed>
		<cfset localStruct['minBath'] = qryGetMinMaxAmenities.minBath>
		<cfset localStruct['maxBath'] = qryGetMinMaxAmenities.maxBath>
		<cfset localStruct['minOccupancy'] = qryGetMinMaxAmenities.minOccupancy>
		<cfset localStruct['maxOccupancy'] = qryGetMinMaxAmenities.maxOccupancy>

		<cfreturn localStruct>

   </cffunction>


   <cffunction name="getMinMaxPrice" returnType="struct" hint="Returns min/max rates for the refine search price range slider">

		<cfargument name="strcheckin" type="date" required="false">
		<cfargument name="strcheckout" type="date" required="false">

		<cfset var qryGetMinMaxPrice = "">
		<cfset var priceType = 'Weekly'>

		<cfif
			isdefined('arguments.strcheckin') and
			len(arguments.strcheckin) and
			isvalid('date',arguments.strcheckin) and
			isdefined('arguments.strcheckout') and
			len(arguments.strcheckout) and
			isvalid('date',arguments.strcheckout) and
			DateDiff('d',arguments.strcheckin,arguments.strcheckout) lt 7
			>

				<cfset priceType = 'Daily'>

		</cfif>

		<cfquery name="qryGetMinMaxPrice" datasource="#variables.settings.booking.dsn#">
			SELECT
				min(rent) as minPrice,
				max(rent) as maxPrice
			FROM
				bf_rates
			WHERE
				startdate >= '#DateFormat(now(),"YYYY")#-01-01'
		   AND
		   	pricetype = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#priceType#">
		</cfquery>

		<cfif qryGetMinMaxPrice.minPrice neq '' and qryGetMinMaxPrice.minPrice gt 0>
			<cfset localStruct['minprice'] = int(qryGetMinMaxPrice.minPrice)>
			<cfset localStruct['maxprice'] = ceiling(qryGetMinMaxPrice.maxPrice)>
		<cfelse>
			<cfset localStruct['minprice'] = 0>
			<cfset localStruct['maxprice'] = 0>
		</cfif>

		<cfreturn localStruct>

   </cffunction>


   <cffunction name="getProperty" returnType="query" hint="Returns all the basic information for a given property">

   	<cfargument name="propertyid" required="false">
   	<cfargument name="slug" required="false">

   	<cfset var qryGetProperty = "">

   	<cfquery name="qryGetProperty" dataSource="#variables.settings.booking.dsn#">
			SELECT
			name,
			description,
			seopropertyname,
			propertyid,
			imagePath as defaultPhoto,
			imagePath as largePhoto,
			unittype as type,
			'' as type,
			IF(petsallowed = 0,'Pets Not Allowed','Pets Allowed') as petsallowed,
			location,
			maxoccupancy as sleeps,
			bedrooms,
			bathrooms,
			latitude,
			longitude,
			'' as city,
			'' as state,
			'' as checkouttime,
			'' as checkintime,
			'' as `view`,
			propAddress as address
			from bf_properties
			<cfif len(arguments.propertyid)>
				where propertyid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.propertyid#">
			<cfelseif len(arguments.slug)>
				where seopropertyname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
			</cfif>
		</cfquery>

		<cfreturn qryGetProperty>

   </cffunction> <!--- end of getProperty --->



   <cffunction name="getPropertyAmenities" returnType="struct" hint="Returns all the amenities for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyAmenities = "">

		<cfquery name="qryGetPropertyAmenities" dataSource="#variables.settings.booking.dsn#">
			select name,amenityvalue
			from bf_property_amenities
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			order by name
		</cfquery>

		<cfset localStruct = StructNew()>

		<cfloop query="qryGetPropertyAmenities">
			<cfset StructInsert(localStruct,name,amenityvalue,true)>
		</cfloop>

		<cfreturn localStruct>

   </cffunction> <!--- end of getPropertyAmenities --->



   <cffunction name="getPropertyPhotos" returnType="query" hint="Returns all the photos for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyPhotos = "">

		<cfquery name="qryGetPropertyPhotos" dataSource="#variables.settings.booking.dsn#">
			select
				imagepath as original,
				imagepath as large,
				imagepath as thumbnail,
				imagedesc as caption
			from bf_propertyimages
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			order by imageno
		</cfquery>

		<cfreturn qryGetPropertyPhotos>

   </cffunction> <!--- end of getPropertyPhotos --->


   <cffunction name="getPropertyPriceRange" returnType="string" hint="Returns the min/max price for a given property">

   	<cfargument name="propertyid" required="true" type="string">
   	<cfargument name="strcheckin" required="false">

		<cfset var qryGetPropertyPriceRange = "">

		<cfquery name="qryGetPropertyPriceRange" dataSource="#variables.settings.booking.dsn#">
			select min(rent) as minPrice, max(rent) as maxPrice
			from bf_rates
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			and startdate >= '#DateFormat(now(),"YYYY")#-01-01'
			and pricetype = 'Weekly'

			<cfif isdefined('arguments.strcheckin') and len(arguments.strcheckin)>
				and #createodbcdate(arguments.strcheckin)# between startdate and enddate
			</cfif>

		</cfquery>

		<cfif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice neq qryGetPropertyPriceRange.maxPrice>
		  <cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.minPrice) & ' - ' & DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Week</small>'>
		<cfelseif qryGetPropertyPriceRange.recordcount gt 0 and len(qryGetPropertyPriceRange.minPrice) and len(qryGetPropertyPriceRange.maxPrice) and qryGetPropertyPriceRange.minPrice eq qryGetPropertyPriceRange.maxPrice>
			<cfset tempReturn = DollarFormat(qryGetPropertyPriceRange.maxPrice) & ' <small>Per Week</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>


   <cffunction name="getPropertyRates" returnType="query" hint="Returns all the rates for a given property">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyRates = "">

   	<cfquery name="qryGetPropertyRates" dataSource="#variables.settings.booking.dsn#">
			select startdate as start_date,enddate as end_date,
			   (SELECT rent from bf_rates er2 where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#"> and er2.startdate = bf_rates.startdate and pricetype = 'daily') as nightly_rate,
			   (SELECT rent from bf_rates er3 where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#"> and er3.startdate = bf_rates.startdate and pricetype = 'weekly') as weekly_rate
			from
				bf_rates where
   			propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			group by start_date
			order by start_date
		</cfquery>

		<cfreturn qryGetPropertyRates>

   </cffunction> <!--- end of getPropertyRates --->



    <cffunction name="getPropertyReviews" returnType="struct" hint="Returns reviews from be_reviews">

   	<cfargument name="propertyid" required="true">

   	<cfset var qryGetPropertyReviews = "">

		<cfquery name="qryGetPropertyReviews" dataSource="#variables.settings.dsn#">
			select rvw.* , rsp.response, rsp.createdAt AS responseCreatedAt
			from be_reviews rvw
           left join be_responses_to_reviews rsp ON rvw.id = rsp.reviewID
			where rvw.unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			and rvw.approved = 'Yes'
			order by rvw.createdat
		</cfquery>

		<cfset reviewStruct = StructNew()>

		<cfloop query="qryGetPropertyReviews">

			<cfset localStruct = structnew()>

			<cfset localStruct.createdat = qryGetPropertyReviews.createdat>
			<cfset localStruct.title = qryGetPropertyReviews.title>
			<cfset localStruct.firstname = qryGetPropertyReviews.firstname>
			<cfset localStruct.lastname = qryGetPropertyReviews.lastname>
			<cfset localStruct.review = qryGetPropertyReviews.review>
			<cfset localStruct.rating = qryGetPropertyReviews.rating>
			<cfset localStruct.hometown = qryGetPropertyReviews.hometown>
			<cfset localStruct.response = qryGetPropertyReviews.response>
			<cfset localStruct.responseCreatedAt = qryGetPropertyReviews.responseCreatedAt>

			<cfset StructInsert(reviewStruct,qryGetPropertyReviews.id,localStruct)>

		</cfloop>

		<cfreturn reviewStruct>

   </cffunction> <!--- end of getPropertyReviews function --->



   <cffunction name="getSearchResults" hint="Calls the API and returns search results based on user's chosen parameters">

   	<cfset var qryGetSearchResults = ''>

   	<cftry>

   			<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate is true>

   				<!--- Only use API when user is searching by dates --->
					<cfhttp url="#settings.booking.barefootSoapURL#/GetPropertyIDByTerm" timeout="#settings.booking.barefootTimeout#">
						<cfhttpparam type="formField" name="username" value="#settings.booking.username#">
						<cfhttpparam type="formfield" name="password" value="#settings.booking.password#">
						<cfhttpparam type="formfield" name="barefootAccount" value="#settings.booking.account#">
						<cfhttpparam type="formField" name="date1" value="#session.booking.strcheckin#">
						<cfhttpparam type="formField" name="date2" value="#session.booking.strcheckout#">
						<cfhttpparam type="formField" name="weekly" value="0"> <!--- obsolete --->
						<cfhttpparam type="formField" name="sleeps" value="0">
						<cfhttpparam type="formField" name="baths" value="0">
						<cfhttpparam type="formField" name="bedrooms" value="0">
						<cfhttpparam type="formField" name="strwhere" value="">
					</cfhttp>

					<cfset xmlDoc = xmlparse(trim(cfhttp.FileContent))>
					<cfset dataString = xmlDoc.string.xmltext>
					<cfsavecontent variable="xmlString"><?xml version="1.0" encoding="utf-8"?><root><cfoutput>#dataString#</cfoutput></root></cfsavecontent>
					<cfset xmlString = Replace(xmlString,'&','&amp;','all')>
					<cfset parsedString = xmlparse(trim(xmlString))>

					<cfif isDefined("parsedString.root.Property.PropertyID")>
	      			<cfloop from="1" to="#arraylen(parsedString.root.Property.PropertyID)#" index="i">
	      				<cfset propertyid = parsedString.root.Property.PropertyID[i].xmltext>
	      				<cfset session.booking.unitCodeList = ListAppend(session.booking.unitCodeList,propertyid)>
	      			</cfloop>
	      		</cfif>

                <cfif isDefined('session.booking.unitCodeList') AND !ListLen(session.booking.unitCodeList)>
                    <cfset cookie.numResults = 0>
                    <cfset session.booking.getResults = "">
                    <cfset session.booking.UnitCodeList = "">
                    <cfreturn>
                </cfif>

      		</cfif>

				<cfquery name="qryGetSearchResults" dataSource="#settings.booking.dsn#">
					select
					propertyid,
					seopropertyname,
					name,
					latitude,
					longitude,
					bedrooms,
					`location`,
					bathrooms,
					petsAllowed,
					unitType as `type`,
					minprice,
					maxprice,
					imagePath as defaultPhoto,
					propAddress as address,
					maxoccupancy as sleeps,
					(select avg(rating) as average from be_reviews where unitcode = bf_properties.propertyid) as avgRating,
					(select min(rent) from bf_rates where pricetype = 'weekly' and propertyid = bf_properties.propertyid) as unitMinWeeklyPrice,
				   (select max(rent) from bf_rates where pricetype = 'weekly' and propertyid = bf_properties.propertyid) as unitMaxWeeklyPrice

					<cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>

						<cfset numNights = DateDiff('d',session.booking.strcheckin,session.booking.strcheckout)>

						<cfif numNights gte 7>
							,(select rent from bf_rates where #createodbcdate(session.booking.strcheckin)# between startDate and endDate and priceType = 'weekly' and propertyid = bf_properties.propertyid limit 1) as 'price'
						<cfelse>
							,(select rent from bf_rates where #createodbcdate(session.booking.strcheckin)# between startDate and endDate and priceType = 'daily' and propertyid = bf_properties.propertyid limit 1) as 'price'
						</cfif>

						,(select rent from bf_rates where #createodbcdate(session.booking.strcheckin)# between startDate and endDate and priceType = 'daily' and propertyid = bf_properties.propertyid limit 1) as 'MapPrice'

					<cfelse>

						,(select rent from bf_rates where priceType = 'daily' and propertyid = bf_properties.propertyid limit 1) as 'MapPrice'

					</cfif>

					from bf_properties

					where 1=1

					<cfif isdefined('session.booking.unitcodelist') and ListLen(session.booking.unitcodelist)>
						and propertyid in (#listQualify(session.booking.unitCodeList,"'")#)
					</cfif>

					<cfinclude template="/#settings.booking.dir#/results-search-query-common.cfm">

					order by #session.booking.strsortby#

				</cfquery>

				<cfif isdefined('session.booking.rentalrate') and len(session.booking.rentalrate)>

					<cfset minSearchValue = #ListGetAt(session.booking.rentalrate,1)#>
					<cfset maxSearchValue = #ListGetAt(session.booking.rentalrate,2)#>

				   <cfif isdefined('session.booking.searchByDate') and session.booking.searchByDate>
				   	<!--- Filter by base rent since the user selected dates --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							temp.price between '#minSearchValue#' and '#maxSearchValue#'
						</cfquery>
					<cfelse>
						<!--- Filter by the price range with a non-dated search --->
						<cfquery name="qryGetSearchResults" dbtype="query">
							select * from qryGetSearchResults where
							temp.unitMinWeeklyPrice >= '#minSearchValue#' and temp.unitMaxWeeklyPrice <= '#maxSearchValue#'
						</cfquery>
					</cfif>

				</cfif>

				<cfset cookie.numResults = qryGetSearchResults.recordcount>
				<cfset session.booking.getResults = qryGetSearchResults>
			   <cfset session.booking.UnitCodeList = valueList(qryGetSearchResults.propertyid)>

		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>

		</cftry>



   </cffunction>




   <cffunction name="getSearchResultsProperty" returnType="query" hint="Returns property results if the user does a sitewide search for a given term like 'ocean front rentals'">

   	<cfargument name="searchterm" required="true">

		<cfquery DATASOURCE="#variables.settings.booking.dsn#" NAME="results">
			SELECT seoPropertyName,propertyid,name as propertyname,description as propertydesc
			FROM bf_properties
			where name like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or extdescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or description like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or unitcomments like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or internetDescription like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
			or propAddress like <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="%#arguments.SearchTerm#%">
		</cfquery>

		<cfreturn results>

   </cffunction> <!--- end of getSearchResultsProperty function --->



   <cffunction name="setGoogleAnalytics" returnType="string" hint="Sets the Google analytics script for the booking confirmation page">

      <cfargument name="settings" required="true">
      <cfargument name="form" required="true">
      <cfargument name="reservationNumber" required="true" type="string">

      <cfsavecontent variable="temp">
      <cfoutput>
         <script type="text/javascript" defer>
           (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
           (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
           m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
           })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

           ga('create', '#settings.googleAnalytics#', '#settings.website#');
           ga('send', 'pageview');

           ga('require', 'ecommerce', 'ecommerce.js');

         	ga('ecommerce:addTransaction', {
         	id: '#reservationNumber#', // Transaction ID - this is normally generated by your system.
         	affiliation: '#settings.company#', // Affiliation or store name
         	revenue: '#form.totalAmountForAPI#', // Grand Total
         	shipping: '0' , // Shipping cost
         	tax: '0' }); // Tax.

         	ga('ecommerce:addItem', {
         	id: '#reservationNumber#', // Transaction ID.
         	sku: '#form.propertyid#', // SKU/code.
         	name: '#Replace(form.propertyname,"'","","All")#', // Product name.
         	category: 'Rental', // Category or variation.
         	price: '#form.totalAmountForAPI#', // Unit price.
         	quantity: '1'}); // Quantity.

         	ga('ecommerce:send');
         </script>
      </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setGoogleAnalytics function --->




   <cffunction name="setPropertyMetaData" returnType="string" hint="Sets the meta data for the property detail page">

      <cfargument name="property" required="true">

      <cfsavecontent variable="temp">
         <cfoutput>
         <title>#property.name# - #property.city# #property.type# Rental | #variables.settings.company#</title>
         <cfset tempDescription = striphtml(mid(property.description,1,300))>
         <meta name="description" content="#tempDescription#">
         <meta property="og:title" content="#property.name# - #variables.settings.company#">
         <meta property="og:description" content="#tempDescription#">
         <meta property="og:url" content="http://#cgi.http_host#/rentals/#property.seopropertyname#/#property.propertyid#">
         <meta property="og:image" content="#property.defaultPhoto#">
         </cfoutput>
      </cfsavecontent>

      <cfreturn temp>

   </cffunction> <!--- end of setMetaData function --->



   <cffunction name="submitLeadToThirdParty" hint="Submits form information a 3rd party;used on the property detail page contact form"></cffunction>


   <cffunction name="getDistinctTypes" returnType="string" hint="Gets distinct unit types for the refine search">

   	<cfset var qryGetDistinctTypes = "">

     	<cfquery name="qryGetDistinctTypes" dataSource="#variables.settings.booking.dsn#">
   		select distinct unitType from bf_properties order by unitType
   	</cfquery>

   	<cfset typeList = ValueList(qryGetDistinctTypes.unitType)>

   	<cfreturn typeList>

   </cffunction>



   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctAreas" returnType="string" hint="Gets distinct areas for the refine search">

   	<cfset var qryGetDistinctAreas = "">

   	<cfquery name="qryGetDistinctAreas" dataSource="#variables.settings.booking.dsn#">
   		select distinct area from bf_properties order by area
   	</cfquery>

   	<cfset areaList = ValueList(qryGetDistinctAreas.area)>

   	<cfreturn areaList>

   </cffunction>


   <!--- This might need to be adjusted per-client based on what they have in their table --->
   <cffunction name="getDistinctViews" returnType="string" hint="Gets distinct views for the refine search">

		<cfset var qryGetDistinctViews = "">

   	<cfquery name="qryGetDistinctViews" dataSource="#variables.settings.booking.dsn#">
			select distinct `view` from bf_properties order by `view`
   	</cfquery>

   	<cfset viewList = ValueList(qryGetDistinctViews.view)>

   	<cfreturn viewList>

   </cffunction>



   <cffunction name="getAllProperties" returnType="query" hint="Returns a query of all properties">

   	<cfset var qryGetAllProperties = "">

   	<cfquery name="qryGetAllProperties" dataSource="#variables.settings.booking.dsn#">
   		select
   			distinct propertyid,
   			name,
   			seopropertyname,
   			maxoccupancy as sleeps,
   			bedrooms,
   			bathrooms
   		from bf_properties order by name
   	</cfquery>

   	<cfreturn qryGetAllProperties>

   </cffunction>

   <cffunction name="insertAPILogEntry" hint="Logs any API request to the apilogs table">

	   <cfargument name="page">
	   <cfargument name="req">
	   <cfargument name="res">

	   <cftry>

				<cfif isXML(arguments.req)>
				  <cfset apirequest = xmlParse(trim(arguments.req))>
				<cfelse>
				  <cfset apirequest = arguments.req>
				</cfif>

				<cfset apiresponse = replace(arguments.res,'&lt;','<','all')>
				<cfset apiresponse = replace(apiresponse,'&gt;','>','all')>

				<cfif isXML(apiresponse)>
				  <cfset apiresponse = xmlparse(trim(apiresponse))>
				<cfelse>
				  <cfset apiresponse = apiresponse>
				</cfif>

				<!--- Begin Barefoot CC wiping on the API request --->
				<cfif isDefined('apirequest.Envelope.Body.PropertyBookingNew.Info')>
				  <cfset apirequest.Envelope.Body.PropertyBookingNew.Info.string[15].xmltext = '*Redacted*'> <!--- cc number --->
				  <cfset apirequest.Envelope.Body.PropertyBookingNew.Info.string[18].xmltext = '*Redacted*'> <!--- 3 digit security code --->
				</cfif>

				<!--- Begin Barefoot CC wiping on the API response --->
				<cfif isdefined('apiresponse.Envelope.Body.PropertyBookingNewResponse.PropertyBookingNewResult.PaymentInfo.CreditcardNum')>
				  <cfset apiresponse.Envelope.Body.PropertyBookingNewResponse.PropertyBookingNewResult.PaymentInfo.CreditcardNum.xmltext = '*Redacted*'> <!--- cc number --->
				</cfif>

				<cfquery datasource="#variables.settings.dsn#">
         		insert into apilogs
         		set
	            page = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#">,
	            req = <cfqueryparam cfsqltype="cf_sql_varchar" value="#toString(apirequest)#">,
	            res = <cfqueryparam cfsqltype="cf_sql_varchar" value="#toString(apiresponse)#">
      	   </cfquery>

	   <cfcatch>

	   	<cfdump var="#cfcatch#">

	      <!--- Change to Jonathan and Randy after go live --->
	      <cfmail
	         subject="API Log Error from #cgi.http_host#"
	         to="jrichey@icoastalnet.com"
	         from="jrichey@icoastalnet.com"
	         server="#settings.cfmailServer#"
	         username="#settings.cfmailUsername#"
	         password="#settings.cfmailPassword#"
	         port="#settings.cfmailPort#"
	         useSSL="#settings.cfmailSSL#"
	         type="HTML"
	      >
	      	<h1>page</h1>
	      	#arguments.page#
	      	<h1>request</h1>
	      	#arguments.req#
	      	<h1>response</h1>
	      	#arguments.res#
	      	<h1>cfcatch</h1>
	         <cfdump var="#cfcatch#">
	         <h1>cgi</h1>
	         <cfdump var="#cgi#">
	      </cfmail>


	   </cfcatch>

	   </cftry>

	</cffunction>


	<cffunction name="getRandomProperties" returnType="query">

		<cfset var qryGetRandomProperties = ''>

		<cfquery name="qryGetRandomProperties" datasource="#variables.settings.booking.dsn#">

		select
				propertyid,
				seopropertyname,
				name,
				bedrooms,
				`location`,
				bathrooms,
				petsAllowed,
				unitType as `type`,
				minprice,
				maxprice,
				imagePath as defaultPhoto,
				maxoccupancy as sleeps,
				(select avg(rating) as average from be_reviews where unitcode = bf_properties.propertyid) as avgRating

			from bf_properties

			order by rand() limit 2

		</cfquery>

		<cfreturn qryGetRandomProperties>

	</cffunction>


	<cffunction name="getSearchFilterCount" returnType="string">

		<cfargument name="filter" required="true" type="string">
		<cfargument name="category" required="true" type="string">

		<cfset var qryGetSearchFilterCount = ''>

		<cfif arguments.category eq 'amenity'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(propertyid) as numRecords from bf_property_amenities where name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'type'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(propertyid) as numRecords from bf_properties where unitType = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelseif arguments.category eq 'view'>
			<cfquery name="qryGetSearchFilterCount" dataSource="#variables.settings.booking.dsn#">
				select count(propertyid) as numRecords from bf_properties where view = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.filter#">
			</cfquery>
			<cfreturn qryGetSearchFilterCount.numRecords>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>


	<cffunction name="getPriceBasedOnDates" returnType="string" hint="Returns the rental rate for a given property based on the arrival date">

   	<cfargument name="propertyid" required="true" type="string">
   	<cfargument name="strcheckin" required="true" type="date">
   	<cfargument name="strcheckout" required="true" type="date">

   	<cfset var qryGetPriceBasedOnDates = "">
   	<cfset var numNights = DateDiff('d',arguments.strcheckin,arguments.strcheckout)>
   	<cfset var pricetype = 'Weekly'>

		<cfif numNights lt 7> <!--- nightly rate --->

			<cfset var pricetype = 'Daily'>

		</cfif>

		<cfquery name="qryGetPriceBasedOnDates" dataSource="#variables.settings.booking.dsn#">
			select rent as baseRate
			from bf_rates
			where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#arguments.propertyid#">
			and #createodbcdate(arguments.strcheckin)# between startdate and enddate
			and pricetype = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#pricetype#">
		</cfquery>

		<cfif qryGetPriceBasedOnDates.recordcount gt 0>
			<cfset tempReturn = DollarFormat(qryGetPriceBasedOnDates.baseRate) & ' <small>+Taxes and Fees</small>'>
		<cfelse>
		  <cfset tempReturn = ''>
		</cfif>

		<cfreturn tempReturn>

   </cffunction>


   <cfscript>
   function stripHTML(str) {
   	str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
   	str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");

   	str = reReplaceNoCase(str, "<.*?>","","all");
   	//get partial html in front
   	str = reReplaceNoCase(str, "^.*?>","");
   	//get partial html at end
   	str = reReplaceNoCase(str, "<.*$","");
   	return trim(str);
   }
   </cfscript>

</cfcomponent>