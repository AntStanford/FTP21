<cfsetting enablecfoutputonly="true">

<cfprocessingdirective suppressWhiteSpace="true">
  <cfoutput>
    <cfsavecontent variable="allPropertiesDropdown">
			<cfset variables.qryAllProperties = application.bookingObject.getAllProperties()>
      <select class="refine-filter-specific-property-select selectpicker" title="Select A Property" data-size="10" data-live-search="true">
        <option value="" data-hidden="true">SELECT A PROPERTY</option>
        <cfloop query="variables.qryAllProperties">
          <option value="/#settings.booking.dir#/#variables.qryAllProperties.seoPropertyName#">#variables.qryAllProperties.name#</option>
        </cfloop>
      </select>
      <script type="application/javascript" language="javascript">
				// SPECIFIC PROPERTY JUMP TO (Name and Number)
				jQuery('.refine-filter-specific-property-select').change(function(){
					var url = jQuery(this).val();
					var redirectWindow = window.open(url, '_new');
					redirectWindow.location;
				});
      </script>
    </cfsavecontent>
    #allPropertiesDropdown#
	</cfoutput>
</cfprocessingdirective>
