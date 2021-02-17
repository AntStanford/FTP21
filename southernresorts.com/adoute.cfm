<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" type="text/javascript"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-migrate/1.4.1/jquery-migrate.min.js" type="text/javascript"></script>

<cfhttp method="get" url="https://svr.trackhs.com/api/crm/contacts/?email=Patriciah@gosouthern.com" username="6ef5fcf54fc49059f42809ff32f06cce" password="c5e08aef3d0a8d9e6a68376fdd57a4f0">
	<cfhttpparam type="header" name="Accept" value="*/*">
					<cfhttpparam type="header" name="Content-type" value="application/json" />
				      </cfhttp>

<cfset contactInfo = deserializeJson(cfhttp.filecontent)>
<cfset contactID = "">
<cfif structKeyExists(contactinfo._embedded,"contacts") AND arrayLen(contactinfo._embedded.contacts)>
	<cfset contactID = contactinfo._embedded.contacts[1].id>
	</cfif>

	<cfoutput>#contactid#</cfoutput>
	
<cfabort>
<cfdump var="#contactinfo#">
Patriciah@gosouthern.com

<script>
	$(document).ready(function(){
		
		//$.get('https://svr.trackhs.com/api/crm/contacts/?email[]=jnorman@icnd.net', { 'auth':      { 'user': '30a5d5c074bd5537f35ae765081f4ed5',        'pass': '2b74261e3fd1cdce561d602338e57fcd' } });
		
		$.ajax({
         url: "https://svr.trackhs.com/api/crm/contacts/?email[]=jnorman@icnd.net",
      
         type: "GET", 
         headers: { 'auth[user]': '30a5d5c074bd5537f35ae765081f4ed5', 'auth[password]': '2b74261e3fd1cdce561d602338e57fcd'},
		success: function(data) { alert(data); }
        
      });
		
	});
	
</script>