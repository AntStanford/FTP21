<cfif isdefined('url.id')>
   
   <cfset page.title ="Editing: #url.name#">
   
   <cfquery name="getEnhancements" dataSource="#dsn#">
		select * 
		from cms_property_enhancements 
		where strpropid = <cfqueryparam CFSQLType="CF_SQL_VARCHAR" value="#url.id#">
	</cfquery>

<cfelse>

	<cflocation url="index.cfm" addtoken="no">

</cfif>



<cfinclude template="/admin/components/header.cfm">


<cfoutput>

<cfif isdefined('url.success') and isdefined('url.id')>
  <div class="alert alert-success">
	<button class="close" data-dismiss="alert">×</button>
	<strong>Update successful!</strong> Continue editing this property or <a href="index.cfm">go back.</a>
  </div>
</cfif>

<div class="widget-box">
  <div class="widget-title">
	<span class="icon">
	  <i class="icon-th"></i>
	</span>
	<h5>Add / Edit Form</h5>
  </div>
  <div class="widget-content nopadding">    

	  <form method="post" action="submit.cfm?id=#url.id#" class="form-horizontal" enctype="multipart/form-data">

		 <div class="control-group">
			<label class="control-label">Virtual Tour URL</label>
			<div class="controls">
			   <input maxlength="255" name="virtualtour" type="text" value="#trim(getEnhancements.virtualtour)#" /> 
			</div>
		 </div>
		 
		 <div class="control-group">
			<label class="control-label">Video URL</label>
			<div class="controls">
			   <input maxlength="255" name="videoLink" type="text" value="#trim(getEnhancements.videoLink)#" /> 
			</div>
		 </div>


		  <div class="form-actions">       
		  <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
		  <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
		</div>

	</form>

  </div>

</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

