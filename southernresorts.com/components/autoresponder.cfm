<cftry>

	<cfif isdefined('autoresponderTo') and LEN(autoresponderTo)>

		<cfquery name="getAutoresponder" dataSource="#application.dsn#">
			select subject,body from cms_autoresponder where active = <cfqueryparam cfsqltype="tinyint" value="1"> and body <> ''  Limit 1
		</cfquery>

		<cfif isdefined('getAutoresponder.body') and LEN(getAutoresponder.body)>
		    <cfsavecontent variable="emailbody">
				<cfoutput>
					<cfinclude template="/components/email-template-top.cfm">       
						<p>#getAutoresponder.body#</p>
					<cfinclude template="/components/email-template-bottom.cfm">
				</cfoutput>
		    </cfsavecontent>
	    </cfif>
	    
	    <!--- <cfset sendEmail(autoresponderTo,emailbody,getAutoresponder.subject)> --->

    </cfif>

<cfcatch></cfcatch>
</cftry>
