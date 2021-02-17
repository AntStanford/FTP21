<cfset rates = application.bookingObject.getPropertyRates(property.propertyid)>

<div id="rates" name="rates" class="info-wrap rates-wrap">
  <div class="info-wrap-heading"><i class="fa fa-tags" aria-hidden="true"></i> Rates</div>
  <div class="info-wrap-body">
    <div class="table-wrap">
  		<table class="table rates-table">
  			<tr>
  				<th>Start Date</th>
  				<th>End Date</th>
  				<th>Weekly</th>
  				<th>Nightly</th>				
           </tr>
  			<cfoutput query="rates">
  			<tr>
  				<td>#DateFormat(start_date,'mm/dd/yyyy')#</td>
  				<td>#DateFormat(end_date,'mm/dd/yyyy')#</td>
  				<td><cfif weekly_rate gt 0>#DollarFormat(weekly_rate)#<cfelse>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-</cfif></td>
  				<td><cfif nightly_rate gt 0>#DollarFormat(nightly_rate)#<cfelse>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-</cfif></td>
  			</tr>
  			</cfoutput>
  		</table>
    </div><!-- END table-wrap -->
  
    <small class="scroll-indicator hide-mobile"><i class="fa fa-arrows-h" aria-hidden="true"></i><strong><span class="swipe">Swipe</span><span class="drag">Drag</span> for Rates</strong></small>
  </div><!-- END info-wrap-body -->
</div><!-- END rates-wrap -->
