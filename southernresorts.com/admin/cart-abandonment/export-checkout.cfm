<cfcontent type="application/vnd.ms-excel">
<cfheader name="Content-Disposition" value="filename=LeadExportCheckout.xls">

<cfquery name="getinfo" dataSource="booking_clients">
  select *
  from cart_abandonment
  where followUpEmailSent = 'Yes'
  and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">

  <cfif isdefined('url.StartDate') and LEN(url.StartDate)>and followUpEmailTimestamp between <cfqueryparam value="#url.StartDate#" cfsqltype="CF_SQL_TimeStamp"></cfif>
  <cfif isdefined('url.EndDate') and LEN(url.EndDate)>and <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#url.EndDate# 23:59:59"></cfif>

  order by followUpEmailTimestamp desc
</cfquery>

<cfquery name="GetProperties" dataSource="#application.dsn#">
  select id as unitcode, name as unitshortname from track_properties
</cfquery>

    <table class="table table-bordered table-striped">
      <tr>
         <th>No.</th>
         <th>First Name</th>
         <th>Last Name</th>
         <th>Email</th>
         <th>Sent On</th>
         <th>Property</th>
         <th>Last Opened</th>
         <th>Returned and Booked</th>
         <th>Abandon Time</th>
      </tr>

    <cfoutput query="getinfo">

      <cfquery name="GetDetails" dataSource="booking_clients">
        select * from cart_abandonment_opens
        where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">
        and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#unitcode#">
        and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">
      </cfquery>

      <cfquery name="GetBooking" datasource="#application.dsn#">
        select * from track_Reservations
        where strEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getinfo.email#">
        and dtBookDate > <cfqueryparam cfsqltype="CF_SQL_Date" value="#followUpEmailTimestamp#">
      </cfquery>

      <cfquery name="GetBookingLastUpdate" datasource="#application.dsn#">
        select * from track_Reservations
        where strEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#email#">
        order by dtBookDate desc
        limit 1
      </cfquery>

      <cfquery dbtype="query" name="getProp">
        select unitcode,unitshortname from GetProperties where unitcode = <cfqueryparam value="#unitcode#" cfsqltype="cf_sql_varchar">
      </cfquery>

      <tr>
      <td width="45">#currentrow#. <a name="#currentrow#"></a></td>
        <td>#firstname#</td>
        <td>#lastname#</td>
        <td>#email#</td>
        <td>#dateformat( dateadd( 'h', -3, followUpEmailTimestamp ),'mm/dd/yyyy' )# #timeformat( dateAdd( 'h', -3, followUpEmailTimestamp ),'h:mm tt' )#</td>
        <td>#unitcode# - #getProp.unitshortname#</td>
        <td>#GetDetails.numtimesviewed# - <cfif isDate( GetDetails.lastopened )>#dateformat( dateadd( 'h', -3, GetDetails.lastopened ),'mm/dd/yyyy')# #timeformat( dateadd( 'h', -3, GetDetails.lastopened ),'h:mm tt')#</cfif></td>
        <td>
        <cfif GetBooking.recordcount gt 0>
          Yes -
          #dollarformat(GetBooking.priceTotal)#<br>
        <cfelse>
          No <br>
        </cfif>

        #dateformat(GetBookingLastUpdate.dtChangeDate,'mm/dd/yyyy')#<!---  #timeformat(GetBookingLastUpdate.lastupdatedatetime,'h:mm tt')#  --->
      </td>
        <td>#dateformat( dateadd('h', -3, getinfo.createdat ),'mm/dd/yyyy')# #timeformat( dateAdd( 'h', -3, getinfo.createdat ),'h:mm tt' )#</td>
      </tr>

    </cfoutput>

    </table>


