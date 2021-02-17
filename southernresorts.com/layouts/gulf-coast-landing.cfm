<style>
	.row.pdp-experience p.h1 {text-align: left;}
	.experience-listings {margin: 0 35px;}
	.i-quick-search {display: none;}
	.experience-listings .h4 {font-family: 'Playfair Display', serif !important; font-weight: 400 !important; /* text-shadow: 0px 2px 5px rgb(44, 44, 44); */ margin-top: 0 !important; font-size: 21px !important; line-height: 27px !important; letter-spacing: 1px;}
	.pdp-callout-text:after { content: ""; width: 100%; display: block; height: 3px; background: #b39a60; margin-top: 18px; }
	.pdp-callout-text {text-align: center; margin-top: 3px; padding: 0 15px;}
	.container.callouts-wrapper { margin: 30px auto 30px; }
	.i-content h1 { text-align: left; color: #000 !important; }
	.h2.site-color-1 { font-family: 'Playfair Display', serif; text-transform: none; color: #000 !important; font-weight: 100; font-size: 25px; }
	.row.experience-group, .row.gcg-map { margin: 10px 37px 58px; }
	.row.gcg-map iframe { width: 100%; height: 300px;}
	.row.pdp-experience p.h1 {text-align: center;}
	.callout-text { top: auto; right: 0; left: 0; text-align: center; transform: none; margin: 0 auto; bottom: 23px; }
	.row.gcg-map {margin: 10px 37px 8px;}
	.i-content .callouts-wrapper h1, .i-content .callouts-wrapper .h1, .mce-content-body .callouts-wrapper  h1, .mce-content-body .callouts-wrapper  .h1 { margin-bottom: 4px; font-size: 30px;}
	.i-content .h5.callout-subtext {font-size: 15px;}
	.i-content .h4.callout-category { font-size: 34px;}
	.row.exp-img-wrap a { color: #fff; background: #448a9b; position: absolute; text-align: center; color: #fff; top: 50%; right: 3%; transform: translate(-50%,-50%); padding: 15px 23px; border-radius: 8px !important; }
	.southern-btn.see-more-description { background: transparent; border: none; font-style: italic; text-align: right; float: right; }
	.gcg-landing-body { max-height: 116px; overflow: hidden; }
	.gcg-landing-body.less { max-height: none; }
	.gcg-landing-body-limit.show { display: block !important; }
	.gcg-landing-body-limit.hide { display: none !important; }
	.gcg-landing-body-full.show { display: block !important; }
	.gcg-landing-body-full.hide { display: none !important; }
	.pdp-gulf-coast-activites, .gcg-southern-perks-callout {position: relative;}
	.pdp-gulf-coast-activites div, .gcg-southern-perks-callout div {display: block; position: absolute; z-index: 9; font-size: 35px; /*text-align: center;*/ /*text-align: left;*/ text-align: right; font-weight: 600; top: 50%; /*right: 27%;*/ right: 23%; bottom: auto; left: auto; transform: translate(50%, -50%); font-family: 'Raleway', sans-serif; color: #5d5d5d;}
  .pdp-gulf-coast-activites img {opacity: .7; transition-timing-function: ease; transition-timing-function: cubic-bezier(0.95, 0.1, 0.25, 1);}
  span.pdp-gca-heading, .gcg-southern-perks-callout span.pdp-gca-heading { font-family: 'Playfair Display', serif; font-weight: 500; font-size: 48px; line-height: normal; text-shadow: 4px 3px 2px rgb(195, 195, 195); }
  span.pdp-gca-subheading, .gcg-southern-perks-callout span.pdp-gca-subheading { font-weight: 100; font-size: 44px; display: block; margin-top: -5px; line-height: normal; text-shadow: 3px 2px 2px rgb(214, 214, 214); }
</style>

<!--- standard 2 column layout --->
<div class="i-content">
  <div class="container">
  	<div class="row">
  		<div class="col-sm-12">
        <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files">
        <h1 class="site-color-1"><cfoutput>#page.h1#</cfoutput></h1>
        
        <cfif len(page.body) gt 0 AND len(page.body) lt 100>
	        <div class="gcg-landing-body">
	          <cfoutput>#page.body#</cfoutput>
	        </div>
        <cfelseif len(page.body) gt 100>
          <div class="gcg-landing-body">
	          <div class="gcg-landing-body-limit"><cfoutput>#striphtml(fullLeft(page.body,550))#...</cfoutput></div>
	          <div class="gcg-landing-body-full" style="display: none;"><cfoutput>#page.body#</cfoutput></div>
	        </div>
	        <button id="" class="site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-description" style="background-color: transparent !important; color: #000 !important;"><span>See More...</span><!--- <i class="fa fa-chevron-right" aria-hidden="true"></i> ---></button>
	                
	        <cf_htmlfoot>
						<script type="text/javascript" defer>
							$(document).ready(function(){
								$('.see-more-description').toggle(function () {
									$(".gcg-landing-body").addClass("less");
									$(".gcg-landing-body .gcg-landing-body-limit").addClass("hide");
									$(".gcg-landing-body .gcg-landing-body-full").toggleClass("show");
									$('.see-more-description span').text('See Less');
								}, function () {
						      $(".gcg-landing-body").removeClass("less");
						      $(".gcg-landing-body .gcg-landing-body-limit").removeClass("hide");
									$(".gcg-landing-body .gcg-landing-body-full").removeClass("show");
						      $('.see-more-description span').text('See More...');
						    });
						  });
						</script>
					</cf_htmlfoot>
        <cfelse>
          Content Coming Soon
        </cfif>
  		</div><!---END col --->
  	</div><!---END row --->
  </div><!--END container-->
	<cfinclude template="/components/destinations.cfm">
	<cfinclude template="/components/gulf-coast-guide.cfm">
	<div class="container">
		<div class="row">
  		<div class="col-sm-12 pdp-gulf-coast-activites gcg-southern-perks-callout">  	  		
				<a href="/southern-perks" class=""><div class=""><span class="pdp-gca-heading">SOUTHERN PERKS</span><br><span class="pdp-gca-subheading">Book an Activity</span></div>
        <img src="/images/layout/southern-perks.jpg" class="img-responsive" style="width: 100%;"></a>
  		</div>
		</div>
	</div><!---END container --->
	<div style="margin-bottom: 50px;"></div>
</div><!---END i-content--->