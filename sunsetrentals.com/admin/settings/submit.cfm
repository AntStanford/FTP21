<cfif isdefined('form.submit')>

  <cfif settings.booking.pms eq 'Homeaway'>
     <cfquery dataSource="#settings.bcDSN#">
       update clients set
       future_rez_fee = <cfqueryparam CFSQLType="CF_SQL_DOUBLE" value="#future_rez_fee#">,
       future_rez_year = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#future_rez_year#">,
       future_rez_status = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#future_rez_status#">
       where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.clientid#">
     </cfquery>
  </cfif>

  <cfquery dataSource="#settings.bcDSN#">
    update settings set
    address = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address#">,
    address2 = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.address2#">,
    city = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.city#">,
    state = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.state#">,
    zip = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.zip#">,
    googleAnalytics = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.googleAnalytics#">,
    facebookURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.facebookURL#">,
    twitterURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.twitterURL#">,
    pinterestURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pinterestURL#">,
    youtubeURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.youtubeURL#">,
    linkedInURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.linkedInURL#">,
    instagramURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.instagramURL#">,
    yelpURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.yelpURL#">,
    blogURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.blogURL#">,
    flickrURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.flickrURL#">,
    phone = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.phone#">,
    fax = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.fax#">,
    tollFree = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.tollFree#">,
    prefooter_left = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.leftCol#">,
    prefooter_right = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.rightCol#">
    where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
  </cfquery>

  <cflocation addToken="no" url="index.cfm?success&init">

</cfif>
