<cfinclude template="../guest-focus/components/header.cfm">
<cfinclude template="../guest-focus/components/sidebar.cfm">

<cfquery name="getFAQs" dataSource="#settings.dsn#">
	SELECT *
	from guest_loyalty_faqs 
	order by question
</cfquery>

<div class="content-wrap">

  <div class="page-header">
    <h1>Guest Loyalty FAQs</h1>
  </div>  
 
  <cfif getFAQs.recordcount gt 0>
  <ul>
  	<cfloop query="getFAQS">
  		<cfoutput><li><b>#question#</b><br />#answer#</li></cfoutput>
  	</cfloop>
  </ul>
  </cfif>
	

</div>

<cfinclude template="../guest-focus/components/footer.cfm">