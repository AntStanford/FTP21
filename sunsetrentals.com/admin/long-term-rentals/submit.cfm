<cftry>
   <cfcache action="flush" key="cms_longterm_rentals">
   <cfcatch></cfcatch>
</cftry>

<!--- On page variables --->
<cfset uppicture = #ExpandPath('/images/longtermrentals')#>
<cfset table = 'cms_longterm_rentals'>



<!--- Deleting the record --->
<cfif isdefined('url.id') and isdefined('url.delete')>



  <!--- Finally, delete the property --->
  <cfquery dataSource="#application.dsn#">
    delete from cms_longterm_rentals where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>


  <cflocation addToken="no" url="index.cfm?success">







<!--- Update Existing Record --->
<cfelseif isdefined('form.id')>

    <cfif Len(form.mainphoto)>

  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.Check(uppicture,"mainphoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.mainphoto = cffile.serverfile>

  		<!--- Resize image if greater than 800px wide --->
  		<cfset cfImage = imageNew("#uppicture#/#cffile.serverfile#")>
      <cfset imageData = imageInfo(cfImage)>
      <cfset vars.imageWidth = imageData.width>

  		<cfif vars.imageWidth gt '800'>
  		  <cfimage source="#uppicture#/#cffile.serverfile#" action="resize" width="800" height="" destination="#uppicture#/#cffile.serverfile#" overwrite = "true">
  		</cfif>

  		<!--- Now compress the image using CF_GraphicsMagick  --->
		<CF_GraphicsMagick
			     action="Optimize"
			     infile="#uppicture#\#cffile.serverfile#"
			     outfile="#uppicture#\#cffile.serverfile#"
			     compress="JPEG">

  	</cfif>

    <cfquery dataSource="#application.dsn#">
      update cms_longterm_rentals set
      name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
      slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
      address = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
      type = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.type#">,
      bedrooms = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.bedrooms#">,
      bathrooms = <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#form.bathrooms#">,
        <cfif form.monthly_rate eq ''>
          monthly_rate = <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="0">,
        <cfelse>
          monthly_rate = <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#form.monthly_rate#">,
        </cfif>
      pet_friendly = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.pet_friendly#">,
      available_now = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.available_now#">,
      description = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
      amenities = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.amenities#">,
      metaTitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaTitle#">,
      metaDescription = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaDescription#">,
      city = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
      state  = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
      zip  = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
      status = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.status#">
      <cfif len(form.mainphoto)>,mainphoto = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.mainphoto#"></cfif>
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
    </cfquery>

    <cflocation addToken="no" url="form.cfm?id=#id#&success">


<!--- Add New Record --->
<cfelse>

    <cfparam name="form.mainphoto" default="">

    <cfif Len(form.mainphoto)>

  		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
  		<cfset results=Obj.Check(uppicture,"mainphoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
  		<cfset form.mainphoto = cffile.serverfile>

  		<!--- Resize image if greater than 800px wide --->
  		<cfset cfImage = imageNew("#uppicture#/#cffile.serverfile#")>
      <cfset imageData = imageInfo(cfImage)>
      <cfset vars.imageWidth = imageData.width>

  		<cfif vars.imageWidth gt '800'>
  		  <cfimage source="#uppicture#/#cffile.serverfile#" action="resize" width="800" height="" destination="#uppicture#/#cffile.serverfile#" overwrite = "true">
  		</cfif>

		<!--- Now compress the image using CF_GraphicsMagick  --->
		<CF_GraphicsMagick
			     action="Optimize"
			     infile="#uppicture#\#cffile.serverfile#"
			     outfile="#uppicture#\#cffile.serverfile#"
			     compress="JPEG">

  	</cfif>



    <cfquery dataSource="#application.dsn#">
      insert into cms_longterm_rentals(name,slug,address,type,bedrooms,bathrooms,monthly_rate,pet_friendly,available_now,description,amenities,mainphoto,metaTitle,metaDescription,city,state,zip,status)
      values(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.type#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.bedrooms#">,
        <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#form.bathrooms#">,
          <cfif form.monthly_rate eq ''>
            <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="0">,
          <cfelse>
            <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#form.monthly_rate#">,
          </cfif>
        <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.pet_friendly#">,
        <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.available_now#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.amenities#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.mainphoto#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaTitle#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metaDescription#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.status#">
        )
    </cfquery>


    <cflocation addToken="no" url="form.cfm?success">


</cfif>