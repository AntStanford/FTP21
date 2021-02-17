<cftry>
  <cfsavecontent variable="soapBody">
    <cfoutput>
      <?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Header>
          <WSUser xmlns="http://webservices.listrak.com/v31/">
            <UserName>#ListrakUser#</UserName>
            <Password>#ListrakPass#</Password>
          </WSUser>
        </soap12:Header>
        <soap12:Body>
          <SubscribeContact xmlns="http://webservices.listrak.com/v31/">
            <ListID>#ListrakListID#</ListID>
            <ContactEmailAddress>#email#</ContactEmailAddress>
            <OverrideUnsubscribe>true</OverrideUnsubscribe>
          </SubscribeContact>
        </soap12:Body>
      </soap12:Envelope>
    </cfoutput>
  </cfsavecontent>
  <cfhttp
    url="https://webservices.listrak.com/v31/IntegrationService.asmx"
    method="post"
    result="httpResponse">
    <cfhttpparam
      type="header"
      name="SOAPAction"
      value="http://webservices.listrak.com/v31/SubscribeContact"
    />
    <cfhttpparam
      type="header"
      name="accept-encoding"
      value="no-compression"
    />
    <cfhttpparam
      type="xml"
      value="#trim(soapBody)#"
    />
  </cfhttp>
  <!--- <cfdump var="#httpResponse.fileContent#">  --->
  <cfcatch type="Any">
	<cfif isdefined("ravenClient")>
		<cfset ravenClient.captureException(cfcatch)>
	</cfif>
  </cfcatch>
</cftry>