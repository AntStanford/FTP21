<!--- THIS IS ADDING DUPLICATE HEADER AND FILES - COMMENTING OUT
<cfinclude template="/#settings.booking.dir#/components/header.cfm">
--->

<cfset page = getPageText(slug)>

<!--- INTERIOR BANNER IMAGE IS NOT NEEDED IN THE RESULTS PAGE - COMMENTING OUT
<cfif len('page.headerImage')>
	<cfoutput><img src="/images/header/#page.headerImage#"></cfoutput>
</cfif>
--->

<cfset url.all_properties = 'true'>

<cfif page.customSearchJSON neq ''>
  <cfset form.camefromsearchform = ''>
  <cfset data = deserializeJSON(page.customSearchJSON)>
  <cfset structure_key_list = structKeyList(data)>
  <cfloop list="#structure_key_list#" index="k">
    <cfset form[k] = data[k]>
  </cfloop>
</cfif>

<cfinclude template="/#settings.booking.dir#/results.cfm">

<!--- THIS IS ADDING DUPLICATE FOOTER AND FILES - COMMENTING OUT
<cfinclude template="/#settings.booking.dir#/components/footer.cfm">
--->