<cfcache key="cms_staff" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
	<cfquery name="getinfo" dataSource="#settings.dsn#">
	  select * from cms_staff order by sort
	</cfquery>
	<cfif getinfo.recordcount gt 0>
		<div class="row cms-staff-option-2">
			<cfoutput query="getinfo">
				<div class="col-xs-12 col-sm-6 col-md-4">
					<div>
            <a href="/staff/#slug#">
	            <cfif len(photo)>
	              <img class="card lazy" data-src="/images/staff/#photo#" src="/images/layout/1x1.png" width="100" alt="#name#">
	            <cfelse>
	              <img class="card lazy" data-src="https://www.icoastalnet.com/images/layout/no-body.jpg" src="/images/layout/1x1.png" width="100" alt="#name#">
	            </cfif>
            </a>
						<strong><a href="/staff/#slug#">#name#</a></strong>
						<em>#title#</em>
					</div>
				</div>
			</cfoutput>
		</div>
	</cfif>
</cfcache>