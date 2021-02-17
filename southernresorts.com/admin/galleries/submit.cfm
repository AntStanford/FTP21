<cftry>

<cfset uppicture = ExpandPath('/images/popups')>

<cfif isdefined('url.delete') and isdefined('url.id')>

  <cfquery dataSource="#settings.dsn#">
    DELETE FROM cms_galleries
    WHERE id = <cfqueryparam value="#url.id#" cfsqltype="integer">
  </cfquery>

  <cfquery dataSource="#settings.dsn#">
    DELETE FROM cms_assets
    WHERE section = <cfqueryparam value="Gallery" cfsqltype="cf_sql_varchar"> and galleryid = <cfqueryparam value="#url.id#" cfsqltype="integer">
  </cfquery>

  <cfif isdefined('url.shortcode') and LEN(url.shortcode)>

    <cfquery dataSource="#settings.dsn#">
      DELETE FROM cms_shortcodes
      WHERE id = <cfqueryparam value="#url.shortcode#" cfsqltype="integer">
    </cfquery>

  </cfif>

 <cflocation url="index.cfm" addtoken="false">

<cfelseif isdefined('url.removePhoto') and len(url.removePhoto)>

  <cfquery name="getPhoto" dataSource="#settings.booking.dsn#">
    select photo from cms_galleries where id = <cfqueryparam value="#url.removePhoto#" cfsqltype="integer"> limit 1
  </cfquery>

  <cfquery dataSource="#settings.booking.dsn#">
    Update cms_galleries 
    Set photo = ''
    Where id = <cfqueryparam value="#url.removePhoto#" cfsqltype="integer">
  </cfquery>

  <cfif getPhoto.recordcount eq 1>
  	<cftry>
  	<cfset photoPath = ("#uppicture#\#getPhoto.photo#")>	

	<cfscript>
		FileDelete(#photoPath#);		
	</cfscript>

  	<cfcatch></cfcatch>
  	</cftry>
  </cfif>

 <cflocation url="form.cfm?id=#url.removePhoto#" addtoken="false">

<cfelseif isdefined('form.id') and len(form.id)>

  <cfquery dataSource="#settings.dsn#">
    UPDATE cms_galleries
    SET title = <cfqueryparam value="#form.title#" cfsqltype="varchar">
    WHERE id = <cfqueryparam value="#form.id#" cfsqltype="integer">
  </cfquery>

  <cflocation url="form.cfm?id=#form.id#&success=yes" addtoken="false">

<cfelse>

  <cfquery dataSource="#settings.dsn#" result="result">
    INSERT INTO cms_galleries(title) 
    VALUES(
    	<cfqueryparam value="#form.title#" cfsqltype="varchar">
    	)
  </cfquery>

  <cfquery dataSource="#settings.dsn#">
    INSERT INTO cms_shortcodes(externalID,includeFile) 
    VALUES(
      <cfqueryparam value="#result.generatedKey#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="galleries.cfm" cfsqltype="varchar">
      )
  </cfquery>


  <cflocation url="form.cfm?success=yes" addtoken="false">

</cfif>



<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>