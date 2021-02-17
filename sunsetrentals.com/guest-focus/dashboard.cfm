<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">


<!--- User has clicked the 'Unfavorite' button on a unit --->
<cfif isdefined('url.removeUnit') and len(url.removeUnit)>

	<!--- remove unit from guest_focus_favs table --->
	<cfquery dataSource="#settings.dsn#">
		delete from guest_focus_favs where propertyID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.removeUnit#">
		and userID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
	</cfquery>

	<!--- also remove unit from cookie.favorites, if it exists --->
	<cfif isdefined('cookie.favorites') and listlen(cookie.favorites) and ListFind(cookie.favorites,url.removeUnit) gt 0>

		<cfset unitIndex = ListFind(cookie.favorites,url.removeUnit)>
		<cfset cookie.favorites = ListDeleteAt(cookie.favorites,unitIndex)>

	</cfif>

</cfif>


<!---
This section looks for any new favorites that have been added since the last time they visited this page
and adds them to the table--->

<cfif isdefined('cookie.favorites') and listlen(cookie.favorites)>

	<cfloop list="#cookie.favorites#" index="i">

		<!--- check to see if the unit exists in the table --->
		<cfquery name="favCheck" dataSource="#settings.dsn#">
			select id from guest_focus_favs where propertyID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#i#">
			and userID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
		</cfquery>

		<cfif favCheck.recordcount eq 0>

			<!--- unit does not exist, add it --->
			<cfquery dataSource="#settings.dsn#">
				insert into guest_focus_favs(propertyID,userID)
				values(
					<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#i#">,
					<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
				)
			</cfquery>

		</cfif>

	</cfloop>

</cfif>


<!--- Check for any saved favorites --->
<cfquery name="getFavs" dataSource="#settings.dsn#">
	select propertyid from guest_focus_favs where userid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
</cfquery>


<div class="content-wrap">

  <div class="page-header">
    <h1>Guest Focus <small>Dashboard</small></h1>
  </div>

  <cfif isdefined('url.success')>
	  <div class="alert alert-success">
	  	<button type="button" class="close" data-dismiss="alert" aria-label="Close">
	   	<span aria-hidden="true">&times;</span>
	  	</button>
	  	<p>Success! Your email has been sent.</p>
	  </div>
  </cfif>

  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">View and Compare Favorites (<cfoutput>#getFavs.recordcount#</cfoutput>)</h3>
    </div>
    <div class="panel-body">

      <div class="row">
        <cfloop query="getFavs">

        <cfif settings.booking.pms eq 'Escapia'>

        		<!--- Get unit info based on propertyid --->
	        <cfquery name="getUnitInfo" dataSource="#settings.booking.dsn#">
		        	select
		        	seopropertyname,
		        	bedrooms,
		        	bathrooms,
		        	unitshortname as name,
		        	maxoccupancy as sleeps,
		        	unitcategory as `type`,
		        	concat("#variables.settings.booking.imagePath#/",mapPhoto) as photo,
		        	(select min(minRent*7) from escapia_rates where unitcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavs.propertyid#"> and startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY")#-01-01"> and ratetype = 'Weekly') as minRent,
		         (select max(maxRent*7) from escapia_rates where unitcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavs.propertyid#"> and startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY")#-01-01"> and ratetype = 'Weekly') as maxRent
					from escapia_properties
		        	where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getFavs.propertyid#">
	        </cfquery>

        <cfelseif settings.booking.pms eq 'Homeaway'>

        	  <!--- Get unit info based on propertyid --->
	        <cfquery name="getUnitInfo" dataSource="#settings.booking.dsn#">
		        	select
		        	seopropertyname,
		        	dblbeds as bedrooms,
		        	dblbaths as bathrooms,
		        	strName as name,
		        	intOccu as sleeps,
		        	strType as `type`,
		        	defaultPhoto as photo,
		        	(select min(dblRate) from pp_season_rates where strpropid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavs.propertyid#"> and dtBeginDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY")#-01-01"> and strChargeBasis = 'Weekly') as minRent,
		         (select max(dblRate) from pp_season_rates where strpropid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getFavs.propertyid#"> and dtBeginDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"YYYY")#-01-01"> and strChargeBasis = 'Weekly') as maxRent
					from pp_propertyinfo
		        	where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getFavs.propertyid#">
	        </cfquery>

        <cfelseif settings.booking.pms eq 'Barefoot'>

        		<!--- Get unit info based on propertyid --->
	        <cfquery name="getUnitInfo" dataSource="#settings.booking.dsn#">
		        	select
		        	seopropertyname,
		        	bedrooms,
		        	bathrooms,
		        	name,
		        	maxoccupancy as sleeps,
		        	unitType as `type`,
		        	imagePath as photo,
		        	minPrice as minRent,
		         maxPrice as maxRent
					from bf_properties
		        	where propertyID = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#getFavs.propertyid#">
	        </cfquery>

        </cfif>


        <cfoutput query="getUnitInfo">
        <div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
          <div class="thumbnail">
          	<div class="compare-details">
          		<div class="compare-pic">
          			<a href="/#settings.booking.dir#/#seopropertyname#" target="_blank"><img src="#photo#" width="100%"></a>
          		</div>
          		<div class="btn-group btn-group-justified">
          			<a target="_blank" href="/#settings.booking.dir#/#seopropertyname#" class="btn btn-primary" style="border-radius:0;"> Details</a>
          			<a href="dashboard.cfm?removeUnit=#getFavs.propertyid#" class="btn btn-danger" style="border-radius:0;">Unfavorite</a>
          		</div>
          		<table class="table table-bordered table-striped" style="margin:0;">
          			<tr><td><b>#name#</b></td></tr>
          			<tr><td><b>Bedrooms:</b> #bedrooms#</td></tr>
          			<tr><td><b>Bathrooms:</b> #bathrooms#</td></tr>
          			<tr><td><b>Sleeps:</b> #sleeps#</td></tr>
          			<tr><td><b>Type:</b> #type#</td></tr>
          			<tr><td><b>Weekly Rate:</b> <cfif IsNumeric(minRent) AND IsNumeric(maxRent)>#DollarFormat(minRent)# - #DollarFormat(maxRent)#<cfelse>#minRent# - #maxRent#</cfif> <small>Per Week</small></td></tr>
          		</table>
          	</div>
          </div>
        </div>
        </cfoutput>
        </cfloop>
    </div>
  </div>

  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">Send to Friend</h3>
    </div>
    <div class="panel-body">

			<style>label.error{color:red}</style>
			<div id="sendToFriendCompareMSG"></div>
			<form role="form" method="post" id="sendFavsToFriend" action="submit.cfm">
			   <input type="hidden" name="action" value="sendFavsToFriend">
				<p>Fill out the form below to send these properties to a friend.</p>
				<div class="form-group">
					<label>Your Email</label>
					<input type="text" name="youremail" class="form-control required email">
				</div>
				<div class="form-group">
					<label>Friend's Email</label>
					<input type="text" name="friendsemail" class="form-control required email">
				</div>
				<input type="submit" name="submit" class="btn btn-primary" value="Submit">
			</form>

    </div>
  </div>

</div>

<cfinclude template="../guest-focus/components/footer.cfm">