<!--- Set some defaults just in case --->
<cfif !isdefined('settings.booking.minOccupancy') or settings.booking.minOccupancy eq ''>
  <cfset settings.booking.minOccupancy = 1>
  <cfset settings.booking.maxOccupancy = 10>
  <cfset settings.booking.minbed = 1>
  <cfset settings.booking.maxbed = 10>
  <cfset settings.booking.minprice = 1>
  <cfset settings.booking.maxprice = 10>
</cfif>
<cfparam name="amenityList" default="">
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
              <cfif parameterexists(id) and isdefined('form.must_haves') and ListFind(form.must_haves,i)>
                <input type="checkbox" name="must_haves" id="checkboxes-0" value="<cfoutput>#i#</cfoutput>" checked="checked">
              <cfelse>
                <input type="checkbox" name="must_haves" id="checkboxes-0" value="<cfoutput>#i#</cfoutput>">
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
      <cfif listlen(settings.booking.typeList)>
        <div class="form-group">
          <label><b>Unit Type</b></label>
          <div>
            <cfloop list="#settings.booking.typeList#" index="i">
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
      <cfif isDefined('settings.booking.viewList') and listlen(settings.booking.viewList)>
        <div class="form-group">
          <label><b>View</b></label>
          <div>
            <cfloop list="#settings.booking.viewList#" index="i">
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
      
    <cfquery name="getDestinations" dataSource="#settings.dsn#">
      select id,nodeid, title from cms_destinations
      order by title
    </cfquery>
       
    <cfset destList = ValueList(getDestinations.title)>
    <cfif getDestinations.recordcount>
      <div class="form-group">
          <label><b>Destination</b></label>
          <div>
            <cfloop query="getDestinations" >
              <cfoutput>
              <label class="checkbox">
                <cfif parameterexists(id) and isdefined('form.dest') and ListFind(form.dest,nodeid)>
                <input type="checkbox" name="dest" value="#nodeid#" checked="checked">
              <cfelse>
                <input type="checkbox" name="dest" value="#nodeid#">
              </cfif>
              #title#
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


      
    <cfquery name="getTowns" dataSource="#settings.dsn#">
      select distinct(locality) from track_properties
      order by locality
    </cfquery>
       
    <cfif getTowns.recordcount>
      <div class="form-group">
          <label><b>Locality</b> (if Destinations is not returning results)</label>
          <div>
            <cfloop query="getTowns" >
              <cfoutput>
              <label class="checkbox">
                <cfif parameterexists(id) and isdefined('form.town') and ListFind(form.town,locality)>
                <input type="checkbox" name="town" value="#locality#" checked="checked">
              <cfelse>
                <input type="checkbox" name="town" value="#locality#">
              </cfif>
              #locality#
              </label>
              </cfoutput>
            </cfloop>
          </div>
      </div>
    </cfif>


    </div>
  </div>
</cfoutput>