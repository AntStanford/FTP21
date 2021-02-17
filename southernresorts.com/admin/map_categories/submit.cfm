<cfset table = 'cms_map_categories'>
<cfset uppicture = #ExpandPath('/images/thingstodo')#>

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
      meta_title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.meta_title#">,
      meta_description = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.meta_description#">,
      slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">
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
      insert into #table#(title,photo,slug,meta_title,meta_description) 
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.meta_title#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.meta_description#">
        )
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?success"> 
  
  
</cfif>  
       




