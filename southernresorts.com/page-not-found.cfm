<cfheader statusCode = "404" statusText = "Page Not Found">

<cfinclude template="/components/header.cfm">

<h3>Page Not Found</h3>
<p>Sorry, the page you were looking for could not be found. <a href="/">Continue browsing</a> the rest of the site.</p>
   
<cfinclude template="/components/footer.cfm">

<cfif len(cgi.query_string)>

	<cfquery datasource="#settings.dsn#" name="404insert">
		insert into notfound(thepage,thereferer,remoteip)
		values(             
			<cfqueryparam value="#CGI.QUERY_STRING#" cfsqltype="CF_SQL_LONGVARCHAR">,
			<cfqueryparam value="#CGI.HTTP_REFERER#" cfsqltype="CF_SQL_LONGVARCHAR">,
			<cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="CF_SQL_LONGVARCHAR">
		)
	</cfquery> 

</cfif>

