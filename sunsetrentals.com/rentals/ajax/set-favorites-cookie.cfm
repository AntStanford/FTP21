<cfif isdefined('url.unitcode')> <!--- We are adding or removing an item from our favorites --->
  <cfset favIndex = ListFind(cookie.favorites,url.unitcode)>
  <cfif favIndex gt 0>
    <cfset cookie.favorites = ListDeleteAt(cookie.favorites,favIndex)>  <!--- delete fav --->
  <cfelse>
    <cfset cookie.favorites = ListAppend(cookie.favorites,url.unitcode)> <!--- add fav --->
  </cfif>
  <cfcookie name="favorites" expires="never" value="#cookie.favorites#">
</cfif>
<cfoutput>#listlen(cookie.favorites)#</cfoutput>