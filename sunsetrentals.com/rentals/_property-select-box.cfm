<style>
.header-nav { top: 70px; }
.header-nav nav li a { padding: 18px 8px; }
.header-nav nav li > ul { top: calc(100% + 16px); }
.property-select-box { position: absolute; top: 15px; right: 22px; width: 250px; }
.property-select-box .bootstrap-select .dropdown-menu li a span.text { width: 98%; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
@media (max-width: 1180px) {
  .header-nav { top: 0; }
  .property-select-box { top: 33px; right: 72px; }
}
@media (max-width: 480px) {
  .property-select-box { position: relative; top: auto; right: auto; left: auto; width: 100%; }
}
@media (max-width: 414px) {
  .booking-header-wrap .header-logo { width: 90px; }
}
</style>
<div class="property-select-box">
	<cfset variables.qryAllProperties = application.bookingObject.getAllProperties()>
  <select class="selectpicker refine-filter-specific-property-select" title="Select A Property" data-live-search="true">
    <option value="" data-hidden="true">Select A Property</option>
    <cfoutput query="variables.qryAllProperties">
      <option value="/#settings.booking.dir#/#variables.qryAllProperties.seoPropertyName#">#variables.qryAllProperties.name#</option>
    </cfoutput>
  </select>
</div>