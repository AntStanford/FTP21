<cfset page.title ="Things To Do Categories">
<cfset module = 'thing to do category'>
<cfinclude template="/admin/components/header.cfm">

<cfif isdefined('url.id')>
  <cfquery name="getinfo" dataSource="#application.dsn#">
    select * from cms_thingstodo_categories where id = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
  </cfquery>
</cfif>

<cfquery name="getDestinations" dataSource="#application.dsn#">
SELECT dst.id, dst.title, dsc.description
FROM cms_destinations dst
     LEFT JOIN cms_thingstodo_dest_cat_desc dsc ON dst.id = dsc.destID 
                                                   AND catID = <cfif isdefined('url.id')>
                                                               		<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#url.id#">
                                                               <cfelse>
                                                               		0
                                                               </cfif>
ORDER BY dst.title
</cfquery>

<cfoutput>

  <cfif isdefined('url.success') and isdefined('url.id')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Update successful!</strong> Continue editing this #module# or <a href="categories-index.cfm">go back.</a>
    </div>
  <cfelseif isdefined('url.success')>
    <div class="alert alert-success">
      <button class="close" data-dismiss="alert">×</button>
      <strong>Success!</strong> Add another #module# or <a href="categories-index.cfm">go back.</a>
    </div>
  </cfif>
  
<p><a href="/admin/thingstodo/categories-index.cfm" class="btn btn-info"><i class="icon-chevron-left icon-white"></i> Back to Categories</a></p>

  <div class="widget-box">
    <div class="widget-title">
      <span class="icon">
        <i class="icon-th"></i>
      </span>
      <h5>Add / Edit Form</h5>
    </div>
    <div class="widget-content nopadding">

      <form action="categories-submit.cfm" method="post" class="form-horizontal validate" enctype="multipart/form-data" id="frmCategory">

            <div class="control-group">
					<label class="control-label">Title</label>
					<div class="controls">
						<input type="text" name="title" class="required" <cfif parameterexists(id)>value="#getinfo.title#"</cfif>>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Slug</label>
					<div class="controls">
						<input type="text" name="slug" class="required" <cfif parameterexists(id)>value="#getinfo.slug#"</cfif>>
					</div>
				</div> 
	  
	  			<div class="control-group">
					<label class="control-label">H1</label>
					<div class="controls">
						<input type="text" name="h1"  <cfif parameterexists(id)>value="#getinfo.h1#"</cfif>>
					</div>
				</div> 
				
				 <div class="control-group">
					<label class="control-label">Image</label>
			    <div class="controls">
			      <div class="uploader" id="uniform-undefined">
			        <input type="file" size="19" name="photo" style="opacity:0;">
			        <span class="filename">No file selected</span>
			        <span class="action">Choose File</span>
			      </div>	
			      <span class="help-block">(Image must be resized to 1600px by 350px before uploaded; max file size is 200kb.)</span>			
            <cfif parameterexists(id) and len(getinfo.photo)>
              <br /><br />Image Preview<br /><img src="/images/thingstodo/#getinfo.photo#" width="200">
            </cfif>              
			    </div>
				</div>
	  
	  		<div class="control-group">
					<label class="control-label">Content</label>
					<div class="controls">
						<textarea name="content" style="height:100px"><cfif parameterexists(id)>#getinfo.content#</cfif></textarea>
					</div>
				</div>

				<cfloop query="getDestinations">
          <div class="control-group">
            <label class="control-label">Destination<br />#getDestinations.title#<br />Description</label>
            <div class="controls">
              <textarea name="description#getDestinations.id#" style="height:100px">#getDestinations.description#</textarea>
            </div>
          </div>
        </cfloop>

				<div class="form-actions">
					<input type="submit" value="Submit" class="btn btn-primary">
          <cfif parameterexists(id)><input type="hidden" name="id" value="#url.id#"></cfif>
				</div>
      </form>

    </div>
  </div>

</cfoutput>

<cfinclude template="/admin/components/footer.cfm">

<style type="text/css">label.error{color:red !important;}</style>

<script>
  $(document).ready(function(){
    $("#frmCategory").validate();
  });
</script>