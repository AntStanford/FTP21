<cfinclude template="/components/header.cfm">

<cftry>

	<cfquery name="getPrivacyPolicy" dataSource="icoastalnet">
		select policy from privacy_policy where id = 1
	</cfquery>
	
	<cfif isdefined('getPrivacyPolicy') and getPrivacyPolicy.recordcount eq 1>
		<div style="padding:20px">
		<h1>Privacy Policy</h1>
		
		<cfset temp = replace(getPrivacyPolicy.policy,'[company_name]','<b>' & settings.company & '</b>','all')>
		<cfset temp = replace(temp,'[company_website]','<b>' &settings.website& '</b>','all')>
		<cfset temp = replace(temp,'[company_address]',settings.address & ', ' & settings.city & ',' & settings.state & ' ' & settings.zip,'all')>
		<cfset temp = replace(temp,'[company_email]',settings.clientEmail,'all')>
		
		<cfoutput>#temp#</cfoutput>
		</div>
	</cfif>

<cfcatch>
	
	<div style="padding:20px">
	<h1>Privacy Policy</h1>
	<cfoutput>#cfcatch.message#</cfoutput>
	</div>
	
</cfcatch>
</cftry>

<cfinclude template="/components/footer.cfm">


