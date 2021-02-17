<!--- 2019-CURRENT TEMPLATE --->
<!--- Set some defaults just in case --->
<cfif !isdefined('settings.booking.minOccupancy') or settings.booking.minOccupancy eq ''>
  <cfset settings.booking.minOccupancy = 1>
  <cfset settings.booking.maxOccupancy = 10>
  <cfset settings.booking.minbed = 1>
  <cfset settings.booking.maxbed = 10>
</cfif>

<div class="container i-quick-search" id="quickSearch">
  <form id= "qsForm" method="post" action="/rentals/results">
    <input type="hidden" name="camefromsearchform">
    <fieldset class="row">
      <div class="col dates-col">
        <label class="hidden" for="start-date">Arrival</label>
        <div class="input-wrap datepicker-wrap">
				  <input type="text" name="strCheckin" id="start-date" placeholder="Arrival Date" value="" readonly>
        </div>
      </div>
      <div class="col dates-col">
        <label class="hidden" for="end-date">Departure</label>
        <div class="input-wrap datepicker-wrap ">
          <input type="text" name="strCheckout" id="end-date" placeholder="Departure Date" value="" readonly>
        </div>
      </div>
      <!---
      <div class="col">
        <label class="hidden" for="sleeps">Guests</label>
        <div class="select-wrap">
          <select class="selectpicker" data-size="6" id="sleeps" name="sleeps" title="Guests">
            <cfloop from="#settings.booking.minOccupancy#" to="#settings.booking.maxOccupancy#" index="i">
              <cfoutput><option value="#i#">#i#</option></cfoutput>
            </cfloop>
          </select>
        </div>
      </div>
      --->
      <div class="col">
        <label class="hidden" for="bedrooms">Bedrooms</label>
        <div class="select-wrap">
          <select class="selectpicker" data-size="6" id="bedrooms" name="bedrooms" title="Bedrooms">
            <option data-hidden="true" value="">Bedrooms</option>
            <cfloop from="#settings.booking.minbed#" to="#settings.booking.maxbed#" index="i">
              <cfoutput><option value="#i#,#settings.booking.maxbed#">#i#</option></cfoutput>
            </cfloop>
          </select>
        </div>
      </div>

      <div class="col">
        <label class="hidden" for="locations">Location</label>
        <div class="select-wrap">
          <select class="selectpicker" multiple data-size="6" id="locations" name="town" title="Location">
            <cfoutput query="settings.booking.locations">
            	<option value="#id#">#name#</option>
            </cfoutput>
          </select>
        </div>
      </div>
      <div class="col submit-col">
        <button type="submit" class="btn btn-block site-color-1-bg site-color-2-bg-hover text-white">Search Now</button>
      </div>
    </fieldset>
    <fieldset class="row checkbox-row">
      <div class="col">
        <input type="checkbox" id="pet-friendly" name="amenities" value="Pet Friendly" title="Pet Friendly">
        <label for="pet-friendly">Pet Friendly</label>
      </div>
      <div class="col">
        <input type="checkbox" id="oceanfront" name="amenities" value="Ocean Front" title="Oceanfront">
        <label for="oceanfront">Oceanfront</label>
      </div>
      <div class="col">
        <input type="checkbox" id="pool" name="amenities" value="Private Pool" title="Pool">
        <label for="pool">Private Pool</label>
      </div>
      <div class="col">
        <input type="checkbox" id="stairfree" name="amenities" value="Stair Free" title="stairfree">
        <label for="stairfree">Stair Free</label>
      </div>
    </fieldset>
  </form>
</div>
