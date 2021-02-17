<cfif CGI.REMOTE_ADDR eq "173.93.73.19">
<style>.property-specials { display: block !important; }
.results-wrap.resorts-wrap .amenities-wrap, .amenities-wrap, .description-wrap { height: auto !important; } /*line 1302 and 1386*/
	</style>
<cfelse>
</cfif>





<cfif StructKeyExists(request,'resortContent')>
  <div id="description" name="description" class="info-wrap description-wrap active">
	  <div class="info-wrap-heading"><i class="fa fa-align-left" aria-hidden="true"></i> Description</div>
		<div class="info-wrap-body">
	  	<div id="descBlock" class="desc-block">
		  	<cfquery name="getFullDescription" dataSource="#settings.dsn#">
			   SELECT * FROM southernresorts.cms_resorts where PropertyID = #getResort.Id#
				</cfquery>
				<cfset resortDesc = #paragraphformat(getFullDescription.fulldescription)#>
				<!--- <cfdump var="#getFullDescription#"> --->
				<cfif len(getFullDescription.fulldescription)>
<!---
					<div class="desc-block-limit">
						<cfoutput>#fullLeft(resortDesc,550)#...</cfoutput>
					</div>
					<div class="desc-block-full" style="display: none;">
						<cfoutput>#resortDesc#</cfoutput>
					</div>
--->
					 <div class="desc-block-limit"></div>
<!---
					  <cfelse>
			  		  <div class="desc-block-limit">#getenhancements.longdescription#</div>
		  		  </cfif>
--->
				  	
				  	<div class="desc-block-full" style="display: none;">
				  	  <cfoutput>#resortDesc#</cfoutput>
				  	</div>
				<cfelseif len(getResort.shortdescription)>
				  <cfoutput>#getResort.shortdescription#</cfoutput>
				<cfelse>
						Content coming soon.
				</cfif>
	  	</div>
	  </div>
	</div><!-- END description-wrap -->
	<button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-description" type="button" style="background-color: transparent !important; color: #000 !important;"><span>See More Description</span> <i class="fa fa-chevron-right" aria-hidden="true"></i></button>

<cfelse>

	<cfoutput>
		<div id="description" name="description" class="info-wrap description-wrap">
		  <div class="info-wrap-heading"><i class="fa fa-align-left" aria-hidden="true"></i> Description</div>
			<div class="info-wrap-body">
		  	<div id="descBlock" class="desc-block">
			  	<cfif getenhancements.longdescription gt 0>

				  	
<!---
				  	<cfif CGI.REMOTE_ADDR eq "173.93.73.19">
						ICND Test:
						#getenhancements.longdescription#
						END ICND Test
						<cfelse>
						</cfif>
--->

				  	
				  	
				  	
				  	  <div class="desc-block-limit"></div>				  	
				  	<div class="desc-block-full" style="display: none;">
				  	  #getenhancements.longdescription#
				  	</div>
		  		<cfelse>
					Content coming soon.
					</cfif>
		  		<cfif settings.booking.pms eq 'Track' and settings.company eq 'Summit Cove'>
					
					<p></p>
					
					<cfquery name="getCustomData" dataSource="#settings.dsn#">
						select * from track_properties_custom_data
						where propertyid = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#property.propertyid#">
						order by customDataId
					</cfquery>
								
					<cfloop query="getCustomData">
						
						<cfif customDataId eq 22>
							<p><b>Parking Instructions:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 33>
							<p><b>Shuttle Information:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 34>
							<p><b>Distance to Shuttle:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 35>
							<p><b>Distance to Slopes:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 39>
							<p><b>Laundry Information:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 40>
							<p><b>BBQ Grill Information:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 58>
							<p><b>Sleeping Arrangements:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 61>
							<p><b>STR Summit County Permit ##:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 62>
							<p><b>STR County Permit Parking Max:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 64>
							<p><b>STR Max Occupancy:</b></p>
							<p>#data#</p>
						<cfelseif customDataId eq 72>
							<p><b>Floor of Building:</b></p>
							<p>#data#</p>					
						</cfif>
						
					</cfloop>
					
				</cfif>
		
		  	</div>
		  </div><!--- END info-wrap-body --->
		</div><!-- END description-wrap -->
		<button id="" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white southern-btn see-more-description" type="button" style="background-color: transparent !important; color: ##000 !important;"><span>See More Description</span> <i class="fa fa-chevron-right" aria-hidden="true"></i></button>
	</cfoutput>
</cfif>
<cf_htmlfoot>

