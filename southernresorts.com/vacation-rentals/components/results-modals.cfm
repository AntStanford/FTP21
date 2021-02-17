<!--- Specials Modal (Shared) --->
<div class="modal fade" id="specialModal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-body">
        <div class="special-modal-info">
          <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
          <div id="specialModalContent"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<cfif isdefined('getCmsResort.videoLink') and getCmsResort.videoLink neq ''>
	<!-- VR Tour Modal -->
	<div class="modal fade vr-tour-modal" id="ResortVidModal" tabindex="-1" role="dialog" aria-labelledby="ResortVidModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <!-- Property Videos/Virtual Tours -->
				<div id="propertyTour" class="property-tour property-iframe info-wrap">
	        <iframe src="<cfoutput>#getCmsResort.videoLink#</cfoutput>" width="100%" height="100%" frameborder="0" style="border:0" allowfullscreen></iframe>
				</div>
	    </div>
	  </div>
	</div>
</cfif>
