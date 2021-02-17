<cfset page.title ="Guest Loyalty Members - View Points">
<cfinclude template="/admin/components/header.cfm">

<style>
.text-center { text-align: center !important; }
</style>

<cfif isdefined('url.successAddingPoints')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Points Added!</strong>
  </div>
</cfif>

<cfif isdefined('url.delete')>
  <cfquery name="delete" dataSource="#application.dsn#">
    delete from guest_loyalty_manual_points where id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
  </cfquery>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<cfif isdefined('url.deleteRedeemedPoints')>
  <cfquery name="delete" dataSource="#application.dsn#">
    delete from guest_loyalty_redeem_points where id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
  </cfquery>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record deleted!</strong>
  </div>
</cfif>

<cfif isdefined('url.successRedeemingPoints')>
  <div class="alert alert-success">
    <button class="close" data-dismiss="alert">×</button>
    <strong>Record entered!</strong>
  </div>
</cfif>

<!--- Homeway client --->
<cfquery name="getUserBookings" dataSource="#settings.dsn#">
  select * from pp_guestreservationinfo where strEmail = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.email#">
  order by dtCheckInDate desc
</cfquery>

<!---
Escapia client - use this for Escapia clients
<cfquery name="getUserBookings" dataSource="#settings.dsn#">
  select * from guestweb_bookings 
  where TenantEmail = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.email#">
  order by arrivalDate desc
</cfquery> ---->

<!---
Barefoot client - use this for Barefoot clients
<cfquery name="getUserBookings" dataSource="#settings.dsn#">
  select * from guestweb_bookings 
  where TenantEmail = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.email#">
  order by arriveDate desc
</cfquery> --->

 

<cfquery name="getManuallyAddedPoints" dataSource="#application.dsn#">
  select * from guest_loyalty_manual_points where Email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.email#" >
  order by createdat desc
</cfquery>

<cfquery name="getPointsRedeemed" dataSource="#application.dsn#">
  select * from guest_loyalty_redeem_points where Email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#url.email#" >
  order by createdat desc
</cfquery>

<cfquery name="getPointValue" dataSource="#application.dsn#">
  select * from guest_loyalty_point_value where id = 1
</cfquery>

<cfoutput>
  <p>
    <a href="index.cfm" class="btn btn-default">
      <i class="icon-chevron-left"></i> Back To Members
    </a>
    <a href="add-points.cfm?email=#url.email#" class="btn btn-success">
      <i class="icon-plus icon-white"></i> Add Points
    </a>
    <a href="redeem-points.cfm?email=#url.email#" class="btn btn-primary">
      <i class="icon-arrow-down icon-white"></i> Redeem Points
    </a>
  </p>
</cfoutput>

<div class="alert alert-info">
	<p><b>*You are currently viewing points for <cfoutput>#url.email#</cfoutput></b></p>
	<p><b>** Reports are based on <cfoutput>#getPointValue.pointValue#</cfoutput> points per night</b></p>
</div>

<h3 style="margin-top:15px;">Earned Points from Bookings</h3>
<div class="widget-box" style="margin-top:0;">
  <div class="widget-content nopadding">
    <cfif getUserBookings.recordcount gt 0>
      <table class="table table-bordered">
        <tr>
          <th width="5">No.</th>
          <th>Reservation #</th>
          <th>Property Name</th>
          <th>Arrival</th>
          <th>Departure</th>
          <th># Nights</th>
          <th>Points</th>
        </tr>
        <cfset PointTotal = "0">
        <cfoutput query="getUserBookings">
        	 
        	 <!--- Homeaway client --->
        	 <cfquery name="getPropertyInfo" dataSource="#settings.dsn#">
  				select strName as name 
  				from pp_propertyinfo 
  				where strPropID = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#getUserBookings.strPropID#">
			 </cfquery>
			 
			 <!---
			 Escapia client
			 <cfquery name="getPropertyInfo" dataSource="#settings.dsn#">
  				select unitshortname as name 
  				from escapia_properties 
  				where unitcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#getUserBookings.strPropID#">
			 </cfquery>--->
			 
			 <!---
			 Barefoot client
			 <cfquery name="getPropertyInfo" dataSource="#settings.dsn#">
  				select name 
  				from bf_properties 
  				where propertyid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#getUserBookings.strPropID#">
			 </cfquery>--->
			 
          <tr>
            <td>#currentrow#.</td>
            <td>#intQuotenum#</td>
            <td>#getPropertyInfo.name#</td>            
            <td class="text-center">#DateFormat(dtCheckInDate,'mm/dd/yyyy')#</td>
            <td class="text-center">#DateFormat(dtCheckOutDate,'mm/dd/yyyy')#</td>
            <cfset NumDays = #datediff('d',dtCheckInDate,dtCheckOutDate)#>
            <td class="text-center">#NumDays#</td>
            <cfset NumPoints = #NumDays# * #getPointValue.pointvalue#>
            <td class="text-center">#NumPoints#</td>
          </tr>
          <cfset PointTotal = PointTotal + NumPoints>
        </cfoutput>
        <cfoutput>
          <tr>
            <td colspan="6" style="text-align:right;"><strong>Point Total</strong></td>
            <td class="text-center"><strong>#PointTotal#</strong></td>
          </tr>
        </cfoutput>
      </table>
    <cfelse>
      <cfset PointTotal = 0>
    </cfif>
  </div>
</div>

<h3 style="margin-top:15px;">Manually Entered Points</h3>
<div class="widget-box" style="margin-top:0;">
  <div class="widget-content nopadding">
    <cfif getManuallyAddedPoints.recordcount gt 0>
      <table class="table table-bordered">
        <tr>
          <th width="5">No.</th>
          <th>Reason</th>          
          <th>Entered On</th>
          <th>Points</th>
          <th></th>
        </tr>
        <cfset ManualAddedPointTotal = "0">
        <cfoutput query="getManuallyAddedPoints">
          <tr>
            <td>#currentrow#.</td>
            <td>#label#</td>            
            <td class="text-center">#DateFormat(createdat,'mm/dd/yyyy')#</td>
            <td class="text-center">#PointsToAdd#</td>
            <td width="65" class="text-center"><a href="view-points.cfm?id=#id#&email=#email#&delete"  data-confirm="Are you sure you want to delete this entry?" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete</a></td>
          </tr>
          <cfset ManualAddedPointTotal = ManualAddedPointTotal + PointsToAdd>
        </cfoutput>
        <cfoutput>
          <tr>
            <td colspan="3" style="text-align:right;"><strong>Point Total</strong></td>
            <td class="text-center"><strong>#ManualAddedPointTotal#</strong></td>
            <td></td>
          </tr>
        </cfoutput>
      </table>
    <cfelse>
      <cfset ManualAddedPointTotal = 0>
    </cfif>
  </div>
</div>

<cfset TotalPointsAvailable = #ManualAddedPointTotal# + #PointTotal#>
<cfoutput>
  <div class="alert alert-success text-center">
    Total All Time Points Earned: <b>#TotalPointsAvailable#</b>
  </div>
</cfoutput>

<h3 style="margin-top:15px;">Redeemed Points</h3>
<div class="widget-box" style="margin-top:0;">
  <div class="widget-content nopadding">
    <cfif getPointsRedeemed.recordcount gt 0>
      <table class="table table-bordered">
        <tr>
          <th width="5">No.</th>
          <th>Reason</th>
          <th>Entered On</th>
          <th>Redeemed</th>
          <th></th>
        </tr>
        <cfset GetPointsRedeemedTotal = "0">
        <cfoutput query="getPointsRedeemed">
          <tr>
            <td>#currentrow#.</td>
            <td>#reason#</td>
            <td>#DateFormat(createdat,'mm/dd/yyyy')#</td>
            <td class="text-center">#pointsRedeemed#</td>
            <td width="65" class="text-center"><a href="view-points.cfm?id=#id#&email=#email#&deleteRedeemedPoints"  data-confirm="Are you sure you want to delete this entry?" class="btn btn-mini btn-danger"><i class="icon-remove icon-white"></i> Delete</a></td>
          </tr>
          <cfset GetPointsRedeemedTotal = #GetPointsRedeemedTotal# + #pointsRedeemed#>
        </cfoutput>
        <cfoutput>
          <tr>
            <td colspan="3" style="text-align:right;"><strong>Total Redeemed Points</strong></td>
            <td class="text-center"><strong>#GetPointsRedeemedTotal#</strong></td>
            <td></td>
          </tr>
        </cfoutput>
      </table>
    <cfelse>
      <cfset GetPointsRedeemedTotal = 0>
    </cfif>
  </div>
</div>

<cfset PointsAvailableForRedemption = #TotalPointsAvailable# - #GetPointsRedeemedTotal#>
<cfoutput>
  <div class="alert alert-warning text-center">
   Points Available For Redemption: <b>#PointsAvailableForRedemption#</b>
  </div>
</cfoutput>

<cfinclude template="/admin/components/footer.cfm">