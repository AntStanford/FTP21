<div id="reviews" name="reviews" class="info-wrap reviews-wrap">
  <div class="info-wrap-heading"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> (<cfoutput>#numReviews#</cfoutput>) Reviews</div>
  <div class="info-wrap-body">
  
    <cfif numReviews gt 0>
  	  <div class="owl-carousel reviews-carousel">
  	    <cfloop collection="#reviews#" item="index">
  	    <cfoutput>
  	    <blockquote class="review">
  	    	<cfif len(reviews[index].rating)>
  		      <div class="star-rating">
  			      <cfif reviews[index].rating eq 1>
  			      	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
  			      <cfelseif reviews[index].rating eq 2>
  			      	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
  			      <cfelseif reviews[index].rating eq 3>
  			      	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
  			      <cfelseif reviews[index].rating eq 4>
  			      	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star-o" aria-hidden="true"></i>
  			      <cfelseif reviews[index].rating eq 5>
  			      	<i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i><i class="fa fa-star" aria-hidden="true"></i>
  			      </cfif>
  			   </div>
  		   </cfif>
  		   <cfif len(reviews[index].title)><strong>#reviews[index].title#</strong><br /></cfif>
  	      #reviews[index].review#
  	      <div class="signature">- <cfif len(reviews[index].firstname)>#reviews[index].firstname#<cfelse>Anonymous</cfif> #Left(reviews[index].lastname,1)# <cfif len(reviews[index].hometown)>from #reviews[index].hometown#</cfif>, Posted: #DateFormat(reviews[index].createdat,'mm/dd/yyyy')#</div>
  	      <cfif len(trim(reviews[index].response)) GT 0>
          	#reviews[index].response#
          	<div class="signature">- #settings.booking.customer# staff, Posted: #DateFormat(reviews[index].responseCreatedAt,'mm/dd/yyyy')#</div> 
           </cfif>
  	    </blockquote>
  	    </cfoutput>
  	    </cfloop>	    
  	  </div>	
  	  <small class="scroll-indicator"><i class="fa fa-arrows-h" aria-hidden="true"></i><strong><span class="swipe">Swipe</span><span class="drag">Drag</span> for Reviews</strong></small>
    <cfelse>
      <em>Currently, there are 0 reviews for this Property.</em>
    </cfif>
  
    <div class="btn-group">
      <cfif numReviews gt 0><button id="nextReview" class="btn site-color-1-bg site-color-1-lighten-bg-hover text-white" type="button">Next Review</button></cfif>
      <button id="writeReview" class="btn site-color-2-bg site-color-2-lighten-bg-hover text-white" type="button" data-toggle="modal" data-target="#writeReviewModal">Write Review</button>
    </div>
  </div><!-- END info-wrap-body -->
</div><!-- END reviews-wrap -->
