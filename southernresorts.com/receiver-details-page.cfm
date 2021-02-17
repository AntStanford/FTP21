<cfif settings.hasCartAbandonment eq 'Yes'> 
 
   <cfparam name="key" type="string" default="">
   <cfparam name="firstname" default="">
   <cfparam name="lastname" default="">
   <cfparam name="email" default="">
   
   <CFQUERY datasource="#settings.bcDSN#" NAME="GetInfo">
   	SELECT * 
   	FROM cart_abandonment_detail_page
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
      
      <cfmail subject="error from #cgi.http_host#" to="mcrouch@icoastalnet.com" from="#cfmail.company# <#cfmail.username#>" server="#cfmail.server#" username="#cfmail.username#" password="#cfmail.password#" port="#cfmail.port#" useSSL="#cfmail.useSSL#" type="HTML" bcc="" cc="">
         <p>File: receiver-details-page.cfm</p>
         <p>No property ID defined?</p>
      </cfmail>
      
   </cfif>
   
   <cfif getinfo.recordcount eq 0>   
      
      <cfquery datasource="#settings.bcDSN#">
         insert into cart_abandonment_detail_page(firstname,lastname,email,thekey,property,unitcode,siteID)
         values(
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
         <cfqueryparam value="#key#" cfsqltype="cf_sql_varchar">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property_name#">,
         <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mypropertyid#">,
         <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
         )
      </cfquery>
   		 
   		
   <cfelse>
   		
   	<cfquery datasource="#settings.bcDSN#">
   		update cart_abandonment_detail_page SET 
   		firstname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#firstname#">,
   		lastname = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#lastname#">,
   		email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">,
   		property = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#property_name#">,
   		unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mypropertyid#">,
   		siteID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">,
   		followupemailsent = "No",
   	   followUpEmailTimestamp = <cfqueryparam CFSQLType="CF_SQL_TIMESTAMP" value="" null="Yes">
   		where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getinfo.id#">
   	</cfquery>		
   		
   </cfif>

</cfif>

		