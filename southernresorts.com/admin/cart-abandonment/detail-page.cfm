<cftry>

<cfset page.title ="Cart Abandonment - Detail Page">

<cfif isdefined('RunReport')>
	<cfset StartDate = "#form.startdate#">
	<cfset EndDate = "#form.enddate#">
<cfelse>
	<cfset StartDate = "#dateformat(now(),'mm')#/01/#dateformat(now(),'yyyy')#">
	<cfset EndDate = "#dateformat(now(),'mm/dd/yyyy')#">
</cfif>

<cfquery name="getinfo" dataSource="booking_clients">
  select * from cart_abandonment_detail_page
  where followUpEmailSent = 'Yes'
  and followUpEmailTimestamp between <cfqueryparam value="#StartDate#" cfsqltype="CF_SQL_TimeStamp">
  and <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#EndDate# 23:59:59">
  and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">
  order by followUpEmailTimestamp desc
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<form action="detail-page.cfm" method="post">
   <cfoutput>
   <table>
      <tr>
         <td>Start Date:</td>
         <td><input type="text" class="datepicker" name="StartDate" value="#startdate#"></td>
         <td>End Date:</td>
         <td><input type="text" class="datepicker" name="EndDate" value="#enddate#"></td>
         <td><input type="submit" class="btn btn-success" name="RunReport" value="Run Report"> <a href="detail-page.cfm" class="btn btn-warning">Reset</a></td>
          <td><cfif getinfo.recordcount gt 0>
				<a href="export.cfm?export=<cfif isdefined('startdate') and LEN(startdate)>&startdate=#startdate#</cfif><cfif isdefined('enddate') and LEN(enddate)>&enddate=#enddate#</cfif>" class="btn btn-primary"><i class="icon-file icon-white"></i> Export (XLS)</a>
		  </cfif>
     </td>
      </tr>
   </table>
   </cfoutput>
</form>

<cfif isdefined('RunReport')>
   <div class="alert alert-success">
      You searched from <b><cfoutput>#form.startdate# to #form.enddate#</cfoutput></b>
   </div>
</cfif>

<cfif getinfo.recordcount gt 0>

<div class="widget-box">
  <div class="widget-content nopadding">

    <table class="table table-bordered table-striped">
      <tr>
         <th>No.</th>
         <th>First Name</th>
         <th>Last Name</th>
         <th>Email</th>
         <th>Sent On</th>
         <th>Last Opened</th>
         <th>Returned and Booked</th>
         <th>Abandon Time</th>
      </tr>

    <cfoutput query="getinfo">

      <cfquery name="GetDetails" dataSource="booking_clients">
        select * from cart_abandonment_opens
        where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.email#">
        and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.unitcode#">
        and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">
      </cfquery>

      <cfquery name="GetBooking" datasource="#application.dsn#">
        select r.*, p.name as propertyname
        from track_Reservations as r
        left join track_properties as p on p.id = r.propertyID
        where strEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.email#">
        and dtBookDate > <cfqueryparam cfsqltype="CF_SQL_Date" value="#followUpEmailTimestamp#">
      </cfquery>

      <cfquery name="isPreviousGuest" datasource="#application.dsn#">
        select *
        from track_Reservations
        where strEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getinfo.email#" />
        and dtBookDate < <cfqueryparam cfsqltype="CF_SQL_Date" value="#followUpEmailTimestamp#">
      </cfquery>

      <tr>
        <td width="45">#currentrow#. <a name="#currentrow#"></a></td>
     		<td>#getinfo.firstname#</td>
     		<td>#getinfo.lastname#</td>
     		<td>#getinfo.email#</td>
     		<td>#dateformat( dateadd( 'h', -3, followUpEmailTimestamp ),'mm/dd/yyyy' )# #timeformat( dateAdd( 'h', -3, followUpEmailTimestamp ),'h:mm tt' )#</td>
     		<td>#GetDetails.numtimesviewed# - <cfif isDate( GetDetails.lastopened )>#dateformat( dateadd( 'h', -3, GetDetails.lastopened ),'mm/dd/yyyy')# #timeformat( dateadd( 'h', -3, GetDetails.lastopened ),'h:mm tt')#</cfif></td>
     		<td>
          <cfif GetBooking.recordcount gt 0>
            Yes - <br>#GetBooking.name#

            <!---<cfif cgi.remote_host eq '75.87.87.115'>--->
              <cfif isPreviousGuest.recordcount gt 1><br>Previous Guest</cfif>
            <!---</cfif>--->
          <cfelse>
            No
          </cfif>
        </td>
     		<td>#dateformat( dateadd('h', -3, getinfo.createdat ),'mm/dd/yyyy')# #timeformat( dateAdd( 'h', -3, getinfo.createdat ),'h:mm tt' )#</td>
	   </tr>

    </cfoutput>

    </table>

  </div>
</div>

</cfif>

<cfinclude template="/admin/components/footer.cfm">

<cfcatch>
  <cfdump var="#cfcatch#" abort="true" />
</cfcatch>

</cftry>