<!--- Flush the cache if it exists --->
<cftry> 
     <cfcache action="flush" key="cms_thingstodo">
     <cfcatch></cfcatch> 
</cftry>

<cfparam name="form.subcatIDs" default="">
<cfparam name="form.destination_ID" default="">
<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/thingstodo')#>
<cfset table = 'cms_thingstodo'>

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
      destination_ID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.destination_ID#">,
      description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
      catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">,
      subcatIDs = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.subcatIDs#">,
      website = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">,
      latitude = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.latitude#" null="#yesnoformat(!Len(form.latitude))#">,
      longitude = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longitude#" null="#yesnoformat(!Len(form.longitude))#">
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
	    
	    <!--- Now compress the image using CF_GraphicsMagick  ---> 		      
		 <CF_GraphicsMagick 
			     action="Optimize" 
			     infile="#uppicture#\#myfile#" 
			     outfile="#uppicture#\#myfile#" 
			     compress="JPEG">    
  
    <cfelse>
      <cfset myfile = ''>  
    </cfif>

    <cfquery dataSource="#application.dsn#">
      insert into #table#(title,destination_ID,description,photo,catID,subcatIDs,website,latitude,longitude) 
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.destination_ID#">,
        <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.subcatIDs#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.latitude#" null="#yesnoformat(!Len(form.latitude))#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.longitude#" null="#yesnoformat(!Len(form.longitude))#">
        )
    </cfquery>
    
    <cflocation addToken="no" url="form.cfm?success"> 
  
  
</cfif>  
       




