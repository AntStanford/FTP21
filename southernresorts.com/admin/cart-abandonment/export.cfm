<cfquery name="getinfo" dataSource="booking_clients">
  select * from cart_abandonment_detail_page
  where followUpEmailSent = 'Yes'
  and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">

    <cfif isdefined('url.StartDate') and LEN(url.StartDate)>
        and followUpEmailTimestamp between <cfqueryparam value="#url.StartDate#" cfsqltype="CF_SQL_TimeStamp">
    </cfif>

    <cfif isdefined('url.EndDate') and LEN(url.EndDate)>
        and <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#url.EndDate# 23:59:59">
    </cfif>

  order by followUpEmailTimestamp desc
</cfquery>

<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="filename=LeadExport.xls">


<table border="0">

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
            <td>#firstname#</td>
            <td>#lastname#</td>
            <td>#email#</td>
            <td>#dateformat( dateadd( 'h', -3, followUpEmailTimestamp ),'mm/dd/yyyy' )# #timeformat( dateAdd( 'h', -3, followUpEmailTimestamp ),'h:mm tt' )#</td>
            <td>#GetDetails.numtimesviewed# - <cfif isDate( GetDetails.lastopened )>#dateformat( dateadd( 'h', -3, GetDetails.lastopened ),'mm/dd/yyyy')# #timeformat( dateadd( 'h', -3, GetDetails.lastopened ),'h:mm tt')#</cfif></td>
            <td>
          <cfif GetBooking.recordcount gt 0>
            Yes - <br>#GetBooking.propertyname#
            <cfif isPreviousGuest.recordcount gt 1><br>Previous Guest</cfif>
          <cfelse>
            No
          </cfif>
        </td>
            <td>#dateformat( dateadd('h', -3, getinfo.createdat ),'mm/dd/yyyy')# #timeformat( dateAdd( 'h', -3, getinfo.createdat ),'h:mm tt' )#</td>
       </tr>

    </cfoutput>

    </table>
