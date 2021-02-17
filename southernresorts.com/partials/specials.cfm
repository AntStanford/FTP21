<cfquery name="getinfo" dataSource="#settings.dsn#">
  select *, (select Count(*) from cms_specials_properties where cms_specials.id = specialid and active = 'yes') as propertycount
  from cms_specials where #createodbcdate(now())# between startdate and enddate
  and active = 'yes'
  order by sort,startdate
</cfquery>
 

<cfif getinfo.recordcount gt 0>
  <cfoutput query="getinfo">
    <div class="row i-specials-box">
      <div class="col-md-4 col-sm-5 col-xs-6">
        <cfif len(slug) and propertycount gt 0><a href="/special/#slug#"></cfif>
          <cfif len(photo)>
            <span class="i-specials-img" style="background:url('/images/specials/#photo#');"></span>
          <cfelse>
            <span class="i-specials-img" style="background:url('http://placehold.it/300x200&text=No Image');"></span>
          </cfif>
        <cfif len(slug) and propertycount gt 0></a></cfif>
      </div>
      <div class="col-md-8 col-sm-7 col-xs-6">
        <div class="i-specials-info">
          <p class="h3"><cfif len(slug) and propertycount gt 0><a href="/special/#slug#">#title#</a><cfelse>#title#</cfif></p>
          <p>#description#</p>
          <cfif len(slug) and propertycount gt 0>
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



