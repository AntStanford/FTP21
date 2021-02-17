<cfquery name="getSpecial" dataSource="#settings.dsn#">
	select * from cms_specials where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<cfset form.camefromsearchform = ''>
<cfset form.fieldnames = ''>
<cfif getSpecial.recordcount gt 0>	

  <cfquery name="getSpecialUnits" dataSource="#settings.dsn#">
  	select unitcode
  	from cms_specials_properties
  	where 
  		specialId = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getSpecial.id#">
  </cfquery>
  
  <cfset session.booking.unitcodelist = ValueList(getSpecialUnits.unitcode)>
	
  <cfsavecontent variable="request.specialContent">
		<cfoutput>
      <h1>#getSpecial.title#</h1>
      #getSpecial.description#
    </cfoutput>
  </cfsavecontent>
	<cfset form.fieldnames = 'specialid'>
	<cfset form.specialid = getSpecial.id>
  <cfset url.all_properties = 'false'>
	<cfinclude template="/#settings.booking.dir#/results.cfm">
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
