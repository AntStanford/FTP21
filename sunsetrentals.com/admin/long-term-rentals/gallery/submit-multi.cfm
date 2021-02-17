<!--- On page variables --->
<cfset largePath = #ExpandPath('/images/longtermrentals')#>
<cfset largePathRSS='\/images\/longtermrentals\/'>
<cfset largeURLRSS='\/images\/longtermrentals\/'>
<cfset uploadGallery="">

<cfif isdefined('form.galleryName')>
	<cfset uploadGallery=form.galleryName>
</cfif>

<cfif isdefined('url.galleryName')>
	<cfset uploadGallery=url.galleryName>
</cfif>


<cfoutput>
    <!--- Image Upload CF --->

	<cffile
    action = "uploadAll"
    destination = "#largePath#"
    accept = "image/jpg,image/jpeg, image/gif, image/png"
    nameConflict = "MakeUnique"
    result = "upfilelist">

    <cfset cma="" />
	{"files": [
    <cfloop array=#upfilelist# index="i">

      <cfquery name="getSort" dataSource="#dsn#">
         select max(sort) as maxSort from cms_assets where section = 'Long Term Rental' and foreignKey = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#uploadGallery#">
      </cfquery>

      <cfif getSort.recordcount gt 0 and len(getSort.maxSort)>
         <cfset sortValue = getSort.maxSort + 1>
      <cfelse>
         <cfset sortValue = 1>
      </cfif>

		<cfquery dataSource="#dsn#">
			insert into cms_assets(foreignKey,thefile,section,sort)
			values(
			<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#uploadGallery#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#i.serverfile#">,
			'Long Term Rental',
			<cfqueryparam cfsqltype="cf_sql_integer" value="#sortValue#">
			)
		</cfquery>
		#cma#
		{
			"name": "#i.serverfile#",
			"size": 902604,
			"url": "#largePathRSS##i.serverfile#",
			"thumbnailUrl": "#largeURLRSS##i.serverfile#",
			"deleteType": "DELETE"
		  }
		  <cfset cma="," />

		<cftry>
			<cfset sourceFileWithPath = "#largePath#\#i.serverfile#">
			<CF_GraphicsMagick action="Commands" commands="convert -auto-orient -strip  #sourceFileWithPath# #sourceFileWithPath#">
		<cfcatch></cfcatch>
		</cftry>

		<!--- Now compress the image using CF_GraphicsMagick  --->
		<CF_GraphicsMagick
			     action="Optimize"
			     infile="#largePath#\#i.serverfile#"
			     outfile="#largePath#\#i.serverfile#"
			     compress="JPEG">

	</cfloop>
	<!--- JSON end --->
	]}
 </cfoutput>












