<cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)>
<!--- <cfdump var="#session.booking.resort#"> --->
     <!---  <cfdump var="#session.booking.resort.getResultsPre#">

           <cfdump var="#session.booking.resort.getResults#">--->

<!--- <cfoutput query="session.booking.resort.getResultsPre">
 #currentrow# - #name#<br>
</cfoutput>
<br><br>
<cfoutput query="session.booking.resort.getResultsPre" group="resortname">
 #currentrow# - #name#<br>
</cfoutput> --->
<!---   <cfoutput>

    <cfquery dbtype="query" name="cntHomesPre">
    Select name,type,typename
    From session.booking.resort.getResultsPre
    Where type = 'Home'
    </cfquery>

    <cfquery dbtype="query" name="cntHomes">
    Select name,type,typename
    From session.booking.resort.getResults
    Where type = 'Home'
    </cfquery>

    <cfquery dbtype="query" name="cntCondosPre">
    Select name,type,typename
    From session.booking.resort.getResultsPre
    Where type = 'Condo'
    </cfquery>

    <cfquery dbtype="query" name="cntCondos">
    Select name,type,typename
    From session.booking.resort.getResults
    Where type = 'Condo'
    </cfquery>

    <cfquery dbtype="query" name="cntComplexesPre">
    Select name,type,typename
    From session.booking.resort.getResultsPre
    Where typename = 'Complex/Neighborhood'
    </cfquery>

    <cfquery dbtype="query" name="cntComplexes">
    Select name,type,typename
    From session.booking.resort.getResults
    Where typename = 'Complex/Neighborhood'
    </cfquery>

    <cfquery dbtype="query" name="cntResortNamesPre">
    Select Distinct(resortname)
    From session.booking.resort.getResultsPre
    </cfquery>

  <p>Total PRE Recordcount : #session.booking.resort.getResultsPre.recordcount#</p>
  <p>Total PRE Homes : #cntHomesPre.recordcount#</p>
  <p>Total Pre Condos : #cntCondosPre.recordcount#</p>
  <p>Total Pre Complexes : #cntComplexesPre.recordcount#</p>
  <p>Total Pre Resort Names : #cntResortNamesPre.recordcount#</p>
  <br>
  <p>Total Recordcount : #session.booking.resort.getResults.recordcount#</p>
  <p>Total Homes : #cntHomes.recordcount#</p>
  <p>Total Condos : #cntCondos.recordcount#</p>
  <p>Total Complexes : #cntComplexes.recordcount#</p>
   </cfoutput>
   <cfabort> --->
   <!--- <cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)><Cfif isdefined('session.booking.resort.must_haves')><cfdump var="#session.booking.resort.must_haves#"><cfelse>No must haves</Cfif></cfif> --->
</cfif>

