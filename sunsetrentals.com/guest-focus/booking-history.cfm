<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">

<!--- change this query per PMS as needed --->
<cfquery name="getBookings" dataSource="#settings.dsn#">
	SELECT
		dtBookDate as bookingDate,
		strpropid as propertyid,
		dtCheckInDate as strcheckin,
		dtCheckOutDate as strcheckout
	from pp_guestreservationinfo 
	where stremail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInEmail#">
	order by dtBookDate
</cfquery>

<div class="content-wrap">

  <div class="page-header">
    <h1>Booking History</h1>
  </div>
  
  <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  
  <cfif getBookings.recordcount gt 0>
  <table class="table table-bordered">
  	<tr>
  		<th>No.</th>
  		<th>Book Date</th>
  		<th>Unit</th>
  		<th>Dates</th>
  	</tr>
  	<cfloop query="getBookings">  	
  		
  		<!--- change this query per PMS as needed --->
  		<cfquery name="getPropertyInfo" dataSource="#settings.dsn#">
  			SELECT
  				strname as propertyname,
  				seopropertyname
  			from pp_propertyinfo 
  			where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getBookings.propertyid#">
  		</cfquery>
  		
  		<cfoutput>
  		<tr>
  			<td>#currentrow#.</td>
  			<td>#DateFormat(bookingDate,'mm/dd/yyyy')#</td>
  			<td>#getPropertyInfo.propertyname#</td>
  			<td>#DateFormat(strcheckin,'mm/dd/yyyy')# - #DateFormat(strcheckout,'mm/dd/yyyy')#</td>
  		</tr>
  		</cfoutput>
  	</cfloop>
  </table>
  <cfelse>
  	<p><b>No bookings were found for this email address.</b></p>
  </cfif>
	

</div>

<cfinclude template="../guest-focus/components/footer.cfm">