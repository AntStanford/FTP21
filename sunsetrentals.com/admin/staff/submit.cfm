<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_staff">
     <cfcatch></cfcatch>
</cftry>

<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/staff')#>
<cfset table = 'cms_staff'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>

   <cfquery name="getinfo" dataSource="#application.dsn#">
    select photo from cms_staff where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cfif len(getinfo.photo)>
  	<cffile action="delete" file="#uppicture#/#getinfo.photo#">
  </cfif>

  <cfquery dataSource="#application.dsn#">
    delete from cms_staff where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
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
      update cms_staff set
      name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
      title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
      description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
      phone = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
      fax = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.fax#">,
      email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
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
      select max(sort) as maxSort from cms_staff
    </cfquery>

    <cfif getSort.recordcount gt 0 and len(getSort.maxSort)>
      <cfset sortValue = getSort.maxSort + 1>
    <cfelse>
      <cfset sortValue = 1>
    </cfif>

    <cfquery dataSource="#application.dsn#">
      insert into cms_staff(name,title,description,photo,sort,phone,fax,email,slug)
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
        <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#sortValue#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.fax#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">
        )
    </cfquery>

    <cflocation addToken="no" url="form.cfm?success">


</cfif>





