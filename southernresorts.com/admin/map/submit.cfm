<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/thingstodo')#>
<cfset table = 'cms_map'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>
    
  <cfquery dataSource="#application.dsn#">
    delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
  
  <cflocation addToken="no" url="index.cfm?success">


<!--- Update Existing Record --->  
<cfelseif isdefined('form.id')>
  
  
    <cfif len(form.photo)>
      <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
      <cfset results=Obj.Check(uppicture,"photo")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
      <cfset myfile = cffile.serverfile>  
    </cfif>
    

    <cfquery dataSource="#application.dsn#">
      update #table# set
      title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">, 
      website = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">, 
      latitude = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.latitude#">,
      longitude = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longitude#">,
      description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
      catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">
      <cfif len(form.photo)>,photo = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?id=#id#&success"> 
    

<!--- Add New Record --->    
<cfelse>
  
  
    <cfif len(form.photo)>      
    
    <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
    <cfset results=Obj.Check(uppicture,"photo")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
    <cfset myfile = cffile.serverfile>   
  
    <cfelse>
      <cfset myfile = ''>  
    </cfif>

    <cfquery dataSource="#application.dsn#">
      insert into #table#(title,website,latitude,longitude,description,photo,catID,createdat) 
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.latitude#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longitude#">,
        <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">,
        <cfqueryparam CFSQLType="CF_SQL_DATE" value="#now()#">
        )
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?success"> 
  
  
</cfif>  
       




