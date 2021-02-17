      <div class="i-footer-info">
        <cfinclude template="/components/header-info.cfm">
      </div>
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
			      </div><!---END col--->
		    		<div class="col-md-4 col-sm-12 footer-follow">
		          <p class="h4 site-color-1">Follow Us</p>
		          <cfinclude template="/components/footer-social.cfm">
<!--- 			    			<div id="footerformMSG" class="text-white"></div> --->
<!---
		          <form class="i-footer-e-newsletter-form validate" id="footerform">
		            <cfinclude template="/cfformprotect/cffp.cfm">
--->
		          <div class="row i-footer-e-newsletter-form">
			          <p class="site-color-3">Get special offers, vacation inspiration &amp; more</p>
		            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
		              <button id="emailsignupModalBtn" class="btn property-tour-btn inactive" type="button" data-toggle="modal" data-target="#emailsignupModal"><!--- <i class="fa fa-video-camera" style="color: ##a59368;" aria-hidden="true"></i> ---> <span>Sign Up For Our Newsletter</span></button>
					      </div>
		          </div>
<!--- 			       </form> --->
		    		</div><!---END col--->
		  		</div><!---END row--->
		  		<div class="i-baseline site-color-3">
		    		<p>
              &copy; <cfoutput>#dateformat(now(),'YYYY')# <!--- #settings.company# --->Southern Vacation Rentals</cfoutput>
		      		<span class="pull-right">
		  					<cfif isdefined('slug') and slug eq 'index'>
		        		  <a href="http://icoastalnet.com" target="_blank" class="site-color-3">Website Design</a> by InterCoastal Net Designs
		  					<cfelse>
							    Web Design by InterCoastal Net Designs
		            </cfif>
		      		</span>
		    		</p>
		  		</div>
				</div><!---END container--->
			</div><!-- END i-footer -->
			<!---
			<a href="" class="i-chat site-color-1-bg site-color-1-lighten-bg-hover text-white text-white-hover" data-toggle="tooltip" data-placement="top" title="Chat"><i class="fa fa-comment"></i></a>
			--->
		</div><!-- END i-wrapper -->

		<!--- Main Script Calls before all other script calls via <cf_htmlfoot> --->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.4.1/jquery-migrate.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.1/js/bootstrap-select.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js" type="text/javascript"></script>
    <script type="text/javascript">
    $(document).ready(function(){
      // Lazy Load
      if ( $('.lazy').length ) {
        $('.lazy').Lazy();
      }
    });
    </script>
		<cfif isdefined('slug') and slug eq 'index'>
		<cfelse>
		  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/jquery.validate.min.js" type="text/javascript"></script>
		  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.17.0/additional-methods.min.js" type="text/javascript"></script>
		  <script src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.3.5/jquery.fancybox.min.js" type="text/javascript"></script>
		</cfif>
		<cfif isDefined ('slug') and slug eq 'thank-you'>
			<style>
				body.thank-you .i-hero-img-wrap { display: none; }
				body.thank-you .col-lg-9.col-md-8.col-sm-12 { width: 100%; }
				body.thank-you .col-lg-3.col-md-4.col-sm-12 { display: none; }
			</style>
    <cfelse>
    </cfif>
		<style>
    <!---
			.i-header-logo { background: url('/images/layout/25thAnniversaryLogo-355x106.jpg') no-repeat center center; background-size: inherit !important; }
			.i-header-logo-wrap { width: 355px; }
			@media (max-width: 1200px) {
			  .i-header-logo-wrap { width: 347px; }
			}
			@media (max-width: 1100px) {
				.i-header-logo { background: url('/images/layout/25thAnniversaryLogo-311x90.jpg') no-repeat center center; background-size: inherit !important; }
				.i-header-logo-wrap { width: 311px; }
			}
			@media (max-width: 992px) {
				.i-header-logo { background: url('/images/layout/25thAnniversaryLogo-258x78.jpg') no-repeat center center; background-size: inherit !important; }
			  .i-header-logo-wrap { width: 258px; padding-bottom: 78px; }
			}
      --->
			@media (max-width: 480px) {
			  .i-social-item a { width: 28px; }
			}
			@media (max-width: 320px) {
				.i-social-item { display: block; }
				.i-social-item a { height: 25px; background: none; }
				.i-header ul.i-social { top: 6px; right: 9px; }
			}
			div#emailsignupModal .modal-dialog { width: 600px; width: 63%; }
			.i-footer-e-newsletter-form .btn { color: #9e9e9e; padding: 11px; text-align: center; display: block; width: 100%; background: #e2e2e2; margin-top: 2px; }
			div#emailsignupModal .modal-content { padding: 12px; }
			div#emailsignupModal .modal-content .modal-body { margin: 12px; }
			.modal-body img { width: 51%; float: left; margin-right: 4%; }
    </style>

		<cf_htmlfoot output="true" />
		<!-- Only show modal on homepage if cookie.showhomepagemodal does not exist (expires in 30 days) -->
<!---
		<cfif isdefined('page.slug') and page.slug eq 'index' and !StructKeyExists(cookie,'showhomepagemodal')>
			<script type="text/javascript">
				$(document).ready(function(){
					setTimeout(function(){
					$("#emailPopup").fadeIn('slow');
						},30000);
						$('body').addClass('email-popup-open');
						$('#emailPopup .close').click(function(){
						$('#emailPopup').fadeOut('slow').hide();
						$('body').removeClass('email-popup-open');
						$.ajax({
							url: '/set-modal-cookie.cfm',
							success: function(data) {
							  //nuthin
							}
						});
					});
				});
			</script>
		</cfif>
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
								<form action="" method="post" id="newsletterform">
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

		<cfinclude template="/components/footer-javascripts.cfm">

		<!--- Global.js made last on Purpose --->
		<cfif not isDefined("request.destination")>
		  <script src="/javascripts/global.js?v=1.0.1"></script>
		</cfif>


<!---
		<cfif CGI.REMOTE_ADDR eq "216.99.119.254">
--->


<script type="text/javascript">
$(function(){
  $('#emailsignupModalBtn').click(function(){
    if(!$('#iframe').length) {
      $('#iframeHolder').html('<iframe width="100%" height="580" src="//1b3a3f-3036.icpage.net/southern-website-sign-up" frameborder="0"></iframe>');
    }
  });
});
</script>

		<div id="emailsignupModal" class="modal fade in">
			<div class="modal-dialog">
				<div class="modal-content">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<div class="modal-body">
						<div class="row">
							<div class="col-xs-12">
								<div class="embed-responsive embed-responsive-16by9">


									<div id="iframeHolder">
<!--- 									<iframe width="100%" height="580" class="lazy" data-src="" frameborder="0"></iframe> --->
									</div>


                </div>
							</div><!--END col-->
						</div><!--END row-->
					</div><!--END modal-body-->
				</div><!--END modal-content-->
			</div><!--END modal-dialog-->
		</div><!--END modal-->


<!---


		<cfelse>



		<div id="emailsignupModal" class="modal fade in">
			<div class="modal-dialog">
				<div class="modal-content">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<div class="modal-body">
						<div class="row">
							<div class="col-xs-12">
								<div class="embed-responsive embed-responsive-16by9">
									<iframe width="100%" height="580" class="lazy" data-src="//1b3a3f-3036.icpage.net/southern-website-sign-up" frameborder="0"></iframe>
                </div>
							</div><!--END col-->
						</div><!--END row-->
					</div><!--END modal-body-->
				</div><!--END modal-content-->
			</div><!--END modal-dialog-->
		</div><!--END modal-->


		</cfif>


--->
<cfif !isdefined('cookie.popupFormViewed')>
	<cfif ListFind('216.99.119.254', CGI.REMOTE_ADDR)>*******</cfif>
  <cfif isdefined('page.slug') and page.slug neq "index">
    <script type="text/javascript">
    $(document).ready(function(){
      function openPopupLeadForm(){
        $('#iContactModal').modal('show');
      }
      setTimeout(openPopupLeadForm, 3000);
      $('#iContactModal').on('hidden.bs.modal',function(){
        $.ajax({
          url : "/components/set-popup-cookie.cfm",
          type: "POST",
          success: function(data) {}
        });
      });
    });
    </script>
    <div id="iContactModal" class="modal fade in">
      <div class="modal-dialog">
        <div class="modal-content">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <div class="modal-body">
            <div class="row">
              <div class="col-xs-12">
                <div class="embed-responsive">
                  <iframe class="embed-responsive-item" src="https://1b3a3f-3036.icpage.net/email-pop-up"/>
                </div>
              </div><!---END col--->
            </div><!---END row--->
          </div><!---END modal-body--->
        </div><!---END modal-content--->
      </div><!---END modal-dialog--->
    </div><!---END modal--->
  </cfif>
</cfif>

		<script language="javascript">
		// OWL CAROUSEL
		  if ($('.owl-carousel').length) {
		    // HP CALLOUTS SLIDER
		    if ($('.owl-carousel.home-callouts').length) {
			    $(function(){
			      $('.owl-carousel.home-callouts').on('initialized.owl.carousel translate.owl.carousel', function(e){
			        idx = e.item.index;
			        $('.owl-carousel.home-callouts .owl-item.activeSlide').removeClass('activeSlide');
			        $('.owl-carousel.home-callouts .owl-item.prev').removeClass('prev');
			        $('.owl-carousel.home-callouts .owl-item.next').removeClass('next');
			        $('.owl-carousel.home-callouts .owl-item').eq(idx).addClass('activeSlide');
			        $('.owl-carousel.home-callouts .owl-item').eq(idx-1).addClass('prev');
			        $('.owl-carousel.home-callouts .owl-item').eq(idx+1).addClass('next');
			        $(".owl-item.activeSlide .customPrevBtn span").html('');
			        $(".owl-item.activeSlide .customNextBtn span").html('');
			        $(".owl-item.activeSlide .customPrevBtn span").html($('.owl-item.prev a.southern-btn span').html());
			        $(".owl-item.activeSlide .customNextBtn span").html($('.owl-item.next a.southern-btn span').html());
			      });
			      $('.owl-carousel.home-callouts').owlCarousel({
			        items: 1, autoplay: false, autoplayTimeout: 5000, smartSpeed: 1000, lazyLoad: true, loop: true, animateIn: 'fadeIn', animateOut: 'fadeOut'
			      });
			      var owl = $('.owl-carousel.home-callouts');
			      $('.customNextBtn').click(function() {
						   owl.trigger('next.owl.carousel');
						})
						// Go to the previous item
						$('.customPrevBtn').click(function() {
					    // With optional speed parameter
					    // Parameters has to be in square bracket '[]'
					    owl.trigger('prev.owl.carousel', [300]);
						})
					});
				}
		  }
		</script>
		<cfif isdefined('page.slug') and page.slug eq "index">
			<div class="results-loader-overlay" style="display: none;">
	      <div class="cssload-container">
	        <div class="cssload-tube-tunnel"></div>
	      </div>
	    </div>
	    <!---THIS CODE IS COPIED FROM THE RESULTS PAGE, BUT IT"S ONLY NEEDED ON THE HOMEPAGE IN THIS INSTANCE--->
	    <style>
		    /* CSS Loading Container */
				.cssload-container { width: 60px; height: 60px; margin: 0 auto; padding: 20px; box-sizing: content-box; }
				/* CSS Loading Animation Tube */
				.cssload-tube-tunnel { width: 100%; height: 100%; margin: 0 auto; border: 3px solid #444; border-radius: 50%; -o-animation: cssload-scale 1.1s infinite linear; -ms-animation: cssload-scale 1.1s infinite linear; -webkit-animation: cssload-scale 1.1s infinite linear; -moz-animation: cssload-scale 1.1s infinite linear; animation: cssload-scale 1.1s infinite linear; }
				@-o-keyframes cssload-scale{ 0% { -o-transform:scale(0); transform:scale(0) } 90%{ -o-transform:scale(0.7); transform:scale(0.7) } 100%{ -o-transform:scale(1); transform:scale(1) } }
				@-ms-keyframes cssload-scale{ 0%{ -ms-transform:scale(0); transform:scale(0) }90%{ -ms-transform:scale(0.7); transform:scale(0.7) }100%{ -ms-transform:scale(1); transform:scale(1) } }
				@-webkit-keyframes cssload-scale{ 0%{ -webkit-transform:scale(0); transform:scale(0) }90%{ -webkit-transform:scale(0.7); transform:scale(0.7) }100%{ -webkit-transform:scale(1); transform:scale(1) } }
				@-moz-keyframes cssload-scale{ 0%{ -moz-transform:scale(0); transform:scale(0) }90%{ -moz-transform:scale(0.7); transform:scale(0.7) }100%{ -moz-transform:scale(1); transform:scale(1) } }
				@keyframes cssload-scale { 0%{ transform:scale(0) }90%{ transform:scale(0.7) }100%{ transform:scale(1) } }
				/* CSS Loading Animation Spinner */
				.cssload-spinner,
				.cssload-spinner:after { width: 100%; height: 100%; border-radius: 50%; }
				.cssload-spinner { position: relative; border: 6px solid rgba(0,0,0,0.35); border-left: 6px solid #444; -o-transform: translateZ(0); -webkit-transform: translateZ(0); -moz-transform: translateZ(0); -ms-transform: translateZ(0); transform: translateZ(0); -o-animation: cssload-wheel 1.1s infinite linear; -ms-animation: cssload-wheel 1.1s infinite linear; -webkit-animation: cssload-wheel 1.1s infinite linear; -moz-animation: cssload-wheel 1.1s infinite linear; animation: cssload-wheel 1.1s infinite linear; }
				@-o-keyframes cssload-wheel { 0% { -o-transform: rotate(0deg); transform: rotate(0deg); } 100% { -o-transform: rotate(360deg); transform: rotate(360deg); } }
				@-webkit-keyframes cssload-wheel { 0% { -ms-transform: rotate(0deg); transform: rotate(0deg); } 100% { -ms-transform: rotate(360deg); transform: rotate(360deg); } }
				@-webkit-keyframes cssload-wheel { 0% { -webkit-transform: rotate(0deg); transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); transform: rotate(360deg); } }
				@-moz-keyframes cssload-wheel { 0% { -moz-transform: rotate(0deg); transform: rotate(0deg); } 100% { -moz-transform: rotate(360deg); transform: rotate(360deg); } }
				@keyframes cssload-wheel { 0% { -webkit-transform: rotate(0deg); transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); transform: rotate(360deg); } }
				.results-loader-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 999999; background: rgba(0,0,0,0.5); }
				.results-loader-overlay .cssload-container { position: absolute; top: 50%; left: 50%; -webkit-transform: translate(-50%,-50%); -moz-transform: translate(-50%,-50%); -ms-transform: translate(-50%,-50%); -o-transform: translate(-50%,-50%); transform: translate(-50%,-50%); }
				.results-loader-overlay .cssload-tube-tunnel { width: 50px; height: 50px; border-color: #fff; }
			</style>
			<script type="text/javascript">
			  $('.quick-search-submit').click(function(){
				  $('.results-loader-overlay').fadeIn(200);
				});
			</script>
		<cfelse>
		  <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script>
		</cfif>
		<cfif fileExists(ExpandPath('/components/cart-abandonment-footer.cfm'))>
			<cfinclude template="/components/cart-abandonment-footer.cfm">
		</cfif>
		<script type="text/javascript">
		  (function(){
		    var c = function() {
		      var track = new Track('svr', 'trackphone');
		      track.track();
		    };
		    var t = document.createElement('script');t.type = 'text/javascript'; t.src = '//cdn.trackhs.com/tracking/tracking.js';
		    t.onload = t.onreadystatechange = function() { var state = s.readyState; if(!c.done && (!state || /loaded|complete/.test(state))){c.done = true; c()} };
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t,s);
		  }());
		</script>
		<!---
		<script type="text/javascript" defer>window.$trChatSettings = {title: "Southern Vacation Rentals Chat", color: "#0B3736", welcome: "Would you like to chat with us today?", away: "We are sorry, there are no available agents to chat at this time.  We will use your contact information to get back to you as soon as possible.", goodbye: "Thank you for chatting with us.  We look forward to helping you again in the future.", hiddenOnStart: false, brand: 1, domain: "svr"};
    	window.$trChat || (function(){
        var t = document.createElement('script'); t.type = 'text/javascript'; t.async = true; t.src = '//chat.trackhs.com/chat/track-webchat-boot.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t, s);
      }());
	  </script>
		--->

  </body>
</html>