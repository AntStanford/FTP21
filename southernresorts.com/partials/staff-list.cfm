<cfcache key="cms_staff" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
  <cfquery name="getinfo" dataSource="#settings.dsn#">
    select * from cms_staff order by sort
  </cfquery>
  <cfif getinfo.recordcount gt 0>
  	<div class="cms-staff-option-1">  	
  		<cfoutput query="getinfo">
  		<div class="row">  			
  			<div class="col-lg-3 col-md-3 col-sm-4 col-xs-4">
  		    <a href="/staff/#slug#">
    		    <cfif len(photo)>
    	        <img src="/images/staff/#photo#" class="thumbnail" width="100%" alt="#name#">
    	      <cfelse>
    	        <img src="https://www.icoastalnet.com/images/layout/no-body.jpg" class="thumbnail" width="100%" alt="#name#">
    	      </cfif>
          </a>
  			</div>
  			<div class="col-lg-9 col-md-9 col-sm-8 col-xs-8">
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