<cfif ICNDeyesOnly> <!--- TEMPORARY UNTIL APPROVED - DO NOT REMOVE --->
<style>
.property-image { text-align: center; }
.property-image>img { width: auto; max-width: 100%; height: 100%; margin: 0 auto; position: relative; }
.property-banner { padding-bottom: 75%; }
.fancybox-navigation .fancybox-button { transform: scale(1.5); }
.fancybox-navigation .fancybox-button--arrow_left { transform-origin: left; }
.fancybox-navigation .fancybox-button--arrow_right { transform-origin: right; }
@media (max-width: 414px) {
  .property-banner { padding-bottom: 75%; }
}
</style>
</cfif>
<cfoutput>
<div id="propertyBanner" class="property-banner">
  <!-- Property Banner -->
  <div id="propertyImage" class="property-image">
    <style>.property-image:before { content: "<cfoutput>#property.name#</cfoutput>"; }</style>
    <cfif property.largePhoto neq "">
    <img src="https://img.trackhs.com/1200x720/#property.largePhoto#" alt="#property.name#">
    <cfelse>
    	<img src="https://img.trackhs.com/1200x720/#photos.original#" alt="#property.name#">
    </cfif>

    <!-- Property Gallery -->
    <div id="hiddenGallery" class="hidden-gallery">
      <cfloop query="#photos#">
	      <a href="https://img.trackhs.com/1200x720/#photos.original#" rel="pdpGallery" data-fancybox="property-images" data-caption="#photos.caption#">
	        <cfif len(caption)>
        		<span class="hidden">#caption#</span>
	        <cfelse>
        		<span class="hidden">#property.name#</span>
	        </cfif>
	      </a>
      </cfloop>
    </div><!-- END hiddenGallery -->
  </div>

  <!-- Property Map -->
  <cfif len(property.latitude) and len(property.longitude)>
  <div id="propertyMap" class="property-map property-iframe">
    <div id="map"></div>
    <!--- <iframe src="https://maps.google.com/maps?q=#property.latitude#,#property.longitude#&ie=UTF8&output=embed" width="100%" height="100%" frameborder="0" style="border:0" allowfullscreen></iframe> --->
  </div>
  </cfif>

<!---
  <cfif getVirtualTour.data neq '' and getVirtualTour.data neq '"' and getVirtualTour.data does not contain 'iframe' and getVirtualTour.data does not contain 'https'>
	  <!-- Property Videos/Virtual Tours -->
	  <div id="propertyTour" class="property-tour property-iframe">
	    <cfset youTubeID = getVirtualTour.data><!-- KEEP OTHER URL PARAMETERS FOR CLEANER VIDEO FRAME -->
	    <iframe id="propertyTourFrame" src="https://www.youtube.com/embed/<cfoutput>#youTubeID#</cfoutput>?rel=0&amp;&amp;showinfo=0&amp;enablejsapi=1" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
	  </div>
  </cfif>
--->
<!---
  <cf_htmlfoot>
    <cfif property.virtualTour neq ''>
      <!--- Do not remove, this is a fix for a bug in Firefox with the iframe Virtual Tour --->
      <style>
        ##myModalFloorPlan.fade { display: block; z-index: -1; }
        ##myModalFloorPlan.fade.in { z-index: 99999; }
      </style>

      <div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalFloorPlanLabel" id="myModalFloorPlan">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header site-color-1-bg text-white">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
              <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
              <div class="TruPlaceEmbedded">
                <iframe class="TruPlaceEmbedded" src="#property.virtualTour#" allowfullscreen></iframe>
              </div>
            </div>
          </div>
        </div>
      </div>
    </cfif>

    <cfif property.videoLink neq ''>
      <div class="modal fade watchvideo" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header site-color-1-bg text-white">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
              <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
              <div class="embed-responsive embed-responsive-16by9">
                <iframe width="560" height="315" src="#property.videolink#" frameborder="0" allowfullscreen></iframe>
              </div>
            </div>
          </div>
        </div>
      </div>
    </cfif>
  </cf_htmlfoot>
