<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
  <cfinclude template="/components/meta.cfm">
  <!--- ANALYTICS --->
	<cfinclude template="/components/analytics.cfm">
  <link rel="dns-prefetch" href="//cdnjs.cloudflare.com">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet" media="all">
  <link href="/stylesheets/styles.css?v=1.62" rel="stylesheet" type="text/css" media="all">
  <cf_htmlfoot>
  <link href="/admin/pages/contentbuilder/assets/minimalist-basic/content-bootstrap-icnd.css?v=4" rel="stylesheet" type="text/css" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.10/css/bootstrap-select.min.css" rel="stylesheet" type="text/css" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css" rel="stylesheet" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css" rel="stylesheet" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css" rel="stylesheet" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.css" rel="stylesheet" media="all">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" media="all">
  </cf_htmlfoot>
  <cfif isdefined('page') and len(page.canonicalLink)>
    <cfoutput><link rel="canonical" href="#page.canonicalLink#"></cfoutput>
  </cfif>
  <!--- RECAPTCHA --->
	<cfinclude template="/components/recaptcha.cfm">
	<cfset Cffp = CreateObject("component","cfformprotect.cffpVerify").init() />

  <!--- RENDER BLOCKING - SO PLACING LAST IN HEAD --->
  <link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <link rel="manifest" href="/site.webmanifest">
  <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#cb763a">
  <meta name="msapplication-TileColor" content="#ffffff">
  <meta name="theme-color" content="#ffffff">

  <!-- Zendesk Widget -->
  <script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=2c87a1d6-1efd-45bf-bdf6-5a92212a193e"> </script>

  <cfinclude template = "/components/pixel-codes.cfm">
</head>
<body <cfif isdefined('page.bodyClass') and LEN(page.bodyClass)>class="<cfoutput>#page.bodyClass#</cfoutput>"</cfif>>


  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PX5S4Q6" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
  <cfif isDefined('slug') and slug eq 'index'>
    <cfinclude template="/components/home-page-announcements.cfm">
  </cfif>
	<div class="i-wrapper">
		<div class="i-header">
      <div class="i-header-nav-bar">
        <div class="container">
    			<div class="i-header-logo-wrap">
      			<a href="/" class="i-header-logo"><cfoutput>#settings.company#</cfoutput></a>
    			</div>
    			<div class="i-header-navigation">
      			<a href="javascript:;" class="i-header-qs-scroller">
        			<span class="text-white"><i class="fa fa-sliders"></i></span>
        			<span class="hidden">Quick Search Scroller</span>
        		</a>
      			<a href="javascript:;" class="i-header-mobileToggle">
              <span class="site-color-1-bg text-white"><i class="fa fa-bars"></i></span>
              <span class="hidden">Mobile Toggle</span>
        		</a>
  					<cfinclude template="/components/navigation.cfm">
          </div>
          <div class="i-header-phone">
            <!---
    			  <cfif len(settings.tollFree)>
    			    <cfoutput><a href="tel:#settings.tollFree#" class="site-color-2 site-color-1-hover">#settings.tollFree#</a></cfoutput>
    			  </cfif>
            --->
    			  <cfif len(settings.phone)>
    			    <cfoutput><a href="tel:#settings.phone#" class="site-color-2 site-color-1-hover">#settings.phone#</a></cfoutput>
    			  </cfif>
    			</div>
        </div>
			</div><!-- END i-header-nav-bar -->
      <!---
			<div class="i-header-info">
  			<div class="container">
          <!-- RECENTLY VIEWED -->
          <div class="i-header-viewed i-header-actions site-color-3 site-color-2-hover">
            <span class="header-action" id="recentlyViewedToggle">Recently Viewed <i class="fa fa-eye" data-toggle="tooltip" data-placement="bottom" title="Recently Viewed"></i> <em class="header-recently-viewed-count"><cfif StructKeyExists(cookie,'recent') and ListLen(cookie.recent)><cfoutput>#listlen(cookie.recent)#</cfoutput><cfelse>0</cfif></em></span>
            <cfinclude template="/#settings.booking.dir#/_recentlist.cfm">
          </div>
          <!-- FAVORITES -->
          <div class="i-header-favorites i-header-actions site-color-3 site-color-2-hover">
            <span class="header-action" id="favoritesToggle">Favorites <i class="fa fa-heart" data-toggle="tooltip" data-placement="bottom" title="Favorites"></i> <em class="header-favorites-count"><cfif StructKeyExists(cookie,'favorites') and ListLen(cookie.favorites)><cfoutput>#listlen(cookie.favorites)#</cfoutput><cfelse>0</cfif></em></span>
            <cfinclude template="/#settings.booking.dir#/_favoriteslist.cfm">
          </div>
    			<div class="i-header-phone">
            <!---
    			  <cfif len(settings.tollFree)>
    			    <cfoutput><a href="tel:#settings.tollFree#" class="site-color-2 site-color-1-hover">#settings.tollFree#</a></cfoutput>
    			  </cfif>
            --->
    			  <cfif len(settings.phone)>
    			    <cfoutput><a href="tel:#settings.phone#" class="site-color-2 site-color-1-hover">#settings.phone#</a></cfoutput>
    			  </cfif>
    			</div>
        </div>
      </div><!-- END i-header-info -->
      --->
		</div><!-- END i-header -->
		<cfinclude template="/components/header-banner.cfm">