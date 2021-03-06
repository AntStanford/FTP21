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
			insert into cms_assets(thefile,section,galleryid) 
			values( 
			'#i.serverfile#',
			'Gallery',
			<cfqueryparam value="#form.galleryid#" cfsqltype="cf_sql_integer">
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
		  
		<!--- Now compress the image using CF_GraphicsMagick  ---> 	
		<cftry>	      
		<CF_GraphicsMagick 
			     action="Optimize" 
			     infile="#largePath#\#i.serverfile#" 
			     outfile="#largePath#\#i.serverfile#" 
			     compress="JPEG">
		<cfcatch></cfcatch>
		</cftry>  
	</cfloop>
	<!--- JSON end --->
	]}
 </cfoutput>   

  
  
 



       




