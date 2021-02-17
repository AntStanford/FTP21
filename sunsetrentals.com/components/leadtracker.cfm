<cftry>
  <cfif settings.timezone eq 'Central'>
    <cfset temp = DateAdd('h',-1,now())>
    <cfset rightNow = DateFormat(temp,'yyyy-mm-dd HH:mm:ss')>
  <cfelseif settings.timezone eq 'Mountain'>
    <cfset temp = DateAdd('h',-2,now())>
    <cfset rightNow = DateFormat(temp,'yyyy-mm-dd HH:mm:ss')>
  <cfelseif settings.timezone eq 'Pacific'>
    <cfset temp = DateAdd('h',-3,now())>
    <cfset rightNow = DateFormat(temp,'yyyy-mm-dd HH:mm:ss')>
  <cfelse>
    <cfset rightNow = DateFormat(now(),'yyyy-mm-dd HH:mm:ss')> <!--- Default to Eastern --->
  </cfif>
  <!--- Check and see if user has already requested info on this property --->
  <cfquery name="ltCheck" dataSource="#settings.ltDSN#">
    select id,email
    from lt_leads
    where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
    and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
    limit 1
  </cfquery>
  <cfparam name="form.comments" default="">
  <cfparam name="form.propertyid" default="">
  <cfparam name="form.hiddenstrcheckin" default="">
  <cfparam name="form.hiddenstrcheckout" default="">
  <cfparam name="form.phone" default="">
  <cfif ltCheck.recordcount gt 0> <!--- append conversation --->
    <cfquery datasource="#settings.ltDSN#">
      update lt_leads
      SET status='Guest Responded',
      statuslastupdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rightNow#">
      where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ltCheck.id#">
      and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
    </cfquery>
    <cfquery datasource="#settings.ltDSN#">
      insert into lt_replybyemail(thedate,subject,notes,mainid,FromORTo,propertyid,siteid
      <cfif len(form.hiddenstrcheckin)>
        ,startdate
      </cfif>
      <cfif len(form.hiddenstrcheckout)>
        ,enddate
       </cfif>
      )
      Values (
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rightNow#">,
        'Request from Website',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.comments#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#ltCheck.id#">,
        'To Company',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyid#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
        <cfif len(form.hiddenstrcheckin)>
          ,<cfqueryparam cfsqltype="cf_sql_date" value="#form.hiddenstrcheckin#"/>
        </cfif>
        <cfif len(form.hiddenstrcheckout)>
          ,<cfqueryparam cfsqltype="cf_sql_date" value="#form.hiddenstrcheckout#"/>
        </cfif>
      )
    </cfquery>
  <cfelse> <!--- add new lead --->
    <cfquery dataSource="#settings.ltDSN#">
      insert into lt_leads(thedate,subject,firstname,lastname,email,status,firstnote,camefrom,siteid)
      values (
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rightNow#">,
        'Request from Website',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.firstname#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.lastname#">,
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">,
        'Waiting on Agent',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.comments#">,
        'Website',
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
      )
    </cfquery>
    <cfquery name="getmaxid" datasource="#settings.ltDSN#">
      select max(id) as maxid
      from lt_leads
      where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.email#">
      and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
    </cfquery>
    <cfset MessageMainID = "#getmaxid.maxid#">
    <cfquery datasource="#settings.ltDSN#">
      insert into lt_replybyemail(thedate,subject,notes,mainid,FromORTo,propertyid,siteid
      <cfif len(form.hiddenstrcheckin)>
        ,startdate
      </cfif>
      <cfif len(form.hiddenstrcheckout)>
        ,enddate
      </cfif>
      )
      Values (
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rightNow#">,
        'Request from Website',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.comments#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#MessageMainID#">,
        'To Company',
        <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.propertyid#">,
        <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#settings.id#">
        <cfif len(form.hiddenstrcheckin)>
          ,<cfqueryparam cfsqltype="cf_sql_date" value="#form.hiddenstrcheckin#"/>
        </cfif>
        <cfif len(form.hiddenstrcheckout)>
          ,<cfqueryparam cfsqltype="cf_sql_date" value="#form.hiddenstrcheckout#"/>
        </cfif>
      )
    </cfquery>
  </cfif>
  <!--- End Leadtracker Code --->
  <cfcatch>
    <cfif isdefined("ravenClient")>
      <cfset ravenClient.captureMessage('components/leadtracker.cfm. cfcatch =' & cfcatch.message)>
    </cfif>
  </cfcatch>
</cftry>