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
      <ul class="nav nav-tabs" style="margin-top:20px">
        <li><a href="##basicTab" data-toggle="tab">Basic Form</a></li>
        <li><a href="##seoTab" data-toggle="tab">SEO Form</a></li> 
      </ul>
	  <form method="post" action="submit.cfm?id=#url.id#" class="form-horizontal" enctype="multipart/form-data">
<div class="tab-content">
          <div class="tab-pane active" id="basicTab">
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
		 
		 <div class="control-group">
			<label class="control-label">Gate Code</label>
			<div class="controls">
			   <input maxlength="255" name="gatecode" type="text" value="#trim(getEnhancements.gatecode)#" /> 
			</div>
		 </div>

		 <div class="control-group">
			<label class="control-label">Bed Types</label>
			<div class="controls">
			   <input maxlength="255" name="bedtypes" type="text" value="#trim(getEnhancements.bedtypes)#" /> 
			</div>
		 </div>

		 <div class="control-group">
			<label class="control-label">Property Not Found Redirect</label>
			<div class="controls">
			   <input maxlength="255" name="notfoundurl" type="text" value="#trim(getEnhancements.notfoundurl)#" /> 
			</div>
		 </div>

		 <!--- <div class="control-group">
			<label class="control-label">Use on Wedding Page</label>
			<div class="controls">
			   <input type="checkbox" value="1" name="showOnwedding"<cfif getEnhancements.showOnwedding gt 0>checked</cfif>> 
			</div>
		 </div>


		 <div class="control-group">
			<label class="control-label">Wedding Description</label>
			<div class="controls">
			   <textarea name="weddingDescription">#getEnhancements.weddingDescription#</textarea>
			</div>
		 </div> 

		 <div class="control-group">
			<label class="control-label">Short Description</label>
			<div class="controls">
			   <textarea name="shortdescription">#getEnhancements.shortdescription#</textarea> 
			</div>
		 </div>
--->
		 <div class="control-group">
			<label class="control-label">Long Description</label>
			<div class="controls">
			   <textarea name="longdescription">#getEnhancements.longdescription#</textarea> 
			</div>
		 </div>
		</div><!-- END basicTab -->
		 <div class="tab-pane" id="seoTab"> 

            <div class="control-group">
				<label class="control-label">H1 Tag</label>
				<div class="controls">
					<input maxlength="255" name="h1" type="text" <cfif parameterexists(id)>value="#getEnhancements.h1#"</cfif>>
				</div>
			</div>
         <div class="control-group">
    					<label class="control-label">Meta Title</label>
    					<div class="controls">
    						<input maxlength="255" name="seotitle" size="70" type="text" <cfif parameterexists(id)>value="#getEnhancements.seotitle#"</cfif>>
    						<div class="input-prepend">
                  <button class="btn btn-info" type="button" onClick="countit3(this)">Calculate Characters</button>
                  <input type="text" name="displaycount3" class="input-small" style="width:10%"  id="prependedInputButton">
    						</div>
    					</div>
    				</div>

            <div class="control-group">
    					<label class="control-label">Meta Description</label>
    					<div class="controls">
    						<textarea name="metadescription" class="mceNoEditor"><cfif parameterexists(id)>#getEnhancements.metadescription#</cfif></textarea>
    						<div class="input-prepend">
                  <button class="btn btn-info" type="button" onClick="countit2(this)">Calculate Characters</button>
                  <input type="text" name="displaycount2" class="input-small" style="width:10%"  id="prependedInputButton">
    						</div>
    					</div>
    				</div>


		 </div><!-- END seoTab -->

	</div>


		  <div class="form-actions">       
		  <input type="submit" value="Submit" id="btnSave" class="btn btn-primary" />
		  <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
		</div>
		<input type="hidden" name="pagename" value="#url.name#">
	</form>

  </div>

</div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

