<cfset getAmenities = application.bookingObject.getPropertyAmenities(property.propertyid)>
<cfset floorLevelArray = [] />
<cfset variables.floorLevel =''/>
<cftry>
	<cfhttp method="get" url="https://svr.trackhs.com/api/pms/units/#property.propertyid#" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#">
		<cfhttpparam type="header" name="Accept" value="*/*">
	</cfhttp>

	<cfif isJSON(cfhttp.filecontent)>
		<!--- <cfdump var="#deserializeJSON(cfhttp.filecontent)#"> --->
		<cfset variables.deserializedJson = deserializeJSON(cfhttp.filecontent) />
		<cfif isDefined("variables.deserializedJson.custom.pms_units_floor_level")>
			<cfset variables.floorLevel = variables.deserializedJson.custom.pms_units_floor_level />
		</cfif>
	<cfelse>
		Something broke
	</cfif>

	<cfcatch>
		<cfdump var="#cfcatch#" abort="true" />
	</cfcatch>
</cftry>
<cfquery datasource="#settings.dsn#" name="getNodeId">
	select nodeId from track_properties where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
</cfquery>	



<cfquery datasource="#settings.dsn#" name="getUnitsize">
	select area from track_properties where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
</cfquery>

<cfquery datasource="#settings.dsn#" name="getBedtypes">
	select * from track_properties_bed_types where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
</cfquery>


<cfset temp = QueryAddRow(getamenities)>
<cfset temp = QuerySetCell(getamenities,"amenitygroupname","Unit Size")>
<cfset temp = QuerySetCell(getamenities,"amenityname","#getunitsize.area# sq. ft")>
<cfset temp = QuerySetCell(getamenities,"amenitytop","0")>
<cfoutput query="getBedtypes">
	<cfset temp = QueryAddRow(getamenities)>
	<cfset temp = QuerySetCell(getamenities,"amenitygroupname","Bed Types")>
	<cfset temp = QuerySetCell(getamenities,"amenityname","#bedTypeName#: #bedTypeCount#")>
	<cfset temp = QuerySetCell(getamenities,"amenitytop","0")>
</cfoutput>


<cfif getBedtypes.recordcount eq 0>

	<cfquery datasource="#settings.dsn#" name="getPropRooms">
		select bedTypeName,count from track_properties_rooms where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
	</cfquery>

	<cfif getPropRooms.recordcount gt 0>
		<cfset distinctRoomTypes = valueList(getPropRooms.bedTypeName)>
		<cfset distinctRoomTypes = ListRemoveDuplicates(distinctRoomTypes)>
		<cfoutput>
			<cfloop list="#distinctRoomTypes#" index="r">
				<cfquery dbtype="query" name="countBedTypes">
					select Count(bedTypeName) as thecnt from getPropRooms where bedTypeName = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#r#">
				</cfquery>
				<cfset temp = QueryAddRow(getamenities)>
				<cfset temp = QuerySetCell(getamenities,"amenitygroupname","Bed Types")>
				<cfset temp = QuerySetCell(getamenities,"amenityname","#r#: #countBedTypes.thecnt#")>
				<cfset temp = QuerySetCell(getamenities,"amenitytop","0")>
			</cfloop>
		</cfoutput>
	</cfif>

</cfif>


<cfoutput query="getAmenities">
	<cfif amenityTop NEQ 1>
	<cfif amenityGroupName EQ "Unit Size">
		<cfset temp = QuerySetCell(getamenities,"orderNum","1",currentRow)>
	<cfelseif amenityGroupName EQ "Bed Types">
		<cfset temp = QuerySetCell(getamenities,"orderNum","2",currentRow)>
	<cfelseif amenityGroupName EQ "Proximity">
		<cfset temp = QuerySetCell(getamenities,"orderNum","3",currentRow)>
	<cfelseif amenityGroupName EQ "View">
		<cfset temp = QuerySetCell(getamenities,"orderNum","4",currentRow)>
	<cfelseif amenityGroupName EQ "Property Features">
		<cfset temp = QuerySetCell(getamenities,"orderNum","5",currentRow)>
	<cfelseif amenityGroupName EQ "Kitchen Features">
		<cfset temp = QuerySetCell(getamenities,"orderNum","6",currentRow)>
	<cfelseif amenityGroupName EQ "Bathroom Features">
		<cfset temp = QuerySetCell(getamenities,"orderNum","7",currentRow)>
	<cfelseif amenityGroupName EQ "Resort/Community Amenities">
		<cfset temp = QuerySetCell(getamenities,"orderNum","8",currentRow)>
	<cfelseif amenityGroupName EQ "Activities Nearby">
		<cfset temp = QuerySetCell(getamenities,"orderNum","9",currentRow)>
	<cfelseif amenityGroupName EQ "Attractions Nearby">
		<cfset temp = QuerySetCell(getamenities,"orderNum","10",currentRow)>
	<cfelseif amenityGroupName EQ "Policies">
		<cfset temp = QuerySetCell(getamenities,"orderNum","11",currentRow)>
	</cfif>
	</cfif>
</cfoutput>

<cfquery dbtype="query" name="getAmenities">
	select * from getAmenities
	order by orderNum
</cfquery>


<cfset currentAmenityCat = ''>

