<cfif settings.hasCartAbandonment eq 'Yes'> 

   <cfparam name="key" type="string" default="">
   <cfparam name="firstname" default="">
   <cfparam name="lastname" default=""> 
   <cfparam name="email" default="">
      
   <cfquery datasource="#settings.bcDSN#" NAME="GetInfo">
   	SELECT id 
   	FROM cart_abandonment
   	where thekey = <cfqueryparam value="#key#" cfsqltype="cf_sql_varchar">
   	and siteID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
   </CFQUERY>
    
   <cfif isdefined('url.strpropid')>
      <cfset mypropertyid = url.strpropid>
   <cfelseif isdefined('url.unitcode')>
      <cfset mypropertyid = url.unitcode>
   <cfelseif isdefined('url.propertyid')>
      <cfset mypropertyid = url.propertyid>
   <cfelseif isdefined('url.property_id')>
      <cfset mypropertyid = url.property_id>
   <cfelseif isdefined('url.unitid')>
      <cfset mypropertyid = url.unitid>
   <cfelse>
      
      <cfmail subject="error from #cgi.http_host#" to="bellefson@icoastalnet.com" from="#cfmail.company# <#cfmail.username#>" server="#cfmail.server#" username="#cfmail.username#" password="#cfmail.password#" port="#cfmail.port#" useSSL="#cfmail.useSSL#" type="HTML" bcc="" cc="">
         <p>File: receiver-details-page.cfm</p>
         <p>No property ID defined?</p>
      </cfmail>
      
   </cfif>
   
   <cfif getinfo.recordcount eq 0>
         
      <!--- User does not exist, insert new row --->			
      <cfquery dataSource="#settings.bcDSN#">
         insert into cart_abandonment(firstname,lastname,email,thekey,unitcode,siteID,property,startdate,enddate)
         values(
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
         <cfqueryparam value="#key#" cfsqltype="cf_sql_varchar">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">,
         <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyname#">,
         <cfqueryparam CFSQLType="CF_SQL_DATE" value="#url.strcheckin#">,
   	  <cfqueryparam CFSQLType="CF_SQL_DATE" value="#url.strcheckout#">
         )
      </cfquery>
   		
   		 
   <cfelse> <!--- We are here, we found the user --->
      		   				
   		<cfquery NAME="UpdateQuery" DATASOURCE="#settings.bcDSN#">
   	      UPDATE cart_abandonment SET 
   	      firstname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
   	      lastname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
   	      email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
   	      unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.propertyid#">,
   	      siteID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">,
   	      property = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyname#">,
   	      startdate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#url.strcheckin#">,
   	      enddate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#url.strcheckout#">,
   	      followupemailsent = "No",
   	      followUpEmailTimestamp = <cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="" null="Yes">
   	      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getinfo.id#">
   	   </cfquery>
   		   
   </cfif>

</cfif>

		