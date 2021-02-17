<cfif parameterexists(id) and getinfo.customSearchJSON neq ''>
  <!--- This is for the Custom Results form tab --->
  <cfset data = deserializeJSON(getinfo.customSearchJSON)>
  <cfset structure_key_list = structKeyList(data)>
  <cfloop list="#structure_key_list#" index="k">
    <cfset form[k] = data[k]>
  </cfloop>      	
</cfif>
<style type="text/css">
  .custom-search-fields > .control-group {padding-top: 25px;}
  .control-group {padding-bottom:10px}
  .control-group > .span6 {margin: 0; padding: 0 30px;}
  .control-group > .span6 > div {margin-bottom: 25px;}
  .form-group .input-append {margin: 0 10px 10px 0;}
  .form-group .split {display: inline-block; width: 49%; margin-right: -4px; box-sizing: border-box;}
  .form-group .split + .split {margin-left: 2%;}
  @media (max-width: 768px) {
    .form-horizontal .controls, .form-horizontal .control-label, .control-group > .span6 {padding: 0 15px;}
    .form-group .split, .form-group .split + .split {width: 100%; margin: 0 0 10px;}
  }
</style>
<script>
  $(document).ready(function(){
    $('#clearDates').on('click', function(){
      $('.datepicker').val('');
    });
  });
</script>

<cfoutput>

