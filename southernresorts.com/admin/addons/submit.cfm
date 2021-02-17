<cfset table = 'cms_checkout_addons'>
<cfset uppicture = #ExpandPath('/images/addons')#>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->
	
  <cfquery dataSource="#application.dsn#">
  	delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#"> 
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?success">
  

<cfelseif isdefined('url.id') and isdefined('url.deletephoto')>
   
   <cfquery dataSource="#application.dsn#">
    update #table# set 
    photo = ''
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>  
  
  <cflocation addToken="no" url="form.cfm?id=#url.id#&deletephoto">

  	
<cfelseif isdefined('form.id')> <!--- update statement --->
  
  <cfif isdefined('form.photo') and len(form.photo)>
   
      <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
      <cfset results=Obj.Check(uppicture,"photo")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
      <cfset myfile = cffile.serverfile>
   
  </cfif>
  
  <cfquery dataSource="#application.dsn#">
    update #table# set 
    title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">, 
    description = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
    track_id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.track_id#">
    ,amount = <cfqueryparam CFSQLType="CF_SQL_FLOAT" value="#form.amount#">
    <cfif isdefined('form.photo') and len(form.photo)>,photo = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>  
  
  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->
  
  <cfif isdefined('form.photo') and len(form.photo)>
   
      <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
      <cfset results=Obj.Check(uppicture,"photo")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
      <cfset myfile = cffile.serverfile>
   
  <cfelse>
  
      <cfset myfile = ''> 

  </cfif>
  
  
  <cfquery dataSource="#application.dsn#">
    insert into #table#(title,description,photo,track_id,amount) 
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">, 
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.track_id#">,
      <cfqueryparam CFSQLType="CF_SQL_FLOAT" value="#form.amount#">
      )
  </cfquery>
  
  <cflocation addToken="no" url="form.cfm?success">
  
</cfif>

































