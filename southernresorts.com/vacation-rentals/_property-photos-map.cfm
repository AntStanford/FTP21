<cfoutput>
<div class="property-banner-wrap">
    <div id="propertyBanner" class="property-banner">
        <cfif isDefined('getConstructLabel') and getConstructLabel.recordcount gt 0>
          <style>
          .pdp-body ##homepage-announcement { margin-bottom: 0; }
          .alert-construction-label { margin: 0; position: relative; overflow: hidden; }
          .alert-construction-label:before,
          .alert-construction-label:after { content: ""; display: block; padding: 20px; width: 200px; background: rgb(138 109 59 / 0.25); position: absolute; top: 0; left: -30px; transform: rotate(-45deg); }
          .alert-construction-label:after { left: 50px; }
          .alert-construction-label .fa,
          .alert-construction-label .fa + p { display: inline-block; }
          </style>
          <div class="alert alert-warning text-center alert-construction-label">
            <i class="fa fa-exclamation-triangle" aria-hidden="true"></i>
            #getConstructLabel.label#
          </div>
        </cfif>
      <!-- Property Banner -->
      <div id="propertyImage" class="property-image">
        <div class="owl-gallery-wrap">
          <div class="owl-gallery-loader-container"><div class="owl-gallery-loader-tube-tunnel"></div></div>
	          <div class="pdp-gallery-inner-wrap">
	          <div class="owl-carousel owl-theme owl-gallery pdp-gallery">
	            <cfloop query="#photos#">
		            <div class="item">
				          <div class="employee-img">
					          <div class="pdp-gallery-img" style="background: url('https://img.trackhs.com/1200x900/#photos.original#')"></div>
<!--- 					          <div class="pdp-gallery-img" style="background: url('https://d2epyxaxvaz7xr.cloudfront.net/#photos.original#')"></div> --->
					          <!---<img src="https://d2epyxaxvaz7xr.cloudfront.net/1000x900/#photos.original#" alt="Employee Name"> --->
				          </div>
				          <div class="employee-info">
					          <h4>#caption#</h4>
					        </div>
				        </div>
	<!---
	              <div class="item">
	                <a href="https://d2epyxaxvaz7xr.cloudfront.net/1000x900/#photos.original#" class="fancybox" data-fancybox="owl-gallery-group">
	                  <div class="owl-lazy" data-src="https://d2epyxaxvaz7xr.cloudfront.net/1000x900/#photos.original#"></div>
	                  <!--- <span class="owl-caption">#photos.caption#</span> --->
	                </a>
	              </div>
	--->
	            </cfloop>
	          </div><!-- END owl-gallery -->

	          <cfif isdefined('property.virtualtour') and property.virtualtour neq ''>
			      	<button id="propertyVRTourBtn" class="btn property-tour-btn collapse-btn inactive" type="button" data-toggle="modal" data-target="##vrTourModal"><i class="fa fa-video-camera" style="color: ##a59368;" aria-hidden="true"></i> <span>View Virtual Tour</span></button>
			      </cfif>
			      <cfif isdefined('property.videoLink') and property.videoLink neq ''>
			      	<button id="propertyVRTourBtn" class="btn property-tour-btn collapse-btn inactive" type="button" data-toggle="modal" data-target="##propVidModal"><i class="fa fa-video-camera" style="color: ##a59368;" aria-hidden="true"></i> <span>View Video</span></button>
			      </cfif>
	        </div><!-- END pdp-gallery-inner-wrap -->
          <div class="owl-carousel owl-theme owl-gallery-thumbs">
            <cfloop query="#photos#">
              <div class="item">
                <div class="owl-lazy" data-src="https://img.trackhs.com/148x111/#photos.thumbnail#"></div>
              </div>
            </cfloop>
          </div><!-- END owl-gallery-thumbs -->
        </div><!-- END owl-gallery-wrap -->
        <!-- Property Gallery -->
<!---
        <div id="hiddenGallery" class="hidden-gallery">
          <cfloop query="#photos#">
            <a href="#photos.original#" rel="pdpGallery" data-fancybox="property-images" data-caption="#photos.caption#">
              <cfif len(caption)>
                <img src="#photos.thumbnail#" alt="#caption#">
              <cfelse>
                <img src="#photos.thumbnail#" alt="#property.name# | Photo ">
              </cfif>
            </a>
          </cfloop>
        </div>
---><!-- END hiddenGallery -->
      </div><!-- END property-image -->
      <!-- Property Map -->
<!---       <cfif len(property.latitude) and len(property.longitude)> --->
<!---       <div id="propertyMap" class="property-map property-iframe"> --->
        <!--- <div id="map"></div> --->
<!---
        <iframe src="https://maps.google.com/maps?q=#property.latitude#,#property.longitude#&ie=UTF8&output=embed" width="100%" height="100%" frameborder="0" style="border:0" allowfullscreen></iframe>
      </div>
--->
<!---       </cfif> --->

<!---
      <cfif isdefined('propertyEnhacements.virtualreality') and propertyEnhacements.virtualreality neq '' and len(propertyEnhacements.virtualreality) gt 20>
    	  <div id="propertyTour" class="property-tour property-iframe">
          <iframe src="<cfoutput>#propertyEnhacements.virtualreality#</cfoutput>?rel=0&showinfo=0&enablejsapi=1" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
        </div>
      </cfif>
--->
      <!--- Favorite Heart --->
<!---
      <a href="javascript:;" class="property-list-property-favorite add-to-favs add-to-fav-detail" data-unitcode="#property.propertyid#" <cfif isdefined('cookie.GuestFocusLoggedInID')>data-guestfocus="loggedin"<cfelse>data-guestfocus="loggedout"</cfif>>
        <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
        <i class="fa fa-heart under<cfif ListFind(cookie.favorites,property.propertyid)> favorited</cfif>" aria-hidden="true"></i>
      </a>
    </div>
---><!-- END propertyBanner -->
<!---
    <div class="banner-btn-wrap">
      <cfif len(property.latitude) and len(property.longitude)><button id="propertyMapBtn" class="btn property-map-btn collapse-btn inactive" type="button"><i class="fa fa-map-marker" aria-hidden="true"></i> <span>View Map</span></button></cfif>
      <button id="propertyGalleryBtn" rel="pdpGallery" data-caption="Pic 1" class="btn property-gallery-btn collapse-btn site-color-2-lighten-bg site-color-2-bg-hover text-white inactive" type="button"><i class="fa fa-camera" aria-hidden="true"></i> <span>View Gallery</span></button>
      <cfif len(propertyEnhacements.virtualtourlink)>
      	<button id="propertyVRBtn" class="btn property-vr-btn collapse-btn inactive" type="button"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>View 3D Tour</span></button>
      </cfif>--->
<!---       <cfif len(propertyEnhacements.virtualreality) and len(propertyEnhacements.virtualreality) gt 20> --->

   <!--- </div>
  </div>
---><!-- END property-banner-wrap -->
    </div><!-- END property-banner -->
  </div><!-- END property-banner-wrap -->
</cfoutput>