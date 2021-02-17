<!--- Flush the cache if it exists --->
<cftry>
     <cfcache action="flush" key="cms_pages">
     <cfcatch></cfcatch>
</cftry>

<cfset table = 'cms_pages'>
<cfset uppicture = #ExpandPath('/images/popular')#>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
  	delete from cms_pages where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">


<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>
      <cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
      <cfset results=Obj.Check(uppicture,"popularSearchPhoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
      <cfset myfile = cffile.serverfile>
  </cfif>


  <cfif isdefined('form.parentID') and form.parentID neq 0 and form.ignoreParentSlug eq 'No'>

      <!--- Get the slug for the parent page and append to new page slug --->
      <cfquery name="getParentSlug" dataSource="#dsn#">
         select slug from cms_pages where id = <cfqueryparam  CFSQLType="CF_SQL_INTEGER" value="#form.parentID#">
      </cfquery>

      <!--- TT-94762: Exclude leading forward-slash if partentSlug is blank --->
      <cfset mySlug = (getParentSlug.slug EQ "" ? form.slug : getParentSlug.slug & '/' & form.slug)>

  <cfelse>
      <cfset mySlug = form.slug>
  </cfif>


  <!---START: VERSIONING CODE BY BS--->

  	<cfquery name="getPreviousPageData" dataSource="#dsn#">
     select * from cms_pages where id = <cfqueryparam  CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  	</cfquery>


    <cfquery dataSource="#application.dsn#">
	    insert into cms_pages_versioning (name,body,slug,h1,metatitle,metadescription,parentID,MainPageID,externalLink,triggerOnly,showinnavigation,ignoreParentSlug,layout,popularSearch,showInFooter,canonicalLink,isCustomSearchPage,customSearchJSON<cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>,popularSearchPhoto</cfif>,googleIndex)
	    values(
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.name#">,
	      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#trim(getPreviousPageData.body)#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.slug#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.h1#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.metatitle#">,
	      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#getPreviousPageData.metadescription#">,
	      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.parentID#">,
	      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.externalLink#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.triggerOnly#">,
	      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.showinnavigation#">,
	      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.ignoreParentSlug#">,
	      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.layout#">,
	      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.popularSearch#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.showInFooter#">,
	      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.canonicalLink#">,
			<cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.isCustomSearchPage#">,
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getPreviousPageData.customSearchJSON#">
	      <cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
	      ,<cfqueryparam CFSQLType="CF_SQL_CHAR" value="#getPreviousPageData.googleIndex#">
	    )
  	</cfquery>

   <!---END: VERSIONING CODE BY BS--->


  <cfquery datasource="#application.dsn#">
	update cms_pages set
    name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
    body = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#trim(form.body)#">,
    slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mySlug#">,
    h1 = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
    metatitle = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metatitle#">,
    metadescription = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.metadescription#">,
    showinnavigation = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.showinnavigation#">,
    parentID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.parentID#">,
    externalLink = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.externalLink#">,
    triggerOnly = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.triggerOnly#">,
    ignoreParentSlug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.ignoreParentSlug#">,
    layout = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.layout#">,
    popularSearch = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.popularSearch#">,
    showInFooter = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.showInFooter#">,
    canonicalLink = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.canonicalLink#">,
    customSearchJSON = <cfqueryparam cfsqltype="sql_varchar" value="#serializeJSON(FORM)#">
    <cfif isdefined('form.isCustomSearchPage') and form.isCustomSearchPage eq 'yes'>
    ,isCustomSearchPage = 'Yes'
    <cfelse>
    ,isCustomSearchPage = 'No'
    </cfif>
    <cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>,popularSearchPhoto = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#"></cfif>
    ,googleIndex = <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.googleIndex#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">





<cfelse>  <!---insert statement--->

	<cfif isdefined('form.popularSearchPhoto') and len(form.popularSearchPhoto)>

		<cfif not isdefined('Obj')><cfset Obj = CreateObject("Component","Components.fileCheck").Init()></cfif>
		<cfset results=Obj.Check(uppicture,"popularSearchPhoto")><cfif len(results)><cfoutput>#results#</cfoutput><cfabort></cfif>
		<cfset myfile = cffile.serverfile>

	<cfelse>
		<cfset myfile = ''>
	</cfif>


  <cfif form.parentID neq 0 and form.ignoreParentSlug eq 'No'>

      <!--- Get the slug for the parent page and append to new page slug --->
      <cfquery name="getParentSlug" dataSource="#dsn#">
         select slug from cms_pages where id = <cfqueryparam  CFSQLType="CF_SQL_INTEGER" value="#form.parentID#">
      </cfquery>

      <!--- TT-94762: Exclude leading forward-slash if partentSlug is blank --->
      <cfset mySlug = (getParentSlug.slug EQ "" ? form.slug : getParentSlug.slug & '/' & form.slug)>

  <cfelse>
      <cfset mySlug = form.slug>
  </cfif>

  <cfif form.parentID neq 0>
    <!--- get highest subsort value + 1  --->
    <cfquery name="qrySubSort" dataSource="#application.dsn#">
      select ifnull(max(subsort),0) + 1 as newSubSort from cms_pages where parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.parentID#">
    </cfquery>

    <cfset variables.newSubSort = qrySubSort.newSubSort />

  </cfif>

  <cfset newString = replace(form.name,' ','-','all')>
  <cfset mybodyclass = lcase(newstring)>

  <cfquery dataSource="#application.dsn#" result="theinsert">
    insert into cms_pages(name,body,slug,h1,metatitle,metadescription,showinnavigation,parentID,externalLink,triggerOnly,ignoreParentSlug,bodyClass,layout,popularSearch,popularSearchPhoto,showInFooter,customSearchJSON,isCustomSearchPage,canonicalLink<cfif form.parentID neq 0>,subsort</cfif>,googleIndex)
    values(
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.body#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mySlug#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.h1#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.metatitle#">,
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.metadescription#">,
      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.showinnavigation#">,
      <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.parentID#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.externalLink#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.triggerOnly#">,
      <cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.ignoreParentSlug#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#mybodyclass#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.layout#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.popularSearch#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#myfile#">,
      <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.showInFooter#">,
      <cfqueryparam cfsqltype="sql_varchar" value="#serializeJSON(FORM)#">
      <cfif isdefined('form.isCustomSearchPage')>
      ,'Yes'
      <cfelse>
      ,'No'
      </cfif>
      ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.canonicalLink#">
      <cfif form.parentID neq 0>,<cfqueryparam cfsqltype="cf_sql_integer" value="#variables.newSubSort#"></cfif>
      ,<cfqueryparam CFSQLType="CF_SQL_CHAR" value="#form.googleIndex#">
    )
  </cfquery>

  <cflocation addToken="no" url="form.cfm?success">

</cfif>
