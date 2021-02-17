<cfsetting enablecfoutputonly="true">

<cfprocessingdirective suppressWhiteSpace="true">
  <cfoutput>
    <cfsavecontent variable="allPropertiesDropdown">
			<cfset variables.qryAllProperties = application.bookingObject.getAllProperties()>
      <select class="selectpicker refine-filter-specific-property-select" title="Select A Property">
        <option value="" data-hidden="true">Select A Property</option>
        <cfloop query="variables.qryAllProperties">
          <option value="/#settings.booking.dir#/#variables.qryAllProperties.seoDestinationName#/#variables.qryAllProperties.seoPropertyName#">#variables.qryAllProperties.name#</option>
        </cfloop>
      </select>
      <script type="application/javascript" language="javascript">
				// SPECIFIC PROPERTY JUMP TO (Name and Number)
				jQuery('.refine-filter-specific-property-select').change(function(){
					var url = jQuery(this).val();
					var redirectWindow = window.open(url, '_blank');
					redirectWindow.location;
				});
      </script>
    </cfsavecontent>
    #allPropertiesDropdown#
	</cfoutput>
</cfprocessingdirective>
