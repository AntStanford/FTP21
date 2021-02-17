
<cfif ListFind('216.99.119.254,70.40.113.45,68.44.158.31', CGI.REMOTE_ADDR)>
<cfinclude template="/components/header.cfm">
<!--- Finds the Contact ID --->
<!--- <cfhttp method="get" url="https://svr.trackhs.com/api/crm/contacts/?email=judyperkins@twc.com" username="#settings.booking.track_hbd_username#" password="#settings.booking.track_hbd_password#">
	<cfhttpparam type="header" name="Accept" value="*/*">
	<cfhttpparam type="header" name="Content-type" value="application/json" />
</cfhttp>


<cfdump var="#cfhttp#"> --->

<!--- <cfset contactInfo = deserializeJson(cfhttp.filecontent)>
<cfif structKeyExists(contactinfo._embedded,"contacts") AND arrayLen(contactinfo._embedded.contacts)>
	<cfset contactID = contactinfo._embedded.contacts[1].id>
</cfif>
<cfif isdefined('contactID') and len(contactID)>

</cfif> --->



<cfquery datasource="#settings.dsn#" name="getTest">
	SELECT body FROM `cms_pages` WHERE `id` = '715'
</cfquery>
<cfset variables.pageBody = getTest.body>


<!--- Find Short Codes and Replace with a Div containging a data-id --->
<!--- <cfset variables.pageBody = reReplace(variables.pageBody, '\[shortcode ', '<div class="icnd-shortcode" data-', 'all')>
<cfset variables.pageBody = reReplace(variables.pageBody, '\/]', '></div>', 'all')> --->

<cfoutput>
	<div class="i-content">
		<div class="container">
			#parseShortCodes(variables.pageBody)#
		</div>
	</div>
</cfoutput>





<!--- 
<cf_htmlfoot>
	<!--- Loop through Short Code Divs and ajax in the corresponding content --->
	<script type="text/javascript" defer="">
		$(".icnd-shortcode").each(function() {
			var thisID = $(this).data('id');
			$.ajax({
			    url : "/content-builder-modules/shortcode.cfm?scodeID=" + thisID,
			    type: "POST",
			    success: function(data) 
			    {	
			     	$('.icnd-shortcode[data-id='+ thisID +']').html(data);
			    }
			});
		});
	</script>
</cf_htmlfoot>

 --->


<cfinclude template="/components/footer.cfm">
</cfif>
