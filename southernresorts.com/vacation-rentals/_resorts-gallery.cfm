<!---
<cfquery name="getResortPhotos" dataSource="#settings.dsn#">
  select *
  from cms_assets
  where section = 'Resorts' and foreignKey = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getResort.id#">
  order by sort
</cfquery>
--->
<div class="pdp-gallery-inner-wrap">

<cfquery name="getResortPhotos" dataSource="#settings.dsn#">
   SELECT * FROM southernresorts.track_nodes_images where nodeid = #getResort.Id#
</cfquery>

<div class="owl-gallery-wrap owl-resorts-gallery-wrap">
  <div class="cssload-container"><div class="owl-gallery-loader-tube-tunnel"></div></div>
  <div class="owl-carousel owl-theme resorts-carousel">
    <cfoutput query="getResortPhotos">
      <div class="item">
        <div class="resort-gallery-img">
	        <a href="https://img.trackhs.com/1200x900/#original#" class="fancybox" data-fancybox="owl-gallery-group">
	          <img class="owl-lazy" data-src="https://img.trackhs.com/1200x900/#original#" alt="#name#">
	        </a>
        </div>
        <div class="resort-caption">#name#</div>
      </div>
    </cfoutput>
  </div>
</div>

<cfif isdefined('getCmsResort.videolink') and getCmsResort.videolink neq ''>
  	<button id="propertyVRTourBtn" class="btn property-tour-btn collapse-btn inactive" type="button" data-toggle="modal" data-target="#ResortVidModal"><i class="fa fa-video-camera" style="color: #a59368;" aria-hidden="true"></i> <span>View Video</span></button>
  	<cfelse>
  </cfif>
</div><!-- END pdp-gallery-inner-wrap -->