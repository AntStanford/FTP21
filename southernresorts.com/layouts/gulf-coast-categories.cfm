<cfquery name="getCategory" dataSource="#settings.dsn#">
	select * from cms_thingstodo_categories where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#dest#">
</cfquery>
<!--- Query all Destinations to loop over later --->

<cfinclude template="/components/header.cfm">
	<cfquery name="getDestinations" datasource="#settings.dsn#">
	SELECT ID, Title, bannerImage, nodeid, slug, exploreStaysSlug, vacationBanner FROM cms_destinations where slug = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#slug#">
</cfquery>
		
<style>
.row.pdp-experience p.h1 {text-align: left;}
.experience-listings {margin: 0 35px;}
.i-quick-search {display: none;}	
.experience-listings .h4 { font-family: 'Playfair Display', serif !important; font-weight: 400 !important; /* text-shadow: 0px 2px 5px rgb(44, 44, 44); */ margin-top: 0 !important; font-size: 21px !important; line-height: 27px !important; letter-spacing: 1px; }
.pdp-callout-text:after { content: ""; width: 100%; display: block; height: 3px; background: #b39a60; margin-top: 18px; }
.pdp-callout-text { text-align: center; margin-top: 3px; padding: 0 15px; }
.i-content h1 { text-align: left; color: #000 !important; }
.h2.site-color-1 { font-family: 'Playfair Display', serif; text-transform: none; color: #000 !important; font-weight: 100; font-size: 25px; }
.row.experience-group, .row.gcg-map { margin: 10px 37px 58px; }
.row.gcg-map {}
.row.gcg-map iframe { width: 100%; height: 300px; }
.row.pdp-experience p.h1 { text-align: center; }
.callout-text { top: auto; right: 0; left: 0; text-align: center; transform: none; margin: 0 auto; bottom: 23px; }
.row.gcg-map { margin: 10px 37px 8px; }
.i-content .callouts-wrapper h1, .i-content .callouts-wrapper .h1, .mce-content-body .callouts-wrapper  h1, .mce-content-body .callouts-wrapper  .h1 { margin-bottom: 4px; font-size: 30px;}
.callouts-wrapper { padding: 0 194px; }
.i-content .h5.callout-subtext {font-size: 15px;}
.i-content .h4.callout-category { font-size: 34px;}
.row.exp-img-wrap a { color: #fff; background: #448a9b; position: absolute; text-align: center; color: #fff; top: 50%; right: 3%; transform: translate(-50%,-50%); padding: 15px 23px; border-radius: 8px !important; }
button.btn.southern-btn.see-more-description { padding: 10px 20px; position: relative; overflow: hidden; border: none; border-radius: 3px; text-transform: uppercase; font-weight: 500; -webkit-transition: all, ease-in-out 0.25s; -moz-transition: all, ease-in-out 0.25s; -ms-transition: all, ease-in-out 0.25s; transition: all, ease-in-out 0.25s; }
button.btn.southern-btn.see-more-description { margin-left: 0; font-size: 14px; font-weight: 300; padding-left: 0; display: none; }
button.btn.southern-btn.see-more-description.show { display: block; }
.desc-block-limit { max-height: 123px; /* background: red; */ /* color: #fff; */ opacity: 0; }
.desc-block-limit.show { opacity: 1 !important; max-height: none; }
.desc-block-limit.show.hide { display: none !important; }

</style>
	
<cfquery name="getAllthingstodo" dataSource="#settings.dsn#">
	select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
	AND destination_id like '%-#getDestinations.nodeid#-%'
	AND latitude is not null and longitude is not null
	and latitude <> 0.000000000 and longitude <>0.000000000
</cfquery>
<cfquery dbtype="query" name="getAvg">
	select avg(latitude) as avglat, avg(longitude) as avglong
	from getallthingstodo
</cfquery>

<cfquery name="getDestDesc" dataSource="#settings.dsn#">
	select description from cms_thingstodo_dest_cat_desc
	where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
	AND destID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getDestinations.id#">
</cfquery>

<div class="i-content gcg-cat-wrapper">
  <div class="container">
  	<div class="row">
  		<div class="col-sm-12 description-wrap">
       <!---         <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
			  <h1 class="site-color-1"><cfoutput>#getcategory.h1#</cfoutput></h1>			
		  	<span class="desc-block-limit" style="opacity: 0;"></span>
				<span class="desc-block-full" style="display: none;"><cfoutput>#getDestDesc.description#</cfoutput></span>
				<!---         </cfcache> --->
				<button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-description" type="button" style="background-color: transparent !important; color: #000 !important;"><span>See More Description</span> <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
  		</div>
  	</div>
	  <cfquery name="getThingstodo" dataSource="#settings.dsn#">
			select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
			AND destination_id like '%-#getDestinations.nodeID#-%'
		    AND (subcatIDS is null OR subcatIDS = '')
		</cfquery>  
  	<div class="row experience-group">
  		<div class="col-sm-12">
<!---         <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
			<cfif getthingstodo.recordcount>
			<div class="h2 site-color-1">Experience <cfoutput>#getdestinations.title#</cfoutput><!--- #page.h2# ---></div>
			</cfif>
	        <div class="row">
		        <cfoutput query="getThingsToDo">
	  		    <div class="col-xs-12 col-sm-3">
		  		    <cfif len(website)>
      			    <a href="#website#" target="_blank" rel="noopener">
      			    	<cfif len(photo)>
										<img src="/images/thingstodo/#photo#">
									<cfelse>
										<img src="http://placehold.it/359x177&text=No%20Image">
									</cfif>
      			    </a>
    			    <cfelse>
    			    	<cfif len(photo)>
									<img src="/images/thingstodo/#photo#">
								<cfelse>
									<img src="http://placehold.it/359x177&text=No%20Image">
								</cfif>
    			    </cfif>
		  		    <div class="title gcg-title">#title#</div><div class="description">#description#</div><!--- <div class="address">Address</div><a href="" class="phone">(555) 555-5555</a> --->
		  		  </div>
				</cfoutput>
	        </div>
<!---         </cfcache> --->
  		</div>
  	</div><!--END experience-group-->
		
		<cfquery name="getThingstodosub" dataSource="#settings.dsn#">
			select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
			AND (subcatIDS is not null OR subcatIDs <> '')
			AND destination_id like '%-#getDestinations.nodeID#-%'
			ORDER BY RAND()
		</cfquery>	
				
		<cfquery name="getsubIDs" dbtype="query">
			select distinct(subcatIDs) from getThingstodosub
		</cfquery>
		<cfoutput>	
			
	<cfloop list="#ListRemoveDuplicates(valuelist(getSubIDs.subcatIDs))#" index="subid">
				<cfquery dataSource="#settings.dsn#" name="subcat">
					select * from cms_thingstodo_subcategories
					where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#subid#">
				</cfquery>
  	
  	<!--BEGIN SUBCAT-->
  	<div class="row experience-group sub-category">
  		<div class="col-sm-12">
<!---         <cfcache key="cms_pages" action="cache" timespan="#settings.globalTimeSpan#" usequerystring="true" useCache="true" directory="e:/inetpub/wwwroot/domains/#tinymce_domain#/temp_files"> --->
			<div class="h2 site-color-1">Experience <!--- <cfoutput> --->#getdestinations.title# - #subcat.title#<!--- </cfoutput> ---></div>
	        <div class="row">
				<cfquery name="getst" dataSource="#settings.dsn#">
								select * from cms_thingstodo where catID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#getCategory.id#">
								AND subcatIDS = #subID#
								AND destination_id like '%-#getDestinations.nodeID#-%'
								ORDER BY RAND()
							</cfquery>
							
              <cfloop query="getSt">
<!--- 		        <cfoutput query="getThingsToDo"> --->
	  		    <div class="col-xs-12 col-sm-3">
		  		    
		  		    <cfif len(website)>
      			    <a href="#website#" target="_blank" rel="noopener">
      			    	<cfif len(photo)>
										<img src="/images/thingstodo/#photo#">
									<cfelse>
										<img src="http://placehold.it/359x177&text=No%20Image">
									</cfif>
      			    </a>
    			    <cfelse>
    			    	<cfif len(photo)>
									<img src="/images/thingstodo/#photo#">
								<cfelse>
									<img src="http://placehold.it/359x177&text=No%20Image">
								</cfif>
    			    </cfif>
			        
		  		    <div class="title gcg-title">#title#</div><div class="description">#description#</div><!--- <div class="address">Address</div><a href="" class="phone">(555) 555-5555</a> --->
		  		  </div>
					</cfloop>
			 
	        </div>
<!---         </cfcache> --->
  		</div>
  	</div><!--END experience-group sub-category-->
					</cfloop>
					</cfoutput>
<!---   </cfoutput> --->
    <cfif cgi.query_string contains "dining">
	  	<div class="row gcg-map">
		  	<div class="col-xs-12">
			    <style>
			      /* Always set the map height explicitly to define the size of the div
			       * element that contains the map. */
			      #map {height: 300px; width: 100%;}
			    </style>
				<cfif getallthingstodo.recordcount><div id="map"></div></cfif>
			    <cf_htmlfoot>
			    
			    <script type="text/javascript" defer>
	$(document).ready(function(){
		//if ($('div.text').text().length > 10) {				
/*		if ($('.desc-block-limit').html().length > 550) {
			var text = $('.desc-block-limit').html();
      text = text.substr(0,550) + '...';
      $('.desc-block-limit').html(text);	
		}*/
	
  });
  
  
			    
			    
			    
<!---
			    
			    
			    <script>
				    
				    
				    
				    
				  
					<!---if ($('div.text').text().length > 10) {--->
						if ($('span.desc-block').html().length > 550) {
						var text = $('span.desc-block').text();
text = text.substr(0,550) + '...';
$('span.desc-block').text(text);


						
					}
					
					
					$('.see-more-description').toggle(function () {
			$(".description-wrap").addClass("less");
			$(".desc-block-limit").addClass("hide");
			$(".desc-block-full").toggleClass("show");
			$('.see-more-description span').text('See Less Description');
		}, function () {
      $(".description-wrap").removeClass("less");
      $(".desc-block-limit").removeClass("hide");
			$(".desc-block-full").removeClass("show");
      $('.see-more-description span').text('See More Description');
    });
				
--->
				    
				    
				    
				    
				    // The following example creates complex markers to indicate beaches near
// Sydney, NSW, Australia. Note that the anchor is set to (0,32) to correspond
// to the base of the flagpole.

function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 10,
    center: {lat: <cfoutput>#getavg.avglat#</cfoutput>, lng: <cfoutput>#getavg.avglong#</cfoutput>}
  });

  setMarkers(map);
}

// Data for the markers consisting of a name, a LatLng and a zIndex for the
// order in which these markers should display on top of each other.
var dining = [
	<cfoutput query="getallthingstodo">							
  ['#JSStringFormat(title)#', #latitude#, #longitude#, '#website#', #currentrow#]<cfif currentrow LT recordcount>,</cfif>
	</cfoutput>
];
function setMarkers(map) {
  // Adds markers to the map.

  // Marker sizes are expressed as a Size of X,Y where the origin of the image
  // (0,0) is located in the top left of the image.

  // Origins, anchor positions and coordinates of the marker increase in the X
  // direction to the right and in the Y direction down.
  /*var image = {
    url: 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png',
    // This marker is 20 pixels wide by 32 pixels high.
    size: new google.maps.Size(20, 32),
    // The origin for this image is (0, 0).
    origin: new google.maps.Point(0, 0),
    // The anchor for this image is the base of the flagpole at (0, 32).
    anchor: new google.maps.Point(0, 32)
  };*/
  // Shapes define the clickable region of the icon. The type defines an HTML
  // <area> element 'poly' which traces out a polygon as a series of X,Y points.
  // The final coordinate closes the poly by connecting to the first coordinate.
/*  var shape = {
    coords: [1, 1, 1, 20, 18, 20, 18, 1],
    type: 'poly'
  };*/
  for (var i = 0; i < dining.length; i++) {
    var dininglocations = dining[i];
    var marker = new google.maps.Marker({
      position: {lat: dininglocations[1], lng: dininglocations[2]},
      map: map,
     /* icon: image,
      shape: shape,*/
      title: dininglocations[0],
      zIndex: dininglocations[4],
      url: dininglocations[3],
    });
    google.maps.event.addListener(marker, 'click', function() {
      window.open(this.url, '_blank');
    });
  }
}
<!---
			      var map;
			      function initMap() {
			        map = new google.maps.Map(document.getElementById('map'), {
			          center: {lat: -34.397, lng: 150.644},
			          zoom: 8
			        });
			      }	      
--->
			    </script>
			    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB6-qsV5qaFbObLbLrjaMK9j59xptpY1ec&callback=initMap"
			    async defer></script>
			
			    </cf_htmlfoot>
			<!---
						  	
					  	<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3311.62035010102!2d-78.47337118505038!3d33.89943023321556!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89009cc0c3058039%3A0xcffb2c40753204d9!2sInterCoastal+Net+Designs!5e0!3m2!1sen!2sus!4v1566493615828!5m2!1sen!2sus" width="" height="" frameborder="0" style="border:0" allowfullscreen></iframe>
			--->
		  	</div>
	  	</div>
	  <cfelse>
	  </cfif>
  	<cfinclude template="/components/callouts-gcg-destination-specific.cfm">
				<div class="row experience-group explore-stays">
  		<div class="col-sm-12">
			<div class="h2 site-color-1">Places to Stay in <cfoutput>#getdestinations.title#</cfoutput><!--- #page.h2# ---></div>
	        <div class="row exp-img-wrap">
	  		    <cfif len(getdestinations.vacationbanner)><img src="/images/header/<cfoutput>#getdestinations.vacationbanner#</cfoutput>"></cfif>
	  		    <a class="btn" href="/<cfoutput>#getdestinations.exploreStaysSlug#</cfoutput>">Explore Stays <i class="fa fa-chevron-right" aria-hidden="true"></i></a>
	        </div>
  		</div>
  	</div>
  </div>
  
    
  <cf_htmlfoot>
  
  
  
 
  
<!---
  
  
  <cfif CGI.REMOTE_ADDR eq "173.93.73.19">
--->
	  
	   <style>.desc-block-limit p:last-child:after { content: "..."; }</style>
  
	  
	  <script type="text/javascript">
		  $(document).ready(function(){
			  
			  var limitCharCountFull = $('.desc-block-full').text().length;
	  console.log('limitCharCountFull: '+limitCharCountFull);
			  
			  if (limitCharCountFull > 550) {
				  console.log('jtestj');
				  var descfullLen = $(".desc-block-full").html().length;
				  console.log('descfullLen: '+descfullLen);
		  
			  	//var str = 'Lorem ipsum <a href="#">dolor <strong>sit</strong> amet</a>, consectetur adipiscing elit.<b>bold</b>';
			  	var str = $( ".desc-block-full" ).html();
					
					/*if $(".desc-block-limit:has(p)") {*/
						var res1 = html_substr( str, 550 );
					var res2 = html_substr( str, 30 );
						
/*					} else {
						var res1 = html_substr( str, 550 )+'...';
					var res2 = html_substr( str, 30 );
					}*/
					
					
					//alert( res1 );
					//alert( res2 );
					$(".desc-block-limit").html(res1);
					
					function html_substr( str, count ) {
				    
				    var div = document.createElement('div');
				    div.innerHTML = str;
				    
				    walk( div, track );
				    
				    function track( el ) {
				        if( count > 0 ) {
				            var len = el.data.length;
				            count -= len;
				            if( count <= 0 ) {
				                el.data = el.substringData( 0, el.data.length + count );
				            }
				        } else {
				            el.data = '';
				        }
				    }
				    
				    function walk( el, fn ) {
			        var node = el.firstChild, oldNode;
			        do {
			            if( node.nodeType === 3 ) {
			                fn(node);
			            } else if( node.nodeType === 1 ) {
			                walk( node, fn );
			            }
			        } while( (node = node.nextSibling) && (count>0));
			        //remove remaining nodes
			        while(node){
			            oldNode = node;
			            node = node.nextSibling;
			            el.removeChild(oldNode);
			        }
				        
				    }
				    return div.innerHTML;
					}
					
				  $(".southern-btn.see-more-description ").addClass('show');
				  if ($(".desc-block-limit:has(p)")) {
					} else {
						$(".desc-block-limit").addClass('nopar');
					}
				  
			   /* var ttext = $(".desc-block-limit").html().substr(0, 550);
			    ttext = ttext.substr(0, ttext.lastIndexOf(" "))  + '...';
			    $(".desc-block-limit").html(ttext);*/
			  } else {
				  $(".desc-block-full").addClass('show'); 
			  }
					
					
					
				$('.see-more-description').toggle(function () {
					$(".description-wrap").addClass("less");
					$(".desc-block-limit").addClass("hide");
					$(".desc-block-full").toggleClass("show");
					$('.see-more-description span').text('See Less Description');
				}, function () {
		      $(".description-wrap").removeClass("less");
		      $(".desc-block-limit").removeClass("hide");
					$(".desc-block-full").removeClass("show");
		      $('.see-more-description span').text('See More Description');
		    });
			});
			
			$(window).load(function () {
			  $('.desc-block-limit').addClass('show');
			  var limitCharCount = $('.desc-block-limit').text().length;
			  console.log('limitCharCount: '+limitCharCount);
			  var limitCharCountFull = $('.desc-block-full').text().length;
			  console.log('limitCharCountFull: '+limitCharCountFull);
		  });
						
			</script>


<!---
  	<cfelse>
  	
			    
			    <script type="text/javascript">
	$(document).ready(function(){
		//if ($('div.text').text().length > 10) {				
/*		if ($('.desc-block-limit').html().length > 550) {
			var text = $('.desc-block-limit').html();
      text = text.substr(0,550) + '...';
      $('.desc-block-limit').html(text);	
		}*/
		//console.log('jjj');
	$('.desc-block-limit').find('a').contents().unwrap();
	$('.desc-block-limit').find('span').contents().unwrap();
  if ($(".desc-block-limit").html().length > 550) {
	  $(".southern-btn.see-more-description ").addClass('show');   
	  
    var ttext = $(".desc-block-limit").html().substr(0, 550);
    ttext = ttext.substr(0, ttext.lastIndexOf(" "))  + '...';
    $(".desc-block-limit").html(ttext);
  }
		
		
		
		$('.see-more-description').toggle(function () {
			$(".description-wrap").addClass("less");
			$(".desc-block-limit").addClass("hide");
			$(".desc-block-full").toggleClass("show");
			$('.see-more-description span').text('See Less Description');
		}, function () {
      $(".description-wrap").removeClass("less");
      $(".desc-block-limit").removeClass("hide");
			$(".desc-block-full").removeClass("show");
      $('.see-more-description span').text('See More Description');
    });
  });
  $(window).load(function () {
	  $('.desc-block-limit').addClass('show');
	  var limitCharCount = $('.desc-block-limit').text().length;
	  console.log('limitCharCount: '+limitCharCount);
	  var limitCharCountFull = $('.desc-block-full').text().length;
	  console.log('limitCharCountFull: '+limitCharCountFull);
  });
  
			    
			    
			    </script>
			   
			    
			    
			    
			    </cfif>
  
   --->
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			    
			
			    </cf_htmlfoot>
  
  
  
<cfinclude template="/components/footer.cfm">