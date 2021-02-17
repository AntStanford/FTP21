<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
  <cfinclude template="/components/meta.cfm">
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <!--- <link rel="manifest" href="/site.webmanifest"> --->
  <link rel="manifest" href="/manifest.json">
  <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#0b3736">
  <meta name="msapplication-TileColor" content="#0b3736">
  <meta name="theme-color" content="#ffffff">
  <link rel="dns-prefetch" href="//cdnjs.cloudflare.com">
  <link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.5.2/animate.min.css" rel="stylesheet" media="screen" type="text/css">
  <link href="/stylesheets/styles.css?v=5.0.2" rel="stylesheet" type="text/css" media="screen, projection">
  <cfoutput>
  <link href="/#settings.booking.dir#/stylesheets/styles.css?v=13.1.8" rel="stylesheet" type="text/css">
	<cfinclude template = "/components/pixel-codes.cfm">
  <cfif cgi.script_name eq '/layouts/special.cfm'><style>.results-list-sort { display: none; }</style></cfif>

  <cfif StructKeyExists(request,'resortContent')>
		<style>
		.results-list-wrap { padding: 0px 15px 75px 15px !important; }
		.refine-wrap {/*top: 189px !important;*/ display: none; }
		.header-actions-refine { display: none; }
		.resort-caption { position: relative; display: block; /* position: absolute;*/ /*bottom: -38px;*/ bottom: -8px; width: 100%; text-align: center; z-index: 99999; }
		.owl-resorts-gallery-wrap { margin-bottom: 15px; /* padding: 0 50px; */ padding: 0; }
		.owl-gallery-wrap { background: ##fff !important; }
		.owl-carousel .owl-stage-outer { padding-bottom: 32px; }
		.property-wrap { width: 1170px !important; }
		.resort-bottom { width: 1170px; margin: 0 auto; }
		.property-dates select+.btn { padding: 7px 13px; }
		.btn.btn-default { border-color: ##ccc !important; }
		.property-dates .boostrap-select .btn, .property-dates select+.btn {height: 37px; border: 1px solid transparent;}
		div##map { height: 1px; opacity: 0; }
		.resort-bottom h2 { font-size: 36px; font-family: 'Playfair Display', serif; /*margin-bottom: 25px;*/ color: hsl(202, 8%, 20%) !important; }

		.property-dates.resort-dates button.southern-btn { text-align: center !important; }
		.property-dates.resort-dates .boostrap-select .btn, .property-dates select+.btn {/*height: auto;*/ padding: 10px 20px; }
		.refine-dropdown.datepicker-wrap.hidden+.form-group { margin: 0 12px; }
		.property-dates.resort-dates button.southern-btn+button.southern-btn { /*margin-top: 32px !important;*/ margin-top: 0px !important; }

	  .resort-dates-wrap .property-dates.resort-dates button.clear-filters { margin: 0 !important; padding: 7px; font-family: 'Roboto'; font-size: 14px; font-family: 'Raleway'; font-weight: 900; }

		/*Acutally ON DESTINATION page*/
		.property-dates form##refineForm input[type=text] { position: relative !important; z-index: auto !important; }
		span.datepicker-wrap .fa { top: auto; }

		.refine-text:hover { background: none !important;	}
		.refine-item.refine-dates .refine-dropdown { z-index: 999; }
		.property-dates .refine-dropdown.datepicker-wrap { position: absolute !important; top: 0; /*left: 0;*/ left: auto; right: 0; width: 600px; }

		/*END Acutally ON DESTINATION page*/

		/*FROM DESTINATION LAYOUT*/
		.property-dates .alert-views { display: block; margin-bottom: 25px; padding-left: 55px; position: relative; border-radius: 0; border-top: none; color: ##484848; }
		.property-dates .alert-views .fa { height: 36px; position: absolute; top: 0; bottom: 0; left: 10px; margin: auto; font-size: 36px; color: ##fe0102; }
		.property-dates .refine-dates { margin-bottom: 20px; position: relative; }
		.property-dates .refine-dates:after { content: ""; display: table; clear: both; }
		.property-dates .datepicker-wrap { display: block; width: 100%; position: relative; }
		.property-dates input[type=text] { display: block; /* width: 50%;  */margin: 0; padding: 10px;/*  float: left; */ /* background: ##fff url('../images/icon-calendar.png') no-repeat right 10px center; */ border: 1px solid ##dedede; -webkit-border-radius: 0; }
		.property-dates form##refineForm input[type=text] { display: block; margin: 0; padding: 11px 10px 89px; /* border: 1px solid ##dedede; */ -webkit-border-radius: 0; width: 100%; text-align: center; text-transform: uppercase; color: ##fff !important; }
		.property-dates form##refineForm input[type=text]::-webkit-input-placeholder { font-size: 12px; color: ##fff; font-family: 'Raleway', sans-serif; }
		.property-dates form##refineForm input[type=text]::-moz-placeholder { font-size: 12px; color: ##fff; font-family: 'Raleway', sans-serif; }
		.property-dates form##refineForm input[type=text]:-ms-input-placeholder { font-size: 12px; color: ##fff; font-family: 'Raleway', sans-serif; }
		.property-dates form##refineForm input[type=text]:-moz-placeholder { font-size: 12px; color: ##fff; font-family: 'Raleway', sans-serif; }
		.property-dates .datepicker-container { position: absolute; top: 45px; }
		.property-dates .detail-datepicker-checkin { left: 0; }
		.property-dates .detail-datepicker-checkout { right: 0; }
		.property-dates .datepicker-container ##ui-datepicker-div { width: 265px; position: absolute !important; top: 100% !important; right: auto !important; left: 0 !important; }
		.property-dates .detail-datepicker-checkin ##ui-datepicker-div { right: auto !important; left: 0 !important; }
		.property-dates .detail-datepicker-checkout ##ui-datepicker-div { right: 0 !important; left: auto !important; }
		.property-dates.resort-dates button.southern-btn { display: block !important; max-width: 100% !important; margin: 15px auto 15px !important; width: 100% !important; border: 1px solid ##dadada !important; display: table; width: 235px; max-width: 235px; margin: 0 auto 15px; }
		.property-dates ##detailBookBtn { width: 100%; max-width: 100%; font-size: 24px; }
		.refine-dates span.datepicker-departure-wrap { position: relative; }
		.refine-dates .arrival-day, .arrival-month, span.datepicker-wrap .fa { position: absolute; left: 0; text-align: center; right: 0; margin: 0 auto; color: ##fff;}
		.refine-dates .arrival-day {bottom: 15px; font-size: 60px; font-family: 'Playfair Display', serif;}
		.refine-dates .arrival-month {bottom: 15px; font-size: 12px; font-family: 'Raleway', sans-serif;}
		.refine-dates span.datepicker-arrival-wrap, span.datepicker-departure-wrap { position: relative; display: block; width: 50%; float: left; /* background: ##b5b5b5; */ background: ##9f8c5f; }
		.destination-availability {margin-top: 53px;}
		.refine-dates span.datepicker-departure-wrap { position: relative; }
		.refine-dates .arrival-day, .arrival-month, span.datepicker-wrap .fa { position: absolute; left: 0; text-align: center; right: 0; margin: 0 auto; color: ##fff; }

		.refine-dates .arrival-month {bottom: 15px; font-size: 12px; font-family: 'Raleway', sans-serif;}
		.refine-dates span.datepicker-arrival-wrap, span.datepicker-departure-wrap { position: relative; display: block; width: 50%; float: left; /* background: ##b5b5b5; */ background: ##9f8c5f; }
		span.datepicker-wrap .fa { bottom: 6px; font-size: 10px; color: ##fff; }
		.destination-availability { margin-top: 53px; }
		.property-dates .bootstrap-select .btn { width: 100%; }
		.property-dates form##refineForm input[type=text] { /* background: ##b5b5b5; */ background: ##9f8c5f; }
		/*END FROM DESTINATION LAYOUT*/

	  ##resortDates .form-group { margin: 7px 12px; }
		.check-group { margin: 26px 0; text-align: left; margin: 26px 0 0 !important; padding-bottom: 0 !important; text-align: left;}
	  .check-group+.check-group { margin-top: 0 !important; }

	  .refine-dates ##resortDates .arrival-day {/*bottom: 15px;*/ bottom: auto; top: 7px; font-size: 60px; font-family: 'Playfair Display', serif; }
	  .owl-carousel.resorts-carousel .owl-nav button.owl-prev, .owl-carousel.resorts-carousel .owl-nav button.owl-next { top: 47%; opacity: .75; }
	  .owl-carousel.resorts-carousel .owl-nav button.owl-prev:hover, .owl-carousel.resorts-carousel .owl-nav button.owl-next:hover { opacity: 1; }
	  .owl-carousel.resorts-carousel i:before { text-shadow: -1px -1px 18px rgb(0, 0, 0); }
	  .owl-carousel.resorts-carousel i.fa.fa-chevron-left, .owl-carousel.resorts-carousel i.fa.fa-chevron-right { color: white; }

	  .view-prop-overlay { top: 39%; }
	  <!--- .refine-dates ##resortDates .date-entered+.arrival-day { top: 14px; } --->
    @media (min-width: 1401px) {
      .property-dates form##refineForm input[type=text] { transform: scale(0.8); width: 110%; top: -9px; left: -4px; }
    }
    @media (max-width: 1400px) {
      .refine-dates ##resortDates .arrival-day { font-size: 46px; margin: 10px 0 0; }
      .property-dates form##refineForm input[type=text] { width: 110%; }
    }
		@media (max-width: 1200px) {
		  .i-header-favorites.i-header-actions { top: 52px; margin-top: 0; }
		  .i-header-viewed { /*right: 23px;*/ top: 24px; }
		  .property-wrap, .resort-bottom { width: 100% !important; }
		  /*.view-prop-overlay { margin: 38px 50px; }*/
		}
		@media (max-width: 1024px) {
		  .results-body .i-header-viewed { top: 42px; margin-top: 0; }
		  .i-header-favorites.i-header-actions { top: 42px; }
		  .property-dates-wrap { position: relative; float: none; }
		  .refine-item.refine-dates.destination-calendar { float: none; }
		  .property-dates form##refineForm input[type=text] { border: none; }
		  .results-wrap { padding-top: 88px; }
		  property-dates form##refineForm input[type=text] { padding: 3px 10px 89px; }
      .refine-dates .date-entered+.arrival-day { line-height: 98px; }
      .mobile-dates-toggle-wrap { display: none; } /*don't show for resorts*/
      .view-prop-overlay { top: 44%; }
			body .owl-carousel .owl-nav button.owl-next, body .owl-carousel .owl-nav button.owl-prev { z-index: 99999; }
    }
    @media (max-width: 992px) {
      .i-header { margin-top: -2px; }
    }
    @media (max-width: 768px) {
      .view-prop-overlay { top: 39%; }
    }
    @media (max-width: 667px) {
      .property-overview a { position: relative; top: auto; float: none; }/*this is for the view props link*/
      .property-overview { padding: 0px 15px 20px; }
      .info-wrap .info-wrap-body { padding: 0; }
      .info-wrap .info-wrap-heading { padding: 0; }
      ##propertyTabs { display: none; } /*?*/
      .property-details-wrap .info-wrap { padding: 17px 3px; }
      form##propertyContactForm { padding-left: 3px; }
      .owl-resorts-gallery-wrap { padding: 0 2px; }
      ##resortDates { padding: 10px 0px 0px; }
      ##resortDates .form-group { margin: 7px 5px; }
      ##resortDates .form-group { margin: 7px 0px; }
      .amenities-wrap .info-wrap-body { -webkit-column-count: 1; -moz-column-count: 1; column-count: 1; }
      .view-prop-overlay .btn { margin: 10px 0%; }
      .results-list-property-title h3 { text-align: left; }
      .results-list-property-info-type { text-align: left; }
      .results-list-property-favorite { bottom: 12px; }
      .owl-carousel .owl-stage-outer { padding-bottom: 2px; }
      .property-dates .refine-dropdown.datepicker-wrap { /*left: -30px; width: 310px;*/ width: 100%; }
      .property-dates .btn { width: 190px; max-width: 190px; padding: 10px 5px; width: 100%; max-width: none; margin-bottom: 4px; }
      .resort-caption { /*bottom: -38px;*/ bottom: -10px; background: ##fff; }
      .refine-dates ##resortDates .date-entered+.arrival-day { top: 3px; }
    }
    @media (max-width: 568px) {
	    .results-wrap.resorts-wrap { padding-top: 136px; }
		  .i-header-favorites.i-header-actions, .results-body .i-header-viewed { /*top: 78px;*/ top: 39px; }
		  .owl-carousel.resorts-carousel .owl-nav button.owl-prev, .owl-carousel.resorts-carousel .owl-nav button.owl-next { top: 38%; }
		  .resort-caption { bottom: -9px; }
		}
		</style>

  </cfif><!---END for Resorts Only--->

  <!--- UPDATE FA TO V5 --->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css" rel="stylesheet">
  <cfif cgi.script_name eq '/destination-page.cfm' OR cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/layouts/special.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/rentals/special-layout.cfm')>
	<cfelse>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.css" rel="stylesheet">
  </cfif>
  </cfoutput>

  <cf_htmlfoot>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" type="text/javascript"></script>
  <!--- REMOVED PER CLEINT REQEST - TT# 111744
    <script src="//cdn.blueconic.net/southernresorts.js"></script> --->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.4.1/jquery-migrate.min.js" type="text/javascript"></script>
  <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?v=3&key=<cfoutput>#settings.googleMapsAPIKey#</cfoutput>"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/OverlappingMarkerSpiderfier/1.0.3/oms.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/js-marker-clusterer/1.0.0/markerclusterer_compiled.js"></script>
  </cf_htmlfoot>

  <cfif cgi.script_name eq '/destination-page.cfm' OR cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/layouts/special.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/rentals/special-layout.cfm')>
  	<link rel="preconnect" href="https://fonts.googleapis.com/css" crossorigin>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/webfont/1.6.28/webfontloader.js"></script>
    <script>
      WebFont.load({
        google: {
          families: ['Playfair+Display:200,400,700','Raleway:400,600,700','Roboto:100,300,400,500&display=swap']
        }
      });
    </script>
	<cfelse>
		<link href="https://fonts.googleapis.com/css?family=Playfair+Display:200,400,700&display=swap" rel="stylesheet">
	  <link href="https://fonts.googleapis.com/css?family=Raleway:400,600&display=swap" rel="stylesheet">
	  <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500&display=swap" rel="stylesheet">
	</cfif>

  <cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />
  <cfinclude template="/components/analytics.cfm">
  <cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm'>
	<cfelse>
	  <script type="text/javascript">
	    var onloadCallback = function() {
	    	if($('div#sendtofriendcaptcha').length){
		      //Send to Friend form on the PDP
		      var sendtofriend = grecaptcha.render('sendtofriendcaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
		      });
	      }
	      if($('div#reviewscaptcha').length){
		      //Submit a Review form on the PDP
	        var reviews = grecaptcha.render('reviewscaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
		      });
	      }
	      if($('div#qandacaptcha').length){
		      //Submit a Question form on the PDP
	        var qanda = grecaptcha.render('qandacaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
		      });
	      }
	      if($('div#pdpmoreinfocaptcha').length){
		      //Request More Info form on the PDP
	        var qanda = grecaptcha.render('pdpmoreinfocaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
		      });
	      }
	      if($('div#sendtofriendcomparecaptcha').length){
		      //Footer contact form
	        var footerform = grecaptcha.render('sendtofriendcomparecaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>' ,
		      });
	      }
	    };
		</script>
  </cfif>

	<!-- Go to www.addthis.com/dashboard to customize your tools -->
<!--- 	<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-5a6a23638591c1d8"></script> --->
	<script>
		var OneSignal = window.OneSignal || [];
		OneSignal.push(function() {
		OneSignal.init({
			appId: "15a98b11-ffb2-49ca-8c12-9f9304cb2ada",
			notifyButton: {
			enable: true,
			},
		});
		OneSignal.showNativePrompt();
		});
	</script>
</head>

<body<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/layouts/special.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/layouts/special.cfm')> class="results-body<cfif (StructKeyExists(request,'resortContent'))> resort-body</cfif>"<cfelseif cgi.script_name eq '/#settings.booking.dir#/property.cfm'> class="pdp-body"</cfif>>

  <cfif cgi.script_name neq '/#settings.booking.dir#/book-now.cfm'>
    <cfinclude template="/components/home-page-announcements.cfm">
  </cfif>

<!--- 	<img class="proof" style="display: none; width: 100%; position: absolute; top: 0; z-index: 99999;" src="/images/proof-pdp.jpg"> --->

  <div class="wrapper">

	  <!--- RESULTS PAGE ONLY --->
		<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/rentals/special-layout.cfm')>
			<div class="i-header">
				<cfinclude template="/components/header-info.cfm">
  			<div class="i-header-navbar">
	  			<cfif isdefined('page.partial') and page.partial eq 'results.cfm' OR (StructKeyExists(request,'resortContent'))>
	  			<div class="container-fluid">
		  		<cfelse>
		  		<div class="container-fluid">
		  		</cfif>
		  			<div class="row">
			  			<div class="i-header-logo-wrap"><a href="/" class="i-header-logo"><cfoutput>#settings.company#</cfoutput></a></div>
			  			<cfinclude template="/components/social.cfm">
                        <div id="siteSearchBtn" class="i-header-site-search"><i class="fa fa-search"></i></div>
							<div id="siteSearchWrap" class="site-search-wrap">
                            <form id="site-search-form" name="search" action="/site-search" method="post">
                              <fieldset>
                                <label for="SearchTermInput" class="hidden">Search Term</label>
                                <input name="SearchTerm" id="SearchTermInput" type="text" placeholder="Site Search">
                                <input type="submit" id="SiteSearchInput" class="btn site-color-1-bg site-color-2-bg-hover text-white" name="submit" value="Search">
                              </fieldset>
                            </form>
                        </div>
                        <cf_htmlfoot>
                          <script>
                            // HEADER SITE SEARCH
						 	  if ($('#siteSearchWrap').length) {
								$( '#siteSearchBtn' ).on('click', function(){
								   $('#siteSearchWrap').toggleClass('active');
								});
							  }
						  </script>
                        </cf_htmlfoot>
							<div class="i-header-navigation">
<!--- 								<a href="javascript:;" class="i-header-qs-scroller"><span class="site-color-1-bg text-white"><i class="fa fa-sliders"></i></span></a> --->
								<a href="javascript:;" class="i-header-mobileToggle"><span class="site-color-1-bg text-white"><i class="fa fa-bars"></i></span></a>
								<span class="show-results-mobile" style="display: none;"><cfinclude template="/components/social.cfm"></span>
								<div class="i-header-phone show-tablet">
			    			  <cfif len(settings.tollFree)>
			    			    <cfoutput><a href="tel:#settings.tollFree#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.tollFree#</a></cfoutput>
			    			  </cfif>
			    			  <cfif len(settings.phone)>
			    			    <cfoutput><a href="tel:#settings.phone#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.phone#</a></cfoutput>
			    			  </cfif>
			    			</div>
								<cfinclude template="/components/navigation.cfm">
							</div>
<!---
							<div class="i-header-site-search"><i class="fa fa-search"></i></div>
							<cfinclude template="/components/social.cfm">
--->

							<!-- FAVORITES -->
			        <div class="i-header-favorites i-header-actions text-black">
			            <span class="header-action" id="favoritesToggle"><span>Favorites</span> <i class="fa fa-heart" data-toggle="tooltip" data-placement="bottom" title="Favorites"></i> <em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
			            <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
			        </div>
							<!-- RECENTLY VIEWED -->
			        <div class="i-header-viewed i-header-actions text-black">
			            <span class="header-action" id="recentlyViewedToggle"><span>Recently Viewed</span> <i class="fa fa-eye site-color-3" data-toggle="tooltip" data-placement="bottom" title="Recently Viewed"></i> <em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
			            <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">
			        </div>
			      </div><!-- END row -->
					</div><!-- END container-fluid -->
				</div><!-- END i-header-navbar -->
	    </div><!-- END i-header -->

    <cfelse>

			<div class="i-header">
				<cfinclude template="/components/header-info.cfm">
<!---
  			<div class="i-header-info">
	  			<div class="container">
		  			<div class="row">
			  			<div class="i-header-explore">
		    			    <cfoutput><a href="" class="text-white text-white-hover"><i class="fa fa-map"></i> Explore Our Destinations</a></cfoutput>
		    			</div>
			  			<div class="i-header-phone">
		    			  <cfif len(settings.tollFree)>
		    			    <cfoutput><a href="tel:#settings.tollFree#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.tollFree#</a></cfoutput>
		    			  </cfif>
		    			  <cfif len(settings.phone)>
		    			    <cfoutput><a href="tel:#settings.phone#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.phone#</a></cfoutput>
    			  </cfif>
    			</div>
    			<div class="i-header-payment">
    			    <cfoutput><a href="https://svr.trackhs.com/irm/payment/search/" class="text-white text-white-hover" target="_blank"><i class="fa fa-money"></i> Make a Payment</a></cfoutput>
    			</div>

    			<div class="i-header-guestportal">
    			    <cfoutput><a href="" class="text-white text-white-hover"><i class="fa fa-map"></i> Guest Portal</a></cfoutput>
    			</div>
    			<!-- LOGIN/ACCOUNT -->
<!---
		        <div class="i-header-login text-white">
		            <cfif isdefined('cookie.GuestFocusLoggedInID')>
		             <a target="_blank" href="/guest-focus/dashboard.cfm" class="text-white">
		            	<cfquery name="getGuestLoyaltyUser" dataSource="#settings.dsn#">
		    						select * from guest_focus_users where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#cookie.GuestFocusLoggedInID#">
		    					</cfquery>
		            	<cfoutput>#getGuestLoyaltyUser.firstname#</cfoutput>
		            <cfelse>
		             <a target="_blank" href="/guest-focus/" class="text-white">
		            	Login
		            </cfif>
		              <i class="fa fa-user text-white" data-toggle="tooltip" data-placement="bottom" title="Create An Account"></i>
		            </a>
		        </div>
--->
		        <div class="i-header-ownerportal">
    			    <cfoutput><a href="" class="text-white text-white-hover"><i class="fa fa-map"></i> Owner Portal</a></cfoutput>
    			</div>

	            <!---
	    			<span class="i-header-location text-white">
	      	    <i class="fa fa-map-marker"></i> <cfoutput>#settings.city#, #settings.state#</cfoutput>
	    			</span>
		        --->
		        <!-- RECENTLY VIEWED -->
<!---
		        <div class="i-header-viewed i-header-actions text-white">
		            <span class="header-action" id="recentlyViewedToggle">Recently Viewed <i class="fa fa-eye site-color-3" data-toggle="tooltip" data-placement="bottom" title="Recently Viewed"></i> <em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
		            <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">
		        </div>
--->
		        <!-- FAVORITES -->
<!---
		        <div class="i-header-favorites i-header-actions text-white">
		            <span class="header-action" id="favoritesToggle">Favorites <i class="fa fa-heart" data-toggle="tooltip" data-placement="bottom" title="Favorites"></i> <em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
		            <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
		        </div>
--->
            </div>
          </div>
	  			</div>
---><!-- END i-header-info -->
	  			<div class="i-header-navbar">
		  			<div class="container">
			  			<div class="row">
				  			<div class="i-header-logo-wrap"><a href="/" class="i-header-logo"><cfoutput>#settings.company#</cfoutput></a></div>
				  			<cfinclude template="/components/social.cfm">
							  <div class="i-header-navigation">
		<!--- 						<div class="container"> --->
<!--- 								<a href="javascript:;" class="i-header-qs-scroller"><span class="site-color-1-bg text-white"><i class="fa fa-sliders"></i></span></a> --->
								<a href="javascript:;" class="i-header-mobileToggle"><span class="site-color-1-bg text-white"><i class="fa fa-bars"></i></span></a>
								<div class="i-header-phone show-tablet">
			    			  <cfif len(settings.tollFree)>
			    			    <cfoutput><a href="tel:#settings.tollFree#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.tollFree#</a></cfoutput>
			    			  </cfif>
			    			  <cfif len(settings.phone)>
			    			    <cfoutput><a href="tel:#settings.phone#" class="text-white text-white-hover"><i class="fa fa-mobile"></i> #settings.phone#</a></cfoutput>
			    			  </cfif>
			    			</div>
									<cfinclude template="/components/navigation.cfm">
		<!--- 						</div> --->
							</div>
							<div class="i-header-site-search"><i class="fa fa-search"></i></div>
<!--- 							<cfinclude template="/components/social.cfm"> --->
						</div>
					</div>
		  		</div><!-- END i-header-navbar -->
<!--- 			</div> ---><!--- END container-fluid --->
		    </div><!-- END i-header -->

    </cfif>

<!---

    <div class="booking-header-wrap<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent'))OR (StructKeyExists(request,'specialContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/layouts/special.cfm')> results-header-wrap<cfelseif cgi.script_name eq '/#settings.booking.dir#/book-now.cfm'> booknow-header-wrap</cfif> site-color-1-bg">
      <div class="container">
        <div class="row">
          <div class="col-md-3">
            <div class="header-logo">
              <a href="/"><img src="/<cfoutput>#settings.booking.dir#</cfoutput>/images/wp-logo.png" alt="Summit Cove Logo"></a>
            </div>
          </div><!-- Logo -->
          <div class="col-md-9">
            <div class="pull-right">
              <a href="tel:<cfoutput>#settings.phone#</cfoutput>" class="header-actions-action header-action-phone text-white">
                <cfoutput>#settings.phone#</cfoutput>
              </a>
            </div>
--->

            <!--- BOOK NOW PAGE ONLY --->
<!---
            <cfif cgi.script_name eq '/#settings.booking.dir#/book-now.cfm'>
              <cfoutput>
                <div class="header-actions">
        					<cfif len(settings.tollFree)>
              			<a class="header-actions-action" href="tel:#settings.tollFree#"> <i class="fa fa-phone"></i> <span>#settings.tollFree#</span></a>
              		</cfif>
                </div>
              </cfoutput>
            <cfelse>

              <div class="header-nav">
--->
                <!--- <cfoutput>#session.wpNav#</cfoutput> --->
<!---               </div> --->
              <!-- END header-nav -->
<!---
              <div class="header-nav">
                <a href="javascript:;" class="header-mobileToggle"><span><i class="fa fa-bars"></i></span></a>
                <cfinclude template="/components/navigation.cfm">
              </div>
              <!-- END header-nav -->
--->
<!---
            </cfif>

          </div>
        </div>
      </div>
--->

  <!---
        <div class="header">
          <div class="header-logo">
            <a href="/"><img src="/<cfoutput>#settings.booking.dir#</cfoutput>/images/wp-logo.png"></a>
          </div>

          <!--- BOOK NOW PAGE ONLY --->
          <cfif cgi.script_name eq '/#settings.booking.dir#/book-now.cfm'>
            <cfoutput>
              <div class="header-actions">
      					<cfif cgi.http_referer does not contain 'results.cfm'>
      						<!--- Only show the 'Back' button if the user came from the PDP --->
      						<cfoutput><a href="javascript:history.go(-1)" class="header-actions-action site-color-4-bg site-color-4-lighten-bg-hover text-white"><i class="fa fa-chevron-left"></i> Back</a></cfoutput>
      					</cfif>
      					<cfif len(settings.tollFree)>
            			<a class="header-actions-action" href="tel:#settings.tollFree#"> <i class="fa fa-phone"></i> <span>#settings.tollFree#</span></a>
            		</cfif>
              </div>
            </cfoutput>
          <cfelse>

            <!--- OTHER BOOKING PAGES --->
            <div class="header-nav">
              <a href="javascript:;" class="header-mobileToggle"><span><i class="fa fa-bars"></i></span></a>
              <cfinclude template="/components/navigation.cfm">
            </div>
            <!-- END header-nav -->
          </cfif>

        </div><!-- END header -->
--->
<!---     </div> ---><!-- END booking-header-wrap -->
<cfif StructKeyExists(request,'resortContent')>
<!---
  <cf_htmlfoot>
		<script type="text/javascript">
			$(document).ready(function (){
			  $(".results-list-property-link").one("click", function(e)     {
			      e.preventDefault();
			      console.log("Click again to open");
			  });
			});
		</script>
	</cf_htmlfoot>
--->
</cfif><!---END for Resorts Only--->

