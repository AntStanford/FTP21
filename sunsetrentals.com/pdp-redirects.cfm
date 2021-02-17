<cfheader statusCode = "301" statusText = "Redirecting to New Page">

<cfif isdefined('url.propid') and isDefined('settings.booking.dir') and isDefined('settings.booking.pms')>

  <cfswitch expression="#settings.booking.pms#">

    <cfcase value="escapia">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM escapia_properties WHERE unitcode LIKE <cfqueryparam CFSQLType="cf_sql_varchar" value="%#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="barefoot">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM bf_properties WHERE PropertyID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="ciirus">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM ciirus_properties WHERE PropertyID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="homeaway">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM pp_propertyinfo WHERE StrPropId = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="RMS">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seopropertyname FROM rms_properties WHERE unitID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="RTR">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM rr_properties WHERE (PropertyID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#"> OR ReferenceID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">)
      </cfquery>
    </cfcase>

    <cfcase value="streamline">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seoPropertyName FROM streamline_properties WHERE unit_id = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfcase value="VRM">
      <cfquery name="getUnitInfo" datasource="#settings.dsn#">
        SELECT seopropertyname FROM vrm_properties WHERE property_id = <cfqueryparam CFSQLType="cf_sql_varchar" value="#url.propid#">
      </cfquery>
    </cfcase>

    <cfdefaultcase>
      <cflocation statusCode = "301" url="/#settings.booking.dir#/results" addtoken="false">
    </cfdefaultcase>
  </cfswitch>

  <cfif getUnitInfo.recordcount is 1>

    <cfset detailPage = '/#settings.booking.dir#/#getUnitInfo.seoPropertyName#'>

    <cflocation statusCode = "301" url="#detailPage#" addtoken="false">

  <cfelse>
    <cflocation statusCode = "301" url="/#settings.booking.dir#/results" addtoken="false">
  </cfif>

<cfelse>
  <cflocation statusCode = "301" url="/#settings.booking.dir#/results" addtoken="false">
</cfif>