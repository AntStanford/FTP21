<cfcomponent displayname="usertracker" hint="used to track site visitors"> 
   
   <cffunction name="insertuser">   
      
      <cfargument name="dsn" type="string" required="true">
      
      <cfquery dataSource="#arguments.dsn#">
         replace into visits_tracker(userTrackingCookie,timeOfVisit) 
         values(<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cfid##cftoken#">,#now()#)
      </cfquery>
   
   </cffunction>
   
   <cffunction name="getnumvisitors" hint="returns number of visitors who have been on site within the last 60 minutes">
      
      <cfargument name="dsn" type="string" required="true">
      
      <cfset variables.oneMinuteAgo = DateAdd('n',-60,now())>
      
      <cfquery name="checkForVisitors" dataSource="#arguments.dsn#">
         select userTrackingCookie 
         from visits_tracker where timeOfVisit between <cfqueryparam value="#variables.oneMinuteAgo#" cfsqltype="cf_sql_timestamp"> and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
         and userTrackingCookie != <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cfid##cftoken#">
      </cfquery>
      
      <cfif checkforvisitors.recordcount gt 0>
         <cfreturn checkForVisitors.recordcount>
      <cfelse>
         <cfreturn 0>
      </cfif>
      
   </cffunction>

</cfcomponent>