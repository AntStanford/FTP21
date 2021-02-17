<!--- On page variables --->

<cfset largePath = #ExpandPath('/images/gallery')#>
<cfset largePathRSS='\/images\/gallery\/'>
<cfset largeURLRSS='\/images\/gallery\/'>

<cfset uploadGallery="">
<cfif isdefined('form.galleryName')>
	<cfset uploadGallery=form.galleryName>
</cfif>
<cfif isdefined('url.galleryName')>
	<cfset uploadGallery=url.galleryName>
</cfif>
<!--- If a new gallery name was entered, that will be the name of the gallery --->
<cfif isdefined('form.newgallery')>
	<cfset uploadGallery=form.newgallery>
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
		<cfquery dataSource="#dsn#">
			insert into cms_assets(thefile,section)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#i.serverfile#">,
			'Gallery'
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