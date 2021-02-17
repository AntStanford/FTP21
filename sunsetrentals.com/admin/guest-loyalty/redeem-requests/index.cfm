<cfset page.title ="Guest Loyalty Request to Redeem Points">

<cfquery name="getinfo" dataSource="#application.dsn#">
  select * from guest_loyalty_redemption_request order by createdAt
</cfquery>

<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.success')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<p>
	This page displays all the requests to redeem Guest Loyalty points.
</p>

<cfif getinfo.recordcount gt 0>
<div class="widget-box">
  <div class="widget-content nopadding">
    <table class="table table-bordered table-striped">
    <tr>
      <th>No.</th>
      <th>Date Requested</th>
      <th>Guest Name</th>         
      <th>Arrival Date</th>
      <th>Departure Date</th>  
      <th>Pet Friendly</th>
      <th>Number of Guests</th>
      <th>Reason</th>
    </tr>      
    <cfoutput query="getinfo">
      <tr>
        <td>#currentrow#.</td>
        <td>#DateFormat(createdat,'mm/dd/yyyy')#</td> 
        <td><a href="mailto:#guestEmail#">#GuestName#</a></td> 
        <td>#DateFormat(arrivaldate,'mm/dd/yyyy')#</td> 
        <td>#DateFormat(departuredate,'mm/dd/yyyy')#</td> 
        <td>#petfriendly#</td> 
        <td>#numberofguests#</td> 
        <td>#reason#</td>                   
      </tr>
    </cfoutput>
    </table>
  </div>
</div>
</cfif>

<cfinclude template="/admin/components/footer.cfm">