<cftry>
	<cfset page.title = 'Construction Labels' />
	<cfset variables.listOfprops = '' />

	<cfif structKeyExists(url,'id')>
		<cfquery name="getinfo" dataSource="#application.dsn#">
		SELECT *
		FROM construction_labels
		WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#" />
		</cfquery>
		<!--- get linked props if any --->
		<cfquery name="getLinkedProps" datasource="#application.dsn#">
		SELECT propertyId
		FROM construction_property_links
		WHERE labelid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#" />
		</cfquery>

		<cfif getLinkedProps.recordcount gt 0>
			<cfset variables.listOfprops = valueList(getLinkedProps.propertyId) />
		</cfif>
	</cfif>
	<!--- get all properties to choose from --->
	<cfquery name="getProperties" datasource="#application.dsn#">
	SELECT id,name
	FROM track_properties
	ORDER BY name
	</cfquery>

	<cfinclude template="/admin/components/header.cfm">

	<cfif structKeyExists(url,'success') and structKeyExists(url,'id')>
		<div class="alert alert-success">
			<button class="close" data-dismiss="alert">×</button>
			<strong>Update successful!</strong> Continue editing these construction labels or <a href="index.cfm">go back.</a>
		</div>
	</cfif>

	<div class="widget-box">
		<div class="widget-title">
			<span class="icon"><i class="icon-th"></i></span>
			<h5>Add / Edit Form</h5>
		</div>
		
		<div class="widget-content nopadding">
			<form method="post" action="submit.cfm" class="form-horizontal" enctype="multipart/form-data">
				<cfoutput>
					<cfif structKeyExists(url,'id')>
						<input type="hidden" name="id" value="#url.id#">
					</cfif>

					<div class="control-group">
						<label class="control-label">Title <em>(internal use only)</em></label>
						<div class="controls">
							<input type="text" name="title" <cfif structKeyExists(url,'id')>value="#getinfo.title#"</cfif>>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Label Text</label>
						<div class="controls">
							<textarea name="labeltext" style="height:100px"><cfif structKeyExists(url,'id')>#getinfo.label#</cfif></textarea>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Properties</label>
						
						<div class="controls">
							<select name="propsIds" multiple="multiple" style="width:81%;">
								<cfloop query="getProperties">
									<option value="#getProperties.id#" <cfif structKeyExists(url,'id') and listFind(variables.listOfprops,getProperties.id)>selected</cfif>>#getProperties.name#</option>
								</cfloop>
							</select>
						</div>
					</div>
				</cfoutput>

				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
				</div>
			</form>
		</div>
	</div>

	<cfinclude template="/admin/components/footer.cfm">

	<cfcatch>
		<cfdump var="#cfcatch#" abort="true" />
	</cfcatch>
</cftry>