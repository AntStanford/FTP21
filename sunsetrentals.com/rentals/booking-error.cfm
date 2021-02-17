<cfinclude template="/rentals/components/header.cfm">

<div class="i-content" style="margin:20px">
  <div class="container">
  	<div class="row">
  		<div class="col-lg-12">
       	<h2>Whoops!</h2>
       	<p>There was a problem with your request.</p>
       	<cfif isdefined('session.errorMessage')>
       	<p><b><cfoutput>#session.errorMessage#</cfoutput></b></p>
       	</cfif>       
  		</div>
  	</div>
  </div>
</div>

<cfinclude template="/rentals/components/footer.cfm">