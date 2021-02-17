<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_eventcal">
     <cfcatch></cfcatch>
</cftry>

<cfset table = 'cms_eventcal'>
<cfset uppicture = #ExpandPath('/images/events')#>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
  	delete from cms_eventcal where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">


<cfelseif isdefined('url.id') and isdefined('url.deletephoto')>

   <cfquery dataSource="#application.dsn#">
    update cms_eventcal set
    photo = ''
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#url.id#&deletephoto">


<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfif isdefined('form.photo') and len(form.photo)>

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
    update cms_eventcal set
    event_title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.event_title#">,
    start_date = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.start_date#">,
    end_date = <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.end_date#">,
    details_long = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.details_long#">,
    event_location = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.event_location#">,
    time_start = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.time_start#">,
    time_end = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.time_end#">
    <cfif isdefined('form.photo') and len(form.photo)>,photo = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">

<cfelse>  <!---insert statement--->

  <cfif isdefined('form.photo') and len(form.photo)>

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
    insert into cms_eventcal(event_title,start_date,details_long,photo,event_location,time_start,time_end,end_date)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.event_title#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.start_date#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.details_long#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.event_location#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.time_start#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.time_end#">,
      <cfqueryparam CFSQLType="CF_SQL_DATE" value="#form.end_date#">
      )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>