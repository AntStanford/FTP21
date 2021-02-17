<cfquery name="getSpecial" dataSource="#settings.dsn#">
SELECT *
FROM cms_specials
WHERE slug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.query_string#">
</cfquery>
<!---<cfinclude template="/vacation-rentals/results.cfm">--->
<cfif getSpecial.recordcount gt 0>
	<cfsavecontent variable="request.specialcontent">
		<cfoutput>
			<h1>#getSpecial.title#</h1>
			#getSpecial.description#
		</cfoutput>
	</cfsavecontent>
	
	<cfset form.camefromsearchform = ''>
	<cfset form.fieldnames = 'specialid'>
	<cfset form.specialid = getSpecial.id>

	<cfinclude template="/vacation-rentals/results.cfm">
<cfelse>
	<cfinclude template="/components/header.cfm">
	
	<div class="i-content">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					Sorry, that special was not found.
				</div>
			</div>
		</div>
	</div><!-- END i-content -->

	<cfinclude template="/components/footer.cfm">
</cfif>

<!---
<cfquery name="getSpecial" dataSource="#settings.dsn#">
	select * from cms_specials where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<cfinclude template="/components/header.cfm">
<cfif getSpecial.recordcount gt 0>
	<div class="i-content">
	  <div class="container">
		<div class="row">
			<div class="col-lg-12">
		  <cfoutput>
			<h1>#getSpecial.title#</h1>
			#getSpecial.description#
		  </cfoutput>
		  <cfset session.specialid = getSpecial.id>
		  <cfinclude template="/partials/results.cfm">
			</div>
		</div>
	  </div>
  </div><!-- END i-content -->
<cfelse>
	<div class="i-content">
	  <div class="container">
		<div class="row">
			<div class="col-lg-12">
			Sorry, that special was not found.
			</div>
		</div>
	  </div>
  </div><!-- END i-content -->
</cfif>
<cfinclude template="/components/footer.cfm">
--->