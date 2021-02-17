<cfif LEN(page.slug) eq 0>
	<style>#header, #content { display: none; }</style>
</cfif>

<cfheader statusCode = "404" statusText = "Page Not Found">

<!--- PAGE LAYOUT HERE --->
<div class="i-content int">
  <div class="container">
  	<div class="row">
  		<div class="col">
        <h1 class="site-color-3">Page Not Found</h1>
        <p>Sorry, the page you were looking for could not be found. <a href="/" class="site-color-3 site-color-3-lighten-hover">Continue browsing</a> the rest of the site.</p>
        <br><br>
  		</div>
  	</div>
  	<cfinclude template="/components/callouts.cfm">
  </div>
</div><!-- END i-content -->
<!--- END PAGE LAYOUT HERE --->

<cfquery dataSource="#settings.dsn#">
	insert into notfound(thepage,thereferer,remoteip)
	values(
	<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#slug#">,
	<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#cgi.HTTP_REFERER#" >,
	<cfqueryparam CFSQLType="CF_SQL_LONGVARCHAR" value="#cgi.REMOTE_ADDR#">
	)
</cfquery>