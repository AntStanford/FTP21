<cfquery name="getSpecial" dataSource="#settings.dsn#">
	select * from cms_specials where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<cfif getSpecial.recordcount gt 0>
  <cfsavecontent variable="request.resortContent">
  <cfoutput>
    <h1>#getSpecial.title#</h1>
    #getSpecial.description#
  </cfoutput>
  </cfsavecontent>
	<cfset form.fieldnames = 'camefromsearchform,specialid'>
	<cfset form.specialid = getSpecial.id>
  <cfset form.camefromsearchform = "">
	<cfset url.all_properties = 'true'>
  <cfinclude template="/partials/results.cfm">
<cfelse>
  <cfinclude template="/components/header.cfm">
	<div class="i-content int">
	  <div class="container">
	  	<div class="row">
	  		<div class="col">
	        Sorry, that special was not found.
	  		</div>
	  	</div>
	  </div>
  </div><!-- END i-content -->
  <cfinclude template="/components/footer.cfm">
</cfif>

