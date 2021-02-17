<cfset page.icon="fa-info-circle">
<cfset table = 'cms_pixel_codes'>

<cfif isdefined('url.id') and isdefined('url.delete')> <!--- delete statement --->

  <cfquery dataSource="#application.dsn#">
    delete from cms_pixel_codes where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success">

<cfelseif isdefined('form.id')> <!--- update statement --->

  <cfquery dataSource="#application.dsn#">
    update cms_pixel_codes set
    pixelcode = <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#form.pixelcode#">,
	PixelCodeType = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.PixelCodeType#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm">

<cfelse>  <!---insert statement--->


  <cfquery dataSource="#application.dsn#">
    insert into cms_pixel_codes(pixelcode,PixelCodeType)
    values(
      <cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#pixelcode#">,
	  <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.PixelCodeType#">
      )
  </cfquery>

  <cflocation addToken="no" url="index.cfm">

</cfif>