<cfcache key="cms_assets" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">

<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_assets 
  where section = 'Documents'
  order by createdAt
</cfquery>

<cfif getinfo.recordcount gt 0>
  <ul>
  <cfoutput query="getinfo">
    <li>
    #name#<br />
    <a href="/files/#thefile#" target="_blank">View</a>
    </li>
  </cfoutput>
  </ul>
</cfif>

</cfcache>