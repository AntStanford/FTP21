<cfsetting enablecfoutputonly="true">

<cfprocessingdirective suppressWhiteSpace="true">
  <cfoutput>
    <cfsavecontent variable="quickSearch">

      <link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
      <link href="/wp-content/themes/shazaam-child/css/jquery-ui.min.css" rel="stylesheet">
      <script src="/wp-content/themes/shazaam-child/js/jquery-ui.min.js"></script>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.10/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">
      <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.10/js/bootstrap-select.min.js" defer type="text/javascript"></script>
      <div id="quickSearch">
        <form id="homequickSearch" method="post" action="/vacation-rentals/results.cfm" class="validate">
          <input type="hidden" name="camefromsearchform">
          <div class="row">
            <div class="col">
              <input name="strCheckin" type="text" id="start-date" placeholder="Check In" readonly>
            </div>
            <div class="col">
              <input name="strCheckout" type="text" id="end-date" placeholder="Check Out" readonly>
            </div>
            <div class="col">
              <select name="bedrooms" class="selectpicker" id="quickSearchBedrooms">
                <option value="">Bedrooms</option>
                <option value="0">Studio</option>
                <cfloop from="1" to="#settings.booking.maxBed#" index="i">
                  <option value="#i#">#i#</option>
                </cfloop>
              </select>
            </div>
            <div class="col">
              <select name="must_haves" class="selectpicker required" multiple id="quickSearchMustHaves">
                <option value="">Must Haves</option>
                <option value="Short Walk to Ski Lifts">Walk to Ski Lift</option>
                <option value="Mountain View">Mountain View</option>
                <option value="Hot Tub - Private">Private Hot Tub</option>
                <option value="Hot Tub - Shared">Shared Hot Tub</option>
                <option value="King Bed">King Sized Bed</option>
                <option value="Indoor Pool (Onsite Access)">On-Site Pool Indoor Pool</option>
                <option value="Outdoor Pool (Onsite Access)">Outdoor Pool</option>
              </select>
            </div>
            <div class="col col-submit">
              <button type="submit" id="quickSearchSubmit">Search</button>
            </div>
          </div>
        </form>
      </div>

      <script type="text/javascript">
        jQuery(function ($) {
          $.datepicker.setDefaults({dateFormat: 'mm/dd/yy'}); // NOTE THE FORMAT CHANGE!
          $( "##start-date" ).datepicker({
            minDate: '+1d',
            onSelect: function( selectedDate ) {
              var newDate = $(this).datepicker('getDate');
              newDate.setDate(newDate.getDate()+4);

              $('##end-date').datepicker('setDate',newDate);
              $('##end-date').datepicker('option','minDate',selectedDate);
              setTimeout(function(){
                $( "##end-date" ).datepicker('show');
              }, 16);
            }
          });
          $( "##end-date" ).datepicker({
            minDate: '+1d'
          });
        });
      </script>

    </cfsavecontent>
  </cfoutput>
  <cfoutput>#quickSearch#</cfoutput>
</cfprocessingdirective>
