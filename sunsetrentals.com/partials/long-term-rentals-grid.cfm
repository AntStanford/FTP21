<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_longterm_rentals where status = 'active' order by name
</cfquery>

<div class="row lt-avail-long-term">
	<cfloop query="getinfo">
	<cfoutput>
	<div class="col-sm-12 col-md-6 col-lg-4">
		<div class="card">
			<div class="card-header site-color-1-bg text-white">
				<p class="h3 card-title m-0"><a href="/long-term-rental/#slug#" class="text-white">#name#</a></p>
			</div>
			<div class="card-body">
				<a href="/long-term-rental/#slug#" class="img-responsive lt-prop-image">
					<cfif len(mainphoto)>
						<img class="card-img-top lazy" data-src="/images/longtermrentals/#mainphoto#" src="/images/layout/1x1.png" alt="Long Term Rentals #mainphoto#">
					<cfelse>
						<img class="card-img-top lazy" data-src="http://placehold.it/400x300&text=placeholder" src="/images/layout/1x1.png" alt="Long Term Rentals Placeholder">
					</cfif>
				</a>
				<div class="lt-prop-info">
					<table class="table m-0">
						<tbody>
							<tr>
								<td class="quick-facts">
									<b>Address:</b> #address#<br />
									<b>Pets Allowed:</b> #pet_friendly#<br />
								</td>
							</tr>
							<tr>
								<td class="pr-0 pl-0">
									<ul class="list-group m-0">
										<li class="list-group-item d-flex justify-content-between align-items-center p-2"><strong>Bedrooms:</strong><span class="badge badge-dark">#bedrooms#</span></li>
										<li class="list-group-item d-flex justify-content-between align-items-center p-2"><strong>Baths:</strong><span class="badge badge-dark">#bathrooms#</span></li>
										<li class="list-group-item d-flex justify-content-between align-items-center p-2"><strong>Monthly Rate:</strong><span class="badge badge-dark">$#monthly_rate#</span></li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
					<a href="/long-term-rental/#slug#" class="details btn site-color-2-bg site-color-2-lighten-bg-hover text-white text-white-hover"><span class="glyphicon glyphicon-list"></span> Details</a>
				</div>
			</div>
		</div>
	</div>
	</cfoutput>
	</cfloop>
</div><!-- END lt-avail-long-term -->