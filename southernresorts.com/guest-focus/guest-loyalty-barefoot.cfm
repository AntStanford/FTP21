<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">


<!--- Get info about logged in user --->
<cfquery datasource="#settings.dsn#" NAME="GetLogin">
  	SELECT *
  	FROM guest_focus_users 
  	where id = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInID#">
</cfquery>

<!--- Get all the reservations this user has made	 --->
<cfquery name="getBookings" dataSource="#settings.dsn#">
	select 
		folioNumber as resNumber,
		propertyid,
		arriveDate as strcheckin,
		departDate as strcheckout 
	from guestweb_bookings 
	where tentantEmail = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInEmail#">
	order by arriveDate desc
</cfquery>

<!--- Get the point value for one night --->
<cfquery name="getPointValue" dataSource="#settings.dsn#">
	select * from guest_loyalty_point_value where id = 1
</cfquery>

<!--- Get all the manually added points for this guest --->
<cfquery name="getManuallyAddedPoints" dataSource="#settings.dsn#">
	select * from guest_loyalty_manual_points 
	where Email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInEmail#">
	order by createdat desc
</cfquery>

<!--- How many points are needed for a free night --->
<cfquery name="getPointsNeededForFreeNight" dataSource="#settings.dsn#">
	select points from guest_loyalty_point_levels where title = 'Free Night Stay'
</cfquery>
  

