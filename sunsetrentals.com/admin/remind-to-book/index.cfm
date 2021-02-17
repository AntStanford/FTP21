<cfset page.title ="Remind Me To Book Stats">


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
<td>Came From:</td><td>
<select name="CameFrom" style="width: 150px;">
	<option value="all">All</option>
	<option value="PDP" <cfif isdefined('CameFrom') and CameFrom is 'PDP'>selected</cfif>>Property Page</option>
	<option value="Checkout" <cfif isdefined('CameFrom') and CameFrom is 'Checkout'>selected</cfif>>Checkout Page</option>
</select>
</td>
<td>Bookers:</td><td>
<select name="Bookers" style="width: 150px;">
	<option value="all">All</option>
	<option value="Only Those Booked" <cfif isdefined('Bookers') and Bookers is 'Only Those Booked'>selected</cfif>>Only Those Booked</option>
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

<cfquery name="GetAll" dataSource="#application.dsn#">
   select *
   from cms_remindtobook
   where createdat between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#enddate#">
   <cfif isdefined('form.CameFrom') and form.CameFrom is not "All">and CameFrom = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#form.CameFrom#"></cfif>
   <cfif isdefined('Bookers') and form.Bookers is "Only Those Booked"> and ReturnedAndBooked = 'Yes'</cfif>
</cfquery>

<cfquery name="GetTotal" dbtype="query">
	select sum(Bookingvalue) as TotalAmount
   from GetAll where ReturnedAndBooked = 'Yes'
</cfquery>

<cfquery name="GetDetailPageClicks" dbtype="query">
	select id
   from GetAll where CameFrom = 'PDP'
</cfquery>

<cfquery name="GetBookNowPageClicks" dbtype="query">
	select id
   from GetAll where CameFrom = 'CheckOut'
</cfquery>

<cfquery name="GetDetailPageBooks" dbtype="query">
	select id
   from GetAll where CameFrom = 'PDP' and ReturnedAndBooked = 'Yes'
</cfquery>

<cfquery name="GetBookNowPageBooks" dbtype="query">
	select id
   from GetAll where CameFrom = 'CheckOut' and ReturnedAndBooked = 'Yes'
</cfquery>



<div class="widget-box">
<div class="widget-title">
    <span class="icon">
      <i class="icon-th"></i>
    </span>
	<cfoutput>
  	<h5>Remind Me To Book Data Showing for #DateFormat(StartDate,'mm/dd/yyyy')# to #DateFormat(EndDate,'mm/dd/yyyy')#</h5>
	</cfoutput>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
	  <th>Sent</th>
	  <th>Booked</th>
	  <th>Email</th>
	  <th>Date Time</th>
      <th>Location</th>
	  <th>Book Amount</th>
    </tr>




	  <cfoutput query="GetAll">
      <tr>
	  	 <td><cfif remindersent is "Yes"><a href="##" class="btn btn-mini btn-success"><i class="icon-ok icon-white"></i></a><cfelse><a href="##" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i></a></cfif></td>
		 <td><cfif ReturnedAndBooked is "Yes"><a href="##" class="btn btn-mini btn-success"><i class="icon-ok icon-white"></i></a><cfelse><a href="##" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i></a></cfif></td>
	  	 <td><a href="mailto:#ReminderEmail#">#ReminderEmail#</a></td>
	  	 <td>#dateformat(createdat,'mm/dd/yyyy')# #timeformat(createdat,'hh:mm tt')#</td>
         <td>#CameFrom#</td>
         <td>#Dollarformat(BookingValue)#</td>
      </tr>
	   </cfoutput>

	   <cfoutput>
	  <tr>
	  	<td></td>
		<td></td>
		<td></td>
	  	<td></td>
		<td>
			<cfset returnedAndBookedPercent = "0">
			<cfset PercentBookers = 0>
			<cfset TotalSubmissions = #GetDetailPageClicks.recordcount# + #GetBookNowPageClicks.recordcount#>
			<cfset TotalReturnandBookers = GetDetailPageBooks.recordcount + GetBookNowPageBooks.recordcount>

			<cfif TotalReturnandBookers GT 0>
				<cfset PercentBookers = TotalReturnandBookers / TotalSubmissions>
			</cfif>

			<cfif PercentBookers GT 0>
				<cfset returnedAndBookedPercent = #TotalReturnandBookers# / #Round(PercentBookers * 100)#>
			</cfif>

			Detail Page Submissions: #GetDetailPageClicks.recordcount#<br>
			Book Now Page Submissions: #GetBookNowPageClicks.recordcount#<br>
			Total Submissions: #TotalSubmissions#<br>
			Total Returned and Booked: #(numberFormat(returnedAndBookedPercent,'__.00'))#%
		</td>
		<td><strong>#dollarformat(GetTotal.TotalAmount)#</strong></td>
	  </tr>
	  </cfoutput>
    </table>
  </div>
</div>



<cfinclude template="/admin/components/footer.cfm">
