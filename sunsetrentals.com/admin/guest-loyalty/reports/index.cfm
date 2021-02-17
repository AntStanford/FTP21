<cfset page.title ="Guest Loyalty Reporting">
<cfinclude template="/admin/components/header.cfm">

<cfset session.userList = ''>

<cfif isdefined('form.submit')>

	<cfquery name="getUsers" dataSource="#settings.dsn#">
		select * from guest_focus_users

		where 1=1

		<cfif isdefined('form.points_greater_than') and isValid('numeric',form.points_greater_than) and form.points_greater_than gt 0>
			and totalPointsAvailable > <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points_greater_than#">
		</cfif>

		<cfif isdefined('form.points_less_than') and isValid('numeric',form.points_less_than) and form.points_less_than gt 0>
			and totalPointsAvailable < <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points_less_than#">
		</cfif>

		<cfif
			isdefined('form.points_between_start') and isValid('numeric',form.points_between_start) and form.points_between_start gt 0
			and
			isdefined('form.points_between_end') and isValid('numeric',form.points_between_end) and form.points_between_end gt 0>

			and totalPointsAvailable between <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points_between_start#"> and <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#form.points_between_end#">

		</cfif>

		<!--- modify the code below per PMS, demo site uses Homeaway --->
		<cfif isdefined('form.date_of_last_reservation') and len(form.date_of_last_reservation)>
			and email IN (select stremail from pp_guestreservationinfo where dtCheckoutDate like <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(form.date_of_last_reservation,"yyyy-mm-dd")#%">)
		</cfif>

		order by firstname

	</cfquery>

<cfelse>

	<cfquery name="getUsers" dataSource="#application.dsn#">
		select * from guest_focus_users order by firstname
	</cfquery>

</cfif>


<cfset session.userList = ValueList(getUsers.email)>

<cfquery name="getPointsPerNight" dataSource="#settings.dsn#">
	select pointvalue from guest_loyalty_point_value where id = 1
</cfquery>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong>
    </div>
  </cfif>

  <p>* Reporting is based on total points earned from confirmed bookings + manual points added via the CMS.</p>
  <p>** This reporting is based on <b><cfoutput>#getPointsPerNight.pointvalue#</cfoutput> points per night.</b></p>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Search Form</h5>
    </div>
    <div class="widget-content nopadding">

  		<cfoutput>
      <form action="index.cfm" method="post" class="form-horizontal">
			<div class="control-group">
				<label class="control-label">Points are greater than</label>
				<div class="controls">
					<input maxlength="255" name="points_greater_than" type="text" <cfif isdefined('form.points_greater_than')>value="#form.points_greater_than#"</cfif>>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Points are less than</label>
				<div class="controls">
					<input maxlength="255" name="points_less_than" type="text" <cfif isdefined('form.points_less_than')>value="#form.points_less_than#"</cfif>>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Points are between</label>
				<div class="controls">
					<input maxlength="255" name="points_between_start" type="text" <cfif isdefined('form.points_between_start')>value="#form.points_between_start#"</cfif>>
					<br />and<br />
					<input maxlength="255" name="points_between_end" type="text" <cfif isdefined('form.points_between_end')>value="#form.points_between_end#"</cfif>>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Date of last reservation</label>
				<div class="controls">
					<input maxlength="255" name="date_of_last_reservation" type="text" class="datepicker" <cfif isdefined('form.date_of_last_reservation')>value="#form.date_of_last_reservation#"</cfif>>
				</div>
			</div>
			<div class="form-actions">
				<input type="submit" value="Submit" class="btn btn-primary" name="submit">
			</div>
  		</form>
  		</cfoutput>

    </div>
  </div>

  <a href="export.cfm" class="btn btn-primary pull-right"><i class="icon-file icon-white"></i> Export Search Results</a><br />

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Search Results</h5>
    </div>
    <div class="widget-content nopadding">

	    <table class="table table-bordered table-striped">
	    <tr>
	      <th>No.</th>
	      <th>Name</th>
	      <th>Email</th>
	      <th>Points Earned from Bookings</th>
	      <th>Manual Points</th>
	      <th>Redeemed Points to Date</th>
	      <th>Total Points Available</th>
	    </tr>
	    <cfif getUsers.recordcount gt 0>
	    <cfloop query="getUsers">

	      <cfset totalNightsBooked = 0>
	      <cfset manualPoints = 0>
	      <cfset redeemedPoints = 0>

	    	<!--- All points earned --->
	    	<cfquery name="getBookings" dataSource="#settings.dsn#">
	    		select dtCheckinDate,dtCheckoutDate
	    		from pp_guestreservationinfo
	    		where strEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	    		and dtCheckoutDate < now()
	    		and strStatus = 'B'
	    	</cfquery>

	    	<!---
	    	For Escapia customers:
	    	<cfquery name="getBookings" dataSource="#settings.dsn#">
	    		select
	    			arrivalDate as dtCheckinDate,
	    			departureDate as dtCheckoutDate
	    		from guestweb_bookings
	    		where tentantEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	    		and departureDate < now()
	    		and status = 'checked out'
	    		and isCancelled = 0
	    	</cfquery>
	    	--->

	    	<!---
	    	For Barefoot customers:
	    	<cfquery name="getBookings" dataSource="#settings.dsn#">
	    		select
	    			arriveDate as dtCheckinDate,
	    			departDate as dtCheckoutDate
	    		from guestweb_bookings
	    		where tentantEmail = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	    		and departDate < now()
	    	</cfquery> --->

	    	<cfloop query="getBookings">

	    		<cfset numNights = DateDiff('d',dtCheckinDate,dtCheckoutDate)>

	    		<cfset totalNightsBooked = totalNightsBooked + numNights>

	    	</cfloop>

	    	<cfset totalPointsEarnedFromBookings = totalNightsBooked * getPointsPerNight.pointvalue>

	    	<!--- Also need to get manual points and add to the total --->
	    	<cfquery name="getManualPoints" dataSource="#settings.dsn#">
	    		select pointsToAdd from guest_loyalty_manual_points where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	    	</cfquery>

	    	<cfif getManualPoints.recordcount gt 0 and getManualPoints.pointsToAdd gt 0>
	    		<cfset manualPoints = getManualPoints.pointsToAdd>
	    		<cfset totalPointsEarned = getManualPoints.pointsToAdd>
	    	</cfif>

	    	<!--- Check for any redeemed points --->
	    	<cfquery name="getRedeemedPoints" dataSource="#settings.dsn#">
	    		select pointsRedeemed from guest_loyalty_redeem_points where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	    	</cfquery>

	    	<cfif getRedeemedPoints.recordcount gt 0 and getRedeemedPoints.pointsRedeemed gt 0>
	    		<cfset redeemedPoints = getRedeemedPoints.pointsRedeemed>
	    	</cfif>

	      <tr>
	        <td>#currentrow#.</td>
	        <td>#firstname# #lastname#</td>
	        <td>#email#</td>
	        <td>#totalPointsEarnedFromBookings#</td>
	        <td>#manualPoints#</td>
	        <td>#redeemedPoints#</td>
	        <cfset totalPoints = totalPointsEarnedFromBookings + manualPoints - redeemedPoints>
	        <td>#totalPoints#</td>
	      </tr>

	      <cfquery dataSource="#settings.dsn#">
	      	update guest_focus_users set totalPointsAvailable = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#totalPoints#">
	      	where email = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getUsers.email#">
	      </cfquery>

	    </cfloop>
	    <cfelse>
	    	<tr>
	    		<td colspan="7">No users found. <cfif isdefined('form.submit')><a href="index.cfm">Reset the search</a></cfif></td>
	    	</tr>
	    </cfif>
	    </table>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