<cfif isdefined('session.booking.resort.unitCodeList') and ListLen(session.booking.resort.unitCodeList) gt 0 and isdefined('session.booking.resort.getResults')>
	<cfif isDefined("form.isresort")>
		<cfset request.resortcontent = "">
	</cfif>

   <cfset ThreeDaysEarlier = dateadd('d','-3',Now())>

	<cfquery datasource="#settings.dsn#" NAME="GetPropertyViewsAll">
			SELECT DISTINCT TrackingEmail,UserTrackerValue,unitcode
			FROM be_prop_view_stats WHERE createdAt >= <cfqueryparam value="#ThreeDaysEarlier#" cfsqltype="CF_SQL_TIMESTAMP">
			and unitcode IN (<cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#session.booking.resort.unitCodeList#" list="Yes">)
			GROUP BY TrackingEmail,UserTrackerValue desc
	</cfquery>

	<!--- Counting each marker to use for highlighting on the map --->
	<cfif !isdefined('session.mapMarkerID') or !isdefined('form.page') or (isdefined('form.page') and LEN(form.page) eq 0)>
	  <cfset session.mapMarkerID ="0">
	</cfif>

  <!--- This section handles the scenario where a special links out to a results page --->
  <cfif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate and isdefined('session.specialid') and len(session.specialid) and session.specialid gt 0>
    <!--- Check for any specials --->
    <cfquery name="checkForSpecials" dataSource="#settings.dsn#">
      select id from cms_specials where #createodbcdate(session.booking.resort.strcheckin)#
      between allowedBookingStartDate and allowedBookingEndDate
      and id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.specialid#"> AND active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Yes">
    </cfquery>

    <cfif checkForSpecials.recordcount gt 0>
      <!--- We found a special, now get a list of units in the special --->
      <cfquery name="getSpecialUnits" dataSource="#settings.dsn#">
        select unitcode from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#session.specialid#"> AND active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Yes">
      </cfquery>

      <cfset unitsWithSpecialList = ValueList(getSpecialUnits.unitcode)>
    </cfif>
  <cfelseif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate and isdefined('session.booking.resort.strcheckin')>
    <!--- if we are searching with dates, check for any valid specials --->
    <cfquery name="checkForSpecials" dataSource="#settings.dsn#">
      select * from cms_specials where
      #createodbcdate(session.booking.resort.strcheckin)# between startdate and enddate and
      #createodbcdate(session.booking.resort.strcheckin)# between allowedBookingStartDate and allowedBookingEndDate
      and active = 'yes'
    </cfquery>
    <cfif checkForSpecials.recordcount gt 0>
      <!--- Now that we have found a valid special, find the units in that special --->
      <cfquery name="getSpecialUnits" dataSource="#settings.dsn#">
        select unitcode from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#checkForSpecials.id#"> AND active = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="Yes">
      </cfquery>
      <cfset unitsWithSpecialList = ValueList(getSpecialUnits.unitcode)>
    </cfif>
  </cfif>

	<div class="results-list-properties <cfif StructKeyExists(request,'resortContent')>resorts-list-properties</cfif>">
	  <ul class="row">
  		<!--- Use the form page data to override url.loop values for infinite scroll --->
  		<cfif isdefined('form.page') and isvalid('integer',form.page)>
  		  <cfset url.loopStart = form.page * 12 + 1>
  		  <cfset url.loopend = (form.page + 1) * 12>
  		</cfif>

      <!---<cfif url.loopend gt cookie.numResortResults>--->
        <cfset url.loopend = cookie.numResortResults>
      <!---</cfif>--->

      <cfloop from="#url.loopStart#" to="#url.loopend#" index="i">
        <cftry>
          <cfset propertyid = ListGetAt(session.booking.resort.unitcodelist,i)>
          <cfcatch><cfbreak></cfcatch>
        </cftry>

      	<cfquery name="getUnitInfo" dbtype="query">
      		select * from session.booking.resort.getResults where propertyid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
      	</cfquery>

      <cfif isDefined("request.resortContent") OR getunitinfo.typename EQ "" OR isDefined("session.booking.resort.specialID")>
        <cfset detailPage = '/#settings.booking.dir#/#getUnitInfo.seoDestinationName#/#getUnitInfo.seoPropertyName#'>
      <cfelse>
        <cfset detailPage = '/resort/#getUnitInfo.seoPropertyName#'>
      </cfif>

        <cfif isdefined("session.booking.resort.strcheckin") and LEN(session.booking.resort.strcheckin)>
         <cfset detailPage = detailPage & "?strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#">
        </cfif>

      	<cfoutput>
  	      <li class="<cfif cgi.script_name eq "/destination-page.cfm">col-xlg-4 col-lg-4 col-md-6 col-sm-6<cfelse>col-xlg-4 col-lg-6 col-md-6 col-sm-6 <cfif cookie.numResortResults EQ 1>flex-result-single </cfif>results-list-col</cfif>">
  	        <div class="results-list-property" data-mapMarkerID="#session.mapMarkerID#" data-unitcode="#propertyid#" data-id="#getUnitInfo.seoPropertyName#" id="#getUnitInfo.seoPropertyName#" data-seoname="#getUnitInfo.seoPropertyName#" data-unitshortname="#getUnitInfo.name#" data-photo="https://img.trackhs.com/565x367/#getUnitInfo.defaultPhoto#" data-latitude="#getUnitInfo.latitude#" data-longitude="#getUnitInfo.longitude#" data-straddress1="#getUnitInfo.address#" data-dblbeds="#getUnitInfo.bedrooms#" data-intoccu="#getUnitInfo.sleeps#" data-strlocation="#getUnitInfo.location#">
  	          <div class="results-list-property-img-wrap">
	  	          <div class="view-prop-overlay">
		  	          #getUnitInfo.description#
		  	          <a href="#detailPage#" class="btn" target="_blank">View Property</a>
	  	          </div>
	  	          <cfif Len(getunitinfo.newproperty)><div class="new-prop-banner">New Property!</div></cfif>
      					<cfif
      					  isdefined('unitsWithSpecialList') and
      						listlen(unitsWithSpecialList) gt 0 and
      						ListFind(unitsWithSpecialList,propertyid)>
  		            <!--- At this point, we know this unit has a special --->
									<cfif isDefined("request.resortContent")>
										<button data-toggle="modal" data-target="##specialModal" class="results-list-property-special site-color-2-bg site-color-2-lighten-bg-hover text-white">
										  <i class="fa fa-tag site-color-3" aria-hidden="true"></i> Special
										</button>
									</cfif>
                  <div class="special-modal-content hidden">
                    <cfquery name="getSpecial" dbtype="query">
                    	select title,description from checkForSpecials where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#checkForSpecials.id#">
                    </cfquery>
                    <cfoutput>
                      <h4>#getSpecial.title#</h4>
                      <p>#getSpecial.description#</p>
                    </cfoutput>
                  </div><!-- END special-modal-content -->
  	            </cfif>
  	            <!--- PROPERTY LINK --->
  	              <!--- PROPERTY IMAGE --->
  	              <cfif len(getUnitInfo.defaultPhoto)>
	  	              <div class="owl-gallery-wrap">
		  	              <!--- FAVORITE HEART --->
		  	              <!--- 				<cfif isDefined("request.resortContent")> --->
<!--- 						  <cfif not isDefined("request.destination")> --->
			  	            <a href="javascript:;" class="results-list-property-favorite add-to-favs add-to-fav-results" <cfif not getunitinfo.isproperty AND not isDefined("request.resortContent") AND not  isDefined("session.booking.resort.specialID")>style="display: none;"</cfif>>
			  	              <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
			  	              <i class="fa fa-heart under<cfif ListFind(cookie.favorites,propertyid)> favorited</cfif>" aria-hidden="true"></i>
			  	            </a>
<!--- 						  </cfif> --->
			  	            <!--- 				</cfif> --->
										  <div class="owl-carousel owl-theme owl-quick-gallery">

													<cfif isDefined("request.resortcontent") or getunitinfo.typename EQ "" >
														<cfquery datasource="#settings.dsn#" name="qryImages">
															 select * from track_properties_images where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.propertyID#">
														</cfquery>

													<cfelse>
														<cfquery datasource="#settings.dsn#" name="qryImages">
															 select * from track_nodes_images where nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.nodeID#">
														</cfquery>
														<cfif qryImages.recordcount EQ 0>
															<cfquery datasource="#settings.dsn#" name="qryImages">
															 select * from track_nodes_images where nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.nodeID2#">
														</cfquery>
															</cfif>
															<cfif qryImages.recordcount EQ 0>
															<cfquery datasource="#settings.dsn#" name="qryImages">
															 select * from track_properties_images where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.propertyID#">
														</cfquery>
															</cfif>
														</cfif>
													<cfloop query="qryImages">
														<div class="item">
														  <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="https://img.trackhs.com/565x367/#original#"></a>
														</div>
													</cfloop>

												<cfif qryImages.recordcount EQ 0>
												    <div class="item">
													    <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="https://img.trackhs.com/565x367/#getUnitInfo.defaultPhoto#"></a>
												    </div>

												</cfif>
											</div>
										</div>
  	              <cfelse>
  	              	<span class="results-list-property-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span></a>
  	              </cfif>

  	              <a href="#detailPage#" class="results-list-property-link" target="_blank">
  	              <span class="results-list-property-title-wrap">
      						  <cfif len(getUnitInfo.avgRating)>
  		                <!--- PROPERTY RATING --->
  		                <span class="results-list-property-rating">
  		                	<cfif ceiling(getUnitInfo.avgRating) eq 1>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 2>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 3>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 4>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(getUnitInfo.avgRating) eq 5>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  </cfif>
  		                </span>
  	                </cfif>
  	                <!--- PROPERTY NAME AND LOCATION --->
  	                <span class="results-list-property-title">
						<h3>#getUnitInfo.name# <!--- <cfif isDefined("getunitinfo.totalunits") AND not isDefined("request.resortContent") AND getunitinfo.typename NEQ "">- #getunitinfo.totalunits# Units</cfif> REMOVED PER CLIENT REQ ---><cfif getUnitInfo.petsallowed eq 'Pets Allowed' or getUnitInfo.petsallowed eq '-1' or getUnitInfo.petsallowed contains 'Pets Allowed'><span class="results-list-property-pet-friendly"><i class="fa fa-paw" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Pet Friendly"></i></span></cfif></h3>
      	            	<!--- PROPERTY TYPE --->
					<!---
                      <cfif len(getUnitInfo.type)>
        	            	<span class="results-list-property-info-type">#getUnitInfo.type#</span>
        	            </cfif>
--->
  	                  <!--- <em>#getUnitInfo.location#</em> --->

<!--- 						<span class="results-list-property-info-type">#getUnitInfo.type#</span> hidden per client req--->
  	                </span>
  	              </span>
  	            </a>

              </div><!-- END results-list-property-img-wrap -->

  	          <div class="results-list-property-info-wrap">
  	            <!--- PROPERTY PRICE --->
  	            <span class="results-list-property-info-price">
                  <cfif session.booking.resort.searchByDate>
	                    <cfif isdefined('verifySpecial') and verifySpecial.recordcount gt 0>
	                      <!---
	                        At this point, we know we have a valid special, now we just need to
	                        see if the current property in the loop has any rates defined.
	                      --->
	                      <cfquery name="checkForSpecialRates" dataSource="#settings.dsn#">
	                        select * from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#verifySpecial.id#">
	                        and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
	                      </cfquery>
	                      <cfif
	                        checkForSpecialRates.recordcount gt 0 and
	                        len(checkForSpecialRates.pricewas) and
	                        len(checkForSpecialRates.pricereducedto) and
	                        checkForSpecialRates.pricewas gt 0 and
	                        checkForSpecialRates.pricereducedto gt 0>
	                        <span>
	                          Price was: <sup>$</sup>#checkForSpecialRates.pricewas# - Price reduced to: <sup>$</sup>#checkForSpecialRates.pricereducedto#
	                        </span>
	                      <cfelse>
	                      	<!--- Search by dates, no special --->
            							<cfif isDefined("request.resortContent")>
  	                      	<cfset baseRate = application.bookingObject.getPriceBasedOnDates(getUnitInfo.propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
  	                      	#baseRate#
            							<cfelse>
          								  #Dollarformat(getUnitInfo.minprice)# - #DollarFormat(getUnitInfo.maxprice)# /Night
            						  </cfif>
	                      </cfif>
	                    <cfelse>
          							<!---api--->
          							<cfif not isDefined("getunitinfo.resortproplist")>


          								<cfset returns = application.bookingObject.getDetailRates2(getUnitInfo.propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
          								<cfset apiresponse = returns.apiresponse>



										<cf_htmlfoot>
										<script type="text/javascript">
										  $.ajax(
											{
												url : "/vacation-rentals/ajax/get-srp-rates.cfm?propertyid=#getUnitinfo.propertyid#&checkin=#session.booking.resort.strcheckin#&checkout=#session.booking.resort.strcheckout#",
												type: "POST",
												success: function(data)
												{
												$('##quote_#getUnitInfo.propertyid#').html(data);
												}


											});
										</script>
										</cf_htmlfoot>

          							<cfelse>

										<cfif isAjaxRequest()>
											<script type="text/javascript">
										var total_#getUnitInfo.propertyid# = 1000000;
										var apiresponse = "";
										  <cfloop list="#getunitinfo.resortproplist#" index="currentprop">
        										<cfif currentprop NEQ "a">
												  $.ajax(
													{
														url : "/vacation-rentals/ajax/get-srp-rates3.cfm?propertyid=#currentprop#&checkin=#session.booking.resort.strcheckin#&checkout=#session.booking.resort.strcheckout#&resortproplist=getunitinfo.resortproplist",
														type: "POST",
														success: function(data)
														{
														 total2_#getUnitInfo.propertyid# = data;



														 if( total_#getUnitInfo.propertyid# > total2_#getUnitInfo.propertyid#){
															total_#getUnitInfo.propertyid# = total2_#getUnitInfo.propertyid#;


															 $.ajax(
																{
																	url : "/vacation-rentals/ajax/get-srp-rates2.cfm?propertyid=#currentprop#&checkin=#session.booking.resort.strcheckin#&checkout=#session.booking.resort.strcheckout#&resortproplist=getunitinfo.resortproplist",
																	type: "POST",
																	success: function(data)
																	{
																	$('##quote_#getUnitInfo.propertyid#').html(data);
																	}


																});




														}
														}


													});

											</cfif>
          								</cfloop>
										</script>


										<cfelse>
										<cf_htmlfoot>
										<script type="text/javascript">
										var total_#getUnitInfo.propertyid# = 1000000;
										var apiresponse = "";
										  <cfloop list="#getunitinfo.resortproplist#" index="currentprop">
        										<cfif currentprop NEQ "a">
												  $.ajax(
													{
														url : "/vacation-rentals/ajax/get-srp-rates3.cfm?propertyid=#currentprop#&checkin=#session.booking.resort.strcheckin#&checkout=#session.booking.resort.strcheckout#&resortproplist=getunitinfo.resortproplist",
														type: "POST",
														success: function(data)
														{
														 total2_#getUnitInfo.propertyid# = data;



														 if( total_#getUnitInfo.propertyid# > total2_#getUnitInfo.propertyid#){
															total_#getUnitInfo.propertyid# = total2_#getUnitInfo.propertyid#;


															 $.ajax(
																{
																	url : "/vacation-rentals/ajax/get-srp-rates2.cfm?propertyid=#currentprop#&checkin=#session.booking.resort.strcheckin#&checkout=#session.booking.resort.strcheckout#&resortproplist=getunitinfo.resortproplist",
																	type: "POST",
																	success: function(data)
																	{
																	$('##quote_#getUnitInfo.propertyid#').html(data);
																	}


																});




														}
														}


													});

											</cfif>
          								</cfloop>
										</script>
										</cf_htmlfoot>
										</cfif>
										<!---
          								<cfset total = 1000000>
          								<cfset apiresponse = "">
          								<cfloop list="#getunitinfo.resortproplist#" index="currentprop">
        										<cfif currentprop NEQ "a">
        											<cfset returns = application.bookingObject.getDetailRates2(currentprop,session.booking.resort.strcheckin,session.booking.resort.strcheckout,getunitinfo.resortproplist)>
        											<cfif total GT returns.total>
        												<cfset total = returns.total>
        												<cfset apiresponse = returns.apiresponse>
        											</cfif>
        										</cfif>
          								</cfloop>
										--->

          							</cfif>

							<span id="quote_#getUnitInfo.propertyid#">

							</span>
	                    	 <!--- Search by dates, no special --->
          						  <cfif isDefined("request.resortContent")>
  	                      <cfset baseRate = application.bookingObject.getPriceBasedOnDates(getUnitInfo.propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
  	                      #baseRate#
        							  <cfelse>
                          <!--- hidden per client 12-3-19
                            <cfset baseRate = application.bookingObject.getPriceBasedOnDates(getUnitInfo.propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
    	                      #baseRate#
                          --->
          						  </cfif>
	                    </cfif>

                  <cfelse>
                    <!--- Non-dated search, show price range --->
        					  <cfif isDefined("request.resortContent")>
  	                  <cfset priceRange = application.bookingObject.getPropertyPriceRange(getUnitInfo.propertyid)>
  	                  #ReplaceNoCase(priceRange,' + Taxes','')#
        					  <cfelse>
        						  #Replace(Dollarformat(getUnitInfo.minprice),".00","")# - #Replace(DollarFormat(getUnitInfo.maxprice),".00","")# /Night
        					  </cfif>
          					<div class="plus">plus taxes</div>
                  </cfif>
                  <!---<div class="plus">plus taxes &amp; fees</div>--->
  	            </span><!--- END PROPERTY PRICE --->

  	              	            <!--- PROPERTY INFO --->
  	            <ul class="results-list-property-info">
	  	            <div class="results-list-city"><cfif getUnitInfo.dest EQ "30A"><cfif len(getUnitInfo.isProperty) and getUnitInfo.isProperty>#getUnitInfo.locality#<cfelse>#getUnitInfo.location#</cfif><cfelse>#getUnitInfo.dest#</cfif>, #getUnitInfo.region#</div>
  	              <cfif getUnitInfo.bedrooms gt 0>
                  	<li><!--- <i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> --->Bedrooms: <cfif isDefined("getUnitInfo.bedroomsrange")>#replace(getUnitInfo.bedroomsrange,"abc","")#<cfelse>#getunitinfo.bedrooms#</cfif></li>
                  <cfelseif getUnitInfo.bedrooms eq 0>
                  	<li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> Studio</li>
                  </cfif>
                  <cfif getUnitInfo.bathrooms gt 0>
                  	<li><!--- <i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i> --->Baths: <cfif isDefined("getUnitInfo.bathroomsrange")>#replace(getUnitInfo.bathroomsrange,"abc","")# Full<cfelse>#getunitinfo.bathrooms# Full</cfif><cfif getUnitInfo.halfBathrooms GT 0>, #getUnitInfo.halfBathrooms# Half</cfif></li></cfif>
                  <cfif getUnitInfo.sleeps gt 0>
                  	<li><!--- <i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> ---><!--- #getUnitInfo.sleeps# Guests --->Sleeps: <cfif isDefined("getUnitInfo.sleepsrange")>#replace(getUnitInfo.sleepsrange,"abc","")#<cfelse>#getunitinfo.sleeps#</cfif></li>
                  </cfif>

                  <li style="display: block;"><cfif isdefined('getUnitInfo.distanceToBeach') and LEN(getUnitInfo.distanceToBeach)>Distance To Beach: #getUnitInfo.distanceToBeach#<cfelse>&nbsp;</cfif></li>
                   
                  <cfquery dbtype="query" NAME="GetPropertyViews">
                  	SELECT DISTINCT TrackingEmail,UserTrackerValue
                  	FROM GetPropertyViewsAll
                  	where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                  	GROUP BY TrackingEmail,UserTrackerValue
                  </cfquery>

                	<cfif GetPropertyViews.recordcount gte 10>
                		<li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> #GetPropertyViews.recordcount#  Views</li>
                  </cfif>

  	            </ul><!-- END results-list-property-info -->

	  	          <cfif isDefined("getUnitInfo.weddingDescription") and len(getUnitInfo.weddingDescription) gt 1 AND 0 EQ 1><div class="results-wedding-desc"><cfoutput><br> #getUnitInfo.weddingDescription#</cfoutput> <a href="#detailPage#" class="btn" target="_blank">Explore Venue</a></div><cfelse></cfif>

	  	          <!--PREV FLEX-->



              </div><!-- END results-list-property-info-wrap -->
				<!---
	            <cfif isdefined('session.booking.resort.searchByDate') and session.booking.resort.searchByDate and isdefined('session.booking.resort.strcheckin') and session.booking.resort.strcheckin neq '' and isdefined('session.booking.resort.strcheckout') and session.booking.resort.strcheckout neq ''>
                <div class="results-list-property-book-btn">
  	            	<cfif cgi.server_name eq settings.devURL>
  	            		<a target="_blank" href="/#settings.booking.dir#/book-now.cfm?propertyid=#propertyid#&strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white results-list-property-booknow-btn">Book Now</a>
  	            	<cfelse>
  	            	  <a target="_blank" href="#settings.booking.bookingURL#/#settings.booking.dir#/book-now.cfm?propertyid=#propertyid#&strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white results-list-property-booknow-btn">Book Now</a>
                  </cfif>
                </div>


	            </cfif>--->
  	        </div><!-- END results-list-property -->
  	      </li>

        </cfoutput>
        <cfset session.mapMarkerID = session.mapMarkerID + 1>
	      </cfloop>
	    </ul>
	    <!--NEW FLEX-->
	    <cfoutput>
        <!---THIS IS THE FLEX DAY SECTION--->
	      <cfif 1 EQ 0 AND session.booking.resort.getresults.recordcount LT 10 AND not isDefined("request.destination") AND not isDefined("request.resortid") AND session.booking.resort.searchbydate AND not isDefined("session.booking.resort.specialID")>

				  <cfinclude template="results-search-query-partial.cfm">

					<cfquery name="getPartialResults" dataSource="#settings.booking.dsn#">
						select
						track_properties.id AS propertyid,
						track_properties.seopropertyname,
						track_properties.name,
						track_properties.latitude,
						track_properties.longitude,
						bedrooms,
						case when nds.typename = 'Complex/Neighborhood'

						then
						nds.name
						ELSE track_properties.name
						END
						AS resortname,
						case when nds.typename = 'Complex/Neighborhood'

						then
						0
						ELSE 1
						END
						AS isproperty,
						nds.locality AS `location`,
						fullBathrooms AS bathrooms,
						halfBathrooms,
						nds.petsFriendly AS petsAllowed,
						lodgingTypeName AS `type`,
						minRate AS minprice,
						maxRate AS maxprice,
						coverImage AS defaultPhoto,
						nds.streetAddress AS address,
						maxoccupancy AS sleeps,
						cpe.notfoundurl,
						IFNULL(track_properties.seoDestinationName,'area') AS seoDestinationName,
						(SELECT AVG(rating) AS average FROM be_reviews WHERE unitcode = track_properties.id) AS avgRating,
						case when nds.typename = 'Complex/Neighborhood' then
						(SELECT original FROM track_nodes_images WHERE nodeid = nds.id LIMIT 1)
						ELSE track_properties.coverimage
						END as resortimage,
						(SELECT weddingDescription from cms_property_enhancements where strPropID = track_properties.id AND showOnWedding =1) as weddingDescription,
						(SELECT amenityname from track_properties_amenities where propertyid = track_properties.id AND amenityid = 204) as newproperty,
						case when nds.typename = 'Complex/Neighborhood'

						then
						nds.shortdescription
						ELSE track_properties.shortdescription
						END
						AS resortdescription,
						track_properties.shortdescription as description,
						nds.id as nodeid,
						nds2.id as nodeid2,
						nds3.id as nodeid3,
						nds.typeID,
						nds.typename,
						nds2.typeid as typeid2,
						nds3.typeid as typeid3



						from track_properties
						left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
						left join track_nodes nds2 on nds2.id = nds.parentid
						left join track_nodes nds3 on nds3.id = nds2.parentid
						left join cms_property_enhancements cpe ON cpe.strPropID = track_properties.id



						where track_properties.id in (<cfqueryparam value="#session.booking.resort.partialResultsList#" cfsqltype="cf_sql_varchar" list="true">)
	    				and track_properties.id not in  (<cfqueryparam value="#session.booking.resort.unitCodeList#" cfsqltype="cf_sql_varchar" list="true">)
							order by rand()
						limit 5

					</cfquery>
					<div class="alert alert-info similar-search-results">
					  View other Vacation Homes Available Close to Your Desired Date Range
					</div>

					<cfloop query="getpartialresults">
					  <cfset detailPage = '/#settings.booking.dir#/#seoDestinationName#/#seoPropertyName#<cfif isdefined("session.booking.resort.strcheckin") and LEN(session.booking.resort.strcheckin)>?strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#</cfif>'>
		        <div class="results-list-partial-properties">
	            <div class="results-list-calendar quick-facts-wrap">
	              <!---
	              <div class="results-list-property-quick-facts-wrap">
	                <span><b>View:</b> Ocean View</span>
	                <span><b>Floor Level:</b> 2nd Floor</span>
	                <span><b>Bedding:</b> King, Queen</span>
	              </div>---><!-- END results-list-property-quick-facts-wrap -->
					      <div class="results-list-property" data-unitcode="#propertyid#">
	              <div class="results-list-property-img-wrap">
							  <!---
		                <a href="javascript:;" class="results-list-property-favorite add-to-fav-results">
		                  <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
		                  <i class="fa fa-heart under" aria-hidden="true"></i>
		                </a> --->
	                <a href="#detailpage#" class="results-list-property-link" target="_blank">
	                <span class="results-list-property-title-wrap">
	                  <span class="results-list-property-title">
	                    <h3>#name# </h3>
	                  </span>
	                </span>
	                <span class="results-list-property-img" style="background:url('https://img.trackhs.com/565x367/#defaultphoto#');"></span>
	              </a>
	            </div><!-- END results-list-property-img-wrap -->
	            <div class="results-list-property-info-wrap">

	            <span class="results-list-property-info-price">
	              <small>Starting at</small> #dollarformat(minprice)# <small>Per Night</small>
	            </span>

	            <ul class="results-list-property-info">
	              <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bedrooms"></i> #bedrooms#</li>
	              <li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bathrooms"></i> #bathrooms# Full<cfif halfBathrooms GT 0>, #halfBathrooms# Half</cfif></li>
	              <li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Guests"></i> #sleeps#</li>
	            </ul><!-- END results-list-property-info -->

	          </div><!-- END results-list-property-info-wrap -->
		      </div>
				  <cfinclude template="_results-alternate-calendar.cfm">
						  <!---
			                <div class="results-list-property-book-btn">
			  	            	<a target="_blank" href="/oregon-coast-rentals/instant-quote.cfm?property=depoe-bay-snuggle-inn-second-floor" class="btn text-gray results-list-property-booknow-btn">Get An Instant Quote</a>
			                </div>
						--->
	        <!-- END results-list-property-book-btn -->
			    </div>
				</div><!---END results-list-partial-properties--->
		  </cfloop>

	    <style>
  	    li.results-list-col {width: 100% !important;}
				<!---
									  	    .results-list-partial-properties {
				    background: blue;
				}
				--->

				.results-list-calendar.quick-facts-wrap {}

				<!---
				.results-list-partial-properties .results-list-calendar {
				    background: green;
				    width: 100%;
				}
				--->

				div##map-all-results { display: none; }
				.results-list-wrap { width: 100%; }
				.results-list-calendar.quick-facts-wrap { width: 100%; }
				.results-list-partial-properties .results-list-property { width: 27%; float: left; margin: 0 2% 0 0; }
				.results-list-partial-properties ul.results-list-property-info { vertical-align: top; }
				.results-list-property-img-wrap { position: relative; /*max-width: 500px !important;*/ margin: 0; }

				.results-list-property-info-price { text-align: center; width: 100%; }
				.results-list-partial-properties ul.results-list-property-info { text-align: center; }
				li.results-list-col { width: 33.3% !important; }
				.flex-result-single.results-list-col .results-list-property-info-price+ul.results-list-property-info { text-align: left; }

				/*new*/
				.results-list-col .results-list-property-info-wrap, .results-list-col .results-list-property-info-price { text-align: left; }
				.similar-search-results { margin: 0 15px 33px; }
				.results-list-calendar.quick-facts-wrap { text-align: center; }
				.flex-result-single.results-list-col .results-list-property-info-wrap { max-width: 500px !important; }
				ul.results-list-property-info { float: none; }
				/*END new*/

				@media (min-width: 1200px) {
				.results-list-property-img-wrap .item a { max-height: none; }
				}
				@media (max-width: 991px) {
					.results-list-partial-properties .results-list-calendar { float: none; padding-left: 0; }
				}
				@media (max-width: 768px) {
					.flex-result-single.results-list-col { width: 100% !important; }
				}
				@media (max-width: 736px) {
				  li.results-list-col { width: 100% !important; }
				}
				@media (max-width: 667px) {
					.results-list-partial-properties .results-list-property { width: 100%; }
					.results-list-partial-properties .results-list-calendar .results-list-property-calendar-wrap { width: 100%; }
				}
				@media (max-width: 480px) {
          .results-list-property-info-price sup, .results-list-property-info-price small { position: relative; }
        }
	    </style>
	    <cf_htmlfoot>
	    <script>
  	    $( document ).ajaxComplete(function() {
				  console.log('acom');
			    $('.owl-quick-gallery').owlCarousel('refresh');
			    $('.owl-quick-gallery').trigger('refresh.owl.carousel');
				});
				console.log('noaj');
  	   </script>
  	   <cf_htmlfoot>
    <cfelse>
    </cfif>
	<!---END THIS IS THE FLEX DAY SECTION--->
	</cfoutput>
  </div><!-- END results-list-properties -->
  <div class="new-flex"></div>




<cfelseif not isDefined("request.destination") AND not isDefined("request.resortid") AND session.booking.resort.searchbydate AND not isDefined("session.booking.resort.specialID") AND 0 EQ 1>
	<cfinclude template="results-search-query-partial.cfm">

					  <cfquery name="getPartialResults" dataSource="#settings.booking.dsn#">
					select
					track_properties.id AS propertyid,
					track_properties.seopropertyname,
					track_properties.name,
					track_properties.latitude,
					track_properties.longitude,
					bedrooms,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.name
					ELSE track_properties.name
					END
					AS resortname,
					case when nds.typename = 'Complex/Neighborhood'

					then
					0
					ELSE 1
					END
					AS isproperty,
					nds.locality AS `location`,
					fullBathrooms AS bathrooms,
					halfBathrooms,
					nds.petsFriendly AS petsAllowed,
					lodgingTypeName AS `type`,
					minRate AS minprice,
					maxRate AS maxprice,
					coverImage AS defaultPhoto,
					nds.streetAddress AS address,
					maxoccupancy AS sleeps,
					cpe.notfoundurl,
					IFNULL(track_properties.seoDestinationName,'area') AS seoDestinationName,
					(SELECT AVG(rating) AS average FROM be_reviews WHERE unitcode = track_properties.id) AS avgRating,
					case when nds.typename = 'Complex/Neighborhood' then
					(SELECT original FROM track_nodes_images WHERE nodeid = nds.id LIMIT 1)
					ELSE track_properties.coverimage
					END as resortimage,
					(SELECT weddingDescription from cms_property_enhancements where strPropID = track_properties.id AND showOnWedding =1) as weddingDescription,
					(SELECT amenityname from track_properties_amenities where propertyid = track_properties.id AND amenityid = 204) as newproperty,
					case when nds.typename = 'Complex/Neighborhood'

					then
					nds.shortdescription
					ELSE track_properties.shortdescription
					END
					AS resortdescription,
					track_properties.shortdescription as description,
					nds.id as nodeid,
					nds2.id as nodeid2,
					nds3.id as nodeid3,
					nds.typeID,
					nds.typename,
					nds2.typeid as typeid2,
					nds3.typeid as typeid3



					from track_properties
					left join track_nodes nds ON track_properties.nodeId = nds.id and nds.typename = 'Complex/Neighborhood'
					left join track_nodes nds2 on nds2.id = nds.parentid
					left join track_nodes nds3 on nds3.id = nds2.parentid
					left join cms_property_enhancements cpe ON cpe.strPropID = track_properties.id



					where track_properties.id in (<cfqueryparam value="#session.booking.resort.partialResultsList#" cfsqltype="cf_sql_varchar" list="true">)

						order by nds.name
					limit 5

				</cfquery>

				 <cfif getpartialresults.recordcount>
						<div class="alert alert-info similar-search-results">
						  View other Vacation Homes Available Close to Your Desired Date Range
						</div>

					 <cfoutput query="getpartialresults">
						  <cfset detailPage = '/#settings.booking.dir#/#seoDestinationName#/#seoPropertyName#<cfif isdefined("session.booking.resort.strcheckin") and LEN(session.booking.resort.strcheckin)>?strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#</cfif>'>
		  	          <div class="results-list-partial-properties">
	  	              <div class="results-list-calendar quick-facts-wrap">
		  	              <!---
  	                  <div class="results-list-property-quick-facts-wrap">
                        <span><b>View:</b> Ocean View</span>
                        <span><b>Floor Level:</b> 2nd Floor</span>
                        <span><b>Bedding:</b> King, Queen</span>
                      </div>---><!-- END results-list-property-quick-facts-wrap -->




						  <div class="results-list-property" data-unitcode="#propertyid#">



              <div class="results-list-property-img-wrap">
				  <!---
                <a href="javascript:;" class="results-list-property-favorite add-to-fav-results">
                  <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
                  <i class="fa fa-heart under" aria-hidden="true"></i>
                </a>
--->
                <a href="#detailpage#" class="results-list-property-link" target="_blank">
                  <span class="results-list-property-title-wrap">



                    <span class="results-list-property-title">
                      <h3>#name# </h3>

                    </span>
                  </span>

                    <span class="results-list-property-img" style="background:url('https://img.trackhs.com/565x367/#defaultphoto#');"></span>

                </a>
              </div><!-- END results-list-property-img-wrap -->
              <div class="results-list-property-info-wrap">

                <span class="results-list-property-info-price">
                  <small>Starting at</small> #dollarformat(minprice)# <small>Per Night</small>
                </span>

                <ul class="results-list-property-info">
                  <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bedrooms"></i> #bedrooms#</li>
                  <li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bathrooms"></i> #bathrooms# Full<cfif halfBathrooms GT 0>, #halfBathrooms# Half</cfif></li>
                  <li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Guests"></i> #sleeps#</li>
                </ul><!-- END results-list-property-info -->
               </div><!-- END results-list-property-info-wrap -->
            </div>
				<cfinclude template="_results-alternate-calendar.cfm">
						  <!---
			                <div class="results-list-property-book-btn">
			  	            	<a target="_blank" href="/oregon-coast-rentals/instant-quote.cfm?property=depoe-bay-snuggle-inn-second-floor" class="btn text-gray results-list-property-booknow-btn">Get An Instant Quote</a>
			                </div>
						--->
<!-- END results-list-property-book-btn -->
			              </div>
					  	    </div><!---END results-list-partial-properties--->
						  </cfoutput>

					  	    <style>li.results-list-col {width: 100% !important;}
					  	    li.results-list-col {width: 100% !important;}
									<!---
														  	    .results-list-partial-properties {
									    background: blue;
									}
									--->
									.results-list-calendar.quick-facts-wrap {}
									<!---
									.results-list-partial-properties .results-list-calendar {
									    background: green;
									    width: 100%;
									}
									--->

									div#map-all-results { display: none; }
									.results-list-wrap { width: 100%; }
									.results-list-calendar.quick-facts-wrap { width: 100%; }
									.results-list-partial-properties .results-list-property { width: 27%; float: left; margin: 0 2% 0 0; }
									.results-list-partial-properties ul.results-list-property-info { vertical-align: top; }
									.results-list-property-img-wrap { position: relative; max-width: 500px !important; margin: 0; }

									.results-list-property-info-price { text-align: center; width: 100%; }
									.results-list-partial-properties ul.results-list-property-info { text-align: center; }

									@media (max-width: 1200px) {
									.results-list-property-img-wrap .item a { max-height: none; }
									}
									@media (max-width: 991px) {
										.results-list-partial-properties .results-list-calendar { float: none; padding-left: 0; }
									}
									@media (max-width: 736px) {
									  li.results-list-col { width: 100% !important; }
									}
									@media (max-width: 667px) {
										.results-list-partial-properties .results-list-property { width: 100%; }
										.results-list-partial-properties .results-list-calendar .results-list-property-calendar-wrap { width: 100%; }
									}
									@media (max-width: 480px) {
					          .results-list-property-info-price sup, .results-list-property-info-price small { position: relative; }
					        }
					  	    </style>
<!---END IF for getpartialresults.recordcount' --->
	<cfelse>
  <!--- HIDES LOADER ANIMATION --->
  <style>
    #bottom-result { display: none; }
    div#map-all-results { display: none; }
    .results-list-wrap { width: 100%; }
  </style>

  <div class="alert alert-danger no-search-results">
    Sorry, there are no properties matching your search criteria. <br />However, here are 2 random properties that you may like:
  </div>

  <cfset randomProperties = application.bookingObject.getRandomProperties()>

  <div class="results-list-properties results-list-suggested-properties">
    <div class="row">
      <cfloop query="randomProperties">
        <cfset detailPage = '/#settings.booking.dir#/#seoDestinationName#/#seoPropertyName#<cfif isdefined("session.booking.resort.strcheckin") and LEN(session.booking.resort.strcheckin)>?strcheckin=#session.booking.resort.strcheckin#&strcheckout=#session.booking.resort.strcheckout#</cfif>'>
        <cfoutput>
  	      <div class="<cfif cgi.script_name eq "/destination-page.cfm">col-xlg-4 col-lg-4 col-md-6 col-sm-6<cfelse>col-xlg-4 col-lg-6 col-md-6 col-sm-6 suggested-col-non-dest</cfif>">
  	        <div class="results-list-property">
  	          <div class="results-list-property-img-wrap">
	  	          <div class="view-prop-overlay">
	                  #description#
	                  <a href="#detailPage#" class="btn" target="_blank">View Property</a>
	              </div>
  	            <cfif len(defaultPhoto)>
                  <div class="owl-gallery-wrap">
		                <a href="javascript:;" class="results-list-property-favorite add-to-fav-results" <cfif isDefined("request.resortContent")>style="display: none;"</cfif>>
		  	              <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
		  	              <i class="fa fa-heart under" aria-hidden="true"></i>
		  	            </a>
                    <div class="owl-carousel owl-theme owl-quick-gallery">
                      <!---<cfloop query="getUnitInfo">--->
                      <cfloop>
						            <cfif isDefined("getUnitinfo.nodeID") AND len(getUnitInfo.nodeid)>
													<cfquery datasource="#settings.dsn#" name="qryImages">
														 select * from track_nodes_images where nodeid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getunitinfo.nodeID#">
													</cfquery>
													<cfloop query="qryImages">
														<div class="item">
														  <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="https://img.trackhs.com/565x367/#original#"></a>
														</div>
													</cfloop>
												<cfelse>
												  <cfloop>
												    <div class="item">
													    <a href="#detailPage#" class="results-list-property-link" target="_blank"><img class="owl-lazy" data-src="https://img.trackhs.com/565x367/#defaultPhoto#"></a>
												    </div>
												  </cfloop>
												</cfif>
                        <!--- <div class="item"> --->
                      </cfloop>
                    </div>
                  </div>
                <cfelse>
                  <span class="results-list-property-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span></a>
                </cfif>
								<!---
	              <cfif len(defaultPhoto)>
	                <span class="results-list-property-img" style="background:url('#defaultPhoto#');"></span>
	              <cfelse>
	              	<span class="results-list-property-img" style="background:url('/#settings.booking.dir#/images/no-img.jpg');"></span>
	              </cfif>
								--->

	              <a href="#detailPage#" class="results-list-property-link" target="_blank">
  	              <span class="results-list-property-title-wrap">
  	              	<cfif len(avgRating)>
  		                <span class="results-list-property-rating">
  		                	<cfif ceiling(avgRating) eq 1>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(avgRating) eq 2>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(avgRating) eq 3>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(avgRating) eq 4>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star-o" aria-hidden="true"></i>
  		                  <cfelseif ceiling(avgRating) eq 5>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  	<i class="fa fa-star" aria-hidden="true"></i>
  		                  </cfif>
  		                </span>
  	                </cfif>
  	                <!--- PROPERTY NAME AND LOCATION --->
  	                <span class="results-list-property-title">
  	                  <h3>#name# <cfif petsallowed eq 'Pets Allowed' or petsallowed eq '-1' or petsallowed contains 'Pets Allowed'><span class="results-list-property-pet-friendly"><i class="fa fa-paw" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Pet Friendly"></i></span></cfif></h3>
      	            	<!--- PROPERTY TYPE --->
                      <cfif len(type)>
<!---         	            	<span class="results-list-property-info-type">#type#</span> hidden per client req--->
        	            </cfif>
  	                </span>
  	              </span>
  	            </a>

              </div><!-- END results-list-property-img-wrap -->

              <div class="results-list-property-info-wrap">
                <!--- PROPERTY INFO --->
                <ul class="results-list-property-info">
                   <cfif bedrooms gt 0>
                    <li><!--- <i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> --->Bedrooms: #bedrooms#</li>
                  <cfelseif bedrooms eq 0>
                    <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bedrooms"></i> Studio</li>
                  </cfif>
                  <cfif bathrooms gt 0>
                    <li><!--- <i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Bathrooms"></i> --->Baths: #bathrooms# Full<cfif halfBathrooms GT 0>, #halfBathrooms# Half</cfif></li></cfif>
                  <cfif sleeps gt 0>
                    <li><!--- <i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="Guests"></i> --->#sleeps# Guests</li>
                  </cfif>
					<!---
                  <cfquery dbtype="query" NAME="GetPropertyViews">
                    SELECT DISTINCT TrackingEmail,UserTrackerValue
                    FROM GetPropertyViewsAll
                    where unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                    GROUP BY TrackingEmail,UserTrackerValue
                  </cfquery>

                    <cfif GetPropertyViews.recordcount gte 10>
                        <li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> #GetPropertyViews.recordcount#  Views</li>
                  </cfif>
--->

                </ul><!-- END results-list-property-info -->

                <!--- PROPERTY PRICE --->
                <span class="results-list-property-info-price">
                  <cfif session.booking.resort.searchByDate>
                        <cfif isdefined('verifySpecial') and verifySpecial.recordcount gt 0>
                          <!---
                            At this point, we know we have a valid special, now we just need to
                            see if the current property in the loop has any rates defined.
                          --->
                          <cfquery name="checkForSpecialRates" dataSource="#settings.dsn#">
                            select * from cms_specials_properties where specialID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#verifySpecial.id#">
                            and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
                          </cfquery>
                          <cfif
                            checkForSpecialRates.recordcount gt 0 and
                            len(checkForSpecialRates.pricewas) and
                            len(checkForSpecialRates.pricereducedto) and
                            checkForSpecialRates.pricewas gt 0 and
                            checkForSpecialRates.pricereducedto gt 0>
                            <span>
                              Price was: <sup>$</sup>#checkForSpecialRates.pricewas# - Price reduced to: <sup>$</sup>#checkForSpecialRates.pricereducedto#
                            </span>
                          <cfelse>
                            <!--- Search by dates, no special --->
                            <cfif isDefined("request.resortContent")>
                            <cfset baseRate = application.bookingObject.getPriceBasedOnDates(propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
                            #baseRate#
                            <cfelse>
								<cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                                <!--- #Dollarformat(minprice)# - #DollarFormat(maxprice)# /Night--->
                             </cfif>
                          </cfif>
                        <cfelse>
                             <!--- Search by dates, no special --->
                          <cfif isDefined("request.resortContent")>
                          <cfset baseRate = application.bookingObject.getPriceBasedOnDates(propertyid,session.booking.resort.strcheckin,session.booking.resort.strcheckout)>
                          #baseRate#
                              <cfelse>
                             <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                         </cfif>
                        </cfif>
                  <cfelse>
                    <!--- Non-dated search, show price range --->
                     <cfif isDefined("request.resortContent")>
                     <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                     <cfelse>
                         <cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                     #priceRange#
                     </cfif>
                  </cfif>
                  <div class="plus">plus taxes &amp; fees</div>
                </span>
                <!--- END PROPERTY PRICE --->
	  	          <cfif isDefined(".weddingDescription") and len(weddingDescription) gt 1 AND 0 EQ 1><div class="results-wedding-desc"><cfoutput><br> #weddingDescription#</cfoutput> <a href="#detailPage#" class="btn" target="_blank">Explore Venue</a></div><cfelse></cfif>
              </div><!-- END results-list-property-info-wrap -->


<!---
  	          <div class="results-list-property-info-wrap">
  	            <span class="results-list-property-info-price">
  	            	<cfset priceRange = application.bookingObject.getPropertyPriceRange(propertyid)>
                  #priceRange#
  	            </span>
  	            <ul class="results-list-property-info">
  	              <li><i class="fa fa-bed site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bedrooms"></i> #bedrooms#</li>
  	              <li><i class="fa fa-bath site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Bathrooms"></i> #bathrooms# Full<cfif halfBathrooms GT 0>, #halfBathrooms# Half</cfif></li>
  	              <li><i class="fa fa-users site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="Guests"></i> #sleeps#</li>
                  <cfset ThreeDaysEarlier = dateadd('d','-3',Now())>
      						<cfquery datasource="#settings.dsn#" NAME="GetPropertyViews">
        						SELECT DISTINCT TrackingEmail,UserTrackerValue
        						FROM be_prop_view_stats WHERE createdAt >= <cfqueryparam value="#ThreeDaysEarlier#" cfsqltype="CF_SQL_TIMESTAMP">
        						and unitcode = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#propertyid#">
        						GROUP BY TrackingEmail,UserTrackerValue desc
      						</cfquery>
      						<!--- <cfif GetPropertyViews.recordcount gte 10> --->
                    <li><i class="fa fa-binoculars site-color-1" aria-hidden="true" data-toggle="tooltip" data-placement="bottom" title="User Views"></i> 25 Views</li>
                  <!--- </cfif> --->
  	            </ul><!-- END results-list-property-info -->
  	            <span class="results-list-property-info-type">#type#</span>
  	           </div>
---><!-- END results-list-property-info-wrap -->
  	        </div>
  	      </div>
  	  	</cfoutput>
      </cfloop><!--END randomProperties-->
    </div>
  </div><!-- END results-list-properties results-list-suggested-properties -->

  <cf_htmlfoot>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js" defer type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" defer type="text/javascript"></script>
    <script>
      $('form#noResultsContactForm').validate({
  			submitHandler: function(form){
  				$.ajax({
  					type: "POST",
  					url: "_submit.cfm",
  					data: $('form#noResultsContactForm').serialize(),
  					dataType: "text",
  					success: function (response) {
  						response = $.trim(response);
  						console.log(response);
  						if(response === "success") {
  							$('.caption').hide();
  							$('form#noResultsContactForm').hide();
  							$('div#noResultsContactFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
  						}
  					}
  				});
  				return false;
  			}
  		});
    </script>
  </cf_htmlfoot>

  <script>
    if (window.jQuery) {
      $('form#noResultsContactForm').validate({
  			submitHandler: function(form){
  				$.ajax({
  					type: "POST",
  					url: "_submit.cfm",
  					data: $('form#noResultsContactForm').serialize(),
  					dataType: "text",
  					success: function (response) {
  						response = $.trim(response);
  						console.log(response);
  						if(response === "success") {
  							$('.caption').hide();
  							$('form#noResultsContactForm').hide();
  							$('div#noResultsContactFormMSG').html("<font color='green'>Thanks! Your email has been sent!</font>");
  						}
  					}
  				});
  				return false;
  			}
  		});
    }
  </script>

  <cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

  <div class="results-inquiry-form-wrap">
    <div class="results-inquiry-form-text">
      <div class="results-inquiry-form-caption">Tell us what you're looking for and someone will contact you with available options.</div>
      <div id="noResultsContactFormMSG"></div>
    </div>
    <form class="results-inquiry-form" id="noResultsContactForm" method="post">
      <cfinclude template="/cfformprotect/cffp.cfm">
      <input type="hidden" name="noResultsContactForm">
      <fieldset>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="firstName" type="text" placeholder="First Name" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="lastName" type="text" placeholder="Last Name" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="phone" type="text" placeholder="Phone" class="form-control">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="email" type="text" placeholder="Email" class="form-control required">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numberOfBeds">
            <option value="">Number of Bedrooms</option>
            <cfloop from="1" to="6" index="i">
            	<option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="budget" type="text" placeholder="Approximate Budget" class="form-control">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="arrivalDate" type="text" placeholder="Arrival Date" class="form-control datepicker datepicker-start">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <input id="" name="departureDate" type="text" placeholder="Departure Date" class="form-control datepicker datepicker-end">
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numAdults">
            <option value="">Num Adults</option>
            <cfloop from="1" to="20" index="i">
            	<option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group col-xs-12 col-md-6">
          <select class="selectpicker" name="numChildren">
            <option value="">Num Children</option>
            <cfloop from="1" to="20" index="i">
            	<option><cfoutput>#i#</cfoutput></option>
            </cfloop>
          </select>
        </div>
        <div class="form-group form-group-full col-xs-12 col-md-12">
          <textarea id="comments" name="comments" placeholder="I am looking for...." class="form-control"></textarea>
        </div>
        <div class="form-group col-xs-12 col-md-12">
          <div class="well input-well">
            <input id="optinNoResults" name="optin" type="checkbox" value="Yes"> <label for="optinNoResults">I agree to receive information about your rentals, services and specials via phone, email or SMS.<br >
            You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank">Privacy Policy</a></label>
          </div>
        </div>
        <div class="form-group col-xs-12 col-md-12 nomargin">
          <input type="submit" value="Submit" id="contactform" name="contactform" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover">
        </div>
      </fieldset>
    </form>
  </div><!-- END results-inquiry-form-wrap -->
</cfif>
</cfif>
