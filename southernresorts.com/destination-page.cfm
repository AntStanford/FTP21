<!---
<cfquery name="getDestination" datasource="#settings.dsn#">
SELECT cd.id,Title, bannerImage, canonicalLink, h1, metaTitle, metaDescription, description, nodeid, t.name as locality
FROM cms_destinations cd left JOIN track_nodes t on t.id = cd.nodeid

WHERE Slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.slug#">
</cfquery>

<cfquery name="getDestinationCallOuts" datasource="#settings.dsn#">
SELECT Title, Description, Photo,link
FROM cms_callouts
WHERE destination_id = <cfif getDestination.nodeid EQ 0 ><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.id#"><cfelse><cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestination.nodeid#"></cfif>
</cfquery>

<cfset session.booking.town = getDestination.locality>
<cfinclude template="/#settings.booking.dir#/results.cfm">
<cfabort>--->
<cfif structKeyExists(session, "booking")>
	<cfset structClear(session.booking)>
</cfif>
	
<cfset request.destination = true>
<cfinclude template="/components/header.cfm">

<!--- standard 2 column layout --->
<style>
.row.pdp-experience p.h1 { text-align: left; }
.experience-listings { margin: 0 35px; }
.i-quick-search { display: none; }
.experience-listings .h4 { font-family: 'Playfair Display', serif !important; font-weight: 400 !important; /* text-shadow: 0px 2px 5px rgb(44, 44, 44); */ margin-top: 0 !important; font-size: 21px !important; line-height: 27px !important; letter-spacing: 1px; }
.pdp-callout-text:after { content: ""; width: 100%; display: block; height: 3px; background: #b39a60; margin-top: 18px; }
.pdp-callout-text { text-align: center; margin-top: 3px; padding: 0 15px; }
.i-content .h5.callout-subtext { text-transform: none; font-size: 15px; text-shadow: none; }
.i-content .h4.callout-category { text-shadow: none; }

.property-dates .alert-views { display: block; margin-bottom: 25px; padding-left: 55px; position: relative; border-radius: 0; border-top: none; color: #484848; }
.property-dates .alert-views .fa { height: 36px; position: absolute; top: 0; bottom: 0; left: 10px; margin: auto; font-size: 36px; color: #fe0102; }
.property-dates .refine-dates { margin-bottom: 20px; position: relative; }
.property-dates .refine-dates:after { content: ""; display: table; clear: both; }
.property-dates .datepicker-wrap { display: block; width: 100%; position: relative; }
.property-dates input[type=text] { display: block; /* width: 50%;  */margin: 0; padding: 10px;/*  float: left; */ /* background: #fff url('../images/icon-calendar.png') no-repeat right 10px center; */ border: 1px solid #dedede; -webkit-border-radius: 0; }
.property-dates form#refineForm input[type=text] { display: block; margin: 0; padding: 11px 10px 89px; border: 1px solid #dedede; -webkit-border-radius: 0; width: 100%; text-align: center; text-transform: uppercase; color: #fff !important; }
.property-dates form#refineForm input[type=text]::-webkit-input-placeholder { font-size: 12px; color: #fff; font-family: 'Raleway', sans-serif; }
.property-dates form#refineForm input[type=text]::-moz-placeholder { font-size: 12px; color: #fff; font-family: 'Raleway', sans-serif; }
.property-dates form#refineForm input[type=text]:-ms-input-placeholder { font-size: 12px; color: #fff; font-family: 'Raleway', sans-serif; }
.property-dates form#refineForm input[type=text]:-moz-placeholder { font-size: 12px; color: #fff; font-family: 'Raleway', sans-serif; }
.property-dates .datepicker-container { position: absolute; top: 45px; }
.property-dates .detail-datepicker-checkin { left: 0; }
.property-dates .detail-datepicker-checkout { right: 0; }
.property-dates .datepicker-container #ui-datepicker-div { width: 265px; position: absolute !important; top: 100% !important; right: auto !important; left: 0 !important; }
.property-dates .detail-datepicker-checkin #ui-datepicker-div { right: auto !important; left: 0 !important; }
.property-dates .detail-datepicker-checkout #ui-datepicker-div { right: 0 !important; left: auto !important; }
.property-dates .btn { display: table; width: 235px; max-width: 235px; margin: 0 auto 15px; }
.property-dates #detailBookBtn { width: 100%; max-width: 100%; font-size: 24px; }
.refine-dates span.datepicker-departure-wrap { position: relative; }
.refine-dates .arrival-day, .arrival-month, span.datepicker-wrap .fa { position: absolute; left: 0; text-align: center; right: 0; margin: 0 auto; color: #fff;}
.refine-dates .arrival-day {bottom: 15px; font-size: 60px; font-family: 'Playfair Display', serif;}
.refine-dates .arrival-month {bottom: 15px; font-size: 12px; font-family: 'Raleway', sans-serif;}
.refine-dates span.datepicker-arrival-wrap, span.datepicker-departure-wrap { position: relative; display: block; width: 50%; float: left; background: #b5b5b5; }
.destination-availability {margin-top: 53px;}
.refine-dates span.datepicker-departure-wrap { position: relative; }
.refine-dates .arrival-day, .arrival-month, span.datepicker-wrap .fa { position: absolute; left: 0; text-align: center; right: 0; margin: 0 auto; color: #fff;}
.refine-dates .arrival-day {bottom: 15px; font-size: 60px; font-family: 'Playfair Display', serif;}
.refine-dates .arrival-month {bottom: 15px; font-size: 12px; font-family: 'Raleway', sans-serif;}
.refine-dates span.datepicker-arrival-wrap, span.datepicker-departure-wrap { position: relative; display: block; width: 50%; float: left; background: #b5b5b5; }
span.datepicker-wrap .fa { bottom: 6px; font-size: 10px; color: #fff; }
.destination-availability { margin-top: 53px; }
.property-dates .bootstrap-select .btn {width: 100%;}
.property-dates form#refineForm input[type=text] {background: #b5b5b5; }

div#map-all-results { display: none; }
.results-wrap, .results-list-wrap, .results-list-legend, .results-list-properties { z-index: auto; }
.owl-gallery-wrap, .owl-carousel { z-index: auto !important; }
.property-dates form#refineForm input[type=text] {position: relative !important; z-index: auto !important;}
.results-list-wrap {width: 95% !important; margin: 0 auto;}
.results-list-properties > .row > [class^=col] {width: 33.3% !important;}
.results-list-wrap h1, .results-list-wrap .h1 {text-align: left;}

.refine-item.refine-dates .refine-dropdown { z-index: 999; }
.refine-item.refine-dates { position: inherit !important; }
form#refineForm, .property-dates .refine-dates {position: inherit !important;}
.btn.btn-default { border: 1px solid transparent !important; }
.property-dates .refine-dropdown.datepicker-wrap { position: absolute !important; top: 0; left: 0;}
span.datepicker-wrap .fa {top: auto;}
.refine-text:hover {background: none !important;}
.results-list-wrap {padding: 22px 15px 75px 15px !important;}
.property-dates .refine-dropdown.datepicker-wrap { left: auto; right: 0; width: 600px;}
.property-dates .datepicker-wrap .form-group {padding: 0 13px;}
.property-dates .btn { display: block !important; max-width: 100% !important; margin: 15px auto 15px !important; width: 100% !important; border: 1px solid #dadada !important; }
.property-dates button.southern-btn {text-align: center !important; }
a.destination-prop-link { text-align: center; display: block; font-size: 20px; color: #003c3d !important; }
a.destination-prop-link:before { content: "\f015"; font-family: FontAwesome; margin-right: 9px; }

.i-header { top: 0 !important; }
/*.i-wrapper { padding-top: 124px !important; }*/

.property-dates form#refineForm input[type=text] { background: #8e8e8e; }

<!--- ul.results-list-sort#sortForm { display: none; } --->
.results-list-property-title h3 { font-weight: 500 !important; }

.results-list-wrap h1 { font-size: 36px; margin-bottom: 10px; }
.destinations-availability-inner.less { max-height: none !important; }

.i-content .destinations-availability-inner p { font-size: 15px; }

.destinations-availability-inner-limit.show { display: block !important; }
.destinations-availability-inner-limit.hide { display: none !important; }
.destinations-availability-inner-full.show { display: block !important; }
.destinations-availability-inner-full.hide { display: none !important; }

@media (max-width: 1024px) {
	.i-header { position:relative!important; }
  .i-header-viewed, .i-header-favorites, .i-header-login, .i-header-location, .i-header-phone { margin-top: 5px !important; }
}
@media (max-width: 768px) {
  /*.i-header-navbar { min-height: 77px !important; }
  .i-wrapper { padding-top: 106px !important; }
  .experience-listing { margin-bottom: 16px; }*/
}
</style>
<div class="i-content gcg-destination">
  <div class="container">
  	<div class="row">
  		<div class="col-sm-12">
<!---         <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
        <div class="row pdp-experience">
	    		<div class="col-lg-12">
					  <p class="h1 h1-header site-color-3"><cfoutput><cfif len(getDestination.h1) gt 10>#getDestination.h1#<cfelse>No h1</cfif></cfoutput></p>
	    		</div>
	    		<cfinclude template="/components/callouts-destinations.cfm">
	    	</div><!-- END pdp-experience -->
	    	<a href="#properties" class="destination-prop-link">View Properties</a>
        <div class="destination-availability">
		        <cfif len(getDestination.description) gt 0 AND len(getDestination.description) lt 100>
			        <div class="col-xs-12 col-sm-9 destination-availability-text"><cfoutput>#getDestination.description#</cfoutput></div>
		        <cfelseif len(getDestination.description) gt 100>
		        
		          <div class="col-xs-12 col-sm-9 destination-availability-text">
			          <div class="destinations-availability-inner" style="margin-bottom: 15px;">
				          <div class="destinations-availability-inner-limit"><cfoutput>#fullLeft(getDestination.description,550)#...</cfoutput></div>
				          <div class="destinations-availability-inner-full" style="display: none;"><cfoutput>#getDestination.description#</cfoutput></div>
			          </div>
			          <button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-description" type="button" style="background-color: transparent !important; color: #000 !important;"><span>See More Description</span> <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
			          <cf_htmlfoot>
								<script type="text/javascript" defer>
									$(document).ready(function(){
										$('.see-more-description').toggle(function () {
											$(".destinations-availability-inner").addClass("less");
											$(".destinations-availability-inner-limit").addClass("hide");
									    $(".destinations-availability-inner-full").toggleClass("show");
											$('.see-more-description span').text('See Less Description');
										}, function () {
								      $(".destinations-availability-inner").removeClass("less");
								      $(".destinations-availability-inner-limit").removeClass("hide");
								    	$(".destinations-availability-inner-full").removeClass("show");
								      $('.see-more-description span').text('See More Description');
								    });
								  });
								</script>
								</cf_htmlfoot>
		          </div>
							
		        <cfelse>
		          <div class="col-xs-12 col-sm-9 destination-availability-text">No Content</div>
		        </cfif>
		        
	        <cfinclude template="/components/_travel-dates-destinations.cfm">
          <!-- INQUIRE BUTTON -->
				<!---   <button id="mobileClose" class="btn site-color-3-lighten-bg site-color-3-bg-hover"><i class="fa fa-close" aria-hidden="true"></i></button> --->
				</div><!-- END destination-availability -->
      </div><!-- END col -->
    </div><!-- END row -->
<!---     <cfinclude template="/#settings.booking.dir#/results.cfm">  ---> 
    <!---
     			<cfif len(page.h1)>
     			  <cfoutput><h1 class="site-color-1">#page.h1#</h1></cfoutput>
     			<cfelse>
     			  <cfoutput><h1 class="site-color-1">#page.name#</h1></cfoutput>
     			</cfif>
      		<div class="content-builder-wrap">
        		<cfoutput>#page.body#</cfoutput>
      		</div>
--->
<!---   			</cfcache> --->
<!---   			<cfif len(page.partial)><cfinclude template="/partials/#page.partial#"></cfif> --->
<!---   		</div> ---><!-- END col -->
<!---
  		<div class="col-lg-3 col-md-4 col-sm-12">
    		<div class="i-sidebar">
    			<cfinclude template="/components/callouts.cfm">
    		</div>
  		</div>
--->
<!---   	</div> ---><!-- END row -->	
 



<!--- <cfinclude template="/components/footer.cfm"> --->
<!--- Set the locality to the destination --->
<cfset session.booking.town = getDestination.locality>
	
<cfinclude template="/#settings.booking.dir#/results2.cfm">
	
	<form id="refineForm">
	
<input type="hidden" name="page" value="0">
	</form>

<!--- <cfdump var="#session.booking.getResults#"> --->


 </div><!-- END container -->
</div><!-- END i-content -->

<cfinclude template="/components/footer.cfm">

<!---
<cfdump var="#getDestination#">
<cfdump var="#getDestinationCallOuts#">
  --->