<!---
<cfif CGI.REMOTE_ADDR eq "216.99.119.254" OR CGI.REMOTE_ADDR eq "69.143.223.135">
<script type="text/javascript" defer>
	$(document).ready(function(){
		//if ($('div.text').text().length > 10) {				
<!---
		if ($('.desc-block-limit').html().length > 550) {
			var text = $('.desc-block-limit').html();
      text = text.substr(0,550) + '...';
      $('.desc-block-limit').html(text);	
		}
--->
		
<!---
		if ($(".desc-block-limit").text().length > 550) {
    var ttext = $(".desc-block-limit").text().substr(0, 550);
    ttext = ttext.substr(0, ttext.lastIndexOf(" "))  + '...';
    $(".desc-block-limit").text(ttext);
  }
--->

$('.desc-block-limit').find('a').contents().unwrap();

if ($(".desc-block-limit").html().length > 550) {
    var ttext = $(".desc-block-limit").html().substr(0, 550);
    ttext = ttext.substr(0, ttext.lastIndexOf(" "))  + '...';
    $(".desc-block-limit").html(ttext);
  }
<!---
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
  });
<!---
  $(window).load(function () {
	  $('.desc-block-limit').addClass('show');
  });
--->
  $(window).load(function () {
	  var limitCharCount = $('.desc-block-limit').text().length;
	  console.log('limitCharCount: '+limitCharCount);
	  var limitCharCountFull = $('.desc-block-full').text().length;
	  console.log('limitCharCountFull: '+limitCharCountFull);
  });

</script>


<style>
	.desc-block-limit {
    max-height: none !important;
    opacity: 1 !important;
}

.desc-block-full {
    display: block !important;
}
</style>

	
	
	<cfelse>
	
	
	--->
	  
  <cfif isdefined('property.propertyId') and property.propertyId eq 695>
  
		  
		<script type="text/javascript" defer>
			$(document).ready(function(){
				//if ($('div.text').text().length > 10) {				
		/*		if ($('.desc-block-limit').html().length > 550) {
					var text = $('.desc-block-limit').html();
		      text = text.substr(0,550) + '...';
		      $('.desc-block-limit').html(text);	
				}*/
				
			$('.desc-block-full').find('a').contents().unwrap();
		  if ($(".desc-block-full").html().length > 550) {
		    var ttext = $(".desc-block-full").html().substr(0, 550);
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
  
  
	  
  <cfelse>
	  
	   
  
	  
	  <script type="text/javascript">
		  $(document).ready(function(){
			  
			  var limitCharCountFull = $('.desc-block-full').text().length;
	      //console.log('limitCharCountFull: '+limitCharCountFull);
			  
			  if (limitCharCountFull > 550) {
				  var descfullLen = $(".desc-block-full").html().length;
				  //console.log('descfullLen: '+descfullLen);
		  
			  	//var str = 'Lorem ipsum <a href="#">dolor <strong>sit</strong> amet</a>, consectetur adipiscing elit.<b>bold</b>';
			  	var str = $( ".desc-block-full" ).html();
						
					var res1 = html_substr( str, 550 );
					var res2 = html_substr( str, 30 );
					
					//alert( res1 );
					//alert( res2 );
					$(".desc-block-limit").html(res1);
					
					function html_substr( str, count ) {
				    
				    var div = document.createElement('div');
				    
				    div.innerHTML = str;
				    
				    <cfif CGI.REMOTE_ADDR eq "173.93.73.19">
				    console.log('div:'+div);
				    console.log('str:'+str);
			    	<cfelse>
			    	</cfif>
				    
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
				  //if ($(".desc-block-limit:has(p)")) {
					  if ($('.desc-block-limit').find("p").length > 0) {
						  $(".desc-block-limit").addClass('par');
					} else {
						$(".desc-block-limit").addClass('nopar');
					}   
				  
			   /* var ttext = $(".desc-block-limit").html().substr(0, 550);
			    ttext = ttext.substr(0, ttext.lastIndexOf(" "))  + '...';
			    $(".desc-block-limit").html(ttext);*/
			  } else {
				  $(".desc-block-full").addClass('show'); 
			  }
					
			
						var replaceHtag = $('.desc-block-limit').html();
			            replaceHtag = replaceHtag.replace(/<h4>/g,'<h2 class="desc-block-h2">');
			            //replaceHtag = replaceHtag.replace(/<\/h2>/g,'<br/>');
			            $('.desc-block-limit').html(replaceHtag);
			            $('.desc-block-h2').css("fontSize", "18px");
					
					
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
			  //console.log('limitCharCount: '+limitCharCount);
			  var limitCharCountFull = $('.desc-block-full').text().length;
			  //console.log('limitCharCountFull: '+limitCharCountFull);
		  });
						
			</script>
			<style>.desc-block-limit.show p:last-child:after { content: "..."; }
			.desc-block-limit.nopar:after { content: "..."; }</style>
	
  </cfif>
	
	
<!---
		
	
</cfif>
--->


</cf_htmlfoot>
