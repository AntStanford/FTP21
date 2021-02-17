<cfif isdefined('url.id')>

  <cfset transGif = "#expandpath('/images/dot.gif')#">
  

            <CFQUERY NAME="UpdateQuery" DATASOURCE="#settings.dsn#">
                UPDATE cms_remindtobook
                SET 
                openedemail = 'Yes',
                LastOpened = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#now()#">
                where id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.id#">
           </cfquery>

  
    <cfcontent type="image/gif" file="#transGif#">
  
</cfif>
