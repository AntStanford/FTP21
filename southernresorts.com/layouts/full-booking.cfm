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
