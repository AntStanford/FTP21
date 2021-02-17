<cfparam name="url.slug" default="">

<cfquery name="getNodeInfo" dataSource="#settings.dsn#">
SELECT id, name, shortDescription, longDescription, typeName
FROM track_nodes
WHERE seoFriendlyURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.slug#">
      AND typeName IN ('Neighborhood','Building / Complex')
      AND seoFriendlyURL IS NOT NULL 
      AND seoFriendlyURL <> ''
</cfquery>

<cfif getNodeInfo.RecordCount EQ 1>
  <cfquery name="getNodePhotos" dataSource="#settings.dsn#">
  SELECT name, original
  FROM track_nodes_images
  WHERE nodeId = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getNodeInfo.id#">
  ORDER BY `order`
  </cfquery>

  <cfquery name="getNodeAmenities" dataSource="#settings.dsn#">
  SELECT amenityGroupName, amenityName
  FROM track_nodes_amenities
  WHERE nodeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getNodeInfo.id#">
  ORDER BY amenityGroupName, amenityName
  </cfquery>

  <cfif getNodeInfo.typeName EQ "Neighborhood">
		<cfset form.camefromsearchform = ''>
    <cfset form.fieldnames = 'neighborhoods'>
 		<cfset form.neighborhoods = getNodeInfo.id>
  <cfelse>
		<cfset form.camefromsearchform = ''>
    <cfset form.fieldnames = 'buildingComplex'>
 		<cfset form.buildingComplex = getNodeInfo.id>
  </cfif>

  <cfsavecontent variable="request.resortContent">
    <h1><cfoutput>#getNodeInfo.name#</cfoutput></h1>

    <div class="owl-gallery-wrap owl-resorts-gallery-wrap">
      <div class="cssload-container"><div class="owl-gallery-loader-tube-tunnel"></div></div>
      <div class="owl-carousel owl-theme resorts-carousel">
        <cfoutput query="getNodePhotos">
          <div class="item">
            <a href="#getNodePhotos.original#" class="fancybox" data-fancybox="owl-gallery-group">
              <img class="owl-lazy" data-src="#getNodePhotos.original#" alt="#getNodePhotos.name#">
            </a>
          </div>
        </cfoutput>
      </div>
    </div>

    <cfoutput>
      <div class="resorts-info-wrap">
        <p>#getNodeInfo.shortDescription#</p>
        <p>#getNodeInfo.longDescription#</p>
      </div><!-- END resorts-info-wrap -->
    </cfoutput>

    <div class="resorts-listed-wrap">
      <div class="container">
        <cfoutput query="getNodeAmenities" group="amenityGroupName">
          <div class="list-group">
          	<h3>#getNodeAmenities.amenityGroupName#</h3>
            <ul>
      			<cfoutput>
      				<li>#getNodeAmenities.amenityName#</li>
      			</cfoutput>
            </ul>
          </div>
    		</cfoutput>
      </div>
    </div>

  </cfsavecontent>
</cfif>
<cfinclude template="/#settings.booking.dir#/results.cfm">
