<!---
This file is called from /components/footer.cfm and is used to set a cookie so users won't
see the homepage modal for 30 days if they close it.
--->

<cfif NOT StructKeyExists(cookie,'showhomepagemodal')>
   <cfcookie name="showhomepagemodal" expires="30" value="no">
</cfif>
