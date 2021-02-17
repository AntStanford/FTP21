		<!--- RESULTS PAGE ONLY --->
		<cfif cgi.script_name eq '/destination-page.cfm' OR cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR cgi.script_name eq '/layouts/special.cfm' OR cgi.script_name eq '/#settings.booking.dir#/customSearchLayout.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/rentals/special-layout.cfm')>

		  <style>
			.booking-footer-wrap {padding: 4px 0;}
<!---
		  .i-header-logo { background: url('/images/layout/25thAnniversaryLogo-247x70.jpg') no-repeat center center; background-size: inherit !important; }
			.i-header-logo-wrap { width: 286px; padding-bottom: 85px; }
			.i-header-logo-wrap { width: 247px; padding-bottom: 70px; }
--->
			@media (max-width: 320px) {
				span.show-results-mobile { display: block !important; top: 12px; position: fixed;  z-index: 99999; left: 51px; }
				.i-header span.show-results-mobile ul.i-social { top: 53px; left: 0;  display: block; z-index: 99999; top: auto; right: auto; left: auto; }
				.i-header .i-header-navigation span.show-results-mobile ul.i-social li { display: inline-block; }
				.i-header span.show-results-mobile ul.i-social { display: block; position: relative; top: -14px; right: auto; left: 129px; z-index: 99999; }
		    .i-header .i-header-navigation span.show-results-mobile ul.i-social, .i-header .i-header-navigation span.show-results-mobile ul.i-social li i, .i-header .i-header-navigation span.show-results-mobile ul.i-social li a { background: none !important; }
				.i-header-logo-wrap+.i-social { display: none; }
				.booking-footer-wrap { position: relative; }
		    .i-social-item a .fa { color: #ffffff; }
		    .i-header-favorites.i-header-actions { right: -9px; top: 31px; }
		    .i-header .i-header-navigation span.show-results-mobile ul.i-social li a { padding: 16px 14px; }
		    .i-social-item a { width: 23px; }
		    .i-header span.show-results-mobile ul.i-social { left: 120px; }
			}
			</style>

		  <div class="booking-footer-wrap
		    <cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm' OR (isdefined('page.partial') and page.partial eq 'results.cfm') OR (StructKeyExists(request,'resortContent')) OR (isdefined('page') and page.isCustomSearchPage eq 'Yes') OR (cgi.script_name eq '/layouts/special.cfm')>
		      results-footer-wrap
		    <cfelseif cgi.script_name eq '/#settings.booking.dir#/property.cfm'>
		      property-footer-wrap
		    <cfelseif cgi.script_name eq '/#settings.booking.dir#/compare-favs.cfm'>
		      compare-footer-wrap
		    <cfelseif cgi.script_name eq '/#settings.booking.dir#/book-now.cfm'>
		      booknow-footer-wrap
		    <cfelseif cgi.script_name eq '/#settings.booking.dir#/book-now-confirm.cfm'>
		      booknow-confirm-footer-wrap
		    </cfif> site-color-1-bg">
		    <cfoutput>
		      <ul class="booking-footer-quick-links">
		        <li class=""><a href="tel:#settings.phone#"><i class="fa fa-phone"></i><!--- <span class="trackphone">#settings.phone#</span> ---></a></li>
		        <li><a href="/contact"><i class="fa fa-envelope"></i><span>Get In Touch</span></a></li>
		      </ul>
		      <span class="booking-footer-copyright">
		        <span>Copyright &copy; #dateformat(now(),'YYYY')# <a href="">#settings.company#</a>.</span> All Rights Reserved.
		      </span>
		    </cfoutput>
		  </div><!-- END booking-footer-wrap -->
		</div><!-- END wrapper -->
	  <!---END RESULTS ONLY--->

<cfelse>

  <a id="footerAnchor" style="height: 1px;"></a>
	<div class="i-footer">
		<div class="container">
  		<div class="row">
    		<div class="col-md-4 col-sm-6">
          <p class="h4 site-color-1">Good To Know</p>
          <ul class="i-footer-links">
	          <cfquery name="getFooterLinks" dataSource="#settings.dsn#">
    					select * from cms_pages where showInFooter = 'Yes' order by sort
    				</cfquery>
    				<cfif getFooterLinks.recordcount gt 0>
    					<cfoutput query="getFooterLinks">
    						<cfif len(getFooterLinks.externalLink)>
    							<li><a href="#getFooterLinks.externalLink#" class="site-color-3" target="_blank">#getFooterLinks.name#</a></li>
    						<cfelse>
    							<li><a href="/#getFooterLinks.slug#" class="site-color-3">#getFooterLinks.name#</a></li>
    						</cfif>
    					</cfoutput>
    				</cfif>
          </ul>
    		</div>
    		<div class="col-md-4 col-sm-6">
          <p class="h4 site-color-1">Our Vision</p>
          <p class="i-footer-vision site-color-3">To be the most caring company along the Gulf Coast.</p>
	      </div>
    		<div class="col-md-4 col-sm-12  footer-follow">
          <p class="h4 site-color-1">Follow Us</p>
          <cfinclude template="/components/footer-social.cfm">
    			<div id="footerformMSG" class="text-white"></div>
          <form class="i-footer-e-newsletter-form validate" id="footerform">
            <cfinclude template="/cfformprotect/cffp.cfm">
            <div class="row">
	            <p class="site-color-3">Get special offers, vacation inspiration &amp; more</p>
              <div class="col-xs-12">
	              <button id="emailsignupModalBtn" class="btn property-tour-btn inactive" type="button" data-toggle="modal" data-target="#emailsignupModal"> <span>Sign Up For Our Newsletter</span></button>
						  </div>
            </div>
          </form>
    		</div>
  		</div>
  		<div class="i-baseline site-color-3">
    		<p>
          <!--- Copyright  --->&copy; <cfoutput>#dateformat(now(),'YYYY')# <!--- #settings.company# --->Southern Vacation Rentals</cfoutput><!--- All Rights Reserved. --->
      		<span class="pull-right">
  					<cfif isdefined('slug') and slug eq 'index'>
        		  <a href="http://icoastalnet.com" target="_blank" class="site-color-3">Website Design</a> by InterCoastal Net Designs
  					<cfelse>
					    Web Design by InterCoastal Net Designs
            </cfif>
      		</span>
    		</p>
  		</div>
		</div>
	</div><!-- END i-footer -->
	<!---
	<a href="" class="i-chat site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover" data-toggle="tooltip" data-placement="top" title="Chat"><i class="fa fa-comment"></i></a>
	--->
	</div><!-- END i-wrapper -->

  <!--- Output all scripts here --->


  <!--- <cfif CGI.REMOTE_ADDR eq "173.93.73.19" or CGI.REMOTE_ADDR eq "96.10.119.187" or CGI.REMOTE_ADDR eq "216.99.119.254"> --->
  	<style>
<!---
  	.i-header-logo { background: url('/images/layout/25thAnniversaryLogo-247x70.jpg') no-repeat center center; background-size: inherit !important; }
  	.i-header-logo-wrap { width: 286px; padding-bottom: 85px; }
  	.i-header-logo-wrap { width: 247px; padding-bottom: 70px; }
--->
  	@media (max-width: 320px) {
  		.i-social-item { display: block; }
  		.i-social-item a { height: 25px; background: none; }
  		.i-header ul.i-social { right: 9px; top: 2px; margin: 0px 0 0; }
  	}

    </style>
  <!---
  <cfelse>
  </cfif>
  --->

</cfif>

<style>
	div#emailsignupModal .modal-dialog { width: 63%; }
  .i-footer-e-newsletter-form .btn { color: #9e9e9e; padding: 11px; text-align: center; display: block; width: 100%; background: #e2e2e2; margin-top: 2px; }
	div#emailsignupModal .modal-content { padding: 12px; }
	div#emailsignupModal .modal-content .modal-body { margin: 12px; }
</style>

<!---
				<div id="emailPopup" class="modal fade in">
					<div class="modal-dialog">
						<div class="modal-content">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<div class="modal-body">
								<div class="row">
									<div class="col-xs-12 col-sm-7">
										<img src="/images/layout/email-popup.jpg">
									</div>
									<div class="col-xs-12 col-sm-5">
										<p class="h2">Never Miss a Thing</p>
										<p>Simply register below to receive our monthly newsletter the "Southern Scoop" featuring our own coastal recipes, Beach DIY, Gulf Coast events, exclusive offers, and access to all of our currently available specials!</p>
										<div id="contactformMSG"></div>
										<form action="" method="post" id="contactform">
											<input type="hidden" name="modalform">
											<cfinclude template="/cfformprotect/cffp.cfm">
					<!--- 						<input type="text" placeholder="Enter your email address to sign up..." name="email" id="fieldEmail" name="cm-pkildt-pkildt" type="email" required> --->
					            <div class="form-group col-xs-12 col-md-6">
			<!--- 		              <label for="firstname">First Name *</label> --->
					            <input id="firstname" name="firstname" type="text" class="form-control required" placeholder="First Name">
					            </div>
					            <div class="form-group col-md-6">
			<!--- 		              <label for="lastname">Last Name *</label> --->
					              <input id="lastname" name="lastname" type="text" class="form-control required" placeholder="Last Name">
					            </div>
			<!---
					            <div class="form-group col-md-6">
					              <label for="phone">Phone</label>
					              <input id="phone" name="phone" type="text" class="form-control">
					            </div>
			--->
					            <div class="form-group col-xs-12">
			<!--- 		              <label for="email">Email *</label> --->
					              <input id="email" name="email" type="text" class="form-control required" placeholder="Email">
					            </div>
											<button type="submit" class="btn">Submit</button>
										</form>
									</div><!--END col-->
								</div><!--END row-->
							</div><!--END modal-body-->
						</div><!--END modal-content-->
					</div><!--END modal-dialog-->
				</div><!--END modal-->
--->

				<cf_htmlfoot output="true" />

				<cfinclude template="footer-javascripts.cfm">
				<!--- Shared.js is a Shared Sitewide JS file
				<script src="/javascripts/shared.js" defer></script>--->
				<!--- global.js made last on Purpose --->
				<script src="/<cfoutput>#settings.booking.dir#</cfoutput>/javascripts/global.js?v=3" defer></script>

				<cfif cgi.script_name eq '/#settings.booking.dir#/results.cfm'>
	      <cfelse>
					<div id="emailsignupModal" class="modal fade in">
						<div class="modal-dialog">
							<div class="modal-content">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
								<div class="modal-body">
									<div class="row">
										<div class="col-xs-12">
											<div class="embed-responsive embed-responsive-16by9">
	                      <iframe width="100%" height="580" src="//1b3a3f-3036.icpage.net/southern-website-sign-up" frameborder="0"></iframe>
	                    </div>
										</div><!--END col-->
									</div><!--END row-->
								</div><!--END modal-body-->
							</div><!--END modal-content-->
						</div><!--END modal-dialog-->
					</div><!--END modal-->
				</cfif>
				<!---
			<cfif (cgi.script_name neq '/#settings.booking.dir#/book-now.cfm')>
			  <script type='text/javascript' data-cfasync='false'>window.purechatApi = { l: [], t: [], on: function () { this.l.push(arguments); } }; (function () { var done = false; var script = document.createElement('script'); script.async = true; script.type = 'text/javascript'; script.src = 'https://app.purechat.com/VisitorWidget/WidgetScript'; document.getElementsByTagName('HEAD').item(0).appendChild(script); script.onreadystatechange = script.onload = function (e) { if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) { var w = new PCWidget({c: '39a326f0-b492-4ca1-bedc-abbeb53a1325', f: true }); done = true; } }; })();</script>
			</cfif>
			--->
	</body>
</html>