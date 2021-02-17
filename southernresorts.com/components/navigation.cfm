<!--- Here is the code used to generate the navigation --->
<cfquery name="getTopLevelNav" dataSource="#settings.dsn#">
  select id,name,slug,externalLink,triggerOnly
  from cms_pages where parentID = 0 and showinnavigation='Yes' order by sort
</cfquery>

<ul>
  <cfoutput query="getTopLevelNav">
    <cfquery name="getSubNav" dataSource="#settings.dsn#">
      select id,name,slug,externalLink,triggerOnly
      from cms_pages where parentID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getTopLevelNav.id#">
      and showinnavigation='Yes'
      order by subsort
    </cfquery>
    <cfif getSubNav.recordcount gt 0>
      <li>
        <cfif getTopLevelNav.triggerOnly eq 'Yes'>
          <a href="javascript:;" class="site-color-3 site-color-1-hover">#name#</a><i class="fa fa-chevron-down text-white"></i>
        <cfelse>
          <cfif len(getTopLevelNav.externalLink)>
            <a href="#getTopLevelNav.externalLink#" <cfif getTopLevelNav.id neq '714'>target="_blank"</cfif> class="site-color-3 site-color-1-hover" rel="noopener">#name#</a><i class="fa fa-chevron-down text-white"></i>
          <cfelse>
            <a href="/#getTopLevelNav.slug#" class="site-color-3 site-color-1-hover">#name#</a><i class="fa fa-chevron-down text-white"></i>
          </cfif>
        </cfif>
        <ul>
          <cfloop query="getSubNav">
            <cfif len(getSubNav.externalLink)>
              <li><a href="#getSubNav.externalLink#" <cfif getSubNav.id neq '714'>target="_blank"</cfif> class="site-color-3 site-color-1-hover" rel="noopener">#name#</a></li>
            <cfelse>
              <li><a href="/#getSubNav.slug#" class="site-color-3 site-color-1-hover">#name#</a></li>
            </cfif>
          </cfloop>
        </ul>
      </li>
    <cfelse>
      <cfif len(getTopLevelNav.externalLink)>
        <li><a href="#getTopLevelNav.externalLink#" target="_blank" class="site-color-3 site-color-1-hover" rel="noopener">#name#</a></li>
      <cfelseif getTopLevelNav.slug eq 'index'>
        <li><a href="/" class="site-color-3 site-color-1-hover">#name#</a></li>
      <cfelse>
        <li><a href="/#getTopLevelNav.slug#" class="site-color-3 site-color-1-hover">#name#</a></li>
      </cfif>
    </cfif>
  </cfoutput>
</ul>
