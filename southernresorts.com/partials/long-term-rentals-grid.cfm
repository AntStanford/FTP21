<cfquery name="getinfo" dataSource="#settings.dsn#">
	select * from cms_longterm_rentals where status = 'active' order by name
</cfquery>

<div class="row lt-avail-long-term">
	<cfloop query="getinfo">
	<cfoutput>
	<div class="col-xs-12 col-sm-6 col-md-4">
		<div id="" class="panel panel-default">
			<div class="panel-heading site-color-1-bg">
				<p class="h3 panel-title"><a href="/long-term-rental/#slug#" class="text-white">#name#</a></p>
			</div>
			<div class="panel-body">
				<a href="/long-term-rental/#slug#" class="img-responsive lt-prop-image">
					<cfif len(mainphoto)>
						<img src="/images/longtermrentals/#mainphoto#">
					<cfelse>
						<img src="http://placehold.it/400x300&text=placeholder">
					</cfif>
				</a>
				<div class="lt-prop-info">
					<ul class="list-group nomargin">
						<li class="list-group-item">
							<table class="table nomargin">
								<tbody>
									<tr>
										<td class="quick-facts">
											<b>Address:</b> #address#<br />
											<b>Pets Allowed:</b> #pet_friendly#<br />
										</td>
									</tr>
									<tr>
										<td>
											<ul class="list-group list-details nomargin">
												<li class="list-group-item"><span class="badge">#bedrooms#</span><b>Bedrooms:</b></li>
												<li class="list-group-item"><span class="badge">#bathrooms#</span><b>Baths:</b></li>
												<li class="list-group-item"><span class="badge">$#monthly_rate#</span><b>Monthly Rate:</b></li>
											</ul>
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
					<a href="/long-term-rental/#slug#" class="details btn site-color-2-bg site-color-2-lighten-bg-hover text-white text-white-hover"><span class="glyphicon glyphicon-list"></span> Details</a>
				</div>
			</div>
		</div>
	</div>
	</cfoutput>
	</cfloop>
</div><!-- END lt-avail-long-term -->