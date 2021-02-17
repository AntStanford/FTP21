<cfquery datasource="#application.dsn#">
      UPDATE cms_destinations
      SET bannerimage = ''
      WHERE id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
      </cfquery>