<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_resorts">
     <cfcatch></cfcatch>
</cftry>



<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/resorts')#>
<cfset uppicturethumb = #ExpandPath('/images/resorts/thumbs')#>
<cfset table = 'cms_resorts'>



<!--- Deleting an uploaded photo --->
<cfif isdefined('url.resortID') and isdefined('url.delPhoto') and isdefined('url.photo')>

  <!--- mainphoto is the only allowed url.photo --->
  <cfquery dataSource="#application.dsn#">
    update cms_resorts
    set mainphoto = ''
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.resortID#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#url.resortID#&deletephoto">

<cfelseif isdefined('url.resortID') and isdefined('url.delMap') and isdefined('url.map')>

  <!--- mainphoto is the only allowed url.photo --->
  <cfquery dataSource="#application.dsn#">
    update cms_resorts
    set pdfmap = ''
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.resortID#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#url.resortID#&deletemap">

  <!--- Delete the entire record and photos --->
<cfelseif isdefined('url.id') and isdefined('url.delete')>

  <!--- Finally, delete the property --->
  <cfquery dataSource="#application.dsn#">
    delete from cms_resorts where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">
<!--- Update Existing Record --->
<cfelseif isdefined('form.id')>

    <cfif Len(form.mainphoto)>

  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.Check(uppicture,"mainphoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.mainphoto = cffile.serverfile>

  		<!--- Make a thumbnail of main photo
 		  <cfimage source="#uppicture#\#cffile.serverfile#" action="resize" width="196"  height="" destination="#uppicturethumb#\#cffile.serverfile#">--->

 		<!--- Now compress the image using CF_GraphicsMagick  --->
		<CF_GraphicsMagick
			     action="Optimize"
			     infile="#uppicture#\#cffile.serverfile#"
			     outfile="#uppicture#\#cffile.serverfile#"
			     compress="JPEG">

  	</cfif>

    <cfif Len(form.pdfmap)>
  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.PDFCheck(uppicture,"pdfmap")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.pdfmap = cffile.serverfile>
  	</cfif>

    <cfquery dataSource="#application.dsn#">
      update cms_resorts set
      name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
      address = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
      description = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
      amenities = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.amenities#">,
      area = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.area#">,
      resort = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.resort#">,
      slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
      city = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
      state = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
      zip = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
      metaTitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaTitle#">,
      metaDescription = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaDescription#">
      <cfif len(form.mainphoto)>,mainphoto = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.mainphoto#"></cfif>
      <cfif len(form.pdfmap)>,pdfmap = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.pdfmap#"></cfif>
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
    </cfquery>

    <cflocation addToken="no" url="form.cfm?id=#id#&success">


<!--- Add New Record --->
<cfelse>

    <cfparam name="form.mainphoto" default="">
    <cfparam name="form.pdfmap" default="">

    <cfif Len(form.mainphoto)>

  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.Check(uppicture,"mainphoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.mainphoto = cffile.serverfile>

  		<!--- Make a thumbnail of main photo
 		  <cfimage source="#uppicture#\#cffile.serverfile#" action="resize" width="90"  height="" destination="#uppicturethumb#\#cffile.serverfile#">--->

 		<!--- Now compress the image using CF_GraphicsMagick  --->
		<CF_GraphicsMagick
			     action="Optimize"
			     infile="#uppicture#\#cffile.serverfile#"
			     outfile="#uppicture#\#cffile.serverfile#"
			     compress="JPEG">

  	</cfif>

    <cfif Len(form.pdfmap)>
  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.PDFCheck(uppicture,"pdfmap")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.pdfmap = cffile.serverfile>
  	</cfif>


    <cfquery dataSource="#application.dsn#">
      insert into cms_resorts(name,address,description,amenities,mainphoto,pdfmap,area,slug,city,state,zip,metaTitle,metaDescription,resort)
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.amenities#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.mainphoto#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.pdfmap#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.area#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaTitle#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaDescription#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.resort#">
        )
    </cfquery>


    <cflocation addToken="no" url="form.cfm?success">


</cfif>








