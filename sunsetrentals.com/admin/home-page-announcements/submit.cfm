<cfset table = 'cms_homepage_announcements'>
<cfset uppicture = #ExpandPath('/images/homepage-announcements')#>
 
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
    start_date = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.start_date#">,
    end_date = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.end_date#">,
    Description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.Description#">,
    link = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.link#">,
    active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.active#">,
    type = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.type#">
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
    insert into #table#(title,start_date,end_date,Description,photo,link,active,type) 
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.start_date#">,
	    <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.end_date#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.Description#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.link#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.active#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.type#">
      )
  </cfquery>
  
  <cflocation addToken="no" url="form.cfm?success">
  
</cfif>

































