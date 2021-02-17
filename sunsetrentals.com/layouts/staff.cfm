<cfquery name="getStaff" dataSource="#settings.dsn#">
	select * from cms_staff where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cgi.query_string#">
</cfquery>
<cfinclude template="/components/header.cfm">
<cfif getStaff.recordcount gt 0>
	<cfoutput query="getStaff">
	<div class="i-content int">
	  <div class="container">
	  	<div class="row">
	  		<div class="col">
	        <div class="row">
	          <div class="col-sm-12 col-md-4">
	            <cfif len(photo) gt 0>
	            	<img class="card lazy" data-src="/images/staff/#photo#" src="/images/layout/1x1.png" width="100%" alt="Staff #photo#">
	            <cfelse>
	            	<img class="lazy" data-src="https://www.icoastalnet.com/images/layout/no-body.jpg" src="/images/layout/1x1.png" alt="Staff Placeholder">
	            </cfif>
	          </div>
	          <div class="col-sm-12 col-md-8">
	            <h1 class="site-color-3 m-0 p-0">#name#</h1>
	            <cfif len(title)><p class="h6 site-color-2">#title#</p></cfif>
	            <p>
	              <cfif len(email)><b>Email:</b> #email#<br></cfif>
	              <cfif len(phone)><b>Phone:</b> #phone#<br></cfif>
	              <cfif len(fax)><b>Fax:</b> #fax#<br></cfif>
	            </p>
	            #description#
	          </div>
	        </div>
	  		</div>
	  	</div>
	  </div>
  </div><!-- END i-content -->
	</cfoutput>
<cfelse>
	<div class="i-content int">
		<div class="container">
			<div class="row">
				<div class="col">
          <h1>Record Not Found</h1>
          <p>Sorry, that record was not found.</p>
				</div>
			</div>
  		<cfinclude template="/components/callouts.cfm">
		</div>
  </div><!-- END i-content -->
</cfif>
<cfinclude template="/components/footer.cfm">