--->

  <!--- Favorite Heart --->
  <a href="javascript:;" class="property-list-property-favorite add-to-favs add-to-fav-detail" data-unitcode="#property.propertyid#">
    <i class="fa fa-heart-o overlay" aria-hidden="true"></i>
    <i class="fa fa-heart under<cfif ListFind(cookie.favorites,property.propertyid)> favorited</cfif>" aria-hidden="true"></i>
  </a>

  <div class="banner-btn-wrap">
    <cfif len(property.latitude) and len(property.longitude)><button id="propertyMapBtn" class="btn property-map-btn collapse-btn inactive" type="button"><i class="fa fa-map-marker" aria-hidden="true"></i> <span>View Map</span></button></cfif>
    <button id="propertyGalleryBtn" rel="pdpGallery" data-caption="Pic 1" class="btn property-gallery-btn collapse-btn site-color-2-bg site-color-2-bg-hover text-white inactive" type="button"><i class="fa fa-camera" aria-hidden="true"></i> <span>View Gallery</span></button>
    <!---
		<cfif getVirtualTour.data neq '' and getVirtualTour.data neq '"' and getVirtualTour.data does not contain 'iframe' and getVirtualTour.data does not contain 'https'>
    	<button id="propertyTourBtn" class="btn property-tour-btn collapse-btn inactive" type="button"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>View Tour</span></button>
    </cfif>
		--->
    <!---
    <cfif property.virtualTour neq ''>
      <link rel="stylesheet" href='/rentals/stylesheets/embedded-min.css' type='text/css' />
      <button id="propertyFloorplanBtn" type="button" class="btn collapse-btn site-color-3-lighten-bg site-color-3-bg-hover text-white inactive" data-toggle="modal" data-target="##myModalFloorPlan"><i class="fa fa-home" aria-hidden="true"></i> <span>View Floor Plan</span></button>
    </cfif>
    <cfif property.videolink neq ''>
      <button id="propertyVideoBtn" class="btn collapse-btn site-color-3-lighten-bg site-color-3-bg-hover text-white inactive"  data-toggle="modal" data-target=".watchvideo"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>Watch Video</span></button>
    </cfif>
    --->
    <cfif property.virtualTour neq ''>
      <cfif property.virtualTour contains 'matterport'>
      	<button data-toggle="modal" data-target="##matterPortTours" class="btn property-tour-btn collapse-btn inactive" type="button"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>View Tour</span></button>
      	<cf_htmlfoot>
        <!--- Matterport Modal --->
        <div class="modal fade" id="matterPortTours" tabindex="-1" role="dialog" aria-labelledby="matterPortToursLabel" style="z-index:99999999">
          <div class="modal-dialog" role="document" style="width: auto;max-width:95vw;">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true" style="color:black">&times;</span></button>
                <h4 class="modal-title" id="matterPortToursHeading">Virtual Tour</h4>
              </div>
              <div class="modal-body">
                <div class="embed-responsive embed-responsive-16by9">
                  <iframe class="embed-responsive-item" id="showcase-player" width="100%" height="480" src="#property.virtualTour#" frameborder="0" allowfullscreen allow='xr-spatial-tracking'></iframe>
                </div>
              </div>
            </div>
          </div>
        </div>
      	</cf_htmlfoot>
      <cfelse>
        <script src="https://tour.truplace.com/include/linkwidget.js" type="text/javascript" id="linkwidgetscript"></script>
      	<button onclick="javascript:TourWidget('<cfoutput>#property.virtualTour#</cfoutput>')" class="btn property-tour-btn collapse-btn inactive" type="button"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>View Tour</span></button>
        <!---	<button id="propertyTourBtn" class="btn property-tour-btn collapse-btn inactive" type="button"><i class="fa fa-video-camera" aria-hidden="true"></i> <span>View Tour</span></button> --->
      </cfif>
    </cfif>
  </div>
</div><!-- END propertyBanner -->
</cfoutput>