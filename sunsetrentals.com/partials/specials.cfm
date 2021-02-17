<cfquery name="getinfo" dataSource="#settings.dsn#">
  select * from cms_specials where <cfqueryparam cfsqltype="cf_sql_date" value="#createodbcdate(now())#"> between startdate and enddate
  and active = 'yes'
  order by startdate
</cfquery>

<cfif getinfo.recordcount gt 0>
  <cfoutput query="getinfo">
    <div class="row i-specials-box">
      <div class="col-xs-6 col-sm-5 col-lg-4">
        <a href="/special/#slug#">
          <cfif len(photo)>
            <span class="i-specials-img lazy" data-src="/images/specials/#photo#" src="/images/layout/1x1.png"></span>
          <cfelse>
            <span class="i-specials-img lazy" data-src="http://placehold.it/300x200&text=No Image" src="/images/layout/1x1.png"></span>
          </cfif>
          <span class="hidden">Special</span>
        </a>
      </div>
      <div class="col-xs-6 col-sm-7 col-lg-8">
        <div class="i-specials-info">
          <p class="h3"><a href="/special/#slug#">#title#</a></p>
          <p>#description#</p>
          <cfif len(slug)>
          	<a href="/special/#slug#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white">More Info</a>
          </cfif>
        </div>
      </div>
    </div><br>
  </cfoutput>
<cfelse>
  <div class="alert alert-info">
    <p><b>No specials found.</b></p>
  </div>
</cfif>

