<cftry>
	<cfset page.title = 'Construction Labels' />

	<cfquery name="getinfo" dataSource="#application.dsn#">
	SELECT *
	FROM construction_labels
	ORDER BY id
	</cfquery>

	<cfinclude template="/admin/components/header.cfm">

	<cfif isdefined('url.deleted')>
		<div class="alert alert-success">
			<button class="close" data-dismiss="alert">x</button>
			<strong>Record deleted!</strong>
		</div>
	</cfif>

	<p><a href="form.cfm" class="btn btn-success"><i class="icon-plus icon-white"></i> Add New</a></p>

	<div class="widget-box">
		<div class="widget-content nopadding">
			<table class="table">
				<tr>
					<th>Title</th>
					<th>Created</th>
					<th width="50"></th>
					<th width="65"></th>
				</tr>

				<cfif getinfo.recordcount gt 0>
					<cfoutput query="getinfo">
							<tr>
								<td>#title#</td>
								<td>#dateFormat(createdAt,'mm/dd/yyyy')#</td>
								<td width="50"><a href="form.cfm?id=#id#" class="btn btn-mini btn-primary"><i class="icon-pencil icon-white"></i> Edit</a></td>
								<td width="65"><a href="submit.cfm?id=#id#&delete=1" class="btn btn-mini btn-danger" data-confirm="Are you sure you want to delete this callout?"><i class="icon-remove icon-white"></i> Delete</a></td>
							</tr>
					</cfoutput>
				</cfif>

			</table>
		</div>
	</div>

	<cfinclude template="/admin/components/footer.cfm">

	<cfcatch>
		<cfdump var="#cfcatch#" abort="true" />
	</cfcatch>
</cftry>