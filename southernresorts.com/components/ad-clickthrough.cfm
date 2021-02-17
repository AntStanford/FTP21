<cfif isdefined('url.ADID')>
  <cfquery datasource="#settings.dsn#">
    INSERT INTO ads_clicks(THeCFID, THECFToken,AdID)
    VALUES (
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cfid#">,
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cftoken#">,
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.ADID#">
    )
  </cfquery>
  <cflocation url="#url.ADLink#">
</cfif>