<div class="content-wrap">

  <div class="page-header">
    <h1>Guest Loyalty <small>Dashboard</small></h1>
  </div>
	
  <div class="guest-loyalty">
	 
	 <cfif isdefined('url.success')>
		 <div class="alert alert-warning">
		 	<button type="button" class="close" data-dismiss="alert" aria-label="Close">
    			<span aria-hidden="true">&times;</span>
  			</button>
		 	<p>Success! Your request to redeem points has been submitted.</p>
		 </div>
	 </cfif>
	 
	 <!--- Calculate their total points for the section at the top of the dashboard --->
	 <cfset totalPointsEarnedTop = "0">
	 
	 <!--- Loop through bookings from API --->
	 <cfloop query="getBookings">
	 	<cfset numNights = Datediff('d',strcheckin,strcheckout)>
	 	<cfset NumPoints = numNights * getPointValue.pointvalue>
	 	<cfset totalPointsEarnedTop = totalPointsEarnedTop + NumPoints>
	 </cfloop>
	 
	 <!--- Loop through manually added points --->
	 <cfloop query="getManuallyAddedPoints">
	 	<cfset totalPointsEarnedTop = totalPointsEarnedTop + pointsToAdd>
	 </cfloop>
	 
    <div class="alert alert-success" style="margin-bottom:5px;">
      <span class="points-title">
        Total Rewards Points Earned
        <span class="points-earned"><cfoutput>#totalPointsEarnedTop#</cfoutput></span>
      </span>
      
      <!--- Calculate points needed for a free night stay --->
      <cfset pointsNeededToGetFreeNight = getPointsNeededForFreeNight.points - totalPointsEarnedTop>
      
      <p class="points-description">You're <b><cfoutput>#pointsNeededToGetFreeNight#</cfoutput></b> points away from your next <b>free</b> stay</p>
      <p class="text-center"><a href="javascript:;" id="redeemPointsNowBtn" class="btn btn-success">Redeem Points Now</a></p>
    </div>
    <div class="text-center">
      <p><small>*Points are added the day after your departure.</small></p>
    </div>

    <div class="well earn-and-redeem">
      <div class="row">
        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 text-right">
          <h3>EARN</h3>
          <p>Earn <cfoutput>#getPointValue.pointvalue#</cfoutput> points for every night you stay. Earn Bonus Points for referring friends and family.</p>
        </div>
        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12">
          <div class="points-trophy">
            <i class="fa fa-trophy"></i>
          </div>
        </div>
        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
          <h3>REDEEM</h3>
          <p>Redeem your points for FREE stays, Swag, and More. The more you earn, the better the bonus!</p>
        </div>
      </div>
    </div>

    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Earned Points</h3>
      </div>
      <div class="panel-body">
        <table class="table table-condensed table-hover">
          <tr>
            <th class="row-1 text-center">No.</th>
            <th class="row-2">Reservation #</th>
            <th class="row-3">Property Name</th>
            <th class="row-4">Email</th>
            <th class="row-5 text-center">Arrival</th>
            <th class="row-6 text-center">Departure</th>
            <th class="row-7 text-center"># Nights</th>
            <th class="row-8 text-center">Points</th>
          </tr>
          
			 <cfset totalPointsEarned = "0">
          <cfloop query="getBookings">          
          	
			  <cfquery name="getPropertyInfo" dataSource="#settings.dsn#">
			  		select 
			  			name,
			  			seoPropertyName,
			  			propertyid 
			  		from bf_properties 
			  		where propertyid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#getBookings.propertyid#">
			  </cfquery>
          	
          	<cfoutput>
	          <tr>
	            <td class="text-center">#currentrow#.</td>
	            <td>#resNumber#</td>
	            <td><a href="/#settings.booking.dir#/#getPropertyInfo.seopropertyname#/#getPropertyInfo.propertyid#" target="_blank">#getPropertyInfo.name#</a></td>
	            <td>#cookie.GuestFocusLoggedInEmail#</td>
	            <td class="text-center">#DateFormat(strcheckin,'mm/dd/yyyy')#</td>
	            <td class="text-center">#DateFormat(strcheckout,'mm/dd/yyyy')#</td>
	            <cfset numNights = Datediff('d',strcheckin,strcheckout)>
	            <td class="text-center">#numNights#</td>
	            <cfset NumPoints = numNights * getPointValue.pointvalue>
	            <td class="text-center">#NumPoints#</td>
	            <cfset totalPointsEarned = totalPointsEarned + numPoints>
	          </tr>
	         </cfoutput>
          </cfloop>          
          <tr class="info">
            <td colspan="7" class="text-right"><b>Point Total:</b></td>
            <td class="text-center"><b><cfoutput>#totalPointsEarned#</cfoutput></b></td>
          </tr>
        </table>
      </div>
    </div>

    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Manually Entered Points</h3>
      </div>
      <div class="panel-body">
        <table class="table table-condensed table-hover">
          <tr>
            <th class="row-1 text-center">No.</th>
            <th class="row-2">Reason</th>
            <th class="row-3">Email</th>
            <th class="row-4"></th>
            <th class="row-5"></th>
            <th class="row-6"></th>
            <th class="row-7 text-center">Entered On</th>
            <th class="row-8 text-center">Points</th>
          </tr>
          <cfset totalManualPoints = "0">
          <cfloop query="getManuallyAddedPoints">
          <cfoutput>
	          <tr>
	            <td class="text-center">#currentrow#.</td>
	            <td>#label#</td>
	            <td colspan="4">#cookie.GuestFocusLoggedInEmail#</td>
	            <td class="text-center">#DateFormat(createdat,'mm/dd/yyyy')#</td>
	            <td class="text-center">#PointsToAdd#</td>
	            <cfset totalManualPoints = totalManualPoints + pointsToAdd>
	          </tr>
	       </cfoutput>
          </cfloop>          
          <tr class="info">
            <td colspan="7" class="text-right"><b>Point Total:</b></td>
            <td class="text-center"><b><cfoutput>#totalManualPoints#</cfoutput></b></td>
          </tr>
        </table>
      </div>
    </div>
	 
	<cfquery name="getRedeemedPoints" dataSource="#settings.dsn#">
		select * from guest_loyalty_redeem_points 
		where Email = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#cookie.GuestFocusLoggedInEmail#">
		order by createdat desc
	</cfquery>
  
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Redeemed Points</h3>
      </div>
      <div class="panel-body">
        <table class="table table-condensed table-hover">
          <tr>
            <th class="row-1 text-center">No.</th>
            <th class="row-2">Email</th>
            <th class="row-3"></th>
            <th class="row-4"></th>
            <th class="row-5"></th>
            <th class="row-6"></th>
            <th class="row-7 text-center">Entered On</th>
            <th class="row-8 text-center">Redeemed</th>
          </tr>
          <cfset totalRedeemedPoints = 0>
          <cfloop query="getRedeemedPoints">
          <cfoutput>
          <tr>
            <td class="text-center">#currentrow#.</td>
            <td colspan="5">#email#</td>
            <td class="text-center">#DateFormat(createdat,'mm/dd/yyyy')#</td>
            <td class="text-center">#pointsRedeemed#</td>
          </tr>
          </cfoutput>
          <cfset totalRedeemedPoints = totalRedeemedPoints + pointsRedeemed>
          </cfloop>
          <tr class="info">
            <td colspan="7" class="text-right"><strong>Total Redeemed Points:</strong></td>
            <td class="text-center"><strong><cfoutput>#totalRedeemedPoints#</cfoutput></strong></td>
          </tr>
        </table>
      </div>
    </div>
	 
	 <cfquery name="getPointLevels" dataSource="#settings.dsn#">
		select * from guest_loyalty_point_levels order by points
	 </cfquery>
	
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Points Key</h3>
      </div>
      <div class="panel-body">
        <table class="table table-condensed table-hover">
          <tr>
            <th class="row-3">Title</th>
            <th class="row-1"></th>
            <th class="row-2"></th>
            <th class="row-4"></th>
            <th class="row-5"></th>
            <th class="row-6"></th>
            <th class="row-7"></th>
            <th class="row-8 text-center"># Points</th>
            <th class="row-2">You need</th>
          </tr>
          <cfloop query="getPointLevels">
          <cfoutput>
	          <tr>
	            <td colspan="7">#title#</td>
	            <td class="text-center">#points#</td>
	            <cfset pointsNeededForThisGoodie = points - totalPointsEarnedTop>
	            <cfif pointsNeededForThisGoodie lt 0>
	            	<td class="text-center">0 more</td>
	            <cfelse>
	            	<td class="text-center">#pointsNeededForThisGoodie# more</td>
	            </cfif>	            
	          </tr>
          </cfoutput>
          </cfloop>          
        </table>
      </div>
    </div>

    <div class="panel panel-default" id="requestToRedeemPointsWrap">
      <div class="panel-heading">
        <h3 class="panel-title">Request to Redeem Points</h3>
      </div>
      <div class="panel-body">
        <form class="form-horizontal" id="requestToRedeemPointsForm" method="post" action="submit.cfm" novalidate="novalidate">          
          <input type="hidden" name="action" value="requestToRedeemPoints">
          <fieldset>
            <div class="row">
              <div class="col-lg-6 col-md-12 col-sm-12 col-xs-12">
                <div class="row">
                  <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <label class="control-label" for="input01">Arrival Date *</label>
                    <div class="controls">
                      <input type="text" placeholder="Arrival Date" class="form-control required ArrivalDate datepicker" name="ArrivalDate" required="" id="" aria-required="true">
                    </div>
                  </div>
                  <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <label class="control-label" for="input01">Departure Date *</label>
                    <div class="controls">
                      <input type="text" placeholder="Departure Date" class="form-control required DepartureDate datepicker" name="DepartureDate" required="" id="" aria-required="true">
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-lg-6 col-md-12 col-sm-12 col-xs-12">
                <div class="row">
                  <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
                    <label class="control-label" for="input01">Pet Friendly *</label>
                    <div class="controls">
                      <select name="PetFriendly" class="form-control">
                        <option value="No" selected="">No</option>
                        <option value="Yes">Yes</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-lg-5 col-md-5 col-sm-6 col-xs-12">
                    <label class="control-label" for="input01"># of Guest In Party *</label>
                    <div class="controls">
                      <select name="NumberOfGuests" class="form-control">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="11">11</option>
                        <option value="12">12</option>
                        <option value="13">13</option>
                        <option value="14">14</option>
                        <option value="15">15</option>
                        <option value="16">16</option>
                        <option value="17">17</option>
                        <option value="18">18</option>
                        <option value="19">19</option>
                        <option value="20">20</option>
                        <option value="21">21</option>
                        <option value="22">22</option>
                        <option value="23">23</option>
                        <option value="24">24</option>
                      </select>
                    </div>
                  </div>
                  <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
                    <label class="visible-lg visible-md">&nbsp;</label>
                    <div class="controls">
                      <button class="btn btn-block btn-primary" name="GuestRedeemStay">Submit</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </fieldset>
        </form>
      </div>
    </div>

  </div>

</div>

<cf_htmlfoot>
<script type="text/javascript">
$(document).ready(function(){
  $('#redeemPointsNowBtn').click(function(){
    $('html, body').animate({
      scrollTop: $("#requestToRedeemPointsWrap").offset().top
    }, 2000);
  });
});
</script>
</cf_htmlfoot>

<cfinclude template="../guest-focus/components/footer.cfm">