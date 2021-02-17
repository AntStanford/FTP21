<cfcache key="cms_staff" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
  <cfquery name="getinfo" dataSource="#settings.dsn#">
    select * from cms_staff order by sort
  </cfquery>
  <cfif getinfo.recordcount gt 0>
  	<div class="cms-staff-option-1">
  		<cfoutput query="getinfo">
  		<div class="row">
  			<div class="col-xs-12 col-sm-4 col-md-3 col-lg-4">
  		    <a href="/staff/#slug#">
    		    <cfif len(photo)>
    	        <img class="card lazy" data-src="/images/staff/#photo#" src="/images/layout/1x1.png" width="100%" alt="#name#">
    	      <cfelse>
    	        <img class="card lazy" data-src="https://www.icoastalnet.com/images/layout/no-body.jpg" src="/images/layout/1x1.png" width="100%" alt="#name#">
    	      </cfif>
          </a>
  			</div>
  			<div class="col-xs-12 col-sm-8 col-md-9 col-lg-8">
    			<p class="h3">
      			<a href="/staff/#slug#">#name#</a>
    			</p>
    			<p>#Title#</p>
  			</div>
  		</div><br>
  		</cfoutput>
  	</div>
  </cfif>
</cfcache>