<div class="control-group">
	<div class="span6">
    <div class="form-group">
      <label><b>Choose dates</b></label>
      <div class="input-append">
        <cfif parameterexists(id) and isdefined('form.strcheckin') and form.strcheckin neq ''>
          <input type="text" class="input-small datepicker nomargin" placeholder="Arrival Date" name="strcheckin" value="#form.strcheckin#">	
        <cfelse>
          <input type="text" class="input-small datepicker nomargin" placeholder="Arrival Date" name="strcheckin">
        </cfif>
        <span class="add-on"><i class="icon-calendar"></i></span>	 
      </div>
  	
      <div class="input-append">
        <cfif parameterexists(id) and isdefined('form.strcheckout') and form.strcheckout neq ''>
          <input type="text" class="input-small datepicker nomargin" placeholder="Departure Date" name="strcheckout" value="#form.strcheckout#">	
        <cfelse>
          <input type="text" class="input-small datepicker nomargin" placeholder="Departure Date" name="strcheckout">
        </cfif>
        <span class="add-on"><i class="icon-calendar"></i></span>	 
      </div>
      <br>
      <a href="javascript:;" id="clearDates" class="btn clear-dates">Clear Dates</a>
    </div>
    	
    <div class="form-group">
			<label><b>Must Haves</b></label>
			<div>
				<cfloop list="#mustHavesList#" index="i">
					<label class="checkbox" for="checkboxes-0">
						<cfif parameterexists(id) and isdefined('form.amenities') and ListFind(form.amenities,i)>
							<input type="checkbox" name="amenities" id="checkboxes-0" value="<cfoutput>#i#</cfoutput>" checked="checked">
						<cfelse>
							<input type="checkbox" name="amenities" id="checkboxes-0" value="<cfoutput>#i#</cfoutput>">
						</cfif>						
	      			<cfoutput>#i#</cfoutput>
	    			</label>
    			</cfloop>
			</div>
    </div>
    	
		<cfif listlen(amenityList)>
      <div class="form-group">
  			<label><b>Amenities</b></label>
  			<div>
  				<cfloop list="#amenityList#" index="i">
  					<cfoutput>
  					<label class="checkbox">
  						<cfif parameterexists(id) and isdefined('form.amenities') and ListFind(form.amenities,i)>
  	      				<input type="checkbox" name="amenities" value="#i#" checked="checked">
  	      			<cfelse>
  	      				<input type="checkbox" name="amenities" value="#i#">
  	      			</cfif>
  	      			#i#
  	      			<cfset filterCount = application.bookingObject.getSearchFilterCount(i,'amenity')> 
  	      			(#filterCount#)
  	    			</label>
  	    			</cfoutput>
      			</cfloop>
  			</div>
      </div>
		</cfif>
		
		<cfif listlen(typeList)>
      <div class="form-group">
				<label><b>Unit Type</b></label>
				<div>
					<cfloop list="#typeList#" index="i">
						<cfoutput>
						<label class="checkbox">
							<cfif parameterexists(id) and isdefined('form.type') and ListFind(form.type,i)>
		      				<input type="checkbox" name="type" value="#i#" checked="checked">
		      			<cfelse>
		      				<input type="checkbox" name="type" value="#i#">
		      			</cfif>
		      			#i#		      			
		      			<cfset filterCount = application.bookingObject.getSearchFilterCount(i,'type')>
		      			(#filterCount#)
		    			</label>
		    			</cfoutput>
	    			</cfloop>
				</div>
      </div>
		</cfif>  
		
		
		<cfif listlen(viewList)>
      <div class="form-group">
				<label><b>View</b></label>
				<div>
					<cfloop list="#viewList#" index="i">
						<cfoutput>
						<label class="checkbox">
							<cfif parameterexists(id) and isdefined('form.view') and ListFind(form.view,i)>
		      				<input type="checkbox" name="view" value="#i#" checked="checked">
		      			<cfelse>
		      				<input type="checkbox" name="view" value="#i#">
		      			</cfif>
		      			#i#		      			
		      			<cfset filterCount = application.bookingObject.getSearchFilterCount(i,'view')>
		      			(#filterCount#)
		    			</label>
		    			</cfoutput>
	    			</cfloop>
				</div>
      </div>
		</cfif>  
		
	</div>
	<div class="span6">
    <div class="form-group">
			<label><b>Bedrooms</b></label>
			<div>
				<select name="bedrooms" class="input-large">
					<option value="0">- Choose One -</option>
					<cfloop from="#settings.booking.minBed#" to="#settings.booking.maxBed#" index="i">
						<option <cfif parameterexists(id) and isdefined('form.bedrooms') and form.bedrooms eq i>selected="selected"</cfif>><cfoutput>#i#</cfoutput></option>
					</cfloop>
				</select>
			</div>
    </div>

    <div class="form-group">
			<label><b>Number of Guests</b></label>
			<div>
				<select name="sleeps" class="input-large">
					<option value="0">- Choose One -</option>
					<cfloop from="#settings.booking.minOccupancy#" to="#settings.booking.maxOccupancy#" index="i">
						<option <cfif parameterexists(id) and isdefined('form.sleeps') and form.sleeps eq i>selected="selected"</cfif>><cfoutput>#i#</cfoutput></option>
					</cfloop>
				</select>
			</div>
    </div>

    <div class="form-group">
			<label><b>Price Range</b></label>
			<div class="split">
				<select name="rentalRateMin" class="input-large">
					<option value="0">- Choose Min -</option>
					<cfloop from="#settings.booking.minPrice#" to="#settings.booking.maxPrice#" index="i" step="100">
						<cfoutput><option value="#ceiling(i)#" <cfif parameterexists(id) and isdefined('form.rentalRateMin') and form.rentalRateMin eq #ceiling(i)#>selected="selected"</cfif>>$#ceiling(i)#</option></cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="split">
				<select name="rentalRateMax" class="input-large">
					<option value="0">- Choose Max -</option>
					<cfloop from="#settings.booking.minPrice#" to="#settings.booking.maxPrice#" index="i" step="100">
						<cfoutput><option value="#ceiling(i)#" <cfif parameterexists(id) and isdefined('form.rentalRateMax') and form.rentalRateMax eq #ceiling(i)#>selected="selected"</cfif>>$#ceiling(i)#</option></cfoutput>
					</cfloop>
				</select>
			</div>
    </div>

	</div>
</div>

</cfoutput>