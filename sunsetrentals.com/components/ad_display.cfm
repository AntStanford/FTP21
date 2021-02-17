<cfquery name="GetAd" dataSource="#settings.dsn#">
  select *
  from ads
  where now() between time_start and time_end <!--- and ShowOnPage = '#cleanSlug#' UNCOMMENT COME TIME FOR REAL TESTING--->
  order by rand()
  limit 1
</cfquery>

<cfoutput query="GetAd">
  <cfquery datasource="#settings.dsn#">
    INSERT INTO ads_impressions (THeCFID, THECFToken,AdID)
    VALUES (
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cfid#">,
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cftoken#">,
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#GetAd.ID#">
    )
  </cfquery>
  #name#<br>
  <img src="/images/ads/#photo#" alt="" border="0"><br>
  #couponcode#<br>
  #details#<Br>
  <a href="ad-clickthrough.cfm?ADID=#GetAd.id#&ADLink=#GetAd.Link#" target="_blank">#link#</a>
</cfoutput>