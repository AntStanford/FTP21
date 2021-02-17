<cfif checkLoggedInUserSecurity()>>
   
   <cflocation addToken="no" url="/admin/dashboard.cfm">
   
<cfelse>

   <cflocation addToken="no" url="login.cfm?logout">

</cfif>