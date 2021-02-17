<cfoutput>
<div id="description" name="description" class="info-wrap description-wrap">
  <div class="info-wrap-heading"><i class="fa fa-align-left" aria-hidden="true"></i> Description</div>
	<div class="info-wrap-body">

		
			<cfset getAmenities = application.bookingObject.getPropertyAmenities(property.propertyid)>
			<cfif listFindNoCase(valueList(getAmenities.AMENITYNAME), 'Vayk Beach Gear')>
				<div class="well">
					<div class="row">
						<div class="col-md-2 col-sm-3 col-xs-4">
							<img alt="Beach Gear Included" width="100%" src="/rentals/images/vaykgear-logo-Light-Blue-2021.png" class="EquipmentIncluded lazy" style="max-width:115px;">
						</div>
						<div class="col-md-10 col-sm-9 col-xs-8">
							<p>Get a ($150, $250, $350) credit towards beach gear for 4+ night stays starting April 1st for 2021! Click here to learn more!</p>
							<a href="/hilton-head/area-info/sunsetrentalsbeachgear" target="_blank" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white">Click Here To Learn More!</a>
							
						</div>
					</div>
				</div>
			</cfif>
			<!--- <div class="well">
				<div class="row">
					<div class="col-md-2 col-sm-3 col-xs-4">
						<img alt="Beach Gear Included" width="100%" src="/rentals/images/vaykgear-logo-Light-Blue-2021.png" class="EquipmentIncluded lazy" style="max-width:115px;">
					</div>
					<div class="col-md-10 col-sm-9 col-xs-8">
						<p>Get a ($150, $250, $350) credit towards beach gear for 4+ night stays starting April 1st for 2021! Click here to learn more!</p>
						<a href="/hilton-head/area-info/sunsetrentalsbeachgear" target="_blank" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white">Click Here To Learn More!</a>
						
					</div>
				</div>
			</div> --->

		<div id="descBlock" class="desc-block">
				<cfset variables.cleanLongDesc = reReplace( property.description, '[\n\r]', '<br/>', 'all' ) />

				#variables.cleanLongDesc#

			<p></p>

			<cfquery name="getCustomData" dataSource="#settings.dsn#">
				select * from track_properties_custom_data
				where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
				order by customDataId
			</cfquery>

			<cfloop query="getCustomData">

				<cfif customDataId eq 22>
					<p><b>Parking Instructions:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 33>
					<p><b>Shuttle Information:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 34>
					<p><b>Distance to Shuttle:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 35>
					<p><b>Distance to Slopes:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 39>
					<p><b>Laundry Information:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 40>
					<p><b>BBQ Grill Information:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 58>
					<p><b>Sleeping Arrangements:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 61>
					<p><b>STR Summit County Permit ##:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 62>
					<p><b>STR County Permit Parking Max:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 64>
					<p><b>STR Max Occupancy:</b></p>
					<p>#data#</p>
				<cfelseif customDataId eq 72>
					<p><b>Floor of Building:</b></p>
					<p>#data#</p>
				</cfif>

			</cfloop>


  	</div>
  </div><!--- END info-wrap-body --->
</div><!-- END description-wrap -->
</cfoutput>

