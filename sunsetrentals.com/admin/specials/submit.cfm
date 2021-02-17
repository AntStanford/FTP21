<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_specials">
     <cfcatch></cfcatch>
</cftry>

<cfset table = 'cms_specials'>
<cfset uppicture = #ExpandPath('/images/specials')#>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
  	delete from cms_specials where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

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
    update cms_specials set
    title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">,
    startdate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#startdate#">,
    enddate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#enddate#">,
    description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#description#">,
    active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.active#">,
    slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
    allowedBookingStartDate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.allowedBookingStartDate#">,
    allowedBookingEndDate = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.allowedBookingEndDate#">
    <cfif len(form.photo)>,photo = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

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
    insert into cms_specials(title,startdate,enddate,description,photo,active,slug,allowedBookingStartDate,allowedBookingEndDate)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#title#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#startdate#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#enddate#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#description#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.active#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.allowedBookingStartDate#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.allowedBookingEndDate#">
      )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>