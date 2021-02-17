<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_thingstodo">
     <cfcatch></cfcatch>
</cftry>

<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/thingstodo')#>
<cfset table = 'cms_thingstodo'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>

  <cfquery dataSource="#application.dsn#">
    delete from cms_thingstodo where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
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
      update cms_thingstodo set
      title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
      description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
      catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">,
      website = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">
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
      insert into cms_thingstodo(title,description,photo,catID,website)
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.catID#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.website#">
        )
    </cfquery>

    <cflocation addToken="no" url="form.cfm?success">


</cfif>





