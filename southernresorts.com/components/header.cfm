<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
  <cfinclude template="/components/meta.cfm">
  <link rel="dns-prefetch" href="//cdnjs.cloudflare.com">
  <link rel="dns-prefetch" href="//fonts.googleapis.com">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">
  <link href="/stylesheets/styles.css?v=10" rel="stylesheet" type="text/css" media="screen, projection">
  <link href="/admin/pages/contentbuilder/assets/minimalist-basic/content-bootstrap-icnd.css?v=1" rel="stylesheet" type="text/css">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css" rel="stylesheet">
  <cfif isdefined('page.slug') and page.slug eq "index">
  <cfelse>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.css" rel="stylesheet">
  </cfif>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Raleway:400,600&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Roboto:100,400,500&display=swap" rel="stylesheet">

	<cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />
	<cfinclude template="/components/analytics.cfm">
	<!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-5Z4Z9Z4');</script>
  <!-- End Google Tag Manager -->
  <!--- Needed for Google reCaptcha, don't touch! --->
  <cfif isdefined('page.slug') and page.slug eq "index">
  <cfelse>
    <script type="text/javascript">
	    var onloadCallback = function() {
	      if($('div#contactcaptcha').length){
		      //Contact form on the Contact Us page
	        var contactform = grecaptcha.render('contactcaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>'
		      });
	      }
	      if($('div#footercaptcha').length){
		      //Footer contact form
	        var footerform = grecaptcha.render('footercaptcha', {
		        'sitekey' : '<cfoutput>#settings.google_recaptcha_sitekey#</cfoutput>',
		      });
	      }
	    };
		</script>
  </cfif>
  <!--- REMOVED PER CLEINT REQEST - TT# 111744
    <script src="//cdn.blueconic.net/southernresorts.js" defer></script> --->
	<!--- RENDER BLOCKING - SO PLACING LAST IN HEAD --->
	<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <!--- <link rel="manifest" href="/site.webmanifest"> --->
  <link rel="manifest" href="/manifest.json">
	<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#0b3736">
	<meta name="msapplication-TileColor" content="#0b3736">
	<meta name="theme-color" content="#ffffff">
	<cfinclude template = "/components/pixel-codes.cfm">
	<script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async=""></script>
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
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5Z4Z9Z4"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
<body <cfif isdefined('page.bodyClass') and LEN(page.bodyClass)>class="<cfoutput>#page.bodyClass#</cfoutput>"<cfelseif cgi.script_name eq '/destination-page.cfm'>class="destination-page"</cfif>>
  <cfinclude template="/components/home-page-announcements.cfm">
	<div class="i-wrapper">
		<div class="i-header">
			<cfinclude template="/components/header-info.cfm">
			<div class="i-header-navbar">
  			<div class="container">
	  			<div class="row">
		  			<div class="i-header-logo-wrap"><a href="/" class="i-header-logo" alt="Southern Resorts"><cfoutput>#settings.company#</cfoutput></a></div>
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
		            <!--- <div class="container"> --->
								<a href="javascript:;" class="i-header-qs-scroller"><span class="site-color-1-bg text-white"><i class="fa fa-sliders"></i></span></a>
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
							</div>
						</div>
					</div>
		  	</div><!-- END i-header-navbar -->
			</div><!-- END i-header -->
		<cfinclude template="/components/header-banner.cfm">