<div id="amenities" name="amenities" class="info-wrap amenities-wrap less">
  <div class="info-wrap-heading"><i class="fa fa-list" aria-hidden="true"></i> Amenities</div>
	  <div class="info-wrap-body">
		<div style="margin-bottom:20px;">
            <span style="font-weight:700;">Don't forget to bring:</span><br>
            While Southern provides you an initial supply of toilet paper, paper towels, hand soap, and trash bags to get you through your first 24 hours, we recommend you bring the following: paper towels, toilet paper, trash bags, hairdryer, napkins, condiments, spices, dishwashing liquid, laundry soap, coffee and coffee filters, beach towels, umbrella, beach toys, sunscreen, and anything else you may need for your perfect vacation.
		</div>
    	<cfset theCategory = getAmenities.amenityGroupName>
 	    	<div class="amenity-row <cfif getAmenities.amenityTop EQ 1> amenityTopWrapper</cfif>">

          <!---<cfoutput><p class="amenity-category-p"><b>#theCategory#</b></p></cfoutput> --->
		      <ul class="amenity-category-ul">
			      <cfloop query="getAmenities">

				      	<cfif getAmenities.amenityGroupName eq theCategory OR (getAmenities.amenityTop EQ 1 )>
				      		<!--- don't show the category, we've already seen it --->
				      	<cfelse>
							  </ul>
							  
							   </div> <!--END amenity-row-->
							   
			 	      		<cfif currentAmenityCat EQ 'Proximity' and isDefined("variables.floorLevel") and isNumeric(variables.floorLevel)>
			 	      			<div class="amenity-row">
					  				<p>Floor Level</p>
					  				<ul class="amenity-category-ul-looped">
										<cfoutput><li class="amenity-floorlevel">#variables.floorLevel#</li></cfoutput>
									</ul>
			 	      			</div>
								<cfset currentAmenityCat = '' />
							</cfif>
							
				      		<cfset theCategory = getAmenities.amenityGroupName>
<!---
									<cfif theCategory contains "Resort">
										<div class="amenity-row">
									    <ul class="amenity-category-ul-looped">
									<cfelseif theCategory eq 'Property Features'>
									  <div class="amenity-row amenity-row-top">
									    <ul class="amenity-category-ul-looped">
									<cfelse>
--->
										<div class="amenity-row">
											
									  		<cfoutput><p>#theCategory#</p></cfoutput>
									    	<ul class="amenity-category-ul-looped">
<!--- 								  </cfif --->

				      	</cfif><!--- END getAmenities.amenityGroupName eq theCategory--->

								<cfoutput>
									
										<li class="amenity-#left(getAmenities.amenityName, 3)#<cfif getAmenities.amenityTop EQ 1> amenityTop</cfif>
											<cfif findNoCase('Pool - Community',getAmenities.amenityName)> pool-community</cfif>
											<cfif findNoCase('Pool - Private',getAmenities.amenityName)> pool-private</cfif>
											<cfif findNoCase('Parking Space',getAmenities.amenityName)> parking-space-car</cfif>
											">#getAmenities.amenityName#
										</li>
								</cfoutput>

						<cfset currentAmenityCat = getAmenities.amenityGroupName />

				      </cfloop><!---END getAmenities --->
				    </ul>
				</div><!--END amenity-row-->
		  </div><!-- END info-wrap-body -->
		</div><!-- END amenities-wrap -->

<!---
		<button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-amenities" type="button" style="background-color: transparent !important; color: #000 !important;">
		  <span>See More Amenities </span>
		  <i class="fa fa-chevron-right" aria-hidden="true"></i>
	  </button>
--->


		<!---
		<div class="read-more-wrap read-more-bottom-cover" data-height="120" style="height:120px;">
		  <cfoutput>#page.body#</cfoutput>
		</div>
		<button class="readMoreBtn btn site-color-1-bg site-color-1-lighten-bg-hover text-white">Read More</button>
		--->
<!---
		<cf_htmlfoot>
		<script type="text/javascript" defer>
		$(document).ready(function(){
		  /*$('.see-more-amenities').click(function(){*/
		    /*var readMoreWrap = $(this).prev('.amenities-wrap');
		    var readMoreWrapHeight = readMoreWrap.data('height');
		    var readMoreWrapFullHeight = readMoreWrap.prop('scrollHeight');
		    if ( $(readMoreWrap).height() === readMoreWrapHeight ) {
			    console.log('bingo');
		      readMoreWrap.css({'height':readMoreWrapFullHeight});
		      setTimeout(function(){
		        readMoreWrap.css({'height':'auto'});
		      }, 500);
		    } else {
			    console.log('bingo2');*/
		      //readMoreWrap.animate({'height':readMoreWrapHeight},500);
		      /*readMoreWrap.css({'height':readMoreWrapFullHeight});
		    }*/
		    //readMoreWrap.toggleClass('read-more-bottom-cover');
		    /*$('.see-more-amenities span').text($(this).text() == 'See More Amenities' ? 'See Less Amenities' : 'See Less Amenities');
		    console.log("readMoreWrap:"+readMoreWrap);
		    console.log('readMoreWrapHeight: '+readMoreWrapHeight);
		    console.log('readMoreWrapFullHeight: '+readMoreWrapFullHeight);*/


		  /*});*/

		    $('.see-more-amenities').toggle(function () {
			    $(".amenities-wrap").addClass("less");
			    $('.see-more-amenities span').text('See Less Amenities');
				}, function () {
					$(".amenities-wrap").removeClass("less");
					$('.see-more-amenities span').text('See More Amenities');
				});
				//$('.see-more-amenities span').text($(this).text() == 'See More Amenities' ? 'See Less Amenities' : 'See Less Amenities');

		});
		</script>
</cf_htmlfoot>
--->