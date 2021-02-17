<!--- On page variables --->
<cfset largePath = #ExpandPath('/images/longtermrentals')#>
<cfset originalPath = #ExpandPath('/images/longtermrentals/original')#>
<cfset thumbsPath = #ExpandPath('/images/longtermrentals/thumb')#>

<!--- Delete --->
<cfif isdefined('url.resortID') and isdefined('url.photo') and isdefined('url.photoid')> 
 
  <cfif FileExists('#largePath#/#url.photo#')><cffile action="delete" file="#largePath#/#url.photo#"></cfif>   
  <cfif FileExists('#originalPath#/#url.photo#')><cffile action="delete" file="#originalPath#/#url.photo#"></cfif>
  <cfif FileExists('#thumbsPath#/#url.photo#')><cffile action="delete" file="#thumbsPath#/#url.photo#"></cfif>
  
  <cfquery dataSource="#dsn#">
    delete from cms_assets where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.photoid#">
  </cfquery>
  
  <cflocation addToken="no" url="formmulti.cfm?id=#url.resortID#&deletephoto">
  
</cfif>  
       




