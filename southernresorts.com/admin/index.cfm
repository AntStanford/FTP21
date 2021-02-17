<cfif isdefined('cookie.LoggedInID') and len(cookie.LoggedInID) and cookie.LoggedInID gt 0>
   
   <cflocation addToken="no" url="/admin/dashboard.cfm">
   
<cfelse>

   <cflocation addToken="no" url="login.cfm">

</cfif>