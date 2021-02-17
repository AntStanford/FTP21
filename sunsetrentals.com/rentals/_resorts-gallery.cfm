<cfquery name="getResortPhotos" dataSource="#settings.dsn#">
  select * 
  from cms_assets 
  where section = 'Resorts' and foreignKey = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getResort.id#"> 
  order by sort
</cfquery>

<div class="owl-gallery-wrap owl-resorts-gallery-wrap">
  <div class="cssload-container"><div class="owl-gallery-loader-tube-tunnel"></div></div>
  <div class="owl-carousel owl-theme resorts-carousel">
    <cfoutput query="getResortPhotos">
      <div class="item">
        <a href="/images/resorts/#thefile#" class="fancybox" data-fancybox="owl-gallery-group">
          <img class="owl-lazy" data-src="/images/resorts/#thefile#" alt="#altTag#">
        </a>
      </div>
    </cfoutput>
  </div>
</div>