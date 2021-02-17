<cfset table = 'clients'>
<cfset page.title ="Full Data Harvest Request">

<cfif isvalid("email",RequestFullUpdateEmail) is "No">
	<cfinclude template="/admin/components/header.cfm">

		<div class="alert alert-danger">
	      <button class="close" data-dismiss="alert">×</button>
	      <strong>Please <a href="javascript: window.history.go(-1)">go back </a>and enter a valid email address!</strong>
	    </div>

	<cfinclude template="/admin/components/footer.cfm">
	<cfabort>
</cfif>




	 <CFQUERY NAME="UpdateQuery" DATASOURCE="booking_clients">
		UPDATE clients
		SET
		RequestFullUpdate = 'Yes',
		RequestFullUpdateEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RequestFullUpdateEmail#">
		where dsn = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dsn#">
	</cfquery>




  <cflocation addToken="no" url="form.cfm?success">

