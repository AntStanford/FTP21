<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_destinations">
     <cfcatch></cfcatch>
</cftry>

<cfset table = 'cms_destinations'>
<cfset uppicture = ExpandPath('/images/popular')>
<cfset headerUppicture = ExpandPath('/images/header')>
<cfset calloutsUppicture = ExpandPath('/images/callouts')>
  <cfif isdefined('form.bannerimage') and len(form.bannerimage)>

    <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck-homepage-slideshow").Init()></cfif>
    <cfset results=Obj.Check(headerUppicture,"bannerimage")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
    <cfset myHeaderfile = cffile.serverfile>
		
	

  </cfif>
		
	<cfif isdefined('form.vacationbanner') and len(form.vacationbanner)>

 
	<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck-homepage-slideshow").Init()></cfif>	
	<cfset results=Obj.Check(headerUppicture,"vacationbanner")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
    <cfset mybannerfile = cffile.serverfile>

  </cfif>
<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
  	delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">


<cfelseif form.id gt 0> <!--- update statement --->

  <cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>
      <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
      <cfset results=Obj.Check(uppicture,"popularSearchPhoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
      <cfset myfile = cffile.serverfile>
  </cfif> 
  




  <cfquery datasource="#application.dsn#">
	update #table# set
    slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,     
    homepageSlug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.homepageSlug#">,
    title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">, 
    h1 = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
    metatitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metatitle#">,
    metadescription = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.metadescription#">,
	description = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.description#">,
    canonicalLink = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.canonicalLink#">,
	hideOnSite = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.hideonsite#">
    <cfif isdefined('form.bannerimage') and len(form.bannerimage)>
    	,bannerimage = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myHeaderfile#">
    </cfif>
	 <cfif isdefined('form.vacationbanner') and len(form.vacationbanner)>
    	,vacationbanner = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mybannerfile#">
    </cfif> 
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>
		
<cfquery name="getcallouts" datasource="#application.dsn#">	
	select * from cms_destinations_callouts
	where destination_id = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.nodeid#">
</cfquery>

<cfloop from="1" to="4" index="i">
  <cfset myHeaderfile = getcallouts.photo[i]>
  <cfif isdefined('form.Callout_Photo_'&i) and len(form['Callout_Photo_'&i])>

    <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck-homepage-slideshow").Init()></cfif>
    <cfset results=Obj.Check(calloutsUppicture,'form.Callout_Photo_'&i)><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
    <cfset myHeaderfile = cffile.serverfile>

  </cfif>

  <cfif i GT getcallouts.recordcount>
	  <cfif len('form.Callout_title_'&i) gt 0>
    <cfquery name="insert_callouts" datasource="#application.dsn#">
    INSERT INTO cms_destinations_callouts
      (Title, Description, Photo, destination_id, link)
      values
      (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Title_'&i]#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Description_'&i]#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myheaderfile#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.nodeid#">
		,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['link_'&i]#">
		)
    </cfquery>
  </cfif>
  <cfelse>
  <cfif len(form['Callout_Title_'&i]) gt 0>
    <cfquery name="update_callouts" datasource="#application.dsn#">
		Update cms_destinations_callouts
		set title = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Title_'&i]#">,
		description = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Description_'&i]#">,
		photo = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myheaderfile#">,
		link = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['link_'&i]#">
		where id = #getcallouts.id[i]#
		
    </cfquery>
  </cfif>
	</cfif>
</cfloop>		
		

  <cflocation addToken="no" url="form.cfm?nodeid=#form.nodeid#&id=#form.id#&success">


<cfelse>  <!---insert statement--->
  

  <cfquery dataSource="#application.dsn#" result="theinsert">
    insert into #table#(slug,homepageSlug, title,h1,metatitle,metadescription,description,canonicalLink,hideOnSite<cfif isdefined('form.bannerimage') and len(form.bannerimage)>,bannerimage</cfif>,nodeid)
    values( 
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.slug#">,  
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.homepageSlug#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">, 
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metatitle#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.metadescription#">,
	  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.description#">,
      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.canonicalLink#">,
	  <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.hideonsite#">,
      <cfif isdefined('form.bannerimage') and len(form.bannerimage)><cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myHeaderfile#">,</cfif>
      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.nodeid#">
    ) 
  </cfquery>
  <cfquery name="getlastinserted" datasource="#application.dsn#">
  SELECT Max(ID) as ID FROM #table#
</cfquery>
<cfquery name="delete_callouts" datasource="#application.dsn#">
DELETE FROM cms_destinations_callouts where destination_id = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.nodeid#">
</cfquery>
<cfloop from="1" to="4" index="i">
  <cfset myHeaderfile = "">
  <cfif isdefined('form.Callout_Photo_'&i) and len(form['Callout_Photo_'&i])>

    <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck-homepage-slideshow").Init()></cfif>
    <cfset results=Obj.Check(calloutsUppicture,'form.Callout_Photo_'&i)><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
    <cfset myHeaderfile = cffile.serverfile>

  </cfif>

  <cfif len('form.Callout_title_'&i) gt 0>
    <cfquery name="insert_callouts" datasource="#application.dsn#">
    INSERT INTO cms_destinations_callouts
      (Title, Description, Photo, destination_id, link)
      values
      (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Title_'&i]#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['Callout_Description_'&i]#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myheaderfile#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getlastinserted.id#">
		,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form['link_'&i]#">
		
		)
    </cfquery>
  </cfif>
</cfloop>
  <cfset form.nodeid = getlastinserted.id>
  <cfset local.id = (form.id gt 0 ? form.id : getlastinserted.ID)>
  <cflocation addToken="no" url="form.cfm?nodeid=#form.nodeid#&id=#local.id#&success">

</cfif>
