<cfset page.title ="Cart Abandonment Footer Stats">


<cfif isdefined('RunReport')>
	<cfset StartDate = "#form.startdate#">
	<cfset EndDate = "#form.enddate#">
<cfelse>
	<cfset StartDate = "#dateformat(now(),'mm')#/01/#dateformat(now(),'yyyy')#">
	<cfset EndDate = "#dateformat(now(),'mm/dd/yyyy')#">
</cfif>


<cfinclude template="/admin/components/header.cfm">


<form action="index.cfm" method="post">
<cfoutput>
<table>
<tr>
<td>Start Date:</td><td><input type="text" class="datepicker" name="StartDate" value="#startdate#"></td>
<td>End Date:</td><td><input type="text" class="datepicker" name="EndDate" value="#EndDate#"></td>
<td>Sort By:</td><td>
<select name="TypeClick" style="width: 300px;">
	<option value="all">All</option>
	<option value="DetailPage" <cfif isdefined('TypeClick') and TypeClick is 'DetailPage'>selected</cfif>>Detail Page Click</option>
	<option value="BookNow" <cfif isdefined('TypeClick') and TypeClick is 'BookNow'>selected</cfif>>Book Now Page Click</option>
	<option value="BookingConfirmed" <cfif isdefined('TypeClick') and TypeClick is 'BookingConfirmed'>selected</cfif>>Confirmed Booking</option>
</select>
</td>
<td><input type="submit" class="btn btn-success" name="RunReport" value="Run Report"></td><td><a href="index.cfm" class="btn btn-warning">Reset</a></td>
</tr>
</table>
</cfoutput>
</form>

 <cfset startdate = "#dateformat(startdate,'yyyy-mm-dd')# 00:00:01">
  <cfset enddate = "#dateadd('d','1',enddate)#">
 <cfset enddate = "#dateformat(enddate,'yyyy-mm-dd')# 11:59:59">

<cfquery name="GetAll" dataSource="#settings.dsn#">
   select *
   from cart_abandonment_tracker_footer
   where createdat between <cfqueryparam cfsqltype="cf_sql_date" value="#startdate#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#enddate#">
   <cfif isdefined('form.TypeClick') and form.TypeClick is not "All">and TypeClick = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.TypeClick#"></cfif>
</cfquery>

<cfquery name="GetTotal" dbtype="query">
	select sum(amount) as TotalAmount
   from GetAll
</cfquery>

<cfquery name="GetDetailPageClicks" dbtype="query">
	select id
   from GetAll where typeclick = 'DetailPage'
</cfquery>

<cfquery name="GetBookNowPageClicks" dbtype="query">
	select id
   from GetAll where typeclick = 'BookNow'
</cfquery>

<cfquery name="GetBookingConfirmedPageClicks" dbtype="query">
	select id
   from GetAll where typeclick = 'BookingConfirmed'
</cfquery>




<div class="widget-box">
<div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>
	<cfoutput>
  	<h5>Cart Abandonment Click Data Showing for #DateFormat(StartDate,'mm/dd/yyyy')# to #DateFormat(EndDate,'mm/dd/yyyy')#</h5>
	</cfoutput>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
	  <th>Date Time</th>
      <th>Type of Click</th>
	  <th>Book Amount</th>
    </tr>


	  <cfoutput query="GetAll">
      <tr>
	  	 <td>#dateformat(createdat,'mm/dd/yyyy')# #timeformat(createdat,'hh:mm tt')#</td>
         <td>#TypeClick#</td>
         <td>#Dollarformat(amount)#</td>
      </tr>
	   </cfoutput>

	   <cfoutput>
	  <tr>
	  	<td></td>
		<td>Detail Page Clicks: #GetDetailPageClicks.recordcount#<br>
			Book Now Page Clicks: #GetBookNowPageClicks.recordcount#<br>
			Booking Confirmed Clicks: #GetBookingConfirmedPageClicks.recordcount#<br>
		</td>
		<td><strong>#dollarformat(GetTotal.TotalAmount)#</strong></td>
	  </tr>
	  </cfoutput>
    </table>
  </div>
</div>



<cfinclude template="/admin/components/footer.cfm">