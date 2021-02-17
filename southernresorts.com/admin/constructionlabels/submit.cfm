<cftry>
	<cftry>
		<cfcache action="flush" key="construction_labels">
		<cfcatch></cfcatch>
	</cftry>

	<cfset variables.label_table = 'construction_labels' />
	<cfset variables.props_table = 'track_properties' />
	<cfset variables.link_table = 'construction_property_links' />

	<cfif structKeyExists(url,'delete') and structKeyExists(url,'id')>
		<!---
		I made this mistake on the last multi-select form by 
		not deleting everything from the link table based on url.id
		--->
		<cfquery name="remLabel" datasource="#application.dsn#">
		DELETE
		FROM #variables.label_table#
		WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#" />
		</cfquery>

		<cfquery name="remLink" datasource="#application.dsn#">
		DELETE
		FROM #variables.link_table#
		WHERE labelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#" />
		</cfquery>

		<cflocation url="index.cfm?deleted" addtoken="false" />
	<cfelseif structKeyExists(form,'id')>
		<!--- remove the properties from the link table, then add them back --->
		<cfquery name="remLink" datasource="#application.dsn#">
		DELETE
		FROM #variables.link_table#
		WHERE labelId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#" />
		</cfquery>

		<cfif structKeyExists(form,'propsIds') and listLen(form.propsIds) gt 0>
			<cfloop list="#form.propsIds#" index="i">
				<cfquery dataSource="#settings.dsn#">
				INSERT INTO #variables.link_table#(labelId,propertyId)
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" />
				)
				</cfquery>
			</cfloop>
		</cfif>

		<cfquery name="updateLabel" datasource="#application.dsn#">
		UPDATE #variables.label_table#
		SET label = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.labeltext#" />,
			title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#" />
		WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#" />
		</cfquery>

		<cflocation url="index.cfm?id=#form.id#&success" addtoken="false" />
	<cfelse>
		<cfquery datasource="#application.dsn#" result="result">
		INSERT INTO #variables.label_table#(label,title)
		VALUES(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.labeltext#" />,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#" />
		)
		</cfquery>

		<cfif structKeyExists(form,'propsIds') and listLen(form.propsIds) gt 0>
			<cfloop list="#form.propsIds#" index="i">
				<cfquery dataSource="#settings.dsn#">
				INSERT INTO #variables.link_table#(labelId,propertyId)
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#result.generatedKey#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" />
				)
				</cfquery>
			</cfloop>
		</cfif>

		<cflocation url="index.cfm?id=#result.generatedKey#&success" addtoken="false" />
	</cfif>

	<cfcatch>
		<cfdump var="#cfcatch#" abort="true" />
	</cfcatch>
</cftry>