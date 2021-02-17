<cfsetting enablecfoutputonly="true">

<cfprocessingdirective suppressWhiteSpace="true">

<!---
<cfif !isAjaxRequest() or !findNoCase(application.settings.website, cgi.HTTP_REFERER)>
  <cfheader statuscode="404" statustext="Not Found">
  <cfabort>
</cfif>
--->
<!---This is to use show a 404 unless a real ajax request has been made for this file--->


  <cfoutput>
    <cfsavecontent variable="quickSearch">
      <link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
      <style>
        ##quickSearchWrap {  background: ##204795; }
        ##quickSearch { width: 1020px; max-width: 100%; margin: auto; padding: 15px; }
        ##quickSearch * { box-sizing: border-box; }
        ##quickSearch .row { margin-left: -5px; margin-right: -5px; }
        ##quickSearch .col { display: inline-block; vertical-align: middle; width: 22.75%; margin-right: -4px; padding: 0 5px; }
        ##quickSearch .col-submit { width: 9%; }
        ##quickSearch label { color: ##fff; display: block; }
        ##quickSearch input[type=text] { cursor: pointer; width: 100%; height: 45px; padding: 5px 10px; border: none; border: 1px solid ##ddd !important; border-radius: 4px; font-size: 14px; color: ##000; line-height: 1; text-transform: uppercase; letter-spacing: 0.3px; }
        ##quickSearch select { display: block; width: 100%; height: 45px; padding: 8px 15px; background-color: ##fff; background-image: none; border: 1px solid ##ddd !important; border-radius: 2px; font-size: 14px; color: ##717171; line-height: 1; text-transform: uppercase; letter-spacing: 0.3px; }
        ##quickSearch .bootstrap-select { display: block; width: 100%; }
        ##quickSearch .bootstrap-select button { width: 100%; height: 45px; padding: 8px 15px; background-color: ##fff; background-image: none; border: 1px solid ##ddd !important; border-radius: 2px; font-size: 14px; color: ##717171; line-height: 1; text-transform: uppercase; letter-spacing: 0.3px; }
        ##quickSearch .btn-group { width: 100%; }
        ##quickSearch .btn-group button { width: 100% !important; height: 45px !important; padding: 8px; background-color: ##fff; border: 1px solid ##ddd; font-size: 14px; color: ##717171; line-height: 1; text-align: left; text-transform: uppercase; letter-spacing: 0.3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        ##quickSearch .btn-group button:after { content: ""; display: block; clear: both; }
        ##quickSearch .btn-group button .caret { float: right; position: relative; top: 5px; }
        ##quickSearch .multiselect-container a, ##quickSearch .multiselect-container label { color: ##717171 !important; white-space: nowrap; overflow: hidden; }
        ##quickSearchSubmit { cursor: pointer; width: 100%; height: auto; padding: 15px 0; background: ##77b3e2; border: none; border-radius: 4px; font-size: 16px; color: ##fff; line-height: 1; text-align: center; text-transform: uppercase; font-weight: bold; }
        ##quickSearchSubmit:hover { background: ##f3a847; }

        /* Datepicker */
        ##ui-datepicker-div { width: 300px; z-index: 7000 !important; font-size: 14px !important; line-height: 2 !important; }
        .ui-datepicker { background: ##f5f5f5; border: 0; border-radius: 0; box-shadow: ##000 0 0 50px -14px; }
        .ui-datepicker .ui-datepicker-header { background: none; border: none; padding: 0 !important; font-weight: normal; }
        .ui-datepicker .ui-datepicker-title { width: 100%; height: 30px !important; margin: 0 auto !important; background: hsl(206, 65%, 68%); border-bottom: 1px solid hsl(206, 65%, 68%); font-size: 14px; color: ##fff; line-height: 2.25 !important; text-align: center; }
        .ui-datepicker .ui-datepicker-next { width: 34px !important; height: 30px !important; top: 0 !important; right: 0 !important; background: url('/rentals//images/datepicker-next-white.png') no-repeat center center !important; cursor: pointer; opacity: 0.75; }
        .ui-datepicker .ui-datepicker-prev { width: 34px !important; height: 30px !important; top: 0 !important; left: 0 !important; background: url('rentals//images/datepicker-prev-white.png') no-repeat center center !important; cursor: pointer; opacity: 0.75; }
        .ui-datepicker .ui-datepicker-next:after,
        .ui-datepicker .ui-datepicker-prev:after { display: none !important; }
        .ui-datepicker .ui-datepicker-next-hover { top: 0 !important; right: 0 !important; opacity: 1; border: 0 !important; }
        .ui-datepicker .ui-datepicker-prev-hover { top: 0 !important; left: 0 !important; opacity: 1; border: 0 !important; }
        .ui-datepicker .ui-datepicker-next span,
        .ui-datepicker .ui-datepicker-prev span { display: none !important; }
        .ui-datepicker .ui-datepicker-calendar .ui-state-default { text-align: center !important; }
        .ui-datepicker-calendar th { font-size: 12px; line-height: 1; font-weight: normal; }
        .ui-datepicker-calendar td { position: relative; line-height: 2; }
        .ui-datepicker-calendar td span,
        .ui-datepicker-calendar td a { width: 40px; height: 40px; padding: 8px 5px !important; background: hsl(206, 65%, 68%) !important; border: 1px solid hsl(206, 65%, 68%) !important; font-size: 12px; color: ##fff !important; text-align: center; }
        .ui-datepicker-calendar td a:hover { background: ##eee !important; color: ##444 !important; font-weight: normal; }
        .ui-datepicker .ui-state-disabled:after { content:""; display: block; position: absolute; top: 50%; right: 0; left: 0; border-bottom: 2px solid ##fff; }
        .ui-datepicker .ui-datepicker-other-month:after { display: none; }
        .ui-datepicker .ui-state-disabled.ui-datepicker-today span,
        .ui-datepicker .ui-datepicker-today span { background: ##f7f7f7 !important; border: 1px solid ##444 !important; color: ##000 !important; }
        .ui-datepicker .ui-datepicker-today span:hover { background: ##fff !important; color: hsl(206, 65%, 68%) !important; font-weight: 700; }
        .ui-datepicker .ui-state-disabled.ui-datepicker-today:after { display: none; }
        .ui-datepicker .dp-highlight .ui-state-default { background: hsl(42, 82%, 55%) !important; border-color: hsl(42, 82%, 55%) !important; color: ##fff !important; }

        @media (max-width: 736px) {
          ##quickSearch .col { width: 25%; }
          ##quickSearch .col-submit { width: 100%; margin-top: 10px; }
        }
        @media (max-width: 480px) {
          ##quickSearch .col { width: 55%; }
        }
      </style>

      <div id="quickSearch">
        <form id="homequickSearch" method="post" action="/rentals/results.cfm" class="validate">
          <input type="hidden" name="camefromsearchform" value="yes">
          <input type="hidden" name="bedrooms" value="">
          <div class="row">
            <div class="col">
              <input name="strCheckin" type="text" id="start-date" placeholder="Check In" readonly>
            </div>
            <div class="col">
              <input name="strCheckout" type="text" id="end-date" placeholder="Check Out" readonly>
            </div>
            <div class="col">
              <select name="bedrooms_" class="bedrooms" id="quickSearchBedrooms" title="Bedrooms">
                <option value="">Bedrooms</option>
                <option value="0">Studio</option>
                <cfloop from="1" to="#settings.booking.maxBed#" index="i">
                  <option value="#i#">#i#</option>
                </cfloop>
              </select>
            </div>
            <div class="col">
              <select name="guests" class="guests" id="quickSearchGuests" title="Guests">
                <option value="">Guests</option>
                <cfloop from="1" to="#settings.booking.maxOccupancy#" index="i">
                  <option value="#i#">#i#</option>
                </cfloop>
              </select>
            </div>
            <div class="col col-submit">
              <button type="submit" id="quickSearchSubmit"><i class="fa fa-search"></i></button>
            </div>
          </div>
        </form>
      </div>
      <script type="text/javascript">
      jQuery(function ($) {
        $('##start-date').datepicker({
          minDate: '+0d',
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
        $('##end-date').datepicker({
          minDate: '+1d'
        });
  		  $('.guests').change(function(){
  			  $('input[name=guests]').val($(this).val() + ',' + $(this).val());
  		  });
  		  $('.bedrooms').change(function(){
  			  $('input[name=bedrooms]').val($(this).val() + ',' + $(this).val());
  		  });
      });
      </script>
    </cfsavecontent>
  </cfoutput>
  <cfoutput>#quickSearch#</cfoutput>
</cfprocessingdirective>