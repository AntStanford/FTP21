<cfset originalPath = #ExpandPath('/images/resorts')#>

<!--- Delete --->
<cfif isdefined('url.photo') and isdefined('url.photoid')> 
 
  <cfif FileExists('#originalPath#/#url.photo#')><cffile action="delete" file="#originalPath#/#url.photo#"></cfif>   

  <cfquery dataSource="#dsn#" name="getFK">
   	select foreignKey from cms_assets where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.photoid#">
  </cfquery>
   
  <cfquery dataSource="#dsn#">
    delete from cms_assets where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.photoid#">
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?deletephoto&id=#url.id#">
  
</cfif>