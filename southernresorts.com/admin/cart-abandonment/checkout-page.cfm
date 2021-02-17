<cftry>

<cfset page.title ="Cart Abandonment - Checkout Page">

<cfif isdefined('RunReport')>
	<cfset StartDate = "#form.startdate#">
	<cfset EndDate = "#form.enddate#">
<cfelse>
	<cfset StartDate = "#dateformat(now(),'mm')#/01/#dateformat(now(),'yyyy')#">
	<cfset EndDate = "#dateformat(now(),'mm/dd/yyyy')#">
</cfif>

<cfquery name="getinfo" dataSource="booking_clients">
  select *
  from cart_abandonment
  where followUpEmailSent = 'Yes'
  and followUpEmailTimestamp between <cfqueryparam value="#StartDate#" cfsqltype="CF_SQL_TimeStamp">
  and <cfqueryparam CFSQLType="CF_SQL_TimeStamp" value="#EndDate# 23:59:59">
  and siteid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="335">
  order by followUpEmailTimestamp desc
</cfquery>

<cfquery name="GetProperties" dataSource="#application.dsn#">
  select id as unitcode, name as unitshortname from track_properties
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">&times;</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<form action="checkout-page.cfm" method="post">
   <cfoutput>
   <table>
      <tr>
         <td>Start Date:</td>
         <td><input type="text" class="datepicker" name="StartDate" value="#startdate#"></td>
         <td>End Date:</td>
         <td><input type="text" class="datepicker" name="EndDate" value="#enddate#"></td>
         <td><input type="submit" class="btn btn-success" name="RunReport" value="Run Report"> <a href="checkout-page.cfm" class="btn btn-warning">Reset</a></td>
		   <td><cfif getinfo.recordcount gt 0>
				<a href="export-checkout.cfm<cfif isdefined('RunReport')>?startdate=#form.startdate#&enddate=#form.enddate#</cfif>" class="btn btn-primary"><i class="icon-file icon-white"></i> Export (XLS)</a>
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
         <th>Property</th>
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
          Yes <!--- -
          #dollarformat(GetBooking.priceTotal)# ---><br>
        <cfelse>
          No <br>
        </cfif>
        
        #dateformat(GetBookingLastUpdate.dtChangeDate,'mm/dd/yyyy')#<!---  #timeformat(GetBookingLastUpdate.lastupdatedatetime,'h:mm tt')#  --->
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