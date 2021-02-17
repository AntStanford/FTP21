<cfset table = 'cms_reunions_retreats_locations'>

<!--- Delete --->
<cfif isdefined('url.id') and isdefined('url.delete')>

    <cfquery dataSource="#application.dsn#">
	    delete from #table# where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
    </cfquery>

    <cfquery dataSource="#application.dsn#">
	    delete from cms_reunions_retreats where AreaID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
    </cfquery>

  	<cflocation addToken="no" url="index.cfm?success">
</cfif>

<cfif isdefined('form.title') >
	<cfquery dataSource="#dsn#">
		INSERT INTO cms_reunions_retreats_locations(name,slug)
      	VALUES
		(
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.title#">
        ,<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.areaslug#">
		)
   </cfquery>

 <cflocation addToken="no" url="index.cfm?successarea">
</cfif>

  <cfif isdefined('form.name')>
        <cfquery dataSource="#dsn#">
              update cms_reunions_retreats_locations
              set name = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.name#">
              ,slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.areaslug#">
              where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
          </cfquery>

  </cfif>
<!--- Clear out any page properties, then re-insert, if any --->
      <cfquery dataSource="#dsn#">
          delete from cms_reunions_retreats where areaID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">
      </cfquery>
  <cfif isdefined('form.properties') and ListLen(form.properties) gt 0>
	  

      <cfloop list="#form.properties#" index="i">

             <cfquery dataSource="#dsn#">
                insert into cms_reunions_retreats(areaID,propertyid) values(<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.id#">,'#i#')
             </cfquery>

          </cfloop>
</cfif>



  <cflocation addToken="no" url="form.cfm?id=#form.id#&success">
