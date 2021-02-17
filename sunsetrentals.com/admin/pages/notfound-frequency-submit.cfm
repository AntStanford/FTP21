
<CFQUERY NAME="UpdateQuery" DATASOURCE="#dsn#">
UPDATE notfound
SET
notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#notes#">
where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
</cfquery>



 <cflocation addToken="no" url="notfound-frequency.cfm?&success">
