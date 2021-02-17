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
</style>
<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-sm-12">
        <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
        <div class="row pdp-experience">
	    		<div class="col-lg-12">
					  <p class="h1 h1-header site-color-3"><cfoutput><cfif len(page.h1) gt 10>#page.h1#<cfelse>No h1</cfif></cfoutput></p>
	    		</div>
	    		<cfinclude template="/components/callouts-destinations.cfm">
	    	</div>
        <div class="destination-availability">
	        <div class="col-xs-12 col-sm-9 destination-availability-text">
		        <cfoutput><cfif len(page.h1) gt 10>#parseShortCodes(page.body)#<cfelse>Content Coming Soon</cfif></cfoutput>
	        </div>
	        <cfinclude template="/components/_travel-dates-destinations.cfm">
          <!-- INQUIRE BUTTON -->
				<!---   <button id="mobileClose" class="btn site-color-3-lighten-bg site-color-3-bg-hover"><i class="fa fa-close" aria-hidden="true"></i></button> --->
				</div>
      </div>
    </div><!-- END pdp-experience -->
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
  			</cfcache>
<!---   			<cfif len(page.partial)><cfinclude template="/partials/#page.partial#"></cfif> --->
  		</div><!-- END col -->
<!---
  		<div class="col-lg-3 col-md-4 col-sm-12">
    		<div class="i-sidebar">
    			<cfinclude template="/components/callouts.cfm">
    		</div>
  		</div>
--->
  	</div><!-- END row -->	
  </div><!-- END container -->
</div><!-- END i-content -->