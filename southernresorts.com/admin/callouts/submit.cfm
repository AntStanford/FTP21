<cftry> 
     <cfcache action="flush" key="cms_callouts">
     <cfcatch></cfcatch> 
</cftry>


<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/callouts')#>
<cfset table = 'cms_callouts'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>
  
   <cfquery name="getinfo" dataSource="#application.dsn#">
    select photo from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
  
  <cffile action="delete" file="#uppicture#/#getinfo.photo#">
  
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
      
      <!--- Now compress the image using CF_GraphicsMagick  ---> 		      
		<CF_GraphicsMagick 
		     action="Optimize" 
		     infile="#uppicture#\#myfile#" 
		     outfile="#uppicture#\#myfile#" 
		     compress="JPEG">
		     
    </cfif>
    

    <cfquery dataSource="#application.dsn#">
      update #table# set      
      title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
      description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
      link = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.link#">,
      linkbuttontext = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.linkbuttontext#">
      <cfif len(form.photo)>,photo = '#myfile#'</cfif>
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?id=#form.id#&success"> 
    

<!--- Add New Record --->    
<cfelse>
  
  
    <cfif len(form.photo)>      
    
	    <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
	    <cfset results=Obj.Check(uppicture,"photo")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
	    <cfset myfile = cffile.serverfile>   
    	 
    	 <!--- Now compress the image using CF_GraphicsMagick  ---> 		      
		<CF_GraphicsMagick 
		     action="Optimize" 
		     infile="#uppicture#\#myfile#" 
		     outfile="#uppicture#\#myfile#" 
		     compress="JPEG">	
    
  
    <cfelse>
      <cfset myfile = ''>  
    </cfif>
    
     <!--- Get current sort values --->
    <cfquery name="getSort" dataSource="#dsn#">
      select max(sort) as maxSort from #table#
    </cfquery>
             
    <cfif getSort.recordcount gt 0 and len(getSort.maxSort)>
      <cfset sortValue = getSort.maxSort + 1> 
    <cfelse>
      <cfset sortValue = 1>
    </cfif>

    <cfquery dataSource="#application.dsn#">
      insert into #table#(title,description,link,linkbuttontext,photo,sort)
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.link#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.linkbuttontext#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#sortValue#">
        )
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?success"> 
  
  
</cfif>  
       




