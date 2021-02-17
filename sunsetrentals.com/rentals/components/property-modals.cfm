<!--- Write Review Property Modal --->
<div class="modal fade write-review-modal" id="writeReviewModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header site-color-1-bg text-white">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="reviewModalLabel"><i class="fa fa-pencil-square-o"></i> Write A Review</h4>
      </div>
      <div class="modal-body">
        <em>Simply fill out the form below to let us know what you thought of this property.</em>
        <hr/>
        <div id="propertyReviewFormMSG"></div>
        <form role="form" id="propertyReviewForm" class="review-form" method="post">
          <input type="hidden" name="submitReview">
          <cfoutput>
          	<input type="hidden" name="property_id" value="#property.propertyid#">
          	<input type="hidden" name="property_name" value="#property.name#">
          </cfoutput>
          <cfinclude template="/cfformprotect/cffp.cfm">
          <fieldset class="row">
            <div class="form-group col-xs-12 col-sm-6">
              <label>First Name</label>
              <input type="text" id="firstName" name="firstName" class="form-control required">
            </div>
            <div class="form-group col-xs-12 col-sm-6">
              <label>Last Name</label>
              <input type="text" id="lastName" name="lastName" class="form-control required">
              <small>For privacy, Last names will not be shown</small>
            </div>
            <div class="form-group col-xs-12">
              <label>Home Town</label>
              <input type="text" id="hometown" name="hometown" class="form-control required">
            </div>
            <div class="form-group col-xs-12">
              <label>Email Address</label>
              <input type="email" id="email" name="email" class="form-control required">
              <small>For privacy, email addresses will not be shown</small>
            </div>
            <div class="form-group col-xs-12 col-sm-6">
              <label>Check-In Date</label>
              <input type="text" id="reviewCheckInDate" name="checkInDate" placeholder="mm/dd/yyyy" class="form-control datepicker required" readonly>
              <div id="reviewDatepickerCheckin" class="datepicker-container"></div>
            </div>
            <div class="form-group col-xs-12 col-sm-6">
              <label>Check-Out Date</label>
              <input type="text" id="reviewCheckOutDate" name="checkOutDate" placeholder="mm/dd/yyyy" class="form-control datepicker required" readonly>
              <div id="reviewDatepickerCheckout" class="datepicker-container"></div>
            </div>
            <div class="form-group col-xs-12 rating-group">
              <label>Rating</label>
  						<div class="star-rating-group">
    						<input type="radio" id="rating-5" name="rating" value="5" checked="checked" /><label for="rating-5" data-toggle="tooltip" data-placement="bottom" title="Loved It">5</label>
    						<input type="radio" id="rating-4" name="rating" value="4" /><label for="rating-4" data-toggle="tooltip" data-placement="bottom" title="Liked It">4</label>
    						<input type="radio" id="rating-3" name="rating" value="3" /><label for="rating-3" data-toggle="tooltip" data-placement="bottom" title="Met Expectations">3</label>
    						<input type="radio" id="rating-2" name="rating" value="2" /><label for="rating-2" data-toggle="tooltip" data-placement="bottom" title="Disliked It">2</label>
    						<input type="radio" id="rating-1" name="rating" value="1" /><label for="rating-1" data-toggle="tooltip" data-placement="bottom" title="Hated It">1</label>
    						<input type="radio" id="rating-0" name="rating" value="0" class="star-rating-clear" /><label for="rating-0" data-toggle="tooltip" data-placement="right" title="test">0</label>
  						</div>
            </div>
            <div class="form-group col-xs-12">
              <label>Title</label>
              <input type="text" id="title" name="title" class="form-control required">
            </div>
            <div class="form-group col-xs-12">
              <label>Review</label>
              <textarea id="" name="review" placeholder="Comments..." class="form-control required"></textarea>
            </div>
            <div class="form-group col-xs-12">
            	<div id="reviewscaptcha"></div>
            	<div class="g-recaptcha-error"></div>
            </div>
            <div class="form-group col-xs-12">
  			      <div class="well input-well">
  			        <input id="optinReview" name="optin" type="checkbox" value="Yes"> <label for="optinReview">I agree to receive information about your rentals, services and specials via phone, email or SMS. <br />
  			        You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank">Privacy Policy</a></label>
  			      </div>
			      </div>
            <div class="form-group col-xs-12">
              <input type="submit" id="" class="btn site-color-1-bg site-color-3-bg-hover text-white" name="" value="Submit Review">
            </div>
          </fieldset>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn site-color-2-bg site-color-3-bg-hover text-white" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!--- Q&A Property Modal --->
<div class="modal fade property-qa-modal" id="propertyQAModal" tabindex="-1" role="dialog" aria-labelledby="propertyQAModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header site-color-1-bg text-white">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="propertyQAModalLabel"><i class="fa fa-question-circle"></i> Questions and Answers about this Property</h4>
      </div>
      <div class="modal-body">
        <em>Want to know specifics? Ask anything about this property that you would like to know...<br/>Example: <strong>"Is the Balcony screened in?"</strong></em>
        <hr/>
        <div id="propertyQandAFormMSG"></div>
        <form role="form" id="propertyQandAForm" class="q-and-a-form validate" method="post">
        	 <input type="hidden" name="submitQandA">
        	 <cfoutput>
          	<input type="hidden" name="property_id" value="#property.propertyid#">
          	<input type="hidden" name="property_name" value="#property.name#">
          </cfoutput>
          <cfinclude template="/cfformprotect/cffp.cfm">
          <fieldset class="row">
            <div class="form-group col-xs-12 col-sm-6">
              <label>First Name</label>
              <input type="text" id="firstName" name="firstName" placeholder="First" class="form-control required">
            </div>
            <div class="form-group col-xs-12 col-sm-6">
              <label>Last Name</label>
              <input type="text" id="lastName" name="lastName" placeholder="Last" class="form-control required">
            </div>
            <div class="form-group col-xs-12">
              <label>Email Address</label>
              <input type="email" id="email" name="email" placeholder="Email" class="form-control required">
            </div>
            <div class="form-group col-xs-12">
              <label>Comments/Questions</label>
              <textarea id="" name="comments" placeholder="Question..." class="form-control required"></textarea>
            </div>
            <div class="form-group col-xs-12">
            	<div id="qandacaptcha"></div>
            	<div class="g-recaptcha-error"></div>
            </div>
            <div class="form-group col-xs-12">
  			      <div class="well input-well">
  			        <input id="optinQA" name="optin" type="checkbox" value="Yes"> <label for="optinQA">I agree to receive information about your rentals, services and specials via phone, email or SMS. <br />
  			        You can unsubscribe at anytime. <a href="/about-us/privacy-policy/" target="_blank">Privacy Policy</a></label>
  			      </div>
  			    </div>
            <div class="form-group col-xs-12">
              <input type="submit" id="" class="btn site-color-1-bg site-color-3-bg-hover text-white" name="" value="Submit Question">
            </div>
          </fieldset>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn site-color-2-bg site-color-3-bg-hover text-white" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!--- Split Cost Calculator Modal --->
<div class="modal fade split-cost-modal" id="splitCostModal" tabindex="-1" role="dialog" aria-labelledby="splitModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <cfinclude template="/#settings.booking.dir#/_family-calculator.cfm">
    </div>
  </div